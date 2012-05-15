//
//  YCOverlayImage.h
//  TestMyOverlay
//
//  Created by li shiyong on 11-8-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface YCOverlayImage :NSObject <MKOverlay> {
	MKMapRect boundingMapRect;
	CLLocationCoordinate2D coordinate;

}

@property (nonatomic) MKMapRect boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;



- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate andBoundingMapRect:(MKMapRect)theBoundingMapRect;



@end
