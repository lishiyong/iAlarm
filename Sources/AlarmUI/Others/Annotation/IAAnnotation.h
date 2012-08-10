//
//  IAAnnotation.h
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "YCLib.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

enum {
    IAAnnotationStatusNormal = 0,        //正常状态     
    IAAnnotationStatusNormal1,           //正常状态1    
	IAAnnotationStatusDisabledNormal,    //禁用状态     
    IAAnnotationStatusDisabledNormal1,   //禁用状态1 
    IAAnnotationStatusEditingBegin,      //编辑开始状态  
    IAAnnotationStatusReversing,         //反转地址中   
	IAAnnotationStatusReversFinished     //反转地址完成  
};

typedef NSUInteger IAAnnotationStatus;


@class YCMapPointAnnotation, IAAlarm;
@interface IAAnnotation : YCMapPointAnnotation {
    BOOL _subTitleIsDistanceString;
}

@property (nonatomic,readonly) NSString *identifier;
@property (nonatomic) IAAnnotationStatus annotationStatus;
@property (nonatomic,readonly) IAAlarm *alarm;

- (id)initWithAlarm:(IAAlarm*)anAlarm;

@end