//
//  CLPlacemark+YC.m
//  iAlarm
//
//  Created by li shiyong on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "CLPlacemark+YC.h"

@implementation CLPlacemark (YC)

- (NSString *)description{
    
    NSMutableString *string = [NSMutableString stringWithCapacity:100];
    [string appendString:@"\n["];
    
    [string appendFormat:@"\n  name = %@",[self.name description]];
    [string appendFormat:@"\n  location = %@",[self.location description]];
    [string appendFormat:@"\n  region = %@",[self.region description]];
    [string appendFormat:@"\n  ISOcountryCode = %@",[self.ISOcountryCode description]];
    [string appendFormat:@"\n  country = %@",[self.country description]];
    [string appendFormat:@"\n  administrativeArea = %@",[self.administrativeArea description]];
    [string appendFormat:@"\n  subAdministrativeArea = %@",[self.subAdministrativeArea description]];
    [string appendFormat:@"\n  locality = %@",[self.locality description]];
    [string appendFormat:@"\n  subLocality = %@",[self.subLocality description]];
    [string appendFormat:@"\n  thoroughfare = %@",[self.thoroughfare description]];
    [string appendFormat:@"\n  subThoroughfare = %@",[self.subThoroughfare description]];
    [string appendFormat:@"\n  postalCode = %@",[self.postalCode description]];
    [string appendFormat:@"\n  areasOfInterest = %@",[self.areasOfInterest description]];
    [string appendFormat:@"\n  inlandWater = %@",[self.inlandWater description]];
    [string appendFormat:@"\n  ocean = %@",[self.ocean description]];
    
    [string appendFormat:@"\n"];
    [string appendFormat:@"\n  addressDictionary = %@",[self.addressDictionary description]];
    [string appendFormat:@"\n"];
    
    [string appendString:@"\n]"];
    return string;
    
}


@end
