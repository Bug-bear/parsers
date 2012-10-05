/**
extract 16 channel noise readings from telosb sniffer data
*/

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <iomanip>
#include <stdint.h>
using namespace std;

int main(){
	ofstream sniffed;
	//sniffed.open ("flat_5wks"); //22
	sniffed.open ("lkl_6wks"); //17
	//sniffed.open ("mal_6wks"); //20
	//sniffed.open ("out_lkl"); //12
	//sniffed.open ("out_mal"); //23
	//sniffed.open ("out_flat"); //19
  	string line;
  	vector<vector<double> >    v3(16, vector<double>());
  	int min;
	int sum, ctr, lastChan;
	sum=0;
	ctr=0;
	lastChan=17; //channel of first record (specific to each data file)

    int num=0;

  	while(getline(cin,line))
  	{
        num++;
        //if(num<100000){
		string dump,rssi,channel;
		int rs,chan;
		std::stringstream ss(line);

		ss>>rs>>chan;
		rs=rs-127;
		if(rs>127) rs=rs-256-45;
		else rs=rs-45;
		//rs=rs+256; //temp to make sure values are positive
		ss.clear();

		if(chan==lastChan){
			sum+=rs;
			ctr++;
		}
		else{
			v3[lastChan-11].push_back((double)sum/ctr);
			sum=rs;
			ctr=1;
			lastChan=chan;
		}
        //}else break;
	}

	min=v3[0].size();
	for(int i=0; i<16; i++){
		if(v3[i].size()<min){
			min=v3[i].size();
        }
        //cout<<v3[i].size()<<endl;
	}
    //cout<<"wawa "<<min<<endl;

	for(int j=0; j< min; j++){
		for(int i=0; i<16; i++){
			sniffed<<setw(8)<<fixed<<setprecision(3)<<v3[i][j]<<" ";
		}
		sniffed<<endl;
	}

/*
	min=v2[0].size();
	for(int i=1; i<16; i++){
		if(v2[i].size()<v2[i-1].size())
			min=v2[i].size();
	}

	for(int j=0; j< min; j++){
		for(int i=0; i<16; i++){
			sniffed<<setw(5)<<v2[i][j]<<" ";
		}
		sniffed<<endl;
	}
	*/

	sniffed.close();
}
