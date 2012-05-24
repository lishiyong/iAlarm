//
//  YCMapPointAnnotation.h
//  iAlarm
//
//  Created by li shiyong on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface YCMapPointAnnotation : MKPlacemark<MKAnnotation> {
@package
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D _visualCoordinate;
    CLLocationCoordinate2D _realCoordinate;
    CLLocationDistance distanceFromCurrentLocation;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D realCoordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coord title:(NSString *) theTitle subTitle:(NSString *) theSubTitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coord title:(NSString *) theTitle subTitle:(NSString *) theSubTitle
       addressDictionary:(NSDictionary *)addressDictionary;

- (void)setRealCoordinateWithVisualCoordinate:(CLLocationCoordinate2D)theVisualCoordinate;
- (void)setVisualCoordinateWithRealCoordinate:(CLLocationCoordinate2D)theRealCoordinate;

@end