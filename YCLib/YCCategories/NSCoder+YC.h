//
//  NSCoder-YC.h
//  iAlarm
//
//  Created by li shiyong on 11-1-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NSCoder (YC)

- (void)encodeCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate forKey:(NSString *)key;
- (CLLocationCoordinate2D)decodeCLLocationCoordinate2DForKey:(NSString *)key;

- (void)encodeMKCoordinateSpan:(MKCoordinateSpan)coordinateSpan forKey:(NSString *)key;
- (MKCoordinateSpan)decodeMKCoordinateSpanForKey:(NSString *)key;

- (void)encodeMKCoordinateRegion:(MKCoordinateRegion)coordinateRegion forKey:(NSString *)key;
- (MKCoordinateRegion)decodeMKCoordinateRegionForKey:(NSString *)key;

@end