//
//  YCAnnotation.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCAnnotation.h"


@implementation YCAnnotation

@synthesize coordinate;
@synthesize subtitle;
@synthesize title;
@synthesize annotationType;
@synthesize placemarkForReverse;
@synthesize placeForSearch;
@synthesize identifier;
@synthesize changedBySearch;

/*
- (id)init{
	return [self initWithCoordinate:CLLocationCoordinate2DMake(0, 0) addressDictionary:nil];
}
 */

- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate addressDictionary:(NSDictionary *)theAddressDictionary identifier:(NSString*)theIdentifier{
	self = [super initWithCoordinate:theCoordinate addressDictionary:theAddressDictionary];
    if (self) {
		identifier = [theIdentifier retain];
	}
	return self;
}

- (id)initWithIdentifier:(NSString*)theIdentifier{
	return [self initWithCoordinate:CLLocationCoordinate2DMake(0, 0) addressDictionary:nil identifier:theIdentifier];
} 

- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate addressDictionary:(NSDictionary *)theAddressDictionary{
	return [self initWithCoordinate:theCoordinate addressDictionary:theAddressDictionary identifier:nil];
}



- (void)dealloc 
{
	[title release];
	[subtitle release];
	[placemarkForReverse release];
	[placeForSearch release];
	[identifier release];
	[super dealloc];
	
}

@end
