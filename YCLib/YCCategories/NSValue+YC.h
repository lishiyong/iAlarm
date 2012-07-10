//
//  NSValue+YC.h
//  iAlarm
//
//  Created by li shiyong on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface NSValue (YC)

+ (NSValue *)valueWithMapRect:(MKMapRect)mapRect;
- (MKMapRect)mapRectValue;

+ (NSValue *)valueWithSelector:(SEL)aSelector; 
- (SEL)selectorValue;

@end
