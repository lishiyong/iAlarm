//
//  YCMapPointAnnotation.m
//  iAlarm
//
//  Created by li shiyong on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCMapPointAnnotation.h"

@implementation YCMapPointAnnotation
@synthesize coordinate, title, subtitle, distanceFromCurrentLocation;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coord title:(NSString *) theTitle subTitle:(NSString *) theSubTitle{
    return [self initWithCoordinate:coord title:theTitle subTitle:theSubTitle addressDictionary:nil];
}

-(id) initWithCoordinate:(CLLocationCoordinate2D) coord title:(NSString *) theTitle subTitle:(NSString *) theSubTitle
       addressDictionary:(NSDictionary *)addressDictionary{
    self = [super initWithCoordinate:coord addressDictionary:addressDictionary];
    if (self) {
        coordinate = coord;
        title = [theTitle copy];
        subtitle = [theSubTitle copy];
        distanceFromCurrentLocation = -1.0; //小于0，表示未初始化
    }
    return self;
}

- (void)dealloc{
    [title release];
    [subtitle release];
    [super dealloc];
}

@end