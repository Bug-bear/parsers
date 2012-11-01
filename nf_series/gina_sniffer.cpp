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
const static int OFFSET = 28;
const static int START = 2;
const static int ID = 2;
const static int PARENT = 2;
const static int ASN = 10;
const static int CHANNEL = 2;
const static int RETRY = 2;
const static int SEQ =8;
const static int SENT =4;
const static int RECV =4;
const static int END =2;

const static int POS[] = {START,ASN,CHANNEL,SEQ,RECV,END};
//					0	  1	  	2	  	3		4	5
const static int FNO = 6; //number of interesting columns

string flipEndian(string s){ //only using the lower 40 bits (5 bytes)
	string flipped;
	flipped=s.substr(0,2)+s.substr(4,2)+s.substr(2,2)+s.substr(8,2)+s.substr(6,2);
	return flipped;
}

int hexStringToInt(string str){
	int ret = 0;
	std::stringstream ss;
	ss<<std::hex<<str;
	ss>>ret;
	return ret;
}

class Packet{
	public: //for convenience
		string start;
		int id;
		int parent;
		string asn;
		string channel;
		string retry;
		int seq;
		string sent_mask;
		string recv_mask;
		string end;
	//public:
		Packet(string);
		void display();
};
	
Packet::Packet(string inputLine){
	inputLine = inputLine.substr(OFFSET);
	start = inputLine.substr(0,START); 						inputLine = inputLine.substr(START);
	id = hexStringToInt(inputLine.substr(0,ID));			inputLine = inputLine.substr(ID);
	parent = hexStringToInt(inputLine.substr(0,PARENT)); 	inputLine = inputLine.substr(PARENT);
	asn = flipEndian(inputLine.substr(0,ASN)); 				inputLine = inputLine.substr(ASN);
	channel = inputLine.substr(0,CHANNEL); 					inputLine = inputLine.substr(CHANNEL);
	retry = inputLine.substr(0,RETRY); 						inputLine = inputLine.substr(RETRY);
	seq = hexStringToInt(inputLine.substr(0,SEQ)); 			inputLine = inputLine.substr(SEQ);
	sent_mask = inputLine.substr(0,SENT); 					inputLine = inputLine.substr(SENT);
	recv_mask = inputLine.substr(0,RECV); 					inputLine = inputLine.substr(RECV);
	end = inputLine.substr(0,END); 							inputLine = inputLine.substr(END);
}

void Packet::display(){
	//string ret = std::to_string(id) + " " + std::to_string(iparent) + " " + asn + " " + seq;
	cout<<id<<" "<<parent<<" "<<asn<<" "<<seq<<endl;
}


int main(){
	string line;
	int sum = 0;
	int ctr = 0;
	double average = 0;
	// record channels regardless of line types
	int lastFreq = 12;
	int freq = 12;
	int lastSeq = 0;
	int seq = 0;
	int ln = 0;

  	while(getline(cin,line)){
		ln++;
		//cout<<line.length()<<endl;
		std::stringstream s(line);
		std::stringstream ss;

		if(line.length()==NFLEN){ //need to check validity
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
			Packet entry(line);
			//extract sequence number from pkt payload
			//ss<<std::hex<<line.substr(PKTDUMP,2);
			//ss>>seq;	ss.clear();
			seq = entry.seq;
			freq = hexStringToInt(entry.channel);
			
			if(seq==lastSeq) continue;
			lastSeq=seq;

			if(freq!=lastFreq){
				sum = 0;
				lastFreq=freq;
				ctr = 0;
			}

			//calculate the average of preceeding noise floors
			if(ctr!=0){
				average = (double)sum/ctr;
				cout<<setw(3)<<freq<<" "<<fixed<<setprecision(3)<<setw(6)<<average+ED<<" "<<setw(3)<<ctr<<" "<<ln<<" ";
				//cout<< sum<<" "<<ctr<<" "<<(double)sum/ctr<<endl;
			} else{
				cout<<setw(3)<<freq<<" "<<0<<" "<<setw(3)<<ctr<<" "<<ln<<" ";
			}
			sum = 0; ctr = 0; average = 0;
			cout<<setw(3)<<seq<<endl;

			//cout<<setw(3)<<line.substr(PKTDUMP,2)<<endl;
		}
	}
}