//
//  NSValue+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSValue+YC.h"

@implementation NSValue (YC)

+ (NSValue *)valueWithMapRect:(MKMapRect)mapRect{
    return [NSValue valueWithBytes:&mapRect objCType:@encode(MKMapRect)];
}

- (MKMapRect)mapRectValue{
    MKMapRect mapRect;
    [self getValue:&mapRect];
    return mapRect;
}

+ (NSValue *)valueWithSelector:(SEL)aSelector{
    return [NSValue valueWithBytes:&aSelector objCType:@encode(SEL)];
}

- (SEL)selectorValue{
    SEL sel;
    [self getValue:&sel];
    return sel;
}

@end
