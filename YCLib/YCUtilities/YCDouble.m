/*
 *  YCDouble.c
 *  iAlarm
 *
 *  Created by li shiyong on 11-1-6.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "YCDouble.h"

NSComparisonResult YCCompareFloat(CGFloat anFloat, CGFloat anotherFloat){
    return YCCompareFloatWithNumber(anFloat, anotherFloat, 10);
}

NSComparisonResult YCCompareFloatWithNumber(CGFloat anFloat, CGFloat anotherFloat,NSInteger n){
    if (fabs(anFloat - anotherFloat) < pow(0.1,n)) {
        return NSOrderedSame;
    }else if(anFloat >anotherFloat){
        return NSOrderedDescending;
    }else{
        return NSOrderedAscending;
    }
}



