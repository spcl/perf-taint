#include <math.h>
#include <assert.h>
#include <stdio.h>
#include <string>
#include <cstring>
#include <sstream>
#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <algorithm>
#include <vector>

#include <nlohmann/json.hpp>

using json_t = nlohmann::json;

std::string ReplaceAll(std::string str, const std::string& from, const std::string& to) {
    size_t start_pos = 0;
    while((start_pos = str.find(from, start_pos)) != std::string::npos) {
        str.replace(start_pos, from.length(), to);
        start_pos += to.length(); // Handles case where 'to' is a substring of 'from'
    }
    return str;
}

double calculate(std::string model, json_t & evaluation_point){

  std::string p1 = evaluation_point["params"][0]["name"];
  std::string p2 = evaluation_point["params"][1]["name"];
  double p1val = evaluation_point["params"][0]["value"];
  double p2val = evaluation_point["params"][1]["value"];
	std::istringstream iss(model);
	std::string tmp="";
        iss>>tmp;
	iss>>tmp;
	double result=0;
	iss>>result;
	//cout<<"COEFF:"<<result<<endl;
	while(!iss.eof()){
	iss>>tmp;
	double coeffterm;
	iss>>coeffterm;
	iss>>tmp;
	char par_c;
	float exp;
	std::string par;
	bool poly=false;
	bool log=false;
	tmp=ReplaceAll(tmp,"size","s");
	while(tmp.find("*")!=std::string::npos){
		int pos=tmp.find("*");
		tmp.erase(0,pos+1);
		if (tmp[0]=='l') {sscanf(tmp.c_str(),"log2^%f(%c)",&exp,&par_c);log=true;
			
			if (p1[0] == par_c)
				coeffterm*=pow(log2(p1val),exp);
		
			if (p2[0] == par_c)
				coeffterm*=pow(log2(p2val),exp);
		
		}
		if (tmp[0]=='(') {sscanf(tmp.c_str(),"(%c^%f)",&par_c,&exp);poly=true;
	
			if (p1[0] == par_c)
				coeffterm*=pow(p1val,exp);
		
			if (p2[0] == par_c)
				coeffterm*=pow(p2val,exp);
		
		}
		
		//par=std::string(par_c);
		
    //std::cerr<<"EXP: "<<exp<<" PAR: "<<par<<" poly: "<<poly<<" log: "<<log<<std::endl;
	}
	//}
	result+=coeffterm;
}
  std::cerr << "Evaluate: " << model << " on " << p1 << "=" << p1val << ", " << p2 << "=" << p2val << " = " << result << std::endl;
return result;
}

double max(double a, double b)
{
if (a>=b) return a;
else return b;
}

struct model
{
  std::vector<std::string> names;
  std::vector<std::string> model;
  static struct model read(const std::string & file_name)
  {
    std::ifstream file(file_name);
    std::string lineString;
    int currentLine = 0;
    bool time=false;
    struct model m;
    while ( std::getline( file, lineString, '\n' ) )
    {
      currentLine++;
      // ignore empty lines
      if ( lineString.empty() )
          continue;

      if ( lineString.find("callpath:")!=std::string::npos)
      {
        m.names.push_back(lineString);
        continue;
      }

      if ( lineString.find("metric: time")!=std::string::npos)
      {
        time=true;
        continue;
      }

      if ((time==true)&&( lineString.find("model:")!=std::string::npos))
      {
        time=false;
        m.model.push_back(lineString);	
      }
    }
    return m;
  }
};

std::string clean_model(const std::string m)
{
  // length of model: + whitespace at the beginning
  std::string str = m.substr(m.find("model:") + 6);
  str.erase(std::remove(str.begin(), str.end(), ' '), str.end());
  return str;
}

json_t evaluate(model & old_model, model & new_model, bool with_evaluation,
    std::vector<model> & evaluation, json_t & evaluation_point)
{
  json_t result;
  int count_equal=0;
  int count_different=0;
  std::vector<int> wins(evaluation.size());

  for(int i=0;i<old_model.names.size();i++)
  {
    json_t m;
    m["name"] = old_model.names[i];
    m["model"]["old"] = clean_model(old_model.model[i]);
    m["model"]["new"] = clean_model(new_model.model[i]);

    if(with_evaluation) {
      if(!old_model.model[i].compare(new_model.model[i])) {
        count_equal++;
        result["equal"].push_back(std::move(m));
      } else {
        int idx = 0;
        count_different++;
        for(auto & eval : evaluation_point) {
          json_t eval_res;
          // TODO: test and finish
          double resold = calculate(old_model.model[i], eval);
          double resnew = calculate(new_model.model[i], eval);
          double reseval = calculate(evaluation[idx].model[i], eval);
          eval_res["value"] = reseval;
          
          double absolute_error_old = std::abs(resold - reseval);
          double absolute_error_new = std::abs(resnew - reseval);
          double relative_error_old =
            std::abs(std::abs(resold) - std::abs(reseval))
            /
            std::abs(std::max(reseval, resold));
          double relative_error_new =
            std::abs(std::abs(resnew) - std::abs(reseval))
            /
            std::abs(std::max(reseval, resnew));
          json_t new_model_result;
          new_model_result["value"] = resnew;
          new_model_result["absolute"] = absolute_error_new;
          new_model_result["relative"] = relative_error_new;
          json_t old_model_result;
          old_model_result["value"] = resold;
          old_model_result["absolute"] = absolute_error_old;
          old_model_result["relative"] = relative_error_old;
          eval_res["new"] = new_model_result;
          eval_res["old"] = old_model_result;
          if (absolute_error_old > absolute_error_new) {
            wins[idx]++;
            eval_res["result"] = "better";
          } else {
            eval_res["result"] = "worse";
          }
          m["eval"].push_back(eval_res);
          ++idx;
        }
        result["different"].push_back(std::move(m));
      }
    } else {
      if(!old_model.model[i].compare(new_model.model[i])) {
        count_equal++;
        result["equal"].push_back(std::move(m));
      } else {
        result["different"].push_back(std::move(m));
        count_different++;
      }
    }
  }
  result["summary"]["equal"] = count_equal;
  result["summary"]["different"] = count_different;
  if(with_evaluation) {
    json_t res;
    for(int win : wins) { 
      res["better"] = win;
      res["worse"] = count_different - win;
      result["summary"]["results"].push_back(res);
    }
  }

  return result;
  //cout<<"Win"<<count_win<<endl;
  //cout<<"Equal:"<<count_equal<<"/"<<count_equal+count_different<<endl;
  //cout<<"Notequal:"<<count_different<<"/"<<count_equal+count_different<<endl;
}

int main(int argc,char**argv)
{
  bool with_evaluation = argc > 3;
  std::string first_model = argv[1];
  std::string second_model = argv[2];
  std::string evaluation_file, evaluation_config;
  std::vector<model> evaluations;
  json_t evaluation_point;

  model old_model = model::read(first_model);
  model new_model = model::read(second_model);
  if(with_evaluation) {
    evaluation_config = argv[3];
    std::ifstream eval(evaluation_config);
    eval >> evaluation_point;
    for(auto & pos : evaluation_point) {
      evaluations.push_back(model::read(pos["path"].get<std::string>()));
    }
  }

   
  if (old_model.names.size() != new_model.names.size()){
    std::cout << "ERROR old new size " << old_model.names.size() << ' ' << new_model.names.size() << std::endl;
    return -1;
  }
  if(with_evaluation) {
    for(size_t j = 0; j < evaluations.size(); ++j) {
      if (old_model.names.size() != evaluations[j].names.size()){
        std::cout << "ERROR old eval size " << old_model.names.size() << ' ' << evaluations[j].names.size() << std::endl;

        size_t count = 0;
        std::vector<int> remove_indices;
        for(const std::string & evaluation_path : evaluations[j].names) {
          auto it = std::find(old_model.names.begin(), old_model.names.end(), evaluation_path);
          if(it == old_model.names.end()) {
            remove_indices.push_back(count);
            std::cerr << "Not found in old: " << evaluation_path << std::endl;
          }
          ++count;
        }
        for(auto it = remove_indices.rbegin(); it != remove_indices.rend(); ++it) {
          evaluations[j].names.erase(evaluations[j].names.begin() + *it);
          evaluations[j].model.erase(evaluations[j].model.begin() + *it);
        }
      }
    }
  }

  for(int i=0;i<old_model.names.size();i++){
    if(old_model.names[i].compare(new_model.names[i])!=0){
      std::cout<<"NAME old new: "<<old_model.names[i]<<" "<<new_model.names[i]<<std::endl;
      return -1;
    }
  }

  if(with_evaluation) {
    for(int i=0;i<old_model.names.size();i++){
      for(size_t j = 0; j < evaluations.size(); ++j) {
        if(old_model.names[i].compare(evaluations[j].names[i])!=0){
          std::cout<<"NAME old eval: <"<<old_model.names[i]<<"> <"<<evaluations[j].names[i]<<">"<<std::endl;
          return -1;
        }
      }
    }
  }

  json_t result = evaluate(old_model,new_model, with_evaluation, evaluations, evaluation_point);
  result["input"]["old"] = first_model;
  result["input"]["new"] = second_model;
  if(with_evaluation) {
    result["input"]["eval_config"] = evaluation_point;
  }
  std::cout << result.dump(2) << std::endl;
  return 0;
}
