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
    return YCCompareFloatWithAccuracy(anFloat, anotherFloat, 10);
}

NSComparisonResult YCCompareFloatWithAccuracy(CGFloat anFloat, CGFloat anotherFloat,NSUInteger accuracy){
    if (fabs(anFloat - anotherFloat) < pow(0.1,accuracy)) {
        return NSOrderedSame;
    }else if(anFloat >anotherFloat){
        return NSOrderedDescending;
    }else{
        return NSOrderedAscending;
    }
}



