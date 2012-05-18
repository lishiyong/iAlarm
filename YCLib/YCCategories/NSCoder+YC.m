//
//  NSCoder-YC.m
//  iAlarm
//
//  Created by li shiyong on 11-1-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSCoder-YC.h"


@implementation NSCoder (YC)

#define    klatitude        @"klatitude"
#define    klongitude       @"klongitude"

- (void)encodeCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate forKey:(NSString *)key
{
	[self encodeDouble:coordinate.latitude forKey:klatitude];
	[self encodeDouble:coordinate.longitude forKey:klongitude];
}

- (CLLocationCoordinate2D)decodeCLLocationCoordinate2DForKey:(NSString *)key
{
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = [self decodeDoubleForKey:klatitude];
	coordinate.longitude = [self decodeDoubleForKey:klongitude];
	return coordinate;
}


#define    klatitudeDelta        @"latitudeDelta"
#define    klongitudeDelta       @"longitudeDelta"
- (void)encodeMKCoordinateSpan:(MKCoordinateSpan)coordinateSpan forKey:(NSString *)key{
	[self encodeDouble:coordinateSpan.latitudeDelta forKey:klatitudeDelta];
	[self encodeDouble:coordinateSpan.latitudeDelta forKey:klongitudeDelta];
}

- (MKCoordinateSpan)decodeMKCoordinateSpanForKey:(NSString *)key{
	MKCoordinateSpan data;
	data.latitudeDelta = [self decodeDoubleForKey:klatitudeDelta];
	data.longitudeDelta = [self decodeDoubleForKey:klongitudeDelta];
	return data;
}


#define    kcenter     @"center"
#define    kspan       @"span"
- (void)encodeMKCoordinateRegion:(MKCoordinateRegion)coordinateRegion forKey:(NSString *)key{
	[self encodeCLLocationCoordinate2D:coordinateRegion.center forKey:kcenter];
	[self encodeMKCoordinateSpan:coordinateRegion.span forKey:kspan];
}
- (MKCoordinateRegion)decodeMKCoordinateRegionForKey:(NSString *)key{
	MKCoordinateRegion data;
	data.center = [self decodeCLLocationCoordinate2DForKey:kcenter];
	data.span = [self decodeMKCoordinateSpanForKey:kspan];
	return data;
}


@end
