/*
 *  YCDouble.c
 *  iAlarm
 *
 *  Created by li shiyong on 11-1-6.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "YCDouble.h"
#include <math.h>

int compareDouble(double src1,double src2,double littleDouble){
	double d = src1 - src2;
	
	int retVal = 0;
	if (fabs(d) < littleDouble) return 0;
	if (d > littleDouble) return  1;
	if (d < 0) return  -1;
	
	return retVal;
	
}

#define kLittleDouble  0.00000000001
//比较2个浮点数；
//返回值:
//0：相等；1：src1>src2; -1:src1<src2
int YCCompareDouble(double src1,double src2){
	return compareDouble(src1,src2,kLittleDouble);
}


int YCCompareDoubleWithNumber(double src1,double src2,int n){
	double littleDouble =  pow(0.1,n);
	return compareDouble(src1,src2,littleDouble);
}