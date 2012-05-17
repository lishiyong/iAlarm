//
//  offSetData.m
//  TestMapOffset
//
//  Created by li shiyong on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OffsetData.h"

@implementation OffsetData

@synthesize latitude, longitude, offsetLatitude, offsetLongitude;

- (NSString *)description{
    NSString *s = [NSString stringWithFormat:@"latitude = %@, longitude = %@, offsetLatitude = %.6f, offsetLongitude = %.6f"
                   ,latitude, longitude, offsetLatitude, offsetLongitude];
    return s;
}

- (void)dealloc {
    [latitude release];
	[longitude release];
	[super dealloc];
}

@end
