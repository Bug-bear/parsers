/**
summarise parsed records of gina sniffer (for NF-ETX relationship)

input: output from gina_sinffer_with_asn

output: (channel) (average noise floor) (batch PDR)
*/

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <iomanip>
#include <stdint.h>
using namespace std;

const int BATCH = 100;

int main(){
	string line;
	double noiseFloor = 0;
	double sum = 0;
	int ln = 0; //multiple initialisation not working here!
	int ctr = 0;
	int lastSeq, seq = 0;
	double average = 0;
	int lastFreq, freq = 0;
	bool filtering = false;

  	while(getline(cin,line)){
		std::stringstream s(line);
		ln++;
		//cout<<ln<<endl;
		string dump;

		s>>freq>>noiseFloor>>dump>>dump>>seq;

		if(ln==1){
			lastFreq = freq;
			lastSeq = seq;
			//cout<<lastSeq;
		}

		//to do: make every 100 a batch - batch per channel
		if(lastFreq==freq){
			sum += noiseFloor;
			ctr++;
			//cout<<freq<<" "<<sum/ctr<<" "<<lastSeq<<" "<<seq<<endl;
		} else{
			lastFreq = freq;
			
			filtering = false;
			if(seq - lastSeq > 0){ //premature channel switch
				filtering = true;
			}
			if(filtering) continue;
			
		
			cout<<lastFreq<<" "<<sum/ctr<<" "<<fixed<<setprecision(3)<<(double)ctr/100<<" "<<ln<<" "<<lastSeq<<" "<<seq<<endl;
			
			ctr=1;
			sum = noiseFloor;
		}
		lastSeq = seq;
	}
}