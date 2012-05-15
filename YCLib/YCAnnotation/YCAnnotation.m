//
//  YCAnnotation.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCMapPointAnnotation.h"
#import "YCAnnotation.h"

@implementation YCAnnotation
@synthesize identifier, placemarkForReverse, placeForSearch, annotationType, changedBySearch;

- (id)initWithIdentifier:(NSString*)theIdentifier{
    return [self initWithCoordinate:kCLLocationCoordinate2DInvalid identifier:theIdentifier];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate identifier:(NSString*)theIdentifier{
    self = [super initWithCoordinate:theCoordinate title:nil subTitle:nil addressDictionary:nil];
    if (self) {
        identifier = [theIdentifier copy];
    }
    return self;
}

- (void)dealloc 
{
	[identifier release];
	[placemarkForReverse release];
	[placeForSearch release];
	[super dealloc];
}

@end
