//
//  NSCoder-YC.m
//  iAlarm
//
//  Created by li shiyong on 11-1-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSCoder+YC.h"


@implementation NSCoder (YC)

#define    klatitude        @"klatitude"
#define    klongitude       @"klongitude"

#define    klatitudeDelta        @"latitudeDelta"
#define    klongitudeDelta       @"longitudeDelta"

#define    kcenter     @"center"
#define    kspan       @"span"

//////////////////
//为了兼容以前的编码错误
- (CLLocationCoordinate2D)oldDecodeCLLocationCoordinate2DForKey:(NSString *)key
{
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = [self decodeDoubleForKey:klatitude];
	coordinate.longitude = [self decodeDoubleForKey:klongitude];
	return coordinate;
}


- (MKCoordinateSpan)oldDecodeMKCoordinateSpanForKey:(NSString *)key{
	MKCoordinateSpan data;
	data.latitudeDelta = [self decodeDoubleForKey:klatitudeDelta];
	data.longitudeDelta = [self decodeDoubleForKey:klongitudeDelta];
	return data;
}


- (MKCoordinateRegion)oldDecodeMKCoordinateRegionForKey:(NSString *)key{
	MKCoordinateRegion data;
	data.center = [self decodeCLLocationCoordinate2DForKey:kcenter];
	data.span = [self decodeMKCoordinateSpanForKey:kspan];
	return data;
}

/////////////////

- (void)encodeCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate forKey:(NSString *)key
{
	[self encodeDouble:coordinate.latitude forKey:[NSString stringWithFormat:@"%@-%@",key,klatitude]];
	[self encodeDouble:coordinate.longitude forKey:[NSString stringWithFormat:@"%@-%@",key,klongitude]];
}

- (CLLocationCoordinate2D)decodeCLLocationCoordinate2DForKey:(NSString *)key
{
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = [self decodeDoubleForKey:[NSString stringWithFormat:@"%@-%@",key,klatitude]];
	coordinate.longitude = [self decodeDoubleForKey:[NSString stringWithFormat:@"%@-%@",key,klongitude]];
	return coordinate;
}

- (void)encodeMKCoordinateSpan:(MKCoordinateSpan)coordinateSpan forKey:(NSString *)key{
	[self encodeDouble:coordinateSpan.latitudeDelta forKey:[NSString stringWithFormat:@"%@-%@",key,klatitudeDelta]];
	[self encodeDouble:coordinateSpan.latitudeDelta forKey:[NSString stringWithFormat:@"%@-%@",key,klongitudeDelta]];
}

- (MKCoordinateSpan)decodeMKCoordinateSpanForKey:(NSString *)key{
	MKCoordinateSpan data;
	data.latitudeDelta = [self decodeDoubleForKey:[NSString stringWithFormat:@"%@-%@",key,klatitudeDelta]];
	data.longitudeDelta = [self decodeDoubleForKey:[NSString stringWithFormat:@"%@-%@",key,klongitudeDelta]];
	return data;
}

- (void)encodeMKCoordinateRegion:(MKCoordinateRegion)coordinateRegion forKey:(NSString *)key{
	[self encodeCLLocationCoordinate2D:coordinateRegion.center forKey:[NSString stringWithFormat:@"%@-%@",key,kcenter]];
	[self encodeMKCoordinateSpan:coordinateRegion.span forKey:[NSString stringWithFormat:@"%@-%@",key,kspan]];
}

- (MKCoordinateRegion)decodeMKCoordinateRegionForKey:(NSString *)key{
	MKCoordinateRegion data;
	data.center = [self decodeCLLocationCoordinate2DForKey:[NSString stringWithFormat:@"%@-%@",key,kcenter]];
	data.span = [self decodeMKCoordinateSpanForKey:[NSString stringWithFormat:@"%@-%@",key,kspan]];
	return data;
}


@end
