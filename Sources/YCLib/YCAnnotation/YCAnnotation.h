//
//  YCAnnotation.h
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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



@class BSKmlResult;
@interface YCAnnotation : MKPlacemark {
	//BOOL isCurrent; //当前
	
	CLLocationCoordinate2D coordinate;
	//NSString *subtitle;
	//NSString *title;
	
	YCMapAnnotationType annotationType;
	
	MKPlacemark *placemarkForReverse;  
	BSKmlResult *placeForSearch;
	
	NSString *identifier;    //标志号
	
	BOOL changedBySearch;    //coordinate,subtitle等是通过查询改变的
	
	
	
}
@property (nonatomic, readwrite,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) NSString *subtitle;
@property (nonatomic,retain) NSString *title;

@property (nonatomic) YCMapAnnotationType annotationType;

@property (nonatomic,retain) MKPlacemark *placemarkForReverse;
@property (nonatomic,retain) BSKmlResult *placeForSearch;

@property (nonatomic,retain,readonly) NSString *identifier;

@property (nonatomic,assign) BOOL changedBySearch;


- (id)initWithIdentifier:(NSString*)theIdentifier;
//指定初始化
- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate addressDictionary:(NSDictionary *)theAddressDictionary identifier:(NSString*)theIdentifier;


@end
