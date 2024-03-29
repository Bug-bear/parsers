/**
parse records of gina sniffer (for NF-ETX relationship)

input format:
	noise lines (36)
	noise lines
	...
	noise lines
	pkt lines (66)

output format:
	each line: (channel) (average noise floor before reception) (number of sniffed readings) (asn) (pkt sequence number)
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
const int PKTLEN = 66;	//length of packet payload lines
const int PKTDUMP = 54;	//length of unwanted packet payload
const int ED = -91;

string flipEndian(string s){ //only using the lower 40 bits (5 bytes)
	string flipped;
	flipped=s.substr(0,2)+s.substr(4,2)+s.substr(2,2)+s.substr(8,2)+s.substr(6,2);
	return flipped;
}

int main(){
	string line;
	int sum = 0;
	int ctr = 0;
	double average = 0;
	// record channels regardless of line types
	int lastFreq = 12;
	int freq = 12;

  	while(getline(cin,line)){
		//cout<<line.length()<<endl;
		std::stringstream s(line);
		std::stringstream ss;

		if(line.length()==NFLEN){
			string dump, nfaHex, nfbHex, chanHex;
			int nfa, nfb, noiseFloor, chan;

			//s>>dump>>dump>>dump>>dump>>dump;
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
			freq = chan;
			//cout<<noiseFloor<<" "<<chan<<endl;

			if(freq==lastFreq){
				sum += noiseFloor;
				ctr++;
			} else{
				sum = noiseFloor;
				lastFreq=freq;
				ctr = 1;
			}
		}
		else if(line.length()==PKTLEN){
			//extract sequence number from pkt payload
			ss<<std::hex<<line.substr(PKTDUMP,2);
			ss>>seq;	ss.clear();

			if(freq!=lastFreq){
				sum = 0;
				lastFreq=freq;
				ctr = 0;
			}

			//calculate the average of preceeding noise floors
			if(ctr!=0){
				average = (double)sum/ctr;
				cout<<setw(3)<<freq<<" "<<fixed<<setprecision(3)<<setw(6)<<average+ED<<" "<<setw(3)<<ctr<<" ";
				//cout<< sum<<" "<<ctr<<" "<<(double)sum/ctr<<endl;
				sum = 0; ctr = 0; average = 0;
			}
			/*
			ss<<std::hex<<line.substr(44,2);
			ss>>freq;	ss.clear();
			cout<<setw(3)<<freq<<" ";
			*/

			//extract asn from pkt payload
			int asn = 0;
			string asnStr = line.substr(34,10);
			ss<<std::hex<<flipEndian(asnStr);
			ss>>asn; ss.clear();
			cout<<asn<<" ";
			cout<<setw(3)<<seq<<endl;
			//cout<<setw(3)<<line.substr(PKTDUMP,2)<<endl;
		}
	}
}