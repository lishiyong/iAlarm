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
- (BOOL)isVisibleForAnnotation:(id < MKAnnotation >)annotation;

//找到离指定坐标最近的Annotation
- (YCMapPointAnnotation*)theNearestAnnotationFromCoordinate:(CLLocationCoordinate2D)Coordinate;

//Annotation是否被选中
- (BOOL)isSelectedForAnnotation:(id < MKAnnotation >)annotation; 

//地图上所有的YCMapPointAnnotation
@property(nonatomic, readonly) NSArray *mapPointAnnotations;

//坐标是否在view的中心，offset:允许偏差的像素
- (BOOL)isViewCenterForCoordinate:(CLLocationCoordinate2D)coordinate allowableOffset:(CGFloat)offset;

/* MKOverlayView 加不上动画，为什么？
- (void)addOverlay:(id<MKOverlay>)overlay animated:(BOOL)animated;
- (void)removeOverlay:(id<MKOverlay>)overlay animated:(BOOL)animated;
 */

/**
 以centerAtCoordinate为中心，截取size的图
 注意：size是UImage点为单位的，可以随scale变化而变化。
 例如：在高清屏下，size = {64,64}，实际截取的图的像素是128*128。
 **/
- (UIImage*)takeImageSize:(CGSize)size centerAtCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 截取整个地图
 **/
- (UIImage*)takeImageFullSize;

/**
 地图上添加一个image，以这个image为中心截图。
 **/
- (UIImage*)takeImageWithoutOverlaySize:(CGSize)size overrideImage:(UIImage*)image leftBottomAtCoordinate:(CLLocationCoordinate2D)coordinate imageCenter:(CGPoint)imageCenter;


@end
