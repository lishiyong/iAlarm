/*
 *  YCDouble.c
 *  iAlarm
 *
 *  Created by li shiyong on 11-1-6.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "YCDouble.h"

NSComparisonResult YCCompareDouble(double anDouble, double anotherDouble){
    return YCCompareDoubleWithAccuracy(anDouble, anotherDouble, 10);
}

NSComparisonResult YCCompareDoubleWithAccuracy(double anDouble, double anotherDouble,NSUInteger accuracy){
    if (fabs(anDouble - anotherDouble) < pow(0.1,accuracy)) {
        return NSOrderedSame;
    }else if(anDouble >anotherDouble){
        return NSOrderedDescending;
    }else{
        return NSOrderedAscending;
    }
}



