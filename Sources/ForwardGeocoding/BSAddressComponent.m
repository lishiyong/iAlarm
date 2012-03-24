//
//  BSAddressComponent.m
//  Forward-Geocoding
//
//  Created by Björn Sållarp on 3/14/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "BSAddressComponent.h"


@implementation BSAddressComponent
@synthesize shortName, longName, types;


-(void)dealloc
{
	[shortName release];
	[longName release];
	[types release];
	[super dealloc];
}
@end
