//
//  MKMapView.m
//  iAlarm
//
//  Created by li shiyong on 11-2-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCMapsUtility.h"
#import "YCLocationUtility.h"
#import "MKMapView-YC.h"


@implementation MKMapView (YC)

- (void)zoomToWorld:(CLLocationCoordinate2D)world animated:(BOOL)animated
{   
	if (!CLLocationCoordinate2DIsValid(world)) //无效返回
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
				[self performSelector:@selector(animateToWorldWithObj:) withObject:coordinateObj afterDelay:delay];
			}else {
				[self zoomToWorld:region.center animated:NO];
			}
		}else {
			[self zoomToWorld:region.center animated:NO];
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
- (BOOL)visibleForAnnotation:(id < MKAnnotation >)annotation{
	MKMapRect vMKRect = self.visibleMapRect;
	MKMapPoint annotationMKPoint = MKMapPointForCoordinate(annotation.coordinate);
	return MKMapRectContainsPoint(vMKRect,annotationMKPoint);
}


@end
