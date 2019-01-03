#include <iostream>
#include <string>
#include <fstream>
#include <nlohmann/json.hpp>
using json = nlohmann::json;
using namespace std;
int main(int argc, char  ** argv)
{

json j;

vector<string> function_list;
vector<json> parameter_list;
vector<vector<json>> dependency_lists;
assert(argc == 2);
std::ifstream i(argv[1],ios_base::in);


i>>j;    

json array=j.at("functions");

for (json::iterator array_it = array.begin();           array_it != array.end();           ++array_it){
  	string function_name=(*array_it)["name"];
	function_name.erase(std::remove(function_name.begin(), function_name.end(), '"'), function_name.end());
  	json callsites=(*array_it)["callsites"];
	int function_index=-1;
	for(int i=0;i<function_list.size();i++)
	if (function_list[i]==function_name ){
	    function_index=i;
	    break;
	}
	if (function_index==-1){
		function_index=function_list.size();
		function_list.push_back(function_name);
		vector<json> parameters;
		dependency_lists.push_back(parameters);

	}

	for (json::iterator callsites_it = callsites.begin();           callsites_it != callsites.end();           ++callsites_it){

  	string callsite_name=callsites_it.key();
	json callsite_instances=callsites_it.value();

		for (json::iterator csi_it = callsite_instances.begin();           csi_it != callsite_instances.end();           ++csi_it){
//			std::cout <<(*csi_it)<<endl;
			json operands=(*csi_it)["operands"];

			for (json::iterator ops_it = operands.begin(); ops_it !=operands.end();++ops_it){

//				std::cout <<(*ops_it)<<endl;
				//std::cout <<ops_it[1]<<endl;
				json parameter_name=(*ops_it)[1];
				if ( std::find(parameter_list.begin(), parameter_list.end(), parameter_name) != parameter_list.end() ){
					if ( std::find(dependency_lists[function_index].begin(), dependency_lists[function_index].end(), parameter_name) == dependency_lists[function_index].end() ){
						dependency_lists[function_index].push_back(parameter_name);
					}
				}
				else{
   					parameter_list.push_back(parameter_name);
					dependency_lists[function_index].push_back(parameter_name);
				}
			}
		}
	}
  	
//	std::cout <<function_name<< "\n";
}

/*
 *
 * Must write one filter file for each parameter and each combination of parameters.
 * I can exclude any calls that are either not dependent or are included in a more involved analysis.
 *
 * */

vector<ofstream> filters;
for(int i=0;i<parameter_list.size();i++)
{
	string filename=parameter_list[i][0];
	for(int j=1 ;j<parameter_list[i].size();j++)
	{
		string additionalparam=parameter_list[i][j];
		filename+=","+additionalparam;
	}

std::cout << filename + ".filt" << '\n';
filters.emplace_back(filename+".filt",ios_base::out);
filters[i]<<"SCOREP_REGION_NAMES_BEGIN"<<endl<<"  EXCLUDE *"<<endl<<"INCLUDE ";// foo"<<endl<<"SCOREP_REGION_NAMES_END"<<endl;
}


for(int i=0;i<function_list.size();i++){
	int maxsize=0;
	for(int j=0;j<dependency_lists[i].size();j++){
		if( dependency_lists[i][j].size()>maxsize) maxsize=dependency_lists[i][j].size();
	}
	vector<int> to_delete;
	for(int k=maxsize;k>1;k--){
		for(int j=0;j<dependency_lists[i].size();j++){
			if(dependency_lists[i][j].size()==k){
			
				for(int l=0;l<dependency_lists[i].size();l++){
					int flag_different=0;
					if (dependency_lists[i][l].size()>=k) continue;
					for(int m=0;m<dependency_lists[i][l].size();m++){
						int flag_same=0;
						for(int n=0;n<dependency_lists[i][j].size();n++)
							if (dependency_lists[i][l][m]==dependency_lists[i][j][n]){ flag_same=1; 
								//cout<<"HERE: i:" <<i<<" j:"<<j<<" l: "<<l <<" m "<<m<<"n"<<n<<endl;
								//	
								}
						if (flag_same==0) flag_different=1;				
					}
					if (flag_different==0)
						to_delete.push_back(l);
					
				}

			}
		}
			
	}
	vector<int> to_prune;
	for(int j=0;j<dependency_lists[i].size();j++){
	to_prune.push_back(0);
	}
	for(int j=0;j<to_delete.size();j++){
		to_prune[to_delete[j]]=1;
	}
	vector<json> pruned;
	for(int j=0;j<dependency_lists[i].size();j++){
	if(to_prune[j]!=1) pruned.push_back(dependency_lists[i][j]);
	}
	dependency_lists[i].clear();
	dependency_lists[i]=pruned;
}




for(int i=0;i<function_list.size();i++)
{
cout<<"Function: "<<function_list[i]<<endl<<"Params: ";
for(int j=0;j<dependency_lists[i].size();j++)
{
	for(int k=0;k<parameter_list.size();k++)
	if (dependency_lists[i][j]==parameter_list[k])
		filters[k]<<function_list[i]<<endl;
	cout<<dependency_lists[i][j]<<", ";
}
cout<<endl;
}

for(int i=0;i<parameter_list.size();i++)
{
filters[i]<<endl<<"SCOREP_REGION_NAMES_END"<<endl;
filters[i].close();
}


//cout<<j.at("debug")[0]["directory"]<<endl;
return 0;
}
