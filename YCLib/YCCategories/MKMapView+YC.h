//
//  MKMapView.h
//  iAlarm
//
//  Created by li shiyong on 11-2-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@class YCMapPointAnnotation;
@interface MKMapView (YC)


////坐标转换 to world -> to Place
////返回值：延时
-(double)setRegion:(MKCoordinateRegion)region 
		 FromWorld:(BOOL)fromWorld 
   animatedToWorld:(BOOL)animatedToWorld 
   animatedToPlace:(BOOL)animatedToPlace;

//selectAnnotation 的延时调用版本
-(void)animateSelectAnnotation:(id<MKAnnotation>)annotation;
//从所有Annotation（包括当前位置等）中选中index
-(void)selectAnnotationAtIndex:(NSInteger)index animated:(BOOL)animated;

//从指定的array中选中index
-(void)selectAnnotationFromAnnotations:(NSArray*)theAnnotations AtIndex:(NSInteger)index animated:(BOOL)animated;

//自带的 selectAnnotation:animated: 非动画调用。为了延时调用
- (void)selectAnnotation:(id < MKAnnotation >)annotation;

//指示annotation是否在地图的可视范围内
- (BOOL)visibleForAnnotation:(id < MKAnnotation >)annotation;

//找到离指定坐标最近的Annotation
- (YCMapPointAnnotation*)theNearestAnnotationFromCoordinate:(CLLocationCoordinate2D)Coordinate;

@end
