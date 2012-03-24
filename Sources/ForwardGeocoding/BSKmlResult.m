//
//  Created by Björn Sållarp on 2010-03-13.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

/**
 
 Object for storing placemark results from Googles geocoding API
 
 **/

#import "BSKmlResult.h"



@implementation BSKmlResult
@synthesize searchString;


@synthesize address, accuracy, countryNameCode, countryName, subAdministrativeAreaName, localityName, addressComponents;
@synthesize viewportSouthWestLat, viewportSouthWestLon, viewportNorthEastLat, viewportNorthEastLon;
@synthesize boundsSouthWestLat, boundsSouthWestLon, boundsNorthEastLat, boundsNorthEastLon, latitude, longitude;


- (CLLocationCoordinate2D)coordinate 
{
	CLLocationCoordinate2D coordinate = {latitude, longitude};
	return coordinate;
}

- (MKCoordinateSpan)coordinateSpan
{
	// Calculate the difference between north and south to create a
	// a span.
	float latitudeDelta = viewportNorthEastLat - viewportSouthWestLat;
	float longitudeDelta = viewportNorthEastLon - viewportSouthWestLon;
	
	MKCoordinateSpan spn = {latitudeDelta, longitudeDelta};
	
	return spn;
}

-(MKCoordinateRegion)coordinateRegion
{
	MKCoordinateRegion region;
	region.center = self.coordinate;
	region.span = self.coordinateSpan;
	
	return region;
}

-(NSArray*)findAddressComponent:(NSString*)typeName
{
	NSMutableArray *matchingComponents = [[NSMutableArray alloc] init];
	
	int components = [addressComponents count];
	for(int i = 0; i < components; i++)
	{
		BSAddressComponent *component = [addressComponents objectAtIndex:i];
		if(component.types != nil)
		{
			BOOL isMatch = NO;
			int typesCount = [component.types count];
			for(int j = 0; isMatch == NO && j < typesCount; j++)
			{
				NSString * type = [component.types objectAtIndex:j];
				if([type isEqualToString:typeName])
				{
					[matchingComponents addObject:component];
					isMatch = YES;
				}
			}
		}
		
	}
	
	[matchingComponents autorelease];
	
	return matchingComponents;
}

-(void)dealloc
{	
	if(address != nil) {
		[address release];
	}
	if(countryNameCode != nil) {
		[countryNameCode release];
	}
	if(countryName != nil) {
		[countryName release];
	}
	if(subAdministrativeAreaName != nil) {
		[subAdministrativeAreaName release];
	}
	if(localityName != nil) {
		[localityName release];
	}
	if(addressComponents != nil){
		[addressComponents release];
	}
	
	[super dealloc];
}


@end
