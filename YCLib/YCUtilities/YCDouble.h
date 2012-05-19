/*
 *  YCDouble.h
 *  iAlarm
 *
 *  Created by li shiyong on 11-1-6.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <math.h>

/**
 The anFloat and anotherFloat are exactly equal to each other, NSOrderedSame
 The anFloat is greater than anotherFloat, NSOrderedDescending
 The anFloat is less than anotherFloat, NSOrderedAscending.

 NSOrderedSame:       相等；
 NSOrderedDescending: anFloat > anotherFloat; 
 NSOrderedAscending:  anFloat < anotherFloat;
 **/
NSComparisonResult YCCompareFloat(CGFloat anFloat, CGFloat anotherFloat);


//accuracy:小数点后有限位
NSComparisonResult YCCompareFloatWithAccuracy(CGFloat anFloat, CGFloat anotherFloat,NSUInteger accuracy);