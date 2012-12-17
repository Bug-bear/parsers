/**
parse received pkts in 4-branch test

input: standard pre14 payload

output:
*/

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <iomanip>
#include <stdint.h>
using namespace std;

const static int PKTLEN = 66;
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
		int retry;
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
	retry = hexStringToInt(inputLine.substr(0,RETRY)); 		inputLine = inputLine.substr(RETRY);
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
	ofstream temp;
	temp.open ("temp", ios::out | ios::app);
	vector<Packet> packets;
	vector<vector<Packet> >    v5(8, vector<Packet>());
	
	int startSeq[8] = {0};
	int finalSeq[8] = {0};
	int count[8] = {0};
	
	string line;	
	while(getline(cin,line)){
		if(line.length()!=PKTLEN){
			cerr<<line<<endl;
			continue;
		}
		Packet entry(line);
		std::stringstream ss;
		//v5[entry.id-2].push_back(entry); //only do this when we need to further manipulate payload
		
		// asn
		ss<<std::hex<<entry.asn;
		uint64_t dec = 0;
		ss>>dec;
		temp<<setfill('0')<<setw(10)<<dec<<" ";		
		
		// sequence
		temp<<setw(3)<<entry.seq+1<<" ";
		
		//id
		temp<<entry.id<<" ";
		
		// retry (now BL update counts)
		temp<<entry.retry<<" ";
		
		// binary channel mask
		//cout<<entry.sent_mask<<endl;
		ss.clear();
		ss<<std::hex<<entry.sent_mask;
		ss>>dec;		
		char bin[16];
		itoa(dec,bin,2);
		temp<<setfill('0')<<setw(16)<<bin<<" "<<endl;	
	}
	temp.close();
}

