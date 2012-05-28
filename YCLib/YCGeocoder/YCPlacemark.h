//
//  YCPlacemark.h
//  iAlarm
//
//  Created by li shiyong on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Mapkit/Mapkit.h>
#import <Foundation/Foundation.h>

@interface YCPlacemark : NSObject<NSCopying, NSCoding>{
    CLPlacemark *placemark;
}
/*
- (id)initWithCLPlacemark:(CLPlacemark*)aPlacemark;
- (id)initWithMKPlacemark:(MKPlacemark*)aPlacemark;
 */

- (id)initWithPlacemark:(id/*CLPlacemark MKPlacemark*/)aPlacemark;

- (NSString *)fullAddress;
- (NSString *)longAddress;
- (NSString *)shortAddress;
- (NSString *)titleAddress;

@end
