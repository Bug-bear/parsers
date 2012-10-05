/**
version 2
*/

Steps:

1. Use parser2.cpp to 1) interleave columns, 2) flip ASN Endianess and convert it to decimal, 3) convert channel number to decimal, 4) output real-time PDR, 5) formated 16-bit channel mask and 6) output overall ETX to ETX2.txt

Note: a. In practise convert2.bat is used for batch processing; b. which parser to use depends on payload structure.

2. Use combine_pdr2.cpp to generate a tuple of (asn, real-time pdr) to reflect the fluctuation of pdr along the time.

Note: a. In practise combine_pdr2.bat is used to batch process of result; b. the result should be sorted based on "asn" column in Excel.

3. Use combine_pdr2_post.cpp to average the result of last step.

4. Use mask_filter.cpp to output mask update records to mask_count2.txt

Note: 
a. In practise mask_count.bat is used for batch processing;
b. Version number 3 are for trunk payload