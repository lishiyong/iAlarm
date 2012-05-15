//
//  offSetData.m
//  TestMapOffset
//
//  Created by li shiyong on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OffsetData.h"

@implementation OffsetData

@synthesize longitude, latitude, offsetLongitude, offsetLatitude;

- (void)dealloc {
	[longitude release];
	[latitude release];
	[super dealloc];
}

@end
