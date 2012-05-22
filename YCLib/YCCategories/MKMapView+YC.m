//
//  MKMapView.m
//  iAlarm
//
//  Created by li shiyong on 11-2-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YCMapPointAnnotation.h"
#import "YCMaps.h"
#import "YCLocation.h"
#import "YCFunctions.h"
#import "MKMapView+YC.h"

@interface MKMapView (private)
/**
 不与当前位置取中点
 **/
- (void)newZoomToWorld:(CLLocationCoordinate2D)world animated:(BOOL)animated;
- (void)newAnimateToWorldWithObj:(id/*CLLocationCoordinate2D*/)obj;

- (void)zoomToWorld:(CLLocationCoordinate2D)world animated:(BOOL)animated;
- (void)zoomToPlace:(MKCoordinateRegion)place animated:(BOOL)animated;
- (void)animateToWorldWithObj:(id/*CLLocationCoordinate2D*/)obj;
- (void)animateToPlaceWithObj:(id/*MKCoordinateRegion*/)obj;

@end

@implementation MKMapView (YC)

- (void)newZoomToWorld:(CLLocationCoordinate2D)world animated:(BOOL)animated
{   
	if (!CLLocationCoordinate2DIsValid(world)) 
		return;
    
    MKCoordinateRegion zoomOut = { { world.latitude, world.longitude }, {45, 45} };
    [self setRegion:zoomOut animated:animated];
}

- (void)zoomToWorld:(CLLocationCoordinate2D)world animated:(BOOL)animated
{   
	if (!CLLocationCoordinate2DIsValid(world)) 
		return;
	
    MKCoordinateRegion current = self.region;
	if(YCMKCoordinateRegionIsValid(current))
	{
		MKCoordinateRegion zoomOut = { { (current.center.latitude + world.latitude)/2.0 , (current.center.longitude + world.longitude)/2.0 }, {90, 90} };
		[self setRegion:zoomOut animated:animated];
	}else {
		MKCoordinateRegion zoomOut = { { world.latitude, world.longitude }, {90, 90} };
		[self setRegion:zoomOut animated:animated];
	}
}

- (void)zoomToPlace:(MKCoordinateRegion)place animated:(BOOL)animated
{
	if (!YCMKCoordinateRegionIsValid(place)) //无效返回
		return;
	
    [self setRegion:place animated:animated];
}

- (void)newAnimateToWorldWithObj:(id/*CLLocationCoordinate2D*/)obj
{   
	CLLocationCoordinate2D target;
	[obj getValue:&target];
	
	[self newZoomToWorld:target animated:YES];
	
}

- (void)animateToWorldWithObj:(id/*CLLocationCoordinate2D*/)obj
{   
	CLLocationCoordinate2D target;
	[obj getValue:&target];
	
	[self zoomToWorld:target animated:YES];
	
}

- (void)animateToPlaceWithObj:(id/*MKCoordinateRegion*/)obj
{
	MKCoordinateRegion target;
	[obj getValue:&target];
	
	[self zoomToPlace:target animated:YES];
}

////坐标转换 to world -> to Place
////返回值：延时
-(double)setRegion:(MKCoordinateRegion)region 
			FromWorld:(BOOL)fromWorld 
	  animatedToWorld:(BOOL)animatedToWorld 
	  animatedToPlace:(BOOL)animatedToPlace
{	
	if (!YCMKCoordinateRegionIsValid(region)) {
		return 0.0;
	}
	
	double delay =0.0f;
	
	//先ZoomToWorld
	if (fromWorld) 
	{
		MKCoordinateRegion current = self.region;
		if (current.span.latitudeDelta < 10) 
		{
			if (animatedToWorld) 
			{   delay +=0.3;
				CLLocationCoordinate2D coordinate = region.center;
				NSValue *coordinateObj = [NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)];
				[self performSelector:@selector(newAnimateToWorldWithObj:) withObject:coordinateObj afterDelay:delay];
			}else {
				[self newZoomToWorld:region.center animated:NO];
			}
		}else {
			[self newZoomToWorld:region.center animated:NO];
		}
		
	}
	
	//ZoomTo目标
	if (animatedToPlace) 
	{
		
		if(delay > 0.1) delay +=1.4;
		NSValue *regionObj = [NSValue valueWithBytes:&region objCType:@encode(MKCoordinateRegion)];
		[self performSelector:@selector(animateToPlaceWithObj:) withObject:regionObj afterDelay:delay];
		
	}else {
		[self zoomToPlace:region animated:NO];
	}
	
	return delay;
}



//selectAnnotation 的延时调用版本
-(void)animateSelectAnnotation:(id<MKAnnotation>)annotation;
{
	//[self selectAnnotation:annotation animated:YES];
	
	//延时执行
	id annotationSelecting = annotation;
	BOOL animated = YES;
	SEL selector = @selector(selectAnnotation:animated:);
	NSMethodSignature *signature = [self methodSignatureForSelector:selector];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self];
	[invocaton setSelector:selector];
	[invocaton setArgument:&annotationSelecting atIndex:2];  //self,_cmd分别占据0、1
	[invocaton setArgument:&animated atIndex:3];
	[invocaton performSelector:@selector(invoke) withObject:nil afterDelay:0.1];
	 
}

//从指定的array中选中index
-(void)selectAnnotationFromAnnotations:(NSArray*)theAnnotations AtIndex:(NSInteger)index animated:(BOOL)animated{
	NSInteger count = theAnnotations.count;
	if (count <= 0) return;
	if (index < 0) return;
	
	if (index >= count) 
		index = count-1;
	
	//[self selectAnnotation:[theAnnotations objectAtIndex:index] animated:animated];
	
	//延时执行
	id annotationSelecting = [theAnnotations objectAtIndex:index]; 
	SEL selector = @selector(selectAnnotation:animated:);
	NSMethodSignature *signature = [self methodSignatureForSelector:selector];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self];
	[invocaton setSelector:selector];
	[invocaton setArgument:&annotationSelecting atIndex:2];  //self,_cmd分别占据0、1
	[invocaton setArgument:&animated atIndex:3];
	[invocaton performSelector:@selector(invoke) withObject:nil afterDelay:0.0];
	
}

-(void)selectAnnotationAtIndex:(NSInteger)index animated:(BOOL)animated
{	
	[self selectAnnotationFromAnnotations:self.annotations AtIndex:index animated:animated];
}

//自带的 selectAnnotation:animated: 非动画调用。为了延时调用
- (void)selectAnnotation:(id < MKAnnotation >)annotation{
	[self selectAnnotation:annotation animated:NO];
}

//指示annotation是否在地图的可视范围内
- (BOOL)isVisibleForAnnotation:(id < MKAnnotation >)annotation{
	MKMapRect vMKRect = self.visibleMapRect;
	MKMapPoint annotationMKPoint = MKMapPointForCoordinate(annotation.coordinate);
	return MKMapRectContainsPoint(vMKRect,annotationMKPoint);
}

- (YCMapPointAnnotation*)theNearestAnnotationFromCoordinate:(CLLocationCoordinate2D)Coordinate{
    if (self.annotations.count == 0) {
        return nil;
    }
    
    YCMapPointAnnotation *annotation = nil;
    CLLocationDistance distance = 8.0E+307;
    for (id<MKAnnotation> anAnnotation in self.annotations) {
        if (![anAnnotation isKindOfClass: [YCMapPointAnnotation class]]) 
            continue;
        
        CLLocationDistance distanceTmp = distanceBetweenCoordinates(Coordinate, anAnnotation.coordinate);
        if (distanceTmp < distance) {
            distance = distanceTmp;
            annotation = (YCMapPointAnnotation*)anAnnotation;
        }
    }
    
    return annotation;
}

- (BOOL)isSelectedForAnnotation:(id < MKAnnotation >)annotation{
    if (self.selectedAnnotations.count > 0 ){
        id selected = [self.selectedAnnotations objectAtIndex:0];
        if (annotation == selected) 
            return YES;
    }
    return NO;
}

- (NSArray *)mapPointAnnotations{
    NSMutableArray *array = [NSMutableArray array];
    for (id<MKAnnotation> anAnnotation in self.annotations) {
        if ([anAnnotation isKindOfClass: [YCMapPointAnnotation class]]) {
            [array addObject:anAnnotation];
        }
    }
    return array;
}

- (BOOL)isViewCenterForCoordinate:(CLLocationCoordinate2D)coordinate allowableOffset:(CGFloat)offset{
    
    CLLocationCoordinate2D centerCoor = self.region.center;
	CGPoint centerPoint = [self convertCoordinate:centerCoor toPointToView:nil];
	
	CGPoint thePoint = [self convertCoordinate:coordinate toPointToView:nil];
	return YCCGPointEqualPointWithOffSet(centerPoint, thePoint,offset);//允许误差x个像素
    
}

- (void)addOverlay:(id<MKOverlay>)overlay animated:(BOOL)animated{
    [self addOverlay:overlay];
    
    if (animated) {
        MKOverlayView *overlayView = [self viewForOverlay:overlay];
        //overlayView.alpha = 0.0;
        
        NSLog(@"overlayView.window = %@",overlayView.window);
        NSLog(@"overlayView.superview = %@",overlayView.superview);
        
        CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
        theAnimation.duration=1.5;
        theAnimation.autoreverses=YES;
        theAnimation.fromValue=[NSNumber numberWithFloat:0.0];
        theAnimation.toValue=[NSNumber numberWithFloat:1.0];
        [overlayView.layer addAnimation:theAnimation forKey:@"animateAlpha"];
        
    }
}
- (void)removeOverlay:(id<MKOverlay>)overlay animated:(BOOL)animated{    
    if (animated) {
        MKOverlayView *overlayView = [self viewForOverlay:overlay];
        overlayView.alpha = 1.0;
        
        [UIView transitionWithView:overlayView.superview duration:1.5 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^
         {
             overlayView.alpha = 0.0;
             
         }completion:^(BOOL finished){
             
             [self removeOverlay:overlay];
             
         }];
        
    }else{
        [self removeOverlay:overlay];
    }
}

@end
