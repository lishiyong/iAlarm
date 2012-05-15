//
//  YCOverlayImage.m
//  TestMyOverlay
//
//  Created by li shiyong on 11-8-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCOverlayImage.h"


@implementation YCOverlayImage

@synthesize boundingMapRect;
@synthesize coordinate;


- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate andBoundingMapRect:(MKMapRect)theBoundingMapRect{
	
	self = [super init];
	if (self) {
		coordinate = theCoordinate;
		boundingMapRect = theBoundingMapRect;
	}
	
	return self;
}



@end
