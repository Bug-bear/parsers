/**
The record of noise floor for 16 channels that Gina mote ACTUALLY see
	- for estimator accuracy evaluation and tuning

input: noise lines (36)
output: vec(16) of noise readings
*/

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <iomanip>
#include <stdint.h>
using namespace std;

const int NFLEN = 36;	//length of sniffed noise lines

int main(){
	ofstream sniffedNF;
	sniffedNF.open ("slotNF.txt");
  	string line;
  	vector<vector<double> >    vNF(16, vector<double>());
	
	while(getline(cin,line)){
		std::stringstream s(line);
		std::stringstream ss;
		if(line.length()==NFLEN){ //need to check validity
			string dump, nfaHex, nfbHex, chanHex;
			int nfa, nfb, noiseFloor, chan;

			s>>dump>>dump>>dump; dump = ""; s>>dump; if(dump!="08") continue;
			dump = ""; s>>dump; if(dump!="1a") continue;

			s>>nfaHex>>nfbHex;
			//extract noise
			ss<<std::hex<<nfaHex; ss>>nfa; ss.clear();
			ss<<std::hex<<nfbHex; ss>>nfb; ss.clear();
			noiseFloor = nfa*100 + nfb;
			//extract channel
			s>>dump; s>>chanHex;
			ss<<std::hex<<chanHex; ss>>chan; ss.clear();
			s.ignore();	
			//cout<<chan<<" "<<noiseFloor<<endl;
			vNF[chan-11].push_back(noiseFloor-91);
		}
	}
	
	int min=vNF[0].size();
	for(int i=1; i<16; i++){
		if(vNF[i].size()<vNF[i-1].size())
			min=vNF[i].size();
	}

	for(int j=0; j< min; j++){
		for(int i=0; i<16; i++){
			cout<<setw(5)<<vNF[i][j]<<" ";
		}
		cout<<endl;
	}	
	
}