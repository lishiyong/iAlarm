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
    IAMapAnnotationTypeStandard = 0,        //已经定位的普通类型
	IAMapAnnotationTypeStandardEnabledDrag, //已经定位的普通类型，但可以拖动
    IAMapAnnotationTypeLocating,            //正在定位的
    IAMapAnnotationTypeMovingToTarget,      //接近的目标位置
	IAMapAnnotationTypeSearch,              //搜索的类型
	IAMapAnnotationTypeDisabled             //禁用
};
typedef NSUInteger IAMapAnnotationType;


@class YCMapPointAnnotation, BSKmlResult, IAAlarm;
@interface IAAnnotation : YCMapPointAnnotation 

@property (nonatomic,readonly) NSString *identifier;
@property (nonatomic,retain) MKPlacemark *placemarkForReverse;
@property (nonatomic,retain) BSKmlResult *placeForSearch;
@property (nonatomic) IAMapAnnotationType annotationType;
@property (nonatomic,assign) BOOL changedBySearch; //coordinate,subtitle等是通过查询改变的
@property (nonatomic,readonly) IAAlarm *alarm;

- (id)initWithAlarm:(IAAlarm*)anAlarm;

@end
