#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <iomanip>
#include <stdint.h>
using namespace std;

const int VALID = 66;

const int OFFSET = 28;
const int START = 2;
const int ID = 2;
const int Parent = 2;
const int ASN = 10;
const int CHANNEL = 2;
const int RETRY = 2;
const int SEND_SEQ =8;
const int SENT =4;
const int RECV =4;
const int END =2;

const int GETMASK = OFFSET+ID+Parent+START+ASN+CHANNEL+RETRY+SEND_SEQ;

int bl[16] = {0};
int ctr = 0;
int validLine=0;

int main(){
	string line = "";
	string last = "";
	while(getline(cin,line)){
		if(line.length()==VALID){
			validLine++;
			string mask = line.substr(GETMASK,SENT);
			if(mask!=last){
				ctr++;
				last=mask;
				char bin[16];
				uint64_t dec=0;
				std::stringstream ss;
				ss<<std::hex<<mask;
				ss>>dec;
				itoa(dec,bin,2);
				// output
				//cout<<setfill('0')<<setw(16)<<bin<<endl;
				/* statistics */
				for(int i=0; i<16; i++){
					if(bin[i]=='0') bl[i]++;
				}
			}
		}
	}
	for(int i=15; i>=0; i--){
		cout<<bl[i]<<" ";
	}
	cout<<ctr<<endl;
	cout<<validLine;
}