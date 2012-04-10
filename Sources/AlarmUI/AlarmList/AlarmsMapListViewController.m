    //
//  AlarmsMapListViewController.m
//  iAlarm
//
//  Created by li shiyong on 11-2-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCOverlayImageView.h"
#import "YCOverlayImage.h"
#import "NSObject-YC.h"
#import "UIViewController-YC.h"
#import "IANotifications.h"
#import "IABuyManager.h"
#import "YCAnimateRemoveFileView.h"
#import "YCCalloutBarButton.h"
#import "YCCalloutBar.h"
#import "YClocationServicesUsableAlert.h"
#import "YCPinAnnotationView.h"
#import "IASaveInfo.h"
#import "YCRemoveMinusButton.h"
#import "AlarmListNotifications.h"
#import "YCMapsUtility.h"
#import "YCParam.h"
#import "IAAlarmRadiusType.h"
#import "YCAnnotation.h"
#import "MKMapView-YC.h"
#import "YCLocationUtility.h"
#import "YCSystemStatus.h"
#import "UIUtility.h"
#import "YCTapHideBarView.h"
#import "IAAlarm.h"
#import "YCPageCurlButtonItem.h"
#import "LocalizedString.h"
#import "AlarmDetailTableViewController.h"
#import "AlarmsMapListViewController.h"
#import <QuartzCore/QuartzCore.h>

//toolbar显示的时间
#define kTimeIntervalForToolbarHide  25.0
//取得用户当前位置的超时时间
#define kTimeSpanForUserLocation     30.0

@implementation AlarmsMapListViewController

#pragma mark -
#pragma mark property

@synthesize lastUpdateDistanceTimestamp;

@synthesize locationServicesUsableAlert;

//@synthesize alarms;
@synthesize mapAnnotations;


@synthesize mapView;
@synthesize maskView;
@synthesize maskLabel;
@synthesize maskActivityIndicator;



@synthesize pinsEditing;

@synthesize toolbarFloatingView;
@synthesize mapsTypeButton;
@synthesize satelliteTypeButton;                   
@synthesize hybridTypeButton;

/////////////////////////////////////
//地址反转
@synthesize placemarkForUserLocation;
@synthesize placemarkForPin;

- (MKReverseGeocoder *)reverseGeocoder:(CLLocationCoordinate2D)coordinate
{
    if (reverseGeocoderForUserLocation) {
		[reverseGeocoderForUserLocation release];
	}
	reverseGeocoderForUserLocation = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
	reverseGeocoderForUserLocation.delegate = self;
	
	return reverseGeocoderForUserLocation;
}

- (id)reverseGeocodersForPin{
	if (reverseGeocodersForPin == nil) {
		reverseGeocodersForPin = [[NSMutableDictionary dictionary] retain];
	}
	return reverseGeocodersForPin;
}

/////////////////////////////////////



#pragma mark - 
#pragma mark - Utility

-(void)setUserInteractionEnabled:(BOOL)enabled{
	/*
	//self.mapView.scrollEnabled = enabled;
	//self.mapView.zoomEnabled = enabled;
	[self.mapView setUserInteractionEnabled:enabled];

	
	self.infoButtonItem.enabled = enabled;
	//self.currentLocationBarItem.enabled = enabled;
	//self.allPinsBarItem.enabled = enabled;
	self.mapTypeBarItem.enabled = enabled;
	self.switchViewBarItem.enabled = enabled;
	 */
	
	[self.view setUserInteractionEnabled:enabled];
	
}


//刷新pinview
- (void)refreshPinView{
	
	if (self.pinsEditing) return;
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshPinView) object:nil];
	
	for (YCAnnotation *aAnnotation in self.mapAnnotations) {
		YCPinAnnotationView *pinView = (YCPinAnnotationView*)[self.mapView viewForAnnotation:aAnnotation];
		
		//[pinView updatePinColor]; //对付 应该灰而不灰的情况
		[pinView performSelector:@selector(updatePinColor) withObject:nil afterDelay:0.0];
		
	}
     
}


//显示距离当前位置XX公里
- (void)setDistanceInAnnotation:(YCAnnotation*)annotation withCurrentLocation:(CLLocation*)location{
    
    if (location == nil || ![location isKindOfClass:[CLLocation class]]) {
        annotation.subtitle = nil;
        return;
    }

    CLLocation *aLocation = [[[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude] autorelease];
	CLLocationDistance distance = [location distanceFromLocation:aLocation];
    
    NSString *s = nil;
    if (distance > 100.0) 
        s = [NSString stringWithFormat:KTextPromptDistanceCurrentLocation,[location distanceFromLocation:aLocation]/1000.0];
    else
        s = KTextPromptCurrentLocation;
    
    annotation.subtitle = s;

}

-(void)alertInternet{
	//检查网络
	BOOL connectedToInternet = [[YCSystemStatus deviceStatusSingleInstance] connectedToInternet];
	if (!connectedToInternet) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            // iOS 5 code
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertNeedInternetTitleAccessMaps
                                                            message:kAlertNeedInternetBodyAccessMaps 
                                                           delegate:self
                                                  cancelButtonTitle:kAlertBtnSettings
                                                  otherButtonTitles:kAlertBtnCancel,nil];
            
            
            [alert show];
            [alert release];
        }
        else {
            // iOS 4.x code
            [UIUtility simpleAlertBody:kAlertNeedInternetBodyAccessMaps alertTitle:kAlertNeedInternetTitleAccessMaps cancelButtonTitle:kAlertBtnOK delegate:nil];
        }
        
		
	}
}



-(MKCoordinateRegion)allPinsRegion{
	
	MKCoordinateRegion r = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(-1000,-1000 ), 0, 0); //初始化，无效值
	
	if (self.alarms.count == 1) {
		IAAlarm *anAlarm = (IAAlarm*)[self.alarms objectAtIndex:0];
		CLLocationDistance distanceForRegion = anAlarm.radius*2*1.8;//直径的1.x倍
		r = MKCoordinateRegionMakeWithDistance(anAlarm.coordinate,distanceForRegion,distanceForRegion);
	}else if (self.alarms.count > 1){
		CLLocationDegrees minLati = 180.0;
		CLLocationDegrees maxLati = -180.0;
		CLLocationDegrees minLong = 180.0;
		CLLocationDegrees maxLong = -180.0;
		
		for (IAAlarm* oneObj in self.alarms) {
			minLati = (oneObj.coordinate.latitude  < minLati) ? oneObj.coordinate.latitude  : minLati;
			maxLati = (oneObj.coordinate.latitude  > maxLati) ? oneObj.coordinate.latitude  : maxLati;
			minLong = (oneObj.coordinate.longitude < minLong) ? oneObj.coordinate.longitude : minLong;
			maxLong = (oneObj.coordinate.longitude > maxLong) ? oneObj.coordinate.longitude : maxLong;
		}
		
		CLLocationCoordinate2D center =  CLLocationCoordinate2DMake((maxLati + minLati)/2, (maxLong + minLong)/2);
		MKCoordinateSpan span = MKCoordinateSpanMake((maxLati - minLati)*2.5, (maxLong - minLong)*2.5); //1.x倍span免得不能完全显示，
		r = MKCoordinateRegionMake(center,span);
		r = [self.mapView regionThatFits:r]; //修正一下
	}
	
	return r;
	
}

//关掉覆盖视图
-(void)animateCloseMaskViewAndShowToolbar
{	

	
	//动画关闭
	[UIView beginAnimations:@"Unmask" context:NULL];
	[UIView setAnimationDuration:1.0];
	self.maskView.alpha = 0.0f;
	self.maskView.hidden = YES;
	[UIView commitAnimations];
	
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES; //mask已经被打开，可用
	
}

//做annotation及其相应的view、circleOverlay，并把他们加入的列表中
- (YCAnnotation*)insertAnnotationWithAlarm:(IAAlarm*)alarm atIndex:(NSInteger)index{
	BOOL isEnabling = alarm.enabling;
	
	YCAnnotation *annotation = [[[YCAnnotation alloc] initWithCoordinate:alarm.coordinate addressDictionary:nil identifier:alarm.alarmId] autorelease];
	annotation.title = alarm.alarmName;
	annotation.subtitle = alarm.position;
	annotation.coordinate = alarm.coordinate;
	
	annotation.annotationType = isEnabling ? YCMapAnnotationTypeStandard:YCMapAnnotationTypeDisabled; //没启用
	annotation.title = alarm.alarmName;
	annotation.subtitle = nil;
	
	if (index < 0 || index > self.mapAnnotations.count-1)
		[self.mapAnnotations addObject:annotation];
	else 
		[self.mapAnnotations insertObject:annotation atIndex:index];
	
	//pinview
	NSString *imageName = alarm.alarmRadiusType.alarmRadiusTypeImageName;
	imageName = [NSString stringWithFormat:@"20_%@",imageName]; //使用20像素的图标
	imageName = isEnabling ? imageName: @"20_IAFlagGray.png";  //没有启用，使用灰色旗帜
	UIImageView *sfIconView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
	sfIconView.image = [UIImage imageNamed:imageName];
	
	static NSString* YCpinViewAnnotationIdentifier = @"YCpinViewAnnotationIdentifier";
	YCPinAnnotationView* pinView = [[[YCPinAnnotationView alloc]
								  initWithAnnotation:annotation reuseIdentifier:YCpinViewAnnotationIdentifier] autorelease];
	pinView.delegate = self;
	
	
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	pinView.rightCalloutAccessoryView = rightButton; 
	pinView.leftCalloutAccessoryView = sfIconView;

	
	
	pinView.canShowCallout = YES;
	pinView.animatesDrop = NO;
	pinView.draggable = NO;
	pinView.pinColor = MKPinAnnotationColorRed;
	
	//长按pin
	UILongPressGestureRecognizer *longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pinLongPressed:)] autorelease];
    longPressGesture.minimumPressDuration = 0.5; //多长时间算长按
	longPressGesture.allowableMovement = 30.0;
	longPressGesture.delegate = self;
	[pinView addGestureRecognizer:longPressGesture];
	
	/*
	//单点pin,为了GrayPin被单点不变成其他颜色
	UITapGestureRecognizer *tapMapViewGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinTap:)] autorelease];
	tapMapViewGesture.delegate = self;
	[pinView addGestureRecognizer:tapMapViewGesture];
     */
	 
	
	
	
	[self.mapAnnotationViews setObject:pinView forKey:alarm.alarmId];  //加入到列表
	
	//警示圈
	MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:alarm.coordinate	radius:alarm.radius];
	[self.circleOverlays setObject:circleOverlay forKey:alarm.alarmId];  //加入到列表
	
	return annotation;
}

-(void)updateMapAnnotations
{
    
	[self.mapAnnotations removeAllObjects];
	[self.mapAnnotationViews removeAllObjects];
	[self.circleOverlays removeAllObjects];
	for (IAAlarm *temp in self.alarms)
	{
		[self insertAnnotationWithAlarm:temp atIndex:-1];
	}
	
}

-(void)addMapAnnotations
{	[self updateMapAnnotations];
	//[self.mapView addAnnotations:self.mapAnnotations];
	[self.mapView performSelectorOnMainThread:@selector(addAnnotations:) withObject:self.mapAnnotations waitUntilDone:YES];
	//[self.mapView addOverlays:[self.circleOverlays allValues]];
}


//用户的当前位置（小蓝点）是否在地图中心
- (BOOL)isUserLocationInMapsCenter{
	CLLocationCoordinate2D currentMapCenter = self.mapView.region.center;
	CGPoint currentMapCenterPoint = [self.mapView convertCoordinate:currentMapCenter toPointToView:nil];
	
	//比较的坐标转换后到屏幕上的点；相等：BarItem不可用
	CLLocationCoordinate2D userCurrentLocation = {-10000.0,-10000.0};
	if (self.mapView.userLocation.location) userCurrentLocation = self.mapView.userLocation.location.coordinate;
	if (!CLLocationCoordinate2DIsValid(userCurrentLocation)) return NO; //无效坐标
	
	CGPoint userCurrentLocationPoint = [self.mapView convertCoordinate:userCurrentLocation toPointToView:nil];
	int isA = YCCompareCGPointWithOffSet(currentMapCenterPoint, userCurrentLocationPoint,2); //允许误差2个像素

	return (isA == 0) ? YES : NO;
}


////是否有大头针在屏幕可视范围中
-(BOOL)isHavePinVisible{
	BOOL b = NO;
	for (IAAlarm* oneObj in self.alarms) {
		CLLocationCoordinate2D coordinate =  oneObj.coordinate;
		MKMapPoint point = MKMapPointForCoordinate(coordinate);
		b = MKMapRectContainsPoint(self.mapView.visibleMapRect,point);
		
		if (b) break;
	}
	
	return b;
}


#pragma mark -
#pragma mark property


- (id)focusBox{
	if (focusBox == nil) {
		focusBox =[[ CALayer layer] retain] ;
		UIImage *image1 = [UIImage imageNamed:@"focusBox.png"];
		focusBox.contents = (id)image1.CGImage;
		focusBox.frame=CGRectMake (0.0,0.0,288.0,288.0);
	}

	return focusBox;
}
/*
- (id)focusPoint{
	if (focusPoint == nil) {
		focusPoint =[[ CALayer layer] retain] ;
		UIImage *image1 = [UIImage imageNamed:@"focusPoint.png"];
		focusPoint.contents = (id)image1.CGImage;
		focusPoint.frame=CGRectMake (0.0,0.0,96.0,96.0);
	}

	return focusPoint;
}
 */

- (id)foucusOverlay:(CGPoint)focusCGPoint{
	
	[foucusOverlay release];
	foucusOverlay = nil;
	
	//原始数据
	CGSize imageSize = CGSizeMake(41.0, 41.0);
	//CLLocationCoordinate2D focusCoordinate = self.mapView.centerCoordinate;
	//CGPoint focusCGPoint = [self.mapView convertCoordinate:focusCoordinate toPointToView:self.mapView];
	
	//矩形的左上、右下坐标
	CGPoint upperLeftCGPoint = CGPointMake(focusCGPoint.x - imageSize.width/2, focusCGPoint.y - imageSize.height/2);
	CGPoint lowerRightCGPoint = CGPointMake(focusCGPoint.x + imageSize.width/2, focusCGPoint.y + imageSize.height/2);
	CLLocationCoordinate2D upperLeftCoordinate = [self.mapView convertPoint:upperLeftCGPoint toCoordinateFromView:self.mapView];
	CLLocationCoordinate2D lowerRightCoordinate = [self.mapView convertPoint:lowerRightCGPoint toCoordinateFromView:self.mapView];
	
	//转换成MkMapXX
	MKMapPoint upperLeft = MKMapPointForCoordinate(upperLeftCoordinate);
	MKMapPoint lowerRight = MKMapPointForCoordinate(lowerRightCoordinate);
	
	double width = lowerRight.x - upperLeft.x;
	double height = lowerRight.y - upperLeft.y;
	
	MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, width, height);
	
	
	foucusOverlay = [[YCOverlayImage alloc] initWithCoordinate:self.mapView.centerCoordinate 
															 andBoundingMapRect:bounds] ;
	
	return foucusOverlay;
}




- (id)toolbarFloatingView{
	if (toolbarFloatingView == nil) {
		//浮动工具栏
		CGPoint p = CGPointMake(210.0, 382.0);
		NSArray *titleArray = [NSArray arrayWithObjects:
							   KDicMapTypeNameStandard
							   ,KDicMapTypeNameSatellite
							   ,KDicMapTypeNameHybrid
							   ,nil];
		
		NSArray *imageArray = [NSArray arrayWithObjects:
							   [NSNull null]
							   ,[NSNull null]
							   ,[NSNull null]
							   ,nil];
		
		NSArray *targetArray = [NSArray arrayWithObjects:self,self,self,self,self,self,self,nil];
		NSValue *obj1 = [NSValue valueWithBytes:& @selector(mapTypeMenuItemPressed:) objCType:@encode(SEL)];
		NSValue *obj2 = [NSValue valueWithBytes:& @selector(mapTypeMenuItemPressed:) objCType:@encode(SEL)];
		NSValue *obj3 = [NSValue valueWithBytes:& @selector(mapTypeMenuItemPressed:) objCType:@encode(SEL)];
		
		NSArray *actionArray = [NSArray arrayWithObjects:obj1,obj2,obj3,nil];
		
		toolbarFloatingView = [[YCCalloutBar alloc] initWithButtonsTitle:titleArray buttonsImage:imageArray targets:targetArray 
																 actions:actionArray arrowPointer:p fromSuperView:self.view];
		
	}
	return toolbarFloatingView;
}
/*
- (id)mapTypemenuController
{
	//if (self->mapTypemenuController == nil) 
	{
		mapTypemenuController = [UIMenuController sharedMenuController];
        UIMenuItem *standardMapMenuItem = [[[UIMenuItem alloc] initWithTitle:KDicMapTypeNameStandard action:@selector(standardMapMenuItemPressed:)] autorelease];
		UIMenuItem *satelliteMapMenuItem = [[[UIMenuItem alloc] initWithTitle:KDicMapTypeNameSatellite action:@selector(satelliteMapMenuItemPressed:)] autorelease];
		UIMenuItem *hybridMapMenuItem = [[[UIMenuItem alloc] initWithTitle:KDicMapTypeNameHybrid action:@selector(hybridMapMenuItemPressed:)] autorelease];
        
		[mapTypemenuController setMenuItems:[NSArray arrayWithObject:standardMapMenuItem]];
        //[mapTypemenuController setMenuItems:[NSArray arrayWithObjects:standardMapMenuItem,satelliteMapMenuItem,hybridMapMenuItem,nil]];
        [mapTypemenuController setTargetRect:CGRectMake(100.0, 20.0, 100.0, 100.0) inView:self.toolbar];
        
	}
	
	return self->mapTypemenuController;
}
 */


- (id)alarms{
	return [IAAlarm alarmArray];
}

- (id)maskActivityIndicator{  //做这个get属性的目的是：在进入前台时候不start动画
	if (maskActivityIndicator == nil) {
		maskActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		maskActivityIndicator.frame = CGRectMake(100.0, 180.0, maskActivityIndicator.frame.size.width, maskActivityIndicator.frame.size.height);
		maskActivityIndicator.hidesWhenStopped = YES;
	}
	[maskActivityIndicator startAnimating];
	return maskActivityIndicator;
}

- (id)animateRemoveFileView{
	if (animateRemoveFileView == nil) {
		animateRemoveFileView = [[YCAnimateRemoveFileView alloc] initWithOrigin:CGPointMake(0.0, 0.0)];
	}
	return animateRemoveFileView;
}



-(id) mapAnnotationViews{
	if (mapAnnotationViews == nil)
    {
        mapAnnotationViews = [[NSMutableDictionary dictionary] retain];
    }
    return mapAnnotationViews;
}

-(id) mapAnnotations{
	if (mapAnnotations == nil)
    {
        mapAnnotations = [[NSMutableArray array] retain];
    }
    return mapAnnotations;
}

-(id) circleOverlays{
	if (circleOverlays == nil)
    {
        circleOverlays = [[NSMutableDictionary dictionary] retain];
    }
    return circleOverlays;
}

- (void)setPinsEditing:(BOOL)theEditing{
	
	
	NSInteger count = self.mapAnnotations.count;
	if (count == 0 ) {
		pinsEditing = NO;
		return ;
	}
	
	pinsEditing = theEditing;
	
	for (YCAnnotation *aAnnotation in self.mapAnnotations) {
		IAAlarm *alarm = [IAAlarm findForAlarmId:aAnnotation.identifier];
		YCPinAnnotationView * aAnnotationView = [self.mapAnnotationViews objectForKey:aAnnotation.identifier];
		
		if (aAnnotationView ==nil ) continue;
		aAnnotationView.calloutViewEditing = theEditing;
		
		//拖动
		aAnnotationView.pinColor = theEditing ? MKPinAnnotationColorPurple : MKPinAnnotationColorRed;
		aAnnotationView.draggable = theEditing;
		
		//更改标题
		NSString *newTitle = theEditing ? KLabelMapNewAnnotationTitle : alarm.alarmName;
		aAnnotation.title = newTitle;
	}

	//灰pin的颜色
	[self refreshPinView];
}



/*
- (YCOverlayImageView*)foucusOverlayView{
	UIImage *image = [UIImage imageNamed:@"focusPoint.png"];
	YCOverlayImageView *overlayImageView = [[[YCOverlayImageView alloc] initWithOverlay:overlay andImage:image] autorelease];
	
	return overlayImageView;
}
 */


#pragma mark -
#pragma mark Notification

-(void)setUIEditing:(BOOL)theEditing{
	
	NSUInteger count = [IAAlarm alarmArray].count;
	if (count == 0) {//行数>0,才可以编辑
		self.pinsEditing = NO;
		self.navigationItem.leftBarButtonItem = nil; //编辑按钮 
	}else {
		self.pinsEditing = theEditing;
	}
	
}

//对象参数版本，延时调用
-(void)setUIEditingObj:(id/*BOOL*/)theEditingObj{
	BOOL target = [(NSNumber*)theEditingObj boolValue]; 
	[self setUIEditing:target];
}



////居中。为了延时调用
-(void)setCenterForAnnotation:(id<MKAnnotation>)annotation{
	
	BOOL setAnimated = NO;
	if (self->isApparing) setAnimated = YES;
	[self.mapView setCenterCoordinate:annotation.coordinate animated:setAnimated]; //居中
	
}

////选中。为了延时调用
-(void)selectForAnnotation:(id<MKAnnotation>)annotation{
	
	BOOL setAnimated = NO;
	if (self->isApparing) setAnimated = YES;
	[self.mapView selectAnnotation:annotation animated:setAnimated];//选中
	
}

/*
//没有选中的，选中第一个.使被选中的在可视范围内
-(void)selectingPinAndVisible{
	if (self.mapAnnotations.count>0) { //至少有1个pin
		
		id annotationSelected = nil;
		//没有选中的，选中第一个
		if (self.mapView.selectedAnnotations == nil 
			|| self.mapView.selectedAnnotations.count == 0
			|| [[self.mapView.selectedAnnotations objectAtIndex:0] isKindOfClass:[MKUserLocation class]]
			) 
		{
			[self.mapView selectAnnotationFromAnnotations:self.mapAnnotations AtIndex:0 animated:YES];
			annotationSelected = [self.mapAnnotations objectAtIndex:0];
		}else {
			annotationSelected = [self.mapView.selectedAnnotations objectAtIndex:0];
			[self.mapView animateSelectAnnotation:annotationSelected]; //防bug
		}
		
		//使被选中的在可视范围内
		BOOL isVisible = [self.mapView visibleForAnnotation:annotationSelected]; //是否在可视范围
		if (!isVisible) {
			if ([annotationSelected isKindOfClass:[IAAnnotation class]]) {
				CLLocationCoordinate2D coordinate =  ((IAAnnotation*)annotationSelected).coordinate;
				[self.mapView setCenterCoordinate:coordinate animated:YES];
			}
		}
		
	}

}
*/
//没有选中的，选中第一个.使被选中的在可视范围内
-(void)selectFirstPinAndVisibleAnimated:(BOOL)animated{
	
	if (self.mapAnnotations == nil || self.mapAnnotations.count==0 )//至少有1个pin
		return;

	id annotationSelected = [self.mapView.selectedAnnotations objectAtIndex:0];//目前选中的
	
	YCAnnotation *annotationSelecting = nil;//将要选中的
	if ([annotationSelected isKindOfClass:[YCAnnotation class]]) //选中的是不是pin
		 annotationSelecting = annotationSelected;
	else
		 annotationSelecting = [self.mapAnnotations objectAtIndex:0];
		 
	 //使被选中的在可视范围内
	 BOOL isVisible = [self.mapView visibleForAnnotation:annotationSelecting]; //是否在可视范围
	 if (!isVisible) {
		 if ([annotationSelecting isKindOfClass:[YCAnnotation class]]) {
			 CLLocationCoordinate2D coordinate =  ((YCAnnotation*)annotationSelecting).coordinate;
			 if(animated)
				 [self.mapView setCenterCoordinate:coordinate animated:YES];
			 else 
				 [self.mapView setCenterCoordinate:coordinate];
		 }
	 }
	
	//先居中，后选中
	if (annotationSelecting != annotationSelected) {
		if(animated)
			[self.mapView selectAnnotation:annotationSelecting animated:YES];
		else 
			[self.mapView selectAnnotation:annotationSelecting];
	}
	
}

-(void)selectFirstPinAndVisibleAnimatedObj:(NSNumber*/*BOOL*/)animatedObj{
	BOOL b = [animatedObj boolValue];
	[self selectFirstPinAndVisibleAnimated:b];
}


//tableView的编辑状态
- (void) handle_alarmListEditStateDidChange:(NSNotification*) notification {	
	
	//还没加载
	if (![self isViewLoaded]) return;
	
	if (shineAnnotationTimer) {
        [self resetShinedIcon];//恢复闪动的图标
	}
	
	NSNumber *isEditingObj = [[notification userInfo] objectForKey:IAEditStatusKey];
	//if(isApparing){
		[self setUIEditing:[isEditingObj boolValue]];

	//}
	 

}

-(void)animateRemoveAnnotion:(id<MKAnnotation>)annotation{
	
	//取得大头针的屏幕坐标
	CGPoint  animateViewOrigin = [self.mapView convertCoordinate:annotation.coordinate toPointToView:self.view];   
	MKAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];
	animateViewOrigin.x = animateViewOrigin.x - annotationView.frame.size.width/2;
	animateViewOrigin.y = animateViewOrigin.y - annotationView.frame.size.height;

	//动画view加入到窗口
	self.animateRemoveFileView.frame = CGRectMake(animateViewOrigin.x, animateViewOrigin.y , self.animateRemoveFileView.frame.size.width, self.animateRemoveFileView.frame.size.height);
	[self.animateRemoveFileView removeFromSuperview];
	[self.view addSubview:self.animateRemoveFileView ];
	
	
	CATransition *animation = [CATransition animation];  
	[animation setDuration:0.75];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	[animation setType:kCATransitionFade];
	[animation setFillMode:kCAFillModeRemoved];
	[animation setRemovedOnCompletion:YES];

	[self.mapView removeAnnotation:annotation];
	
	[[self.mapView layer] addAnimation:animation forKey:@"RemoveDeletePin"];
	

	[self.animateRemoveFileView performSelector:@selector(startPlaying) withObject:nil afterDelay:0.1];//播放声音
	[self.animateRemoveFileView performSelector:@selector(startAnimating) withObject:nil afterDelay:0.5]; //播放动画
	
}

//闹钟列表发生变化
- (void) handle_alarmsDataListDidChange:(NSNotification*)notification {
	
	//还没加载
	if (![self isViewLoaded]) return;
	
	//更新大头针
	IASaveInfo *saveInfo = [((NSNotification*)notification).userInfo objectForKey:IASaveInfoKey];
	NSString *alarmId = saveInfo.objId;
	YCAnnotation *annotation = nil;
	switch (saveInfo.saveType) {
		case IASaveTypeDelete:
			if ([self.mapView.annotations count] == 0) break;//如果地图没有大头针，防系统bug
			
			annotation = [[self.mapAnnotationViews objectForKey:alarmId] annotation];
			if (!annotation) break;
			
			[self.mapView removeOverlay:[self.circleOverlays objectForKey:alarmId]];
			[self.mapAnnotations removeObject:annotation];
			[self.mapAnnotationViews removeObjectForKey:alarmId];
			[self.circleOverlays removeObjectForKey:alarmId];
			
			if ([(NSNotification*)notification object] == self) {
				[self animateRemoveAnnotion:annotation]; //在自己的上删除，动画效果。自己只能删除
				//[self performSelector:@selector(selectingPinAndVisible) withObject:nil afterDelay:1.0]; 
				[self performSelector:@selector(selectFirstPinAndVisibleAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.0];//播放删除完动画，再移动地图
			}else {
				[self.mapView removeAnnotation:annotation];
				[self selectFirstPinAndVisibleAnimated:NO]; //没有选中的，选中第一个;使被选中的在可视范围内
			}
			
			if ([self.mapAnnotations count] == 0) {
				//改变编辑状态
				BOOL isEditing = NO;
				NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
				NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmListEditStateDidChangeNotification 
																			  object:self
																			userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isEditing] forKey:IAEditStatusKey]];
				[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
			}
			
			break;
		case IASaveTypeUpdate:
			if (notification.object == self) break; //如果是自身视图的大头针拖动，不用做下面的
			if ([self.mapView.annotations count] == 0) break;//如果地图没有大头针，防系统bug
			
			annotation = [[self.mapAnnotationViews objectForKey:alarmId] annotation];
			if (!annotation) break;
			NSInteger index = [self.mapAnnotations indexOfObject:annotation];
			
			//先都删除了
			[self.mapView removeAnnotation:annotation];
			[self.mapView removeOverlay:[self.circleOverlays objectForKey:alarmId]];
			[self.mapAnnotations removeObject:annotation];
			[self.mapAnnotationViews removeObjectForKey:alarmId];
			[self.circleOverlays removeObjectForKey:alarmId];
			
			//再增加
			annotation = [self insertAnnotationWithAlarm:[IAAlarm findForAlarmId:alarmId] atIndex:index];
			//[self.mapView addAnnotation:annotation];
			[self.mapView performSelectorOnMainThread:@selector(addAnnotation:) withObject:annotation waitUntilDone:YES];
			
			if (![self.mapView visibleForAnnotation:annotation]) { //如果annotation不在可视范围
				//新增的在屏幕中央
				if(self->isApparing)
					[self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
				else 
					[self.mapView setCenterCoordinate:annotation.coordinate];
			}

			
			break;
		case IASaveTypeAdd:
			annotation = [self insertAnnotationWithAlarm:[IAAlarm findForAlarmId:alarmId] atIndex:0];
			if (!annotation) break;
			//[self.mapView addAnnotation:annotation];
			[self.mapView performSelectorOnMainThread:@selector(addAnnotation:) withObject:annotation waitUntilDone:YES];
			
			//新增的在屏幕中央
			if(self->isApparing)
				[self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
			else 
				[self.mapView setCenterCoordinate:annotation.coordinate];
			
			//如果屏幕没打开
			if (NO == self.maskView.hidden){
				isFirstShow = YES;//为了让在viewWillAppear重新打开
			}
						
			break;
		default:
			break;
	}
		
	
	/*
	//编辑按钮
	[self setUIEditing:self.pinsEditing];
	*/
	
	//设置“显示所有按钮”的可用状态。
	 
}



- (void) handle_applicationDidEnterBackground: (id) notification{
	
	//不知道为什么，不这样。从后台起来，第一次就没动画
	
	[focusBox release];
	focusBox = nil;
	//[focusPoint release];
	//focusPoint = nil;
	 
	
	//还没加载
	if (![self isViewLoaded]) return;
	
		
	//不显示工具条
	if (!self.toolbarFloatingView.hidden)
		self.toolbarFloatingView.hidden = YES;
	
    
    if (shineAnnotationTimer) {
        [self resetShinedIcon];//恢复闪动的图标
    }
	
	//保存最后加载的区域
	if (self.mapView.region.span.latitudeDelta < 20.0) { //很大的地图就不存了
		[YCParam paramSingleInstance].lastLoadMapRegion = self.mapView.region;
		[[YCParam paramSingleInstance] saveParam];
	}
	 
}

- (void) handle_applicationWillEnterForeground: (id) notification{
	
	//如果mask还没打开，那么重新设置超时。(用户可能去设置去了)
	if (!self.maskView.hidden) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endUpdateUserLocation) object:nil];
		[self performSelector:@selector(endUpdateUserLocation) withObject:nil afterDelay:kTimeSpanForUserLocation];
	}
	
	isAlreadyAlertForInternet = NO; //在mapview的加载地图数据失败时候中检查网络
		
}

- (void) handle_standardLocationDidFinish: (NSNotification*) notification{
    //还没加载
	if (![self isViewLoaded]) return;
    
    //间隔20秒以上才更新
    if (!(self.lastUpdateDistanceTimestamp == nil || [self.lastUpdateDistanceTimestamp timeIntervalSinceNow] < -20)) 
        return;
    self.lastUpdateDistanceTimestamp = [NSDate date]; //更新时间戳

    
    CLLocation *location = [[notification userInfo] objectForKey:IAStandardLocationKey];
    for (YCAnnotation *oneObj in self.mapAnnotations ) {
        if (location)
            [self setDistanceInAnnotation:oneObj withCurrentLocation:location];
        else
            oneObj.subtitle = nil;
		
    }
    
}

- (void) handle_applicationWillResignActive:(id)notification{	
	
	//恢复navbar 标题
	self.navigationItem.titleView = nil;
	//self.mapView.showsUserLocation = NO;
	
	//不再刷新pin
	[refreshPinLoopTimer invalidate];
	[refreshPinLoopTimer release];
	refreshPinLoopTimer = nil;
}

- (void) handle_applicationDidBecomeActive:(id)notification{	
	
	//刷新pin的refreshPinLoopTimer
	NSTimeInterval ti = 0.75;
	refreshPinLoopTimer = [[NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(refreshPinView) userInfo:nil repeats:YES] retain];
     
}



- (void) handle_letAlarmMapsViewHaveAPinVisibleAndSelected:(id)notification{	
	//没有选中的，选中第一个;使被选中的在可视范围内
	[self selectFirstPinAndVisibleAnimated:YES];
}

//为了延时调用
- (void)focusToPoint:(CGPoint)focusWhere{
		
	//动画期间不允许拖动地图，不允许其他事件
	[self setUserInteractionEnabled:NO];


	//加上聚焦点
	[NSObject cancelPreviousPerformRequestsWithTarget:self.mapView selector:@selector(removeOverlay:) object:foucusOverlay];
    if (foucusOverlay)
        [self.mapView removeOverlay:foucusOverlay];
	[self.mapView addOverlay:[self foucusOverlay:focusWhere]];

	
	CALayer *rootLayer=self.mapView.layer; 
	self.focusBox.position= focusWhere;
	[rootLayer addSublayer :self.focusBox];
	
	
	//先把动画都删除了
	[self.focusBox removeAllAnimations];
	[rootLayer removeAllAnimations];

	
	[CATransaction begin];
	[ CATransaction setValue:[ NSNumber numberWithFloat: 1.0 ] forKey: kCATransactionAnimationDuration];  
	
	//聚焦框动画
	CABasicAnimation *focusAnimation=[ CABasicAnimation animationWithKeyPath: @"transform.scale" ];  
	focusAnimation.delegate = self;
	focusAnimation.timingFunction= [ CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];  
	focusAnimation.fromValue= [NSNumber numberWithFloat:1.0];
	focusAnimation.toValue= [NSNumber numberWithFloat:0.0];   
	focusAnimation.duration=1.0 ;  
	focusAnimation.fillMode=kCAFillModeForwards;  
	focusAnimation.removedOnCompletion=NO;
	[self.focusBox addAnimation :focusAnimation forKey :@"focus" ];
	
	/*
	//聚焦点显示动画
	CATransition *transition = [CATransition animation];
	transition.duration = 0.5;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	transition.removedOnCompletion=YES;
    [rootLayer addAnimation:transition forKey:@"fade"];
	 */

	
	
	[CATransaction commit];
	

	
	//丢下个大头针
	CLLocationCoordinate2D focusCoordinate = [self.mapView convertPoint:focusWhere toCoordinateFromView:self.mapView];
	MKPlacemark *annotationTemp = [[[MKPlacemark alloc] initWithCoordinate:focusCoordinate addressDictionary:nil] autorelease];
	[self.mapView performSelector:@selector(addAnnotation:) withObject:annotationTemp afterDelay:0.75];
	[self.mapView performSelector:@selector(removeAnnotation:) withObject:annotationTemp afterDelay:2.5];
}


//显示聚焦情况
- (void)handle_addIAlarmButtonPressed:(NSNotification*)notification{
	
	//还没加载
	if (![self isViewLoaded]) return;
	
	CGRect viewFrame= self.mapView.frame;  
	CALayer *rootLayer=self.mapView.layer;  
	rootLayer.frame=viewFrame;
	
	IAAlarm *alarm = [[notification userInfo] objectForKey:IAAlarmAddedKey];
	CGPoint focusWhere;
	if (CLLocationCoordinate2DIsValid(alarm.coordinate)) {
		//使用闹钟里的坐标
		focusWhere = [self.mapView convertCoordinate:alarm.coordinate toPointToView:self.mapView];
	}else {
		if (self.mapView.userLocation.location) {
			//使用当前位置
			focusWhere = [self.mapView convertCoordinate:self.mapView.userLocation.location.coordinate toPointToView:self.mapView];
		}else {
			//使用屏幕中央点
			focusWhere = CGPointMake(viewFrame.size.width/ 2 , viewFrame.size.height/ 2 );
		}

	}
	
	//判断聚焦点是否在可视范围内
	CLLocationCoordinate2D focusCoordinate = [self.mapView convertPoint:focusWhere toCoordinateFromView:self.mapView];
	MKMapPoint focusMapPoint = MKMapPointForCoordinate(focusCoordinate);
	MKMapRect visibleRect = [self.mapView visibleMapRect];
	if (!MKMapRectContainsPoint(visibleRect,focusMapPoint)){
		[self.mapView setCenterCoordinate:focusCoordinate animated:YES];
		focusWhere = CGPointMake(viewFrame.size.width/ 2 , viewFrame.size. height/ 2 );
		
		//延时执行
		SEL selector = @selector(focusToPoint:);
		NSMethodSignature *signature = [self methodSignatureForSelector:selector];
		NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
		[invocaton setTarget:self];
		[invocaton setSelector:selector];
		[invocaton setArgument:&focusWhere atIndex:2];  //self,_cmd分别占据0、1
		[invocaton performSelector:@selector(invoke) withObject:nil afterDelay:0.25];
		 
		
	}else {
		[self focusToPoint:focusWhere];
	}


}

- (void)handle_currentLocationButtonPressed:(NSNotification*)notification{
	//[self performSelector:@selector(setLocationBarItem:) withObject:nil afterDelay:0.5];//0.5秒后，把barItem改回正常状态
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate,kDefaultLatitudinalMeters,kDefaultLongitudinalMeters);
	[self.mapView setRegion:region FromWorld:NO animatedToWorld:NO animatedToPlace:YES];
	[self.mapView performSelector:@selector(animateSelectAnnotation:) withObject:self.mapView.userLocation afterDelay:0.5]; //适当延长时间		
}

- (void)handle_focusButtonPressed:(NSNotification*)notification{
		
	//选中第一个
	if (self.mapAnnotations.count >0) {
		if (self.mapView.selectedAnnotations.count ==1) { 
			id selectedAnnotation = [self.mapView.selectedAnnotations objectAtIndex:0];
			if ([selectedAnnotation isKindOfClass:[MKUserLocation class]]) { 
				//目前选中是当前位置
				[self.mapView animateSelectAnnotation:[self.mapAnnotations objectAtIndex:0]];
			}
			
		}else if (self.mapView.selectedAnnotations.count <=0){
			//没有选中的
			[self.mapView animateSelectAnnotation:[self.mapAnnotations objectAtIndex:0]];
		}
		
	}
	
	MKCoordinateRegion region = [self allPinsRegion];
	
	//是否有大头针在屏幕可视范围中
	if ([self isHavePinVisible]) {
		//不Zoom
		[self.mapView setRegion:region FromWorld:NO animatedToWorld:NO animatedToPlace:YES];
	}else {
		//先到世界地图，在下来
		[self.mapView setRegion:region FromWorld:YES animatedToWorld:YES animatedToPlace:YES];
	}
	
}

- (void)handle_mapTypeButtonPressed:(NSNotification*)notification{
	self.toolbarFloatingView.hidden = !self.toolbarFloatingView.hidden;
	
	switch (self.mapView.mapType) {
		case MKMapTypeStandard:
			self.mapsTypeButton.enabled = NO;
			self.satelliteTypeButton.enabled = YES;
			self.hybridTypeButton.enabled = YES;
			break;
		case MKMapTypeSatellite:
			self.mapsTypeButton.enabled = YES;
			self.satelliteTypeButton.enabled = NO;
			self.hybridTypeButton.enabled = YES;
			break;
		case MKMapTypeHybrid:
			self.mapsTypeButton.enabled = YES;
			self.satelliteTypeButton.enabled = YES;
			self.hybridTypeButton.enabled = NO;
			break;
		default:
			break;
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	//还没加载
	if (![self isViewLoaded]) return;
	

	if (object == self.maskView && [keyPath isEqualToString:@"hidden"])
	{		
		BOOL isHidden = [(NSNumber*)[change valueForKey:NSKeyValueChangeNewKey] boolValue];
		
		//发覆盖通知
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmMapsMaskingDidChangeNotification 
																	  object:self
																	userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:!isHidden] forKey:IAAlarmMapsMaskingKey]];
		[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
		
	}
	
	
}

- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmListEditStateDidChange:)
							   name: IAAlarmListEditStateDidChangeNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmsDataListDidChange:)
							   name: IAAlarmsDataListDidChangeNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidEnterBackground:)
							   name: UIApplicationDidEnterBackgroundNotification
							 object: nil];
	 
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillEnterForeground:)
							   name: UIApplicationWillEnterForegroundNotification
							 object: nil];
	 
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillResignActive:)
							   name: UIApplicationWillResignActiveNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidBecomeActive:)
							   name: UIApplicationDidBecomeActiveNotification
							 object: nil];
	 
    [notificationCenter addObserver: self
						   selector: @selector (handle_standardLocationDidFinish:)
							   name: IAStandardLocationDidFinishNotification
							 object: nil];
	

	[notificationCenter addObserver: self
						   selector: @selector (handle_letAlarmMapsViewHaveAPinVisibleAndSelected:)
							   name: IALetAlarmMapsViewHaveAPinVisibleAndSelectedNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_addIAlarmButtonPressed:)
							   name: IAAddIAlarmButtonPressedNotification
							 object: nil];
	//
	[notificationCenter addObserver: self
						   selector: @selector (handle_currentLocationButtonPressed:)
							   name: IACurrentLocationButtonPressedNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_focusButtonPressed:)
							   name: IAFocusButtonPressedNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_mapTypeButtonPressed:)
							   name: IAMapTypeButtonPressedNotification
							 object: nil];
	
	[self.maskView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: IAAlarmListEditStateDidChangeNotification object: nil];
	[notificationCenter removeObserver:self	name: IAAlarmsDataListDidChangeNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationDidEnterBackgroundNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationWillEnterForegroundNotification object: nil];
    [notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationDidBecomeActiveNotification object: nil];
	[notificationCenter removeObserver:self	name: IALetAlarmMapsViewHaveAPinVisibleAndSelectedNotification object: nil];
	[notificationCenter removeObserver:self	name: IAAddIAlarmButtonPressedNotification object: nil];
	[notificationCenter removeObserver:self	name: IACurrentLocationButtonPressedNotification object: nil];
	[notificationCenter removeObserver:self	name: IAFocusButtonPressedNotification object: nil];
	[notificationCenter removeObserver:self	name: IAMapTypeButtonPressedNotification object: nil];

	
	
	
	[self.maskView removeObserver:self forKeyPath:@"hidden"];

}

#pragma mark -
#pragma mark CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
	[self.focusBox removeFromSuperlayer];
	if (foucusOverlay)
		[self.mapView performSelector:@selector(removeOverlay:) withObject:foucusOverlay afterDelay:1.25];

	//详细页面出现后，再允许拖动地图、允许其他事件
	[self performSelector:@selector(setUserInteractionEnabled:) withInteger:YES afterDelay:1.25];

}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {

    [super viewDidLoad];	
	self.title = KViewTitleAlarmsListMaps;
	self.maskLabel.text = KTextPromptWhenLoading;
	self.mapView.delegate = self;
	self->isFirstShow = YES;
	
	
	//mask view
	[self.maskView addSubview:self.maskActivityIndicator];
	self.maskView.hidden = NO;
		
	
	//单点地图
	UITapGestureRecognizer *tapMapViewGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTap:)] autorelease];
	tapMapViewGesture.delegate = self;
	[self.mapView addGestureRecognizer:tapMapViewGesture];
	
	
	//长按地图
	UILongPressGestureRecognizer *longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewLongPressed:)] autorelease];
    longPressGesture.minimumPressDuration = 1.0; //多长时间算长按
	longPressGesture.allowableMovement = 30.0;
	[self.mapView addGestureRecognizer:longPressGesture];
	 
	 
	
	//显示大头针
	[self addMapAnnotations];
	
	//检查网络
	isAlreadyAlertForInternet = NO;
	NSInteger alarmsCount = self.alarms.count;
	if (0 == alarmsCount) { //闹钟数不等于0，就会直接加载地图了，在地图数据加载失败事件中会提示网络的。
		[self performSelector:@selector(alertInternet) withObject:nil afterDelay:1.5];
		isAlreadyAlertForInternet = YES;
	}
		
	//浮动工具栏
	self.toolbarFloatingView.hidden = YES;
	[self.view addSubview:self.toolbarFloatingView];
	
	self.mapsTypeButton = [[self.toolbarFloatingView buttons] objectAtIndex:0];
	self.satelliteTypeButton  = [[self.toolbarFloatingView  buttons] objectAtIndex:1];
	self.hybridTypeButton = [[self.toolbarFloatingView  buttons] objectAtIndex:2];
	
    [self registerNotifications];

}

//为了延时执行。否则有上个bar的痕迹
-(void)performShowBar:(UIView*)theBar{
	BOOL isTopBar = YES;
	if ([theBar isKindOfClass:[UIToolbar class]]) {
		isTopBar = NO;
	}
	[UIUtility setBar:theBar topBar:isTopBar visible:YES animated:YES animateDuration:1.0 animateName:@"showOrHideToolbar"];
}

-(void)viewWillAppear:(BOOL)animated
{	
	[super viewWillAppear:animated];
	self->isApparing = YES;
	
	
	if (isFirstShow){
		NSInteger alarmsCount = self.alarms.count;
		
		//1.显示所有pin的region
		//2.显示最后显示的
		//3.显示当前位置
		MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(-1000.0, -1000.0), 0.0, 0.0);;
		if (alarmsCount > 0) {   //1.
			
			region = [self allPinsRegion];
			
		}else if(YCMKCoordinateRegionIsValid([YCParam paramSingleInstance].lastLoadMapRegion)){       //2.
			
			region = [YCParam paramSingleInstance].lastLoadMapRegion;
			
		}else {                                //3.
			
			if (!self.mapView.userLocation.location) { //设备当前位置
				[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endUpdateUserLocation) object:nil];//上一次viewload后，用户去setting了
				[self performSelector:@selector(endUpdateUserLocation) withObject:nil afterDelay:kTimeSpanForUserLocation];
			}else {
				region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate,kDefaultLatitudinalMeters,kDefaultLongitudinalMeters);
			}
			
		}
		
		
		
		
		if (YCMKCoordinateRegionIsValid(region)) {
			//关掉覆盖视图,显示toolbar
			[self animateCloseMaskViewAndShowToolbar];
			//先到世界地图，在下来
			[self.mapView setRegion:region FromWorld:YES animatedToWorld:NO animatedToPlace:YES];
		}
		
		
	}
	
	if (self.pinsEditing != [YCSystemStatus deviceStatusSingleInstance].isAlarmListEditing) {
		//刷新编辑状态
		[self setUIEditing:[YCSystemStatus deviceStatusSingleInstance].isAlarmListEditing];
	}
	
	

	isFirstShow = NO;
	
}

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	self->isApparing = NO;


	//保存最后加载的区域
	if (self.mapView.region.span.latitudeDelta < 20.0) { //很大的地图就不存了
		[YCParam paramSingleInstance].lastLoadMapRegion = self.mapView.region;
		[[YCParam paramSingleInstance] saveParam];
	}
    
	
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	//不显示工具条
	if (!self.toolbarFloatingView.hidden)
		self.toolbarFloatingView.hidden = YES;
	
	if (shineAnnotationTimer) {
        [self resetShinedIcon];//恢复闪动的图标
    }
}


#pragma mark -
#pragma mark Events Handle

- (void)mapTypeButtonPressed:(id)sender{
	self.toolbarFloatingView.hidden = !self.toolbarFloatingView.hidden;
	
	switch (self.mapView.mapType) {
		case MKMapTypeStandard:
			self.mapsTypeButton.enabled = NO;
			self.satelliteTypeButton.enabled = YES;
			self.hybridTypeButton.enabled = YES;
			break;
		case MKMapTypeSatellite:
			self.mapsTypeButton.enabled = YES;
			self.satelliteTypeButton.enabled = NO;
			self.hybridTypeButton.enabled = YES;
			break;
		case MKMapTypeHybrid:
			self.mapsTypeButton.enabled = YES;
			self.satelliteTypeButton.enabled = YES;
			self.hybridTypeButton.enabled = NO;
			break;
		default:
			break;
	}
}

- (void)mapTypeMenuItemPressed:(id)sender{
	
	if (sender == self.mapsTypeButton) {
		self.mapView.mapType = MKMapTypeStandard;
	}else if (sender == self.satelliteTypeButton) {
		self.mapView.mapType = MKMapTypeSatellite;
	}else if (sender == self.hybridTypeButton){
		self.mapView.mapType = MKMapTypeHybrid;
	}
	
	/*
	 self.mapsTypeButton.enabled = (sender != self.mapsTypeButton);
	 self.satelliteTypeButton.enabled = (sender != self.satelliteTypeButton);
	 self.hybridTypeButton.enabled = (sender != self.hybridTypeButton);
	 */
	
	[self mapTypeButtonPressed:nil]; //改变Item项的不可用状态
}


/*
- (void)standardMapMenuItemPressed:(id)sender{
	[self.mapTypemenuController setMenuVisible:NO animated:YES];
}
- (void)satelliteMapMenuItemPressed:(id)sender{
	[self.mapTypemenuController setMenuVisible:NO animated:YES];
}
- (void)hybridMapMenuItemPressed:(id)sender{
	[self.mapTypemenuController setMenuVisible:NO animated:YES];
}

-(IBAction)mapTypeMenuButtonPressed:(id)sender{
	[self.mapTypemenuController setMenuVisible:YES animated:YES];
}
 */



-(void)mapViewTap:(UITapGestureRecognizer *)sender{
	if (sender.state == UIGestureRecognizerStateEnded) {
		//不显示工具条
		if (!self.toolbarFloatingView.hidden)
			[self mapTypeButtonPressed:nil];
	}
}

-(void)pinTap:(UITapGestureRecognizer *)sender{
	
	//NSLog(@"pinTap:");
	/*
	YCPinAnnotationView *annotationView = (YCPinAnnotationView*)sender.view;
	if(![annotationView isKindOfClass:[YCPinAnnotationView class]]) return;
	
	if (UIGestureRecognizerStateBegan == sender.state){ //只处理长按开始
		[(YCPinAnnotationView*)annotationView performSelector:@selector(updatePinColor) withObject:nil afterDelay:0.25];
		[(YCPinAnnotationView*)annotationView performSelector:@selector(updatePinColor) withObject:nil afterDelay:1.75];
	}
	 */
	
}

- (void)pinLongPressed:(UILongPressGestureRecognizer *)sender{
		
	if (shineAnnotationTimer) {
        [self resetShinedIcon];//恢复闪动的图标
    }
	

	
	YCPinAnnotationView *annotationView = (YCPinAnnotationView*)sender.view;
	if(![annotationView isKindOfClass:[YCPinAnnotationView class]]) return;
	
	


	if (UIGestureRecognizerStateBegan == sender.state){ //只处理长按开始
		
		//[(YCPinAnnotationView*)annotationView performSelector:@selector(updatePinColor) withObject:nil afterDelay:0.25];
		//[(YCPinAnnotationView*)annotationView performSelector:@selector(updatePinColor) withObject:nil afterDelay:1.75];
		
		//如果是编辑状态，退出
		if (pinsEditing) {
			return;
		}
		
		id selectedAnnotation = nil;
        if (self.mapView.selectedAnnotations.count > 0) {
            selectedAnnotation = [self.mapView.selectedAnnotations objectAtIndex:0];
        }
		
		//选中的不是这个view,先选中
		if (selectedAnnotation != annotationView.annotation){
			[self.mapView selectAnnotation:annotationView.annotation animated:YES];
			return;
		}
		

		
		//annotationView.calloutViewEditing = !annotationView.calloutViewEditing;
		//改变编辑状态
		BOOL isEditing = !pinsEditing;
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmListEditStateDidChangeNotification 
																	  object:self
																	userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isEditing] forKey:IAEditStatusKey]];
		[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
		
		//编辑状态变了，使至少一个pin可视并选中
		NSNotification *bNotification = [NSNotification notificationWithName:IALetAlarmMapsViewHaveAPinVisibleAndSelectedNotification 
																	  object:self
																	userInfo:nil];
		[notificationCenter performSelector:@selector(postNotification:) withObject:bNotification afterDelay:0.0];
		
	}
	
	

	
}

- (void)mapViewLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
	
	if (UIGestureRecognizerStateBegan == gestureRecognizer.state){ //只处理长按开始
		
		CGPoint pointPressed = [gestureRecognizer locationInView:self.mapView];
		CLLocationCoordinate2D coordinatePressed = [self.mapView convertPoint:pointPressed toCoordinateFromView:self.mapView];
		
		if (CLLocationCoordinate2DIsValid(coordinatePressed)){
			IAAlarm *alarm = [[[IAAlarm alloc] init] autorelease];
			alarm.coordinate = coordinatePressed; 
			
			NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
			NSNotification *aNotification = [NSNotification notificationWithName:IAAddIAlarmButtonPressedNotification 
																		  object:self
																		userInfo:[NSDictionary dictionaryWithObject:alarm forKey:IAAlarmAddedKey]];
			[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
		}
	}
	
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString *str = @"prefs:root=General&path=Network"; //打开设置中的网络
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}

#pragma mark -
#pragma mark - YCPinAnnotationViewDelegete

//按下了删除按钮
- (void)annotationView:(YCPinAnnotationView *)annotationView didPressDeleteButton:(UIButton*)button{	
	//删除Alarm
	NSString *alarmId = [(YCAnnotation*)annotationView.annotation identifier];
	IAAlarm *alarmSelected =[IAAlarm findForAlarmId:alarmId];
	[alarmSelected deleteFromSender:self];
}

/*
//AnnotationView收到消息
- (void)annotationView:(YCPinAnnotationView *)annotationView hitTestWithEven:(UIEvent *)event{
	//对付 应该灰而不灰的情况
	[self performSelector:@selector(refreshPinView) withObject:nil afterDelay:1.0];
}
 */

#pragma mark -
#pragma mark Utility - UIGestureRecognizerDelegate


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{

	if ([otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
		return YES;
	}
	
	return NO;

}
 

/*
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
	return NO;
}
 */
 
 
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
	
	if ([gestureRecognizer.view isKindOfClass:[YCPinAnnotationView class]]) {
		return YES;
	}
	
	//浮动工具条是否显示
	BOOL toolbarFloatingViewHidden = NO;
	if (!self.toolbarFloatingView.hidden) 
		toolbarFloatingViewHidden = YES;
	else 
		toolbarFloatingViewHidden = NO;
	
	
	//点的范围是否在UICalloutView内
	BOOL touchInCalloutView = NO;
	id<MKAnnotation> selectedAnnotation = nil;
	MKAnnotationView *selectedView = nil;
    if (self.mapView.selectedAnnotations.count >0) {
        selectedAnnotation = [self.mapView.selectedAnnotations objectAtIndex:0];
        selectedView = [self.mapView viewForAnnotation:selectedAnnotation];
    }
	if ([selectedView isKindOfClass:[MKPinAnnotationView class]]) {
		
		UIView *calloutView = nil;
		NSArray *subArray =[selectedView subviews];
		for (UIView *subView in subArray) {
			NSString *className = NSStringFromClass([subView class]) ;
			if ([className isEqualToString:@"UICalloutView"]){
				calloutView = subView;
				break;
			}
		}
		
		if (calloutView) {
			CGRect calloutViewFrame = [self.view convertRect:calloutView.frame fromView:selectedView];
			CGPoint touchPoint = [touch locationInView:self.view]; 
			touchInCalloutView = CGRectContainsPoint(calloutViewFrame,touchPoint);
		}
		
	}
	
	return (toolbarFloatingViewHidden || touchInCalloutView);
	
}


#pragma mark -
#pragma mark Utility - ReverseGeocoder


#define kTimeOutForReverse 5.0

-(void)beginReverseWithCoordinate:(CLLocationCoordinate2D)coordinate
{
	//初始化，reverseGeocoder对象必须根据特定坐标init。
	reverseGeocoderForUserLocation = [self reverseGeocoder:coordinate];
	reverseGeocoderForUserLocation.delegate = self;
	
	//反转坐标
	self.placemarkForUserLocation = nil; //先赋空相关数据
	[reverseGeocoderForUserLocation start];
	[self performSelector:@selector(endReverse) withObject:nil afterDelay:kTimeOutForReverse];
}

//beginReverseWithCoordinate:的对象版本，供延时调用
- (void)beginReverseWithObj:(id/*CLLocationCoordinate2D*/)obj
{   
	CLLocationCoordinate2D target;
	[obj getValue:&target];
	
	[self beginReverseWithCoordinate:target];
}

-(void)endReverse
{
	
	//如果超时了，反转还没结束，结束它
	[reverseGeocoderForUserLocation cancel];
	//取消掉另一个调用
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endReverse) object:nil];
	
	NSString *subtitle = nil;
	if (self.placemarkForUserLocation != nil) {
		
		subtitle = YCGetAddressString(self.placemarkForUserLocation);
		MKUserLocation *userLocationAnnotation = self.mapView.userLocation;     //当前地址
		userLocationAnnotation.subtitle = subtitle;
		
	}
	
}


-(void)beginReverseWithAnnotation:(id<MKAnnotation>)annotation
{	
	//如果原来的还在查询，就先结束它
	MKReverseGeocoder *oldReverseGeocoderForPin = [self.reverseGeocodersForPin objectForKey:[(YCAnnotation*)annotation identifier]];
	if (oldReverseGeocoderForPin && oldReverseGeocoderForPin.querying) {
		[oldReverseGeocoderForPin cancel];
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endReverseWithAnnotation:) object:annotation];
	}
	
	//初始化，reverseGeocoder对象必须根据特定坐标init。
	MKReverseGeocoder *aReverseGeocoderForPin = [[[MKReverseGeocoder alloc] initWithCoordinate:annotation.coordinate] autorelease];
	aReverseGeocoderForPin.delegate = self;
	[self.reverseGeocodersForPin setObject:aReverseGeocoderForPin forKey:[(YCAnnotation*)annotation identifier]];//应该不需要释放老的，自动了

	//反转坐标
	self.placemarkForPin = nil; //先赋空相关数据
	[aReverseGeocoderForPin start];
	[self performSelector:@selector(endReverseWithAnnotation:) withObject:annotation afterDelay:kTimeOutForReverse];
}


-(void)endReverseWithAnnotation:(id<MKAnnotation>)annotation
{
	MKReverseGeocoder *aReverseGeocoderForPin = [self.reverseGeocodersForPin objectForKey:[(YCAnnotation*)annotation identifier]];
	//如果超时了，反转还没结束，结束它
	if ([aReverseGeocoderForPin respondsToSelector:@selector(cancel)])
		[aReverseGeocoderForPin cancel];
	//取消掉另一个调用，如果有
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endReverseWithAnnotation:) object:annotation];
	
	IAAlarm *alarm = [IAAlarm findForAlarmId:[(YCAnnotation*)annotation identifier]];
	CLLocationCoordinate2D coordinate = annotation.coordinate;
	MKPlacemark *placemark = self.placemarkForPin;
	NSString *addressTitle = nil;
	NSString *addressShort = nil;
	NSString *address = nil;
	
	alarm.usedCoordinateAddress = NO;  
	if (placemark != nil) {
		address = YCGetAddressString(placemark);
		
		addressShort = YCGetAddressShortString(placemark);
		addressShort = (addressShort != nil) ? addressShort : address;
		
		addressTitle = YCGetAddressTitleString(placemark);
		addressTitle = (addressTitle != nil) ? addressTitle : addressShort;
		
		
	}else {
		//反转坐标 失败，使用坐标作为地址
		addressTitle = KDefaultAlarmName;
		address = [UIUtility convertCoordinate:coordinate];
		addressShort = address;
		alarm.usedCoordinateAddress = YES;
	}
	
	//最后的判空
	addressTitle = (addressTitle != nil) ? addressTitle:KDefaultAlarmName;
	if (addressShort == nil) {
		alarm.usedCoordinateAddress = YES;
		addressShort = (addressShort != nil) ? addressShort : [UIUtility convertCoordinate:coordinate];
	}
	address = (address != nil) ? address : [UIUtility convertCoordinate:coordinate];
	
	
	
	if (!alarm.nameChanged) {
		[(YCAnnotation*)annotation setTitle:addressTitle];
		alarm.alarmName = addressTitle;
	}
	alarm.coordinate = coordinate;
	alarm.position = address;
	alarm.positionShort = addressShort;
    alarm.reserve1 = addressTitle;  //做为addressTitle
	alarm.locationAccuracy = kCLLocationAccuracyBest;
	
	[alarm saveFromSender:self];
	
}


#pragma mark -
#pragma mark MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	

	if (reverseGeocoderForUserLocation == geocoder) {//当前位置使用的反转
		
		self.placemarkForUserLocation = placemark;
		[self performSelector:@selector(endReverse) withObject:nil afterDelay:0.0];  //数据更新后，等待x秒
		
	}else{
		//通过reverseGeocoder找到Annotation
		self.placemarkForPin = placemark;
		NSArray *array = [self.reverseGeocodersForPin allKeysForObject:geocoder];
		if (array.count >0) {
            NSString *alarmId = [array objectAtIndex:0];
            YCPinAnnotationView *anPinAnnotationView = (YCPinAnnotationView*)[mapAnnotationViews objectForKey:alarmId];
            if (anPinAnnotationView) {
                [self endReverseWithAnnotation:[anPinAnnotationView annotation]];
            }
            
        }
		
	}

}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	
	//无网络连接时候，收到失败数据，就结束反转
	BOOL connectedToInternet = [[YCSystemStatus deviceStatusSingleInstance] connectedToInternet];
	if (!connectedToInternet) {

		if (reverseGeocoderForUserLocation == geocoder) {//当前位置使用的反转
			
			self.placemarkForUserLocation = nil;
			[self performSelector:@selector(endReverse) withObject:nil afterDelay:0.0];  //等待x秒，结束
			
		}else {
			//通过reverseGeocoder找到Annotation
			self.placemarkForPin = nil;
			NSArray *array = [self.reverseGeocodersForPin allKeysForObject:geocoder];
            if (array.count >0) {
                NSString *alarmId = [array objectAtIndex:0];
                YCPinAnnotationView *anPinAnnotationView = (YCPinAnnotationView*)[mapAnnotationViews objectForKey:alarmId];
                if (anPinAnnotationView) {
                    [self endReverseWithAnnotation:[anPinAnnotationView annotation]];
                }
                
            }
			
		}
	}
	
	
}



#pragma mark - 
#pragma mark - MKMapViewDelegate
/*
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[MKUserLocation class]])
	{
		return nil;
	}
    
	MKPinAnnotationView* pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ABCD"];
	pinView.draggable = YES;
	return pinView;
    
}
 */


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[MKUserLocation class]])
	{
		return nil;
	}
    
	MKPinAnnotationView* pinView = nil;
	if ([annotation isKindOfClass:[YCAnnotation class]]) {
		pinView = [self.mapAnnotationViews objectForKey:((YCAnnotation*)annotation).identifier];
	}else {
		//临时的pin
		pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil] autorelease];
		pinView.pinColor = pinsEditing ? MKPinAnnotationColorPurple : MKPinAnnotationColorRed;
		pinView.animatesDrop = YES;
	}
	return pinView;
    
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView
{
	//[self setPreviousNextButtonEnableStatus]; //设置上一个下一个按钮状态
	
	if ([annotationView.annotation isKindOfClass:[MKUserLocation class]])
	{
		return;
	}
	
	//设置最后选中的索引
	self->lastSelectedAnnotionIndex = [self.mapAnnotations indexOfObject:annotationView.annotation];
	if (NSNotFound == self->lastSelectedAnnotionIndex) 
		self->lastSelectedAnnotionIndex = -1;//没有被选中的
	
	
	/////////////////////////////////////////
	//警示圈
	YCAnnotation *annotation = (YCAnnotation*)annotationView.annotation;
	if ([annotation isKindOfClass:[YCAnnotation class]])
	{
		//反转坐标－地址
		//[self performSelector:@selector(beginReverseWithAnnotation:) withObject:annotation afterDelay:0.0];
		
		//先都隐藏
		[self.mapView removeOverlays:[self.circleOverlays allValues]]; 
		
		MKCircle *circleOverlay = [self.circleOverlays objectForKey:annotation.identifier];
		[self.mapView performSelector:@selector(addOverlay:) withObject:circleOverlay afterDelay:0.5];
	}
	/////////////////////////////////////////
	 
	
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)annotationView{
	
	//先都隐藏
	[self.mapView removeOverlays:[self.circleOverlays allValues]]; 	 
}

//重新地图设备当前地址共享结束，设这个函数是为了别的地方同步调用
- (void)endUpdateUserLocation{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endUpdateUserLocation) object:nil];
	
	
	if (self.mapView.userLocation.location){
		CLLocationCoordinate2D coordinate = self.mapView.userLocation.location.coordinate;
		NSValue *coordinateObj = [NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)];
		[self performSelector:@selector(beginReverseWithObj:) withObject:coordinateObj afterDelay:0.0]; //反转坐标－地址。延时调用
		
	}
	
	if (!self.maskView.hidden) {
		//关掉覆盖视图,显示toolbar
		[self animateCloseMaskViewAndShowToolbar];
		
		if (self.mapView.userLocation.location) {
			MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate,kDefaultLatitudinalMeters,kDefaultLongitudinalMeters);
			if (YCMKCoordinateRegionIsValid(region)) //区域有有效
				[self.mapView setRegion:region FromWorld:YES animatedToWorld:YES animatedToPlace:YES];//先到世界地图，在下来
		}
	}
	
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (userLocation.location == nil) //ios5.0 没有取得用户位置的时候也回调这个方法
        return;
    
	[self performSelector:@selector(endUpdateUserLocation) withObject:nil afterDelay:0.0];
	
	//设置“回到当前位置按钮”的可用状态。
	BOOL currentLocationStatus = NO;
	if (self.mapView.userLocation.location)
		currentLocationStatus = ![self isUserLocationInMapsCenter];
	
	NSDictionary *currentLocationDic = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithInteger:1],IAControlIdKey
										,[NSNumber numberWithBool:currentLocationStatus],IAControlStatusKey
										,nil];
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *currentLocationNotification = [NSNotification notificationWithName:IAControlStatusShouldChangeNotification object:self userInfo:currentLocationDic];
	[notificationCenter performSelector:@selector(postNotification:) withObject:currentLocationNotification afterDelay:0.0];
}



- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
	NSArray *array = [self.circleOverlays allValues];
	NSInteger index = [array indexOfObject:overlay];
	
	if (NSNotFound != index) {
		
		MKCircleView *cirecleView = nil;
		cirecleView = [[[MKCircleView alloc] initWithCircle:overlay] autorelease];
		cirecleView.fillColor = [UIColor colorWithRed:160.0/255.0 green:127.0/255.0 blue:255.0/255.0 alpha:0.4]; //淡紫几乎透明
		cirecleView.strokeColor = [UIColor whiteColor];   //白
		cirecleView.lineWidth = 2.0;
		return cirecleView;
		
	}else if ([overlay isKindOfClass:[YCOverlayImage class]]) {
		//聚集view
		UIImage *image = [UIImage imageNamed:@"focusPoint.png"];
		YCOverlayImageView *overlayImageView = [[[YCOverlayImageView alloc] initWithOverlay:overlay andImage:image] autorelease];
		return overlayImageView;
	}
	
	return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
	//设置选中
	//if (-1 == self->lastSelectedAnnotionIndex) self->lastSelectedAnnotionIndex = 0;
	//[self.mapView selectAnnotationFromAnnotations:self.mapAnnotations AtIndex:self->lastSelectedAnnotionIndex animated:YES];
	
	BOOL hasSelected = NO;
	for (MKAnnotationView *annotationView in views) {

		YCAnnotation *annoation = (YCAnnotation*)annotationView.annotation ;

		
		if ([annoation isKindOfClass:[YCAnnotation class]]) {
            
            //显示距离当前位置XX公里
            annoation.subtitle = nil;
            if ([YCSystemStatus deviceStatusSingleInstance].lastLocation) {
                [self setDistanceInAnnotation:annoation withCurrentLocation:[YCSystemStatus deviceStatusSingleInstance].lastLocation];
            }
		}
		
		
		//选中
		if (!hasSelected) {
			if (self.mapAnnotations.count == views.count) { //view load时候，选中最新加入的
				id annotationselecting = nil;
                if (self.mapAnnotations.count > 0) {
                    annotationselecting = [self.mapAnnotations objectAtIndex:0];
                    [self.mapView performSelector:@selector(selectAnnotation:) withObject:annotationselecting afterDelay:0.0]; 
                }
				
				
			}else {
				if ([annoation isKindOfClass:[YCAnnotation class]]) 
					[self.mapView performSelector:@selector(selectAnnotation:) withObject:annoation afterDelay:0.0]; 
			}
			
			hasSelected = YES;
		}

	}
	

}
 


	
- (void)mapView:(MKMapView *)theMapView regionDidChangeAnimated:(BOOL)animated{
	
	//设置“回到当前位置按钮”的可用状态。
	BOOL currentLocationStatus = NO;
	if (self.mapView.userLocation.location)
		currentLocationStatus = ![self isUserLocationInMapsCenter];
	
	NSDictionary *currentLocationDic = [NSDictionary dictionaryWithObjectsAndKeys:
										 [NSNumber numberWithInteger:1],IAControlIdKey
										,[NSNumber numberWithBool:currentLocationStatus],IAControlStatusKey
										,nil];
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *currentLocationNotification = [NSNotification notificationWithName:IAControlStatusShouldChangeNotification object:self userInfo:currentLocationDic];
	[notificationCenter performSelector:@selector(postNotification:) withObject:currentLocationNotification afterDelay:0.0];
	
	//设置“显示所有按钮”的可用状态。
	BOOL focusStatus = NO;
	if (self.alarms.count >0) {
		//有一个pin不可视，按钮就可用
		BOOL isHaveAPinVisible = NO;
		for (YCAnnotation *anAnnotation in self.mapAnnotations) {
			isHaveAPinVisible = [self.mapView visibleForAnnotation:anAnnotation];
			if (!isHaveAPinVisible)
				break;
		}
		focusStatus = !isHaveAPinVisible;
	}
	NSDictionary *focusDic = [NSDictionary dictionaryWithObjectsAndKeys:
										 [NSNumber numberWithInteger:2],IAControlIdKey
										,[NSNumber numberWithBool:focusStatus],IAControlStatusKey
										,nil];
	NSNotification *focusNotification = [NSNotification notificationWithName:IAControlStatusShouldChangeNotification object:self userInfo:focusDic];
	[notificationCenter performSelector:@selector(postNotification:) withObject:focusNotification afterDelay:0.0];
	
	
	
	//设置警示半径圈
	if (self.circleOverlays) {
		NSArray *array = [self.circleOverlays allValues];
		for (MKCircle *circleOverlay in array) {
			
			//是否是当前选中的
			BOOL isSelecting = NO;
			NSArray *selectedArray = [self.mapView selectedAnnotations];
			if (selectedArray.count >0) {
				YCAnnotation *selected = [self.mapView.selectedAnnotations objectAtIndex:0];
				if ([selected isKindOfClass:[YCAnnotation class]]) {
					MKCircle *selectedCircle = [self.circleOverlays objectForKey:selected.identifier];
					if (selectedCircle == circleOverlay) 
						isSelecting = YES;
				}
				
			}
			
			//直径是否小于12像素
			BOOL isTooSmall = YES;
			if (isSelecting){ //没选中，没必要下面的计算了
				MKCoordinateRegion overlayRegion = MKCoordinateRegionMakeWithDistance(circleOverlay.coordinate, circleOverlay.radius, circleOverlay.radius);
				CGRect overlayRect = [self.mapView convertRegion:overlayRegion toRectToView:self.mapView];
				double w = overlayRect.size.width;
				isTooSmall = w <12 ? YES : NO;
			}
			
			//显示的条件：选中 而且 不太小
			BOOL visable = (isSelecting && (!isTooSmall));

			if (visable){
				if ([self.mapView viewForOverlay:circleOverlay] == nil) {
					[self.mapView addOverlay:circleOverlay];
				}
			}else 
				[self.mapView removeOverlay:circleOverlay];
		}
	}
	 

}
 
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{

	if (!isAlreadyAlertForInternet && [self.view superview]!=nil) { //没警告过 而且 view在显示
		//检查网络
		[self performSelector:@selector(alertInternet) withObject:nil afterDelay:0.25];
		isAlreadyAlertForInternet = YES;
	}
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)theView calloutAccessoryControlTapped:(UIControl *)control{
	
	if (![theView isKindOfClass:[YCPinAnnotationView class]]) {
		return;
	}
	
	if (theView.rightCalloutAccessoryView != control) { //只处理右按钮
		return;
	}
	
	NSString *alarmId = [(YCAnnotation*)theView.annotation identifier]; 
	IAAlarm *theAlarm =[IAAlarm findForAlarmId:alarmId];
	if (![(YCPinAnnotationView*)theView calloutViewEditing]) {
		// ">"按钮被按下，打开编辑alarm
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		NSNotification *aNotification = [NSNotification notificationWithName:IAEditIAlarmButtonPressedNotification 
																	  object:self
																	userInfo:[NSDictionary dictionaryWithObject:theAlarm forKey:IAEditIAlarmButtonPressedNotifyAlarmObjectKey]];
		[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
		
	}else {
		// "删除"按钮被按下
		//[theAlarm deleteFromSender:self];
		
		//不好用，没找到原因呢
	}

} 


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{
    
	YCAnnotation *annotation = (YCAnnotation*)annotationView.annotation;
	MKCircle *circleOverlay = [self.circleOverlays objectForKey:annotation.identifier];
	
	IAAlarm *alarm = [IAAlarm findForAlarmId:annotation.identifier];
	
	switch (newState) 
	{
			
		case MKAnnotationViewDragStateStarting:
			//取消变灰的预约执行
			//[NSObject cancelPreviousPerformRequestsWithTarget:annotationView selector:@selector(updatePinColor) object:nil];
			//隐藏警示圈
			[self.mapView removeOverlay:circleOverlay];
			break;
		case MKAnnotationViewDragStateDragging:
			//隐藏警示圈
			[self.mapView removeOverlay:circleOverlay];
			break;
		case MKAnnotationViewDragStateEnding:   //结束拖拽－大头针落下
			
			//////////////////////////////////////////
			//反转
			if ([annotation isKindOfClass:[YCAnnotation class]])
			{
				if (!alarm.nameChanged)
					annotation.title = @" . . .             ";
				
				//显示距离当前位置XX公里
				if ([YCSystemStatus deviceStatusSingleInstance].lastLocation) {
					[self setDistanceInAnnotation:annotation withCurrentLocation:[YCSystemStatus deviceStatusSingleInstance].lastLocation];
					//为了有动画效果
					NSString *subtitleTemp = annotation.subtitle;
					annotation.subtitle = nil;
					[annotation performSelector:@selector(setSubtitle:) withObject:subtitleTemp afterDelay:1.0];
				}
				//反转坐标－地址
				[self performSelector:@selector(beginReverseWithAnnotation:) withObject:annotation afterDelay:0.0];
				
			}
			//////////////////////////////////////////
			
			
			
			/////////////////////////////////////////
			//先都删掉，免得出bug
			[self.mapView removeOverlays:[self.circleOverlays allValues]]; 
			//从警示圈列表中删除旧的，加入新的
			[self.circleOverlays removeObjectForKey:annotation.identifier];
			MKCircle *newCircleOverlay = [MKCircle circleWithCenterCoordinate:annotation.coordinate	radius:alarm.radius];
			[self.circleOverlays setObject:newCircleOverlay forKey:annotation.identifier];
			//[self.mapView addOverlay:newCircleOverlay]; 不用加到地图上，选中的委托方法会 加上的
			/////////////////////////////////////////
			
			//对付 应该灰而不灰的情况
			//[(YCPinAnnotationView*)annotationView performSelector:@selector(updatePinColor) withObject:nil afterDelay:0.25];
			//[(YCPinAnnotationView*)annotationView performSelector:@selector(updatePinColor) withObject:nil afterDelay:1.75];
			 
			break;
		case MKAnnotationViewDragStateCanceling: //取消拖拽
			//显示警示半径圈
			if (circleOverlay) {
				
				MKCoordinateRegion overlayRegion = MKCoordinateRegionMakeWithDistance(circleOverlay.coordinate, circleOverlay.radius, circleOverlay.radius);
				CGRect overlayRect = [self.mapView convertRegion:overlayRegion toRectToView:self.mapView];
				double w = overlayRect.size.width;
				if (w <12) 
					[self.mapView addOverlay:circleOverlay];
				
			}
			
			//对付 应该灰而不灰的情况
			//[(YCPinAnnotationView*)annotationView performSelector:@selector(updatePinColor) withObject:nil afterDelay:0.25];
			//[(YCPinAnnotationView*)annotationView performSelector:@selector(updatePinColor) withObject:nil afterDelay:1.75];			
			break;
		default:
			break;
			
	}
	
	
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	//NSLog(@"我的地图 我的地图 我的地图 我的地图 我的地图 didReceiveMemoryWarning didReceiveMemoryWarning ！！！！");

    [super didReceiveMemoryWarning];
    /* 他们需要在 viewDidLoad 加到view上 ，不能在内存警告时候释放
	self.toolbarFloatingView = nil;
	self.mapsTypeButton = nil;
	self.satelliteTypeButton = nil;                   
	self.hybridTypeButton = nil;
	 */
	
	[focusBox release];
	focusBox = nil;
	[foucusOverlay release];
	foucusOverlay = nil;
	
	//[maskActivityIndicator release];
	//maskActivityIndicator = nil;
	
	[animateRemoveFileView release];
	animateRemoveFileView = nil;
	[shineAnnotationTimer release];
	shineAnnotationTimer = nil;
	
	
	[reverseGeocoderForUserLocation release];
	reverseGeocoderForUserLocation = nil;
	
	[reverseGeocodersForPin release];
	reverseGeocodersForPin = nil;
	
	[placemarkForUserLocation release];
	placemarkForUserLocation = nil;
	
	[placemarkForPin release];
	placemarkForPin = nil;
	
	
	
}

- (void)viewDidUnload {
	//NSLog(@"我的地图 我的地图 我的地图 我的地图 我的地图 viewDidUnload viewDidUnload ！！！！");
    [super viewDidUnload];
	[self unRegisterNotifications];
	
    self.locationServicesUsableAlert = nil;
	
	
    self.mapView = nil;            
    self.maskView = nil;
	
	
	self.toolbarFloatingView = nil;
	self.mapsTypeButton = nil;
	self.satelliteTypeButton = nil;                   
	self.hybridTypeButton = nil;
	
	
	[self.mapAnnotationViews removeAllObjects];
	[self.mapAnnotations removeAllObjects];
	[self.circleOverlays removeAllObjects];
	

}


- (void)dealloc {
	//NSLog(@"我的地图 我的地图 我的地图 我的地图 我的地图 dealloc dealloc ！！！！");

	[self unRegisterNotifications];
	
	[locationServicesUsableAlert release];
	[mapAnnotations release];                         
	[mapAnnotationViews release];  
	[circleOverlays release];

	[mapView release];            
	[maskView release];
	[maskActivityIndicator release];
	
	[toolbarFloatingView release];
	[mapsTypeButton release];
	[satelliteTypeButton release];
	[hybridTypeButton release];
                   
	/////////////////////////////////////
	//地址反转
	[reverseGeocoderForUserLocation release];
	[placemarkForUserLocation release];
	[reverseGeocodersForPin release];
	[placemarkForPin release];
	/////////////////////////////////////
	
	[animateRemoveFileView release];    
    [shineAnnotationTimer release];
	
	[focusBox release];
	[foucusOverlay release];
	
	[refreshPinLoopTimer invalidate];
	[refreshPinLoopTimer release];
	refreshPinLoopTimer = nil;

    [lastUpdateDistanceTimestamp release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark find Alarm

//恢复闪动的图标，进入后台时候调用
- (void)resetShinedIcon{
    
    //停止轮询
    [self.shineAnnotationTimer invalidate];
    [shineAnnotationTimer release];
    shineAnnotationTimer = nil;
    
    //有变灰的情况
	/*
    YCSystemStatus *status = [YCSystemStatus deviceStatusSingleInstance];
    NSMutableArray *alarmIds = status.localNotificationIdentifiers;
    
	for (id oneId in alarmIds) {
        [[IAAlarm findForAlarmId:oneId] saveFromSender:nil];
    }
	 
    [alarmIds removeAllObjects];
	 */
	[self refreshPinView];
	 
    
    //恢复到达的区域的左图标
	YCAnnotation *annotationSelected = nil;
    if (self.mapView.selectedAnnotations.count > 0) {
        annotationSelected = [self.mapView.selectedAnnotations objectAtIndex:0];
    }
    if ([annotationSelected isKindOfClass:[YCAnnotation class]] ) {
        MKPinAnnotationView *viewSelected = (MKPinAnnotationView*)[self.mapView viewForAnnotation:annotationSelected];
        viewSelected.leftCalloutAccessoryView.hidden = NO;
        [self performSelector:@selector(setVisibleForView:) withObject:viewSelected.leftCalloutAccessoryView afterDelay:0.5];
    }
	 
    
    //恢复当前位置蓝点
    MKUserLocation *currentLocation = self.mapView.userLocation;
    if (currentLocation) {
        MKAnnotationView *viewCurrentLocation = [self.mapView viewForAnnotation:currentLocation];
        viewCurrentLocation.hidden = NO;
    }
    

	//刷新pinview
	//[self refreshPinView];
	
    
}


- (void)setColorRedForPinView:(MKPinAnnotationView*)pinView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setColorRedForPinView:) object:pinView];
    
    if ([pinView isKindOfClass:[MKPinAnnotationView class]]) {
        pinView.pinColor = MKPinAnnotationColorRed;
    }
}

- (void)animateSetColorGreenForPinView:(MKPinAnnotationView*)pinView{
    
    CATransition *animation = [CATransition animation];   
    [animation setDuration:0.5];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
    [animation setType:kCATransitionFade];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:YES];
    
    pinView.pinColor = MKPinAnnotationColorGreen;
    [[pinView layer] addAnimation:animation forKey:@"SetColorGreen"];
}

- (void)animateSetColorRedForPinView:(MKPinAnnotationView*)pinView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateSetColorRedForPinView:) object:pinView];
    
    CATransition *animation = [CATransition animation];   
    [animation setDuration:1.1];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
    [animation setType:kCATransitionFade];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:YES];
    
    pinView.pinColor = MKPinAnnotationColorRed;
    [[pinView layer] addAnimation:animation forKey:@"SetColorRed"];
}
 

- (void)setVisibleForView:(UIView*)theView{
    theView.hidden = NO;
}

- (void)timerFireMethod:(NSTimer*)theTimer{
    
    static NSInteger i = 2;
    i++;

    //闪到达的区域的pin
	YCAnnotation *annotationSelected = nil;
    if (self.mapView.selectedAnnotations.count > 0) 
        annotationSelected = [self.mapView.selectedAnnotations objectAtIndex:0];
    
	MKPinAnnotationView *viewSelected = nil;
    if ([annotationSelected isKindOfClass:[YCAnnotation class]] && annotationSelected == self->shineAnnotation) {
		viewSelected = (MKPinAnnotationView*)[self.mapView viewForAnnotation:annotationSelected];
        
        if (i>=2) { //2秒一个变化颜色的周期
            i = 0;
            [self animateSetColorGreenForPinView:viewSelected]; //变化pin的颜色
            [self performSelector:@selector(animateSetColorRedForPinView:) withObject:viewSelected afterDelay:0.8];
        }

    }else{
        [self resetShinedIcon];//没有选中的，取消闪烁
        i = 2;
        return;
    }
	
	//闪左图标
	viewSelected.leftCalloutAccessoryView.hidden = YES;  
	[self performSelector:@selector(setVisibleForView:) withObject:viewSelected.leftCalloutAccessoryView afterDelay:0.6];
    
    //闪当前位置蓝点
    MKUserLocation *currentLocation = self.mapView.userLocation;
    if (currentLocation) {
        MKAnnotationView *viewCurrentLocation = [self.mapView viewForAnnotation:currentLocation];
        viewCurrentLocation.hidden = YES;
        [self performSelector:@selector(setVisibleForView:) withObject:viewCurrentLocation afterDelay:0.6];
    }

}

- (id)shineAnnotationTimer{
   
    [shineAnnotationTimer invalidate];
    [shineAnnotationTimer release];
    shineAnnotationTimer = nil;
    
    //if (shineAnnotationTimer == nil) 
    {
        shineAnnotationTimer = [[NSTimer timerWithTimeInterval:1.2 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES] retain];
        [[NSRunLoop currentRunLoop] addTimer:shineAnnotationTimer forMode:NSDefaultRunLoopMode];
    }
    
    return shineAnnotationTimer;
}


//找到alarm的pin，使之居中
-(void)findAlarm:(IAAlarm*)alarm{
	NSString *alarmId = alarm.alarmId;
	if (!alarmId) return;
	
	YCPinAnnotationView *annotationView = [self.mapAnnotationViews objectForKey:alarmId];
	YCAnnotation *annotation = (YCAnnotation*)annotationView.annotation;
	self->shineAnnotation = annotation;
	if (!annotation) return;
	
	//先反选
	[self.mapView deselectAnnotation:annotation animated:NO];

    
	//变到合适查看的region
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate,alarm.radius*2*1.2,alarm.radius*2*1.2);
    [self.mapView setRegion:region animated:YES];

	
	//选中
	[self.mapView selectAnnotation:annotation animated:NO];
    
    //闪烁
    [self.shineAnnotationTimer fire];
	
}

@end
