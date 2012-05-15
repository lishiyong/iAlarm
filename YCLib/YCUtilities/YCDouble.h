/*
 *  YCDouble.h
 *  iAlarm
 *
 *  Created by li shiyong on 11-1-6.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

//比较2个浮点数；
//返回值:
//0：相等；1：src1>src2; -1:src1<src2
int YCCompareDouble(double src1,double src2);

//n:小数点后有限位
int YCCompareDoubleWithNumber(double src1,double src2,int n);