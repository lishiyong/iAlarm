//
//  YCPlacemark+YCForwardGeocode.m
//  iAlarm
//
//  Created by li shiyong on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCMaps.h"
#import "YCFunctions.h"
#import <AddressBook/AddressBook.h>
#import "BSKmlResult.h"
#import "YCPlacemark+YCForwardGeocode.h"

@implementation YCPlacemark (YCForwardGeocode)

- (id)initWithBSKmlResult:(BSKmlResult*)kmlResult{
    
    NSString *country  = nil;
    NSString *state = nil;
    NSString *city = nil;
    NSString *street = nil;
    NSString *countryCode = nil;
    NSString *ISOcountryCode = nil;
    NSString *zip = nil;

    NSString *administrativeArea = nil;
    NSString *subAdministrativeArea = nil;
    NSString *locality = nil;
    NSString *subLocality = nil;
    NSString *thoroughfare = nil;
    NSString *subThoroughfare = nil;
    
    NSString *name = nil;
    CLRegion *region = nil;
    CLLocation *location = nil;
    NSString *formattedAddress = nil;
    
    NSString *inlandWater = nil;
    NSString *ocean  = nil;
    NSArray *areasOfInterest = nil;
    
    /////////////
    /////
    CLLocationCoordinate2D coordinate = kmlResult.coordinate;
    
    /////
    street = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"route"] objectAtIndex:0] longName];
    city = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"locality"] objectAtIndex:0] longName];
    if (!city) 
        city = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"administrative_area_level_2"] objectAtIndex:0] longName];
    state = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"administrative_area_level_1"] objectAtIndex:0] longName];
    country = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"country"] objectAtIndex:0] longName];
    countryCode = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"country"] objectAtIndex:0] shortName];
    ISOcountryCode = countryCode;
    zip = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"postal_code"] objectAtIndex:0] longName];

    /////
    administrativeArea = state;
    subAdministrativeArea = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"administrative_area_level_2"] objectAtIndex:0] longName];
    locality = city;
    if (subAdministrativeArea && [locality isEqualToString:subAdministrativeArea]) //如果城市与副省相等
        subAdministrativeArea = nil;
    subLocality = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"sublocality"] objectAtIndex:0] longName];
    thoroughfare = street;
    subThoroughfare = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"street_number"] objectAtIndex:0] longName];
    
    
    /////
    name = kmlResult.name;
    region = YCRegionForCoordinateRegion(kmlResult.coordinateRegion);
    location = [[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] autorelease];
    formattedAddress = kmlResult.address;
    
    /////
    /////////////
    
    
    NSMutableDictionary *addressDic = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if (country)
        [addressDic setObject:country forKey:(NSString *)kABPersonAddressCountryKey];
    if (state)
        [addressDic setObject:state forKey:(NSString *)kABPersonAddressStateKey];
    if (city)
        [addressDic setObject:city forKey:(NSString *)kABPersonAddressCityKey];
    if (street) 
        [addressDic setObject:street forKey:(NSString *)kABPersonAddressStreetKey];
    if (countryCode)
        [addressDic setObject:countryCode forKey:(NSString *)kABPersonAddressCountryCodeKey];
    if (ISOcountryCode)
        [addressDic setObject:ISOcountryCode forKey:@"ISOcountryCode"];
    if (zip)
        [addressDic setObject:zip forKey:(NSString *)kABPersonAddressZIPKey];
    
    
    if (administrativeArea)
        [addressDic setObject:administrativeArea forKey:@"AdministrativeArea"];
    if (subAdministrativeArea)
        [addressDic setObject:subAdministrativeArea forKey:@"SubAdministrativeArea"];
    if (locality)
        [addressDic setObject:locality forKey:@"Locality"];
    if (subLocality)
        [addressDic setObject:subLocality forKey:@"SubLocality"];
    if (thoroughfare)
        [addressDic setObject:thoroughfare forKey:@"Thoroughfare"];
    if (subThoroughfare)
        [addressDic setObject:subThoroughfare forKey:@"SubThoroughfare"];
        
    if (name)
        [addressDic setObject:name forKey:@"Name"];
    if (region)
        [addressDic setObject:region forKey:@"Region"];
    if (location)
        [addressDic setObject:location forKey:@"Location"];
    if (formattedAddress)
        [addressDic setObject:formattedAddress forKey:@"FormattedAddress"];

    if (inlandWater)
        [addressDic setObject:inlandWater forKey:@"InlandWater"];
    if (ocean)
        [addressDic setObject:ocean forKey:@"Ocean"];
    if (areasOfInterest)
        [addressDic setObject:areasOfInterest forKey:@"AreasOfInterest"];
    
    
    MKPlacemark *mkPlacemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:addressDic];
    
    self = [self initWithPlacemark:mkPlacemark];
    //[self debug];
    return self;
     
}

+ (NSArray *)placemarksWithBSKmlResults:(NSArray*)kmlResults{
    
    NSMutableArray *placemarks = [NSMutableArray arrayWithCapacity:kmlResults.count];
    for (id anObj in kmlResults) {
        YCPlacemark *placemark = [[YCPlacemark alloc] initWithBSKmlResult:anObj];
        [placemarks addObject:placemark];
        [placemark release];
    }
    return placemarks;
     
    //NSLog(@"kmlResults = %@",[kmlResults description]);
    //return nil;
}

+ (NSArray *)placemarksWithCLPacemarks:(NSArray*)clPacemarks{
    NSMutableArray *placemarks = [NSMutableArray arrayWithCapacity:clPacemarks.count];
    for (id anObj in clPacemarks) {
        YCPlacemark *placemark = [[YCPlacemark alloc] initWithPlacemark:anObj];
        [placemarks addObject:placemark];
        [placemark release];
    }
    return placemarks;
}

@end
