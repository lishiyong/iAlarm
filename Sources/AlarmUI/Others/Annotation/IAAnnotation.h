//
//  IAAnnotation.h
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "YCMapPointAnnotation.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

enum {
    IAAnnotationStatusNormal = 0,        //正常状态     titel：名称，           subtitle：距离
    IAAnnotationStatusNormal1,           //正常状态1    titel：名称，           subtitle：长地址
	IAAnnotationStatusDisabled,          //禁用状态     titel：名称，           subtitle：长地址
    IAAnnotationStatusEditingBegin,      //编辑开始状态  titel："拖动改变目的地"， subtitle：名称
    IAAnnotationStatusReversing,         //反转地址中   titel："..."，          subtitle：名称
	IAMapAnnotationTypeReversFinished    //反转地址完成  titel：名称，           subtitle：长地址
};

typedef NSUInteger IAAnnotationStatus;


@class YCMapPointAnnotation, BSKmlResult, IAAlarm;
@interface IAAnnotation : YCMapPointAnnotation 

@property (nonatomic,readonly) NSString *identifier;
@property (nonatomic) IAAnnotationStatus annotationStatus;
@property (nonatomic,readonly) IAAlarm *alarm;

- (id)initWithAlarm:(IAAlarm*)anAlarm;

@end