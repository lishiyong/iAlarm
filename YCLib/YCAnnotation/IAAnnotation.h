//
//  YCAnnotation.h
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "YCMapPointAnnotation.h"
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

enum {
    YCMapAnnotationTypeStandard = 0,        //已经定位的普通类型
	YCMapAnnotationTypeStandardEnabledDrag, //已经定位的普通类型，但可以拖动
    YCMapAnnotationTypeLocating,            //正在定位的
    YCMapAnnotationTypeMovingToTarget,      //接近的目标位置
	YCMapAnnotationTypeSearch,              //搜索的类型
	YCMapAnnotationTypeDisabled             //禁用
};
typedef NSUInteger YCMapAnnotationType;


@class YCMapPointAnnotation, BSKmlResult;
@interface YCAnnotation : YCMapPointAnnotation 

@property (nonatomic,readonly) NSString *identifier;
@property (nonatomic,retain) MKPlacemark *placemarkForReverse;
@property (nonatomic,retain) BSKmlResult *placeForSearch;
@property (nonatomic) YCMapAnnotationType annotationType;
@property (nonatomic,assign) BOOL changedBySearch; //coordinate,subtitle等是通过查询改变的


- (id)initWithIdentifier:(NSString*)theIdentifier;
- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate identifier:(NSString*)theIdentifier;

@end
