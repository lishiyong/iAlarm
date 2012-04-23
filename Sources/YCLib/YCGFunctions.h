//
//  YCGFunctions.h
//  iAlarm
//
//  Created by li shiyong on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//产生一个唯一的序列号
NSString* YCSerialCode();

/**
    The anFloat and anotherFloat are exactly equal to each other, NSOrderedSame
    The anFloat is greater than anotherFloat, NSOrderedDescending
    The anFloat is less than anotherFloat, NSOrderedAscending.
 */
NSComparisonResult compareFloat(CGFloat anFloat, CGFloat anotherFloat);

