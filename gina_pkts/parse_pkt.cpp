/**
parse received pkts
 - asn converted to decimal
 - ETX (overall and real time) calculated
*/

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <iomanip>
#include <stdint.h>
using namespace std;

const int OFFSET = 36;

const int START = 2;
const int ASN = 10;
const int CHANNEL = 2;
//const int ID = 2;
//const int RETRY = 2;
const int SEND_SEQ =8;
const int RECV =4;
//const int SENT =4;
const int END =2;

//const int POS[] = {START,CHANNEL,ID,RETRY,SEND_SEQ,RECV,SENT,END};

const int POS[] = {START,ASN,CHANNEL,SEND_SEQ,RECV,END};
//					0	  1	  	2	  	3		4	5
const int FNO = 6; //number of interesting columns

string flipEndian(string s){ //only using the lower 40 bits (5 bytes)
	string flipped;
	flipped=s.substr(0,2)+s.substr(4,2)+s.substr(2,2)+s.substr(8,2)+s.substr(6,2);
	return flipped;
}

int main(){
	int64_t initial_time, final_time;
  	string line;
  	int ln=0;
  	while(getline(cin,line))
  	{
		ln++;
		line = line.substr(OFFSET,line.size()-OFFSET);

		for(int i=0; i<FNO; i++)
		{
			string hex = line.substr(0,POS[i]);
			if((i!=0)&&(i!=5)) //exclude START & END
			{
				uint64_t dec=0;
				std::stringstream ss;

				if(i==1)	//10bits asn
				{
					string asn=flipEndian(hex);
					ss<<std::hex<<asn;
					ss>>dec;

					//if(ln==1) initial_time=dec; //start time
					//final_time = dec; //finishing time
					//start counting from the very 1st pkt
					cout<<setfill('0')<<setw(10)<<dec<<" ";
				}
				else
				{
					ss<<std::hex<<hex;
					ss>>dec;
					if(i==3) //output real-time PDR
					{
						cout<<setw(3)<<dec+1<<" ";
						//cout<<fixed<<setprecision(3)<<(double)ln/(dec+1)<<" ";
					}
					else if(i==4) //binary channel mask
					{
						char bin[16];
						itoa(dec,bin,2);
						cout<<setfill('0')<<setw(16)<<bin<<" ";
					}
					else
					{
						cout<<setw(3)<<dec<<" ";
					}
				}
			}
			else cout<<setw(2)<<hex<<" "; //hex string

			line=line.substr(POS[i]);
		}
		cout<<endl;
	}


	ofstream etx;
	etx.open ("etx2.txt", ios::out | ios::app);
	//time.open ("time2.txt", ios::out | ios::app);
	//etx<<fixed<<setprecision(3)<<(double)300/ln<<endl; //calculate ETX
	//record period in sec (meaningless in the current implementation)
	//time<<(double)(final_time-initial_time)*30/1000<<endl;
	etx.close();
	//time.close();
}

