/**
form the record of noise floor for 16 channels 
	- for channel diversity in PDR and NF

input: result of gina_sniffer_summary: (chan)(noise floor)(PDR)(line number - dump)
output: vec(16) of average noise
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
	ofstream sniffedNF, sniffedPDR;
	sniffedNF.open ("sniffedNF.txt");
	sniffedPDR.open ("sniffedPDR.txt");
  	string line;
  	vector<vector<double> >    vNF(16, vector<double>());
  	vector<vector<double> >    vPDR(16, vector<double>());
  	int min;

  	while(getline(cin,line))
  	{
		string channel, rssi, pdratio, dump;
		int chan;
		double 			nf, 	pdr;
		
		std::stringstream ss(line);
		std::stringstream s;
		
		ss>>channel>>rssi>>pdratio>>dump;
		s<<channel; s>>chan; s.clear();
		s<<rssi; s>>nf; s.clear();
		s<<pdratio; s>>pdr; s.clear();
		
		//cout<<channel<<" "<<rssi<<" "<<pdratio<<endl;
		//cout<<chan<<" "<<nf<<" "<<pdr<<endl;

		vNF[chan-11].push_back(nf);
		vPDR[chan-11].push_back(pdr);
	}
	//noise floor
	min=vNF[0].size();
	for(int i=1; i<16; i++){
		if(vNF[i].size()<vNF[i-1].size())
			min=vNF[i].size();
	}

	for(int j=0; j< min; j++){
		for(int i=0; i<16; i++){
			sniffedNF<<setw(5)<<vNF[i][j]<<" ";
		}
		sniffedNF<<endl;
	}	
	sniffedNF.close();
	
	//pdr
	min=vPDR[0].size();
	for(int i=1; i<16; i++){
		if(vPDR[i].size()<vPDR[i-1].size())
			min=vPDR[i].size();
	}

	for(int j=0; j< min; j++){
		for(int i=0; i<16; i++){
			sniffedPDR<<setw(5)<<vPDR[i][j]<<" ";
		}
		sniffedPDR<<endl;
	}
	sniffedPDR.close();
}
