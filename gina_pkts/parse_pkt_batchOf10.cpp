//updated version of parse
//real time PDR based on batches of 10

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <iomanip>
#include <stdint.h>
using namespace std;

const int BATCHSIZE = 10;

const int OFFSET = 36;

const int START = 2;
const int ASN = 10;
const int RATE = 2;
const int CHANNEL = 2;
//const int ID = 2;
//const int RETRY = 2;
const int SEND_SEQ =8;
const int MASK =4;
//const int SENT =4;
const int END =2;

//const int POS[] = {START,CHANNEL,ID,RETRY,SEND_SEQ,RECV,SENT,END};

const int POS[] = {START,ASN,RATE,CHANNEL,SEND_SEQ,MASK,END};
//					0	  1	  	2 		3		4	5	6
const int FNO = 7; //number of interesting columns

string flipEndian(string s){ //only using the lower 40 bits (5 bytes)
	string flipped;
	flipped=s.substr(0,2)+s.substr(4,2)+s.substr(2,2)+s.substr(8,2)+s.substr(6,2);
	return flipped;
}

int main(){
	ofstream etx;
	etx.open ("batchedPDR.txt", ios::out | ios::app);

	int64_t initial_time, final_time;
  	string line;
  	int ln=0;
  	int batch=1;
  	int batchCtr=0;
  	int lastSeq=-1;
  	while(getline(cin,line))
  	{
		ln++;
		//cout<<line.size()<<endl;
		line = line.substr(OFFSET,line.size()-OFFSET);

		for(int i=0; i<FNO; i++)
		{
			string hex = line.substr(0,POS[i]);
			if((i!=0)&&(i!=6)) //exclude START & END
			{
				uint64_t dec=0;
				std::stringstream ss;

				if(i==1)	//10bits asn
				{
					string asn=flipEndian(hex);
					ss<<std::hex<<asn;
					ss>>dec;

					if(ln==1) initial_time=dec; //start time
					//final_time = dec; //finishing time
					//start counting from the very 1st pkt
					cout<<setfill('0')<<setw(10)<<dec-initial_time<<" ";
				}
				else
				{
					ss<<std::hex<<hex;
					ss>>dec;
					if(i==4) //seq; output PDR
					{
						if(dec==lastSeq){
							;
						}
						else if(dec<BATCHSIZE*batch){
							batchCtr++;
							lastSeq=dec;
						}
						else{
							etx<<fixed<<setprecision(3)<<(double)batchCtr/BATCHSIZE<<endl;
							lastSeq=dec;
							batch++;
							batchCtr=1;
						}
						cout<<setw(3)<<dec+1<<" ";
						//cout<<fixed<<setprecision(3)<<(double)ln/(dec+1)<<" ";
					}
					else if(i==5) //binary channel mask
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
	etx<<fixed<<setprecision(3)<<(double)batchCtr/BATCHSIZE<<endl;
	etx.close();
}

