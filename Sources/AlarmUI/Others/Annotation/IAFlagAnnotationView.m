//
//  IAFlagAnnotationView.m
//  iAlarm
//
//  Created by li shiyong on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IAFlagAnnotationView.h"

@implementation IAFlagAnnotationView

@synthesize flagColor = _flagColor;

- (void)setFlagColor:(IAFlagAnnotationColor)flagColor{
    _flagColor = flagColor;
    UIImage *flagImage = nil;
    switch (_flagColor) {
        case IAFlagAnnotationColorBlueDeep:
            flagImage = [UIImage imageNamed:@"Shadow_IAFlagBlueDeep.png"];
            break;
        case IAFlagAnnotationColorGreen:
            flagImage = [UIImage imageNamed:@"Shadow_IAFlagGreen.png"];
            break;
        case IAFlagAnnotationColorOrange:
            flagImage = [UIImage imageNamed:@"Shadow_IAFlagOrange.png"];
            break;
        case IAFlagAnnotationColorPurple:
            flagImage = [UIImage imageNamed:@"Shadow_IAFlagPurple.png"];
            break;
        default:
            flagImage = [UIImage imageNamed:@"Shadow_IAFlagOrange.png"];
            break;
    }
    
    [self setImage:flagImage];
    [self setCenterOffset:(CGPoint){13,0}];
    [self setCalloutOffset:(CGPoint){-6,-3}];
}


@end
