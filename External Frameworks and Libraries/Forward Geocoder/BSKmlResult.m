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

#import "YCFunctions.h"
#import "BSKmlResult.h"


@implementation BSKmlResult

@synthesize address = _address;
@synthesize accuracy = _accuracy;
@synthesize countryNameCode = _countryNameCode;
@synthesize countryName = _countryName;
@synthesize subAdministrativeAreaName = _subAdministrativeAreaName;
@synthesize localityName = _localityName;
@synthesize addressComponents = _addressComponents;
@synthesize viewportSouthWestLat = _viewportSouthWestLat;
@synthesize viewportSouthWestLon = _viewportSouthWestLon;
@synthesize viewportNorthEastLat = _viewportNorthEastLat;
@synthesize viewportNorthEastLon = _viewportNorthEastLon;
@synthesize boundsSouthWestLat = _boundsSouthWestLat;
@synthesize boundsSouthWestLon = _boundsSouthWestLon; 
@synthesize boundsNorthEastLat = _boundsNorthEastLat; 
@synthesize boundsNorthEastLon = boundsNorthEastLon; 
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize searchString =_searchString;
@synthesize types = _types;

- (void)dealloc
{	
    [_address release];
    [_countryNameCode release];
    [_countryName release];
    [_subAdministrativeAreaName release];
    [_localityName release];
    [_addressComponents release];
    [_searchString release];
	[super dealloc];
}

- (CLLocationCoordinate2D)coordinate 
{
	CLLocationCoordinate2D coordinate = {self.latitude, self.longitude};
	return coordinate;
}

- (MKCoordinateSpan)coordinateSpan
{
	// Calculate the difference between north and south to create a span.
	float latitudeDelta = fabs(fabs(self.viewportNorthEastLat) - fabs(self.viewportSouthWestLat));
	float longitudeDelta = fabs(fabs(self.viewportNorthEastLon) - fabs(self.viewportSouthWestLon));
	
	MKCoordinateSpan spn = {latitudeDelta, longitudeDelta};
	
	return spn;
}

- (MKCoordinateRegion)coordinateRegion
{
	MKCoordinateRegion region;
	region.center = self.coordinate;
	region.span = self.coordinateSpan;
	
	return region;
}

- (NSArray*)findAddressComponent:(NSString*)typeName
{
    //2012-06-02修改 lishiyong
	NSMutableArray *matchingComponents = [[[NSMutableArray alloc] init] autorelease];
	
	for (int i = 0, components = [self.addressComponents count]; i < components; i++) {
		BSAddressComponent *component = [self.addressComponents objectAtIndex:i];
		if (component.types != nil) {
			for(int j = 0, typesCount = [component.types count]; j < typesCount; j++) {
				NSString * type = [component.types objectAtIndex:j];
				if ([type isEqualToString:typeName]) {
					[matchingComponents addObject:component];
					break;
				}
			}
		}
		
	}
	
	return matchingComponents.count > 0 ? matchingComponents : nil;
}

- (NSString *)description{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"coordinate = %@",NSStringFromCLLocationCoordinate2D(self.coordinate)];
    [string appendFormat:@"\naddress = %@",self.address];
    [string appendFormat:@"\ncountryName = %@",self.countryName];
    [string appendFormat:@"\nlocalityName = %@",self.localityName];
    [string appendFormat:@"\naddressComponents = %@",[self.addressComponents description]];
    return string;
}

- (NSString *)debugDescription{
    return [self description];
}

//lishiyong 2012-6-2添加
- (NSString *)name{
    
    if (NSNotFound != [self.types indexOfObject:@"political"]) { //不能是行政区域
        return nil;
    }
    
    NSString *name = nil;
    for (BSAddressComponent *aComponent in self.addressComponents) {
        if ([self.types isEqualToArray:aComponent.types]) {//找到类型相等的，就是name
            name = aComponent.longName;
            break;
        }
    }
    
    return name;
}

@end
