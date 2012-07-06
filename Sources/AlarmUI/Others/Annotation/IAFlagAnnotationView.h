//
//  IAFlagAnnotationView.h
//  iAlarm
//
//  Created by li shiyong on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

enum {
    IAFlagAnnotationColorGreen = 0,
    IAFlagAnnotationColorOrange,
    IAFlagAnnotationColorBlueDeep,
    IAFlagAnnotationColorPurple
};
typedef NSUInteger IAFlagAnnotationColor;

@interface IAFlagAnnotationView : MKAnnotationView

@property (nonatomic) IAFlagAnnotationColor flagColor;

@end
