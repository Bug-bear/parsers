/**
filter out unique masks
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
const int FNO = 6;

int main(){
	ofstream mask2;
	mask2.open ("mask_count2.txt", ios::out | ios::app);

  	string line;
	string last;
  	while(getline(cin,line))
  	{
		string dump,mask;
		std::stringstream ss(line);
		for(int i=0; i<5; i++)
			ss>>dump;
		ss>>mask;
		if(mask!=last){
			last=mask;
			mask2<<mask<<endl;
		}
		else continue;
	}


	//mask2<<<<endl;
	mask2.close();
	//time.close();
}

