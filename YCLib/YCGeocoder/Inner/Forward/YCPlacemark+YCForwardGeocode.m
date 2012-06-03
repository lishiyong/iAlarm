//
//  YCPlacemark+YCForwardGeocode.m
//  iAlarm
//
//  Created by li shiyong on 12-6-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCFunctions.h"
#import <AddressBook/AddressBook.h>
#import "BSKmlResult.h"
#import "YCPlacemark+YCForwardGeocode.h"

@implementation YCPlacemark (YCForwardGeocode)

- (id)initWithBSKmlResult:(BSKmlResult*)kmlResult{
    
    NSString *street = nil;
    NSString *city = nil;
    NSString *state = nil;
    NSString *zip = nil;
    NSString *country  = nil;
    NSString *countryCode = nil;
    NSString *name = nil;
    NSString *subAdministrativeArea = nil;
    NSString *subLocality = nil;
    NSString *subThoroughfare = nil;
    
    NSString *inlandWater = nil;
    NSString *ocean  = nil;
    NSArray *areasOfInterest = nil;
    CLRegion *region = nil;
    NSString *formattedAddress = nil;
    
    
    CLLocationCoordinate2D coordinate = kmlResult.coordinate;
    
    //
    name = kmlResult.name;
    
    //
    CLLocationDistance radius = kmlResult.coordinateSpan.latitudeDelta * 111000;//每纬度111公里
    region = [[CLRegion alloc] initCircularRegionWithCenter:coordinate radius:radius identifier:@"RegionForYCPlacemark"];
    
    //
    formattedAddress = kmlResult.address;
    
    //
    countryCode = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"country"] objectAtIndex:0] shortName];

    /*
    
    NSString *subLocality = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"sublocality"] objectAtIndex:0] longName];
    NSString *subAdministrativeArea = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"administrative_area_level_2"] objectAtIndex:0] longName];

    NSString *countryCode = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"country"] objectAtIndex:0] shortName];
    NSString *country = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"country"] objectAtIndex:0] longName];
    NSString *zip = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"postal_code"] objectAtIndex:0] longName];
    NSString *formattedAddress = kmlResult.address;
    NSString *state = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"administrative_area_level_1"] objectAtIndex:0] longName];
    NSString *city = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"locality"] objectAtIndex:0] longName];
    
    NSString *street = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"country"] objectAtIndex:0] longName];
    NSString *subThoroughfare = [(BSAddressComponent*)[[kmlResult findAddressComponent:@"country"] objectAtIndex:0] longName];
    */ 
    
    
    NSMutableDictionary *addressDic = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if (street) 
        [addressDic setObject:street forKey:(NSString *)kABPersonAddressStreetKey];
    if (city)
        [addressDic setObject:city forKey:(NSString *)kABPersonAddressCityKey];
    if (state)
        [addressDic setObject:state forKey:(NSString *)kABPersonAddressStateKey];
    if (zip)
        [addressDic setObject:zip forKey:(NSString *)kABPersonAddressZIPKey];
    if (country)
        [addressDic setObject:country forKey:(NSString *)kABPersonAddressCountryKey];
    if (countryCode)
        [addressDic setObject:countryCode forKey:(NSString *)kABPersonAddressCountryCodeKey];
    
    if (name)
        [addressDic setObject:name forKey:@"Name"];
    if (subAdministrativeArea)
        [addressDic setObject:subAdministrativeArea forKey:@"SubAdministrativeArea"];
    if (subLocality)
        [addressDic setObject:subLocality forKey:@"SubLocality"];
    if (subThoroughfare)
        [addressDic setObject:subThoroughfare forKey:@"SubThoroughfare"];
    if (inlandWater)
        [addressDic setObject:inlandWater forKey:@"InlandWater"];
    if (ocean)
        [addressDic setObject:ocean forKey:@"Ocean"];
    if (areasOfInterest)
        [addressDic setObject:areasOfInterest forKey:@"AreasOfInterest"];
    if (region)
        [addressDic setObject:region forKey:@"Region"];
    if (formattedAddress)
        [addressDic setObject:formattedAddress forKey:@"FormattedAddress"];
    
    MKPlacemark *mkPlacemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:addressDic];
    
    self = [self initWithPlacemark:mkPlacemark];
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
