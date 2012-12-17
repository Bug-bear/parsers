#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <iomanip>
#include <stdint.h>
using namespace std;

string delimitMask(string mask){
	string ret = "";
	for(int i=0; i<mask.size(); i++){
		ret = ret + mask[i]+" ";
	}
	return ret;
}

int main(){
	ofstream roundStream;
	roundStream.open ("round4.txt", ios::out | ios::app);
	ofstream groupStream[3];
	groupStream[0].open ("groupB.txt", ios::out | ios::app);
	groupStream[1].open ("groupC.txt", ios::out | ios::app);
	groupStream[2].open ("groupD.txt", ios::out | ios::app);
	
  	string line;
	
	int lastCtr=0;
  	while(getline(cin,line))
  	{
		string dump,mask;
		int id, ctr;
		
		std::stringstream ss(line);
		ss>>dump>>dump;
		ss>>id>>ctr>>mask;
		
		if(ctr!=lastCtr){
			if(mask=="1111111111111111"){
				continue;
			}
			lastCtr=ctr;
			if(ctr==0 || mask=="1111111111111111"){
				continue;
			}
			//cout<<mask<<endl;
			roundStream<<delimitMask(mask)<<endl;
			groupStream[id-7]<<delimitMask(mask)<<endl;
			//roundStream<<ctr<<" "<<mask<<endl;
			//groupStream[id-7]<<ctr<<" "<<mask<<endl;
		}
		else 
			continue;
		
		
		//cout<<id<<" "<<ctr<<" "<<mask<<endl;
	}
	
	roundStream.close();
	for(int i=0; i<3; i++){
		groupStream[i].close();
	}
}

