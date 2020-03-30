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
	char par_c[20];
	float exp;
	std::string par;
	bool poly=false;
	bool log=false;
	tmp=ReplaceAll(tmp,"size","s");
	//cout<<tmp<<endl;
	while(tmp.find("*")!=std::string::npos){
		int pos=tmp.find("*");
		tmp.erase(0,pos+1);
		if (tmp[0]=='l') {sscanf(tmp.c_str(),"log2^%f(%s)",&exp,par_c);log=true;
			
			if (p1==par_c)
				coeffterm*=pow(log2(p1val),exp);
		
			if (p2==par_c)
				coeffterm*=pow(log2(p2val),exp);
		
		}
		if (tmp[0]=='(') {sscanf(tmp.c_str(),"(%s^%f)",par_c,&exp);poly=true;
		
			if (p1==par_c)
				coeffterm*=pow(p1val,exp);
		
			if (p2==par_c)
				coeffterm*=pow(p2val,exp);
		
		}
		
		par=std::string(par_c);
		
	//	cout<<"EXP: "<<exp<<" PAR: "<<par<<" poly: "<<poly<<" log: "<<log<<endl;
	}
	//}
	//cout<<"COEFFTERM: "<<coeffterm<<" "<<tmp<<endl;
	result+=coeffterm;
}
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

json_t evaluate(model & old_model, model & new_model, bool with_evaluation, model & evaluation, json_t & evaluation_point)
{
  json_t result;
  int count_equal=0;
  int count_different=0;
  int count_win=0;
  for(int i=0;i<old_model.names.size();i++)
  {
    json_t m;
    m["name"] = old_model.names[i];
    m["model"]["old"] = clean_model(old_model.model[i]);
    m["model"]["new"] = clean_model(new_model.model[i]);

    if(with_evaluation) {
      // TODO: test and finish
      double resold = calculate(old_model.model[i], evaluation_point);
      double resnew = calculate(new_model.model[i], evaluation_point);
      double reseval = calculate(evaluation.model[i], evaluation_point);
      m["eval"]["model"] = reseval;
      
      if (resold==resnew) {
        count_equal++;
        result["equal"].push_back(std::move(m));
      }
      else {
        count_different++;
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
        if (absolute_error_old > absolute_error_new) {
          count_win++;
          result["different"].push_back(std::move(m));
        } else
          result["different"].push_back(std::move(m));
      }
    } else {
      if(!old_model.model[i].compare(new_model.model[i])) {
        count_equal++;
        result["different"].push_back(std::move(m));
      } else {
        result["equal"].push_back(std::move(m));
        count_different++;
      }
    }
  }
  result["summary"]["equal"] = count_equal;
  result["summary"]["different"] = count_different;
  if(with_evaluation) {
    result["summary"]["better"] = count_win;
    result["summary"]["worse"] = count_different - count_win;
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
  model evaluation_model;
  json_t evaluation_point;

  model old_model = model::read(first_model);
  model new_model = model::read(second_model);
  if(with_evaluation) {
    evaluation_file = argv[3];
    evaluation_config = argv[4];
    evaluation_model = model::read(evaluation_file);
    std::ifstream eval(evaluation_config);
    eval >> evaluation_point;
  }

   
  if (old_model.names.size() != new_model.names.size()){
    std::cout << "ERROR old new size" << std::endl;
    return -1;
  }
  if(with_evaluation) {
    if (old_model.names.size() != evaluation_model.names.size()){
      std::cout << "ERROR old eval size" << std::endl;
      return -1;
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
      if(old_model.names[i].compare(evaluation_model.names[i])!=0){
        std::cout<<"NAME old eval: "<<old_model.names[i]<<" "<<evaluation_model.names[i]<<std::endl;
        return -1;
      }
    }
  }

  json_t result = evaluate(old_model,new_model, with_evaluation, evaluation_model, evaluation_point);
  result["input"]["old"] = first_model;
  result["input"]["new"] = second_model;
  if(with_evaluation) {
    result["input"]["eval"] = evaluation_file;
    result["input"]["eval_config"] = evaluation_point;
  }
  std::cout << result.dump(2) << std::endl;
  return 0;
}
