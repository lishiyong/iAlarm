    //
//  AlarmsMapListViewController.m
//  iAlarm
//
//  Created by li shiyong on 11-2-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import <AddressBook/AddressBook.h>
//#import <AddressBookUI/AddressBookUI.h>
#import "IAContactManager.h"
#import "YCLib.h"
#import "IAPerson.h"
#import "IAAddressInfoViewController.h"
#import "UIAlertView+YC.h"
#import "UIColor+YC.h"
#import "YCFunctions.h"
#import "YCLocationManager.h"
#import "UIApplication+YC.h"
#import "iAlarmAppDelegate.h"
#import "YCMapPointAnnotation+AlarmUI.h"
#import "YCOverlayImageView.h"
#import "YCOverlayImage.h"
#import "NSObject+YC.h"
#import "UIViewController+YC.h"
#import "IANotifications.h"
#import "IABuyManager.h"
#import "YCAnimateRemoveFileView.h"
#import "YCCalloutBarButton.h"
#import "YCCalloutBar.h"
#import "IAPinAnnotationView.h"
#import "IASaveInfo.h"
#import "YCRemoveMinusButton.h"
#import "AlarmListNotifications.h"
#import "YCMaps.h"
#import "YCParam.h"
#import "IAAlarmRadiusType.h"
#import "IAAnnotation.h"
#import "MKMapView+YC.h"
#import "YCLocation.h"
#import "YCSystemStatus.h"
#import "UIUtility.h"
#import "YCTapHideBarView.h"
#import "IAAlarm.h"
#import "YCPageCurlButtonItem.h"
#import "LocalizedString.h"
#import "AlarmDetailTableViewController.h"
#import "AlarmsMapListViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AlarmsMapListViewController (private) 

- (void)setPinsEditing:(BOOL)theEditing;
-(void)reverseGeocodeWithAnnotation:(IAAnnotation*)annotation;
@property (nonatomic,retain,readonly) NSArray *alarms;

@end

@implementation AlarmsMapListViewController

#pragma mark - property

@synthesize mapView, maskView, maskLabel, maskActivityIndicator;
@synthesize mapPointAnnotations;
@synthesize toolbarFloatingView, mapsTypeButton, satelliteTypeButton, hybridTypeButton;
@synthesize contactManager;

- (id)alarms{
	return [IAAlarm alarmArray];
}

#pragma mark - Utility

-(void)alertInternetAfterDelay:(NSTimeInterval)delay{
	//检查网络
	BOOL connectedToInternet = [[YCSystemStatus deviceStatusSingleInstance] connectedToInternet];
	if (!connectedToInternet) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            // iOS 5 code
            if (!checkNetAlert) 
                checkNetAlert = [[UIAlertView alloc] initWithTitle:kAlertNeedInternetTitleAccessMaps
                                                           message:kAlertNeedInternetBodyAccessMaps 
                                                          delegate:self
                                                 cancelButtonTitle:kAlertBtnSettings
                                                 otherButtonTitles:kAlertBtnCancel,nil];
            
            
            
            
        } else {
            // iOS 4.x code
            if (!checkNetAlert) 
                checkNetAlert = [[UIAlertView alloc] initWithTitle:kAlertNeedInternetTitleAccessMaps
                                                           message:kAlertNeedInternetBodyAccessMaps 
                                                          delegate:nil
                                                 cancelButtonTitle:kAlertBtnCancel
                                                 otherButtonTitles:nil];
        }
        
        [checkNetAlert showWaitUntilBecomeKeyWindow:self.view.window afterDelay:delay];
        
	}
}

-(MKCoordinateRegion)allPinsRegion{
	
	MKCoordinateRegion r = MKCoordinateRegionMakeWithDistance(kCLLocationCoordinate2DInvalid, 0, 0); //初始化，无效值
	
	if (self.mapView.mapPointAnnotations.count == 1) {
		IAAlarm *anAlarm = (IAAlarm*)[self.alarms objectAtIndex:0];
		CLLocationDistance distanceForRegion = anAlarm.radius*2*1.8;//直径的1.x倍
		r = MKCoordinateRegionMakeWithDistance(anAlarm.visualCoordinate,distanceForRegion,distanceForRegion);
	}else if (self.mapView.mapPointAnnotations.count > 1){
		CLLocationDegrees minLati = 180.0;
		CLLocationDegrees maxLati = -180.0;
		CLLocationDegrees minLong = 180.0;
		CLLocationDegrees maxLong = -180.0;
		
		for (IAAlarm* oneObj in self.alarms) {
			minLati = (oneObj.visualCoordinate.latitude  < minLati) ? oneObj.visualCoordinate.latitude  : minLati;
			maxLati = (oneObj.visualCoordinate.latitude  > maxLati) ? oneObj.visualCoordinate.latitude  : maxLati;
			minLong = (oneObj.visualCoordinate.longitude < minLong) ? oneObj.visualCoordinate.longitude : minLong;
			maxLong = (oneObj.visualCoordinate.longitude > maxLong) ? oneObj.visualCoordinate.longitude : maxLong;
		}
		
		CLLocationCoordinate2D center =  CLLocationCoordinate2DMake((maxLati + minLati)/2, (maxLong + minLong)/2);
		MKCoordinateSpan span = MKCoordinateSpanMake((maxLati - minLati)*2.5, (maxLong - minLong)*2.5); //1.x倍span免得不能完全显示，
		r = MKCoordinateRegionMake(center,span);
	}
    
	r = [self.mapView regionThatFits:r]; //修正一下
	return r;
	
}

//做annotation及其相应的view、circleOverlay，并把他们加入的列表中
- (IAAnnotation*)insertAnnotationWithAlarm:(IAAlarm*)alarm atIndex:(NSInteger)index{

	IAAnnotation *annotation = [[[IAAnnotation alloc] initWithAlarm:alarm] autorelease];
	
	if (index < 0 || index > self.mapPointAnnotations.count-1)
		[self.mapPointAnnotations addObject:annotation];
	else 
		[self.mapPointAnnotations insertObject:annotation atIndex:index];
	
	static NSString* YCpinViewAnnotationIdentifier = @"YCpinViewAnnotationIdentifier";
	IAPinAnnotationView* pinView = [[[IAPinAnnotationView alloc]
								  initWithAnnotation:annotation reuseIdentifier:YCpinViewAnnotationIdentifier] autorelease];
	pinView.delegate = self;
	
	//长按pin
    UILongPressGestureRecognizer *pinLongPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pinLongPressed:)] autorelease];
    pinLongPressGesture.minimumPressDuration = 0.5; //多长时间算长按
	pinLongPressGesture.allowableMovement = 30.0;
	pinLongPressGesture.delegate = self;
	[pinView addGestureRecognizer:pinLongPressGesture];
	
	
	[self.mapPointAnnotationViews setObject:pinView forKey:alarm.alarmId];  //加入到列表
	
	//警示圈
    CLLocationCoordinate2D visualCoordinate = alarm.visualCoordinate;
	MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:visualCoordinate radius:alarm.radius];
	[self.circleOverlays setObject:circleOverlay forKey:alarm.alarmId];  //加入到列表
	
	return annotation;
}

-(void)updateMapAnnotations
{
    
	[self.mapPointAnnotations removeAllObjects];
	[self.mapPointAnnotationViews removeAllObjects];
	[self.circleOverlays removeAllObjects];
	for (IAAlarm *temp in self.alarms)
	{
		[self insertAnnotationWithAlarm:temp atIndex:-1];
	}
	
}

////是否有大头针在屏幕可视范围中
-(BOOL)isHavePinVisible{
    /*
	BOOL b = NO;
	for (IAAlarm* oneObj in self.alarms) {
		CLLocationCoordinate2D coordinate =  oneObj.realCoordinate;
		MKMapPoint point = MKMapPointForCoordinate(coordinate);
		b = MKMapRectContainsPoint(self.mapView.visibleMapRect,point);
		
		if (b) break;
	}
	
	return b;
     */
    
    BOOL b = NO;
	for (YCMapPointAnnotation* oneObj in [self.mapView mapPointAnnotations]) {
		MKMapPoint point = MKMapPointForCoordinate(oneObj.coordinate);
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
		//CGPoint p = CGPointMake(210.0, 382.0);
        CGPoint p = CGPointMake(210.0, 446.0); //顶层window的坐标
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
- (id)maskActivityIndicator{  //做这个get属性的目的是：在进入前台时候不start动画
	if (maskActivityIndicator == nil) {
		maskActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		maskActivityIndicator.frame = CGRectMake(100.0, 180.0, maskActivityIndicator.frame.size.width, maskActivityIndicator.frame.size.height);
		maskActivityIndicator.hidesWhenStopped = YES;
	}
	[maskActivityIndicator startAnimating];
	return maskActivityIndicator;
}
 */

- (id)animateRemoveFileView{
	if (animateRemoveFileView == nil) {
		animateRemoveFileView = [[YCAnimateRemoveFileView alloc] initWithOrigin:CGPointMake(0.0, 0.0)];
	}
	return animateRemoveFileView;
}

-(id) mapPointAnnotationViews{
	if (mapPointAnnotationViews == nil)
    {
        mapPointAnnotationViews = [[NSMutableDictionary dictionary] retain];
    }
    return mapPointAnnotationViews;
}

-(id) mapPointAnnotations{
	if (mapPointAnnotations == nil)
    {
        mapPointAnnotations = [[NSMutableArray array] retain];
    }
    return mapPointAnnotations;
}

-(id) circleOverlays{
	if (circleOverlays == nil)
    {
        circleOverlays = [[NSMutableDictionary dictionary] retain];
    }
    return circleOverlays;
}

- (void)setPinsEditing:(BOOL)theEditing{
	
	
	NSInteger count = self.mapPointAnnotations.count;
	if (count == 0 ) {
		pinsEditing = NO;
		return ;
	}
	
	pinsEditing = theEditing;
	
	for (IAAnnotation *aAnnotation in self.mapPointAnnotations) {
		IAAlarm *alarm = [IAAlarm findForAlarmId:aAnnotation.identifier];
		IAPinAnnotationView * aAnnotationView = [self.mapPointAnnotationViews objectForKey:aAnnotation.identifier];
		
		if (aAnnotationView ==nil ) continue;
        
        if ([self.mapView isVisibleForAnnotation:aAnnotation] 
            && [self.mapView isSelectedForAnnotation:aAnnotation]
            && [self isViewAppeared]) 
            [aAnnotationView setEditing:theEditing animated:YES];//可视 && 选中 && 本视图在显示 动画切换
        else
            aAnnotationView.editing = theEditing;
		
		//拖动
		aAnnotationView.pinColor = theEditing ? MKPinAnnotationColorPurple : MKPinAnnotationColorRed;
		aAnnotationView.draggable = theEditing;
		
		//更改标题
		NSString *newTitle = theEditing ? KLabelMapNewAnnotationTitle : (alarm.alarmName ? alarm.alarmName : alarm.positionTitle);
		aAnnotation.title = newTitle;
	}

}

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

//没有选中的，选中最近的.使被选中的在可视范围内
-(void)selectAndVisibleTheNearestAnnotationFromCoordinate:(CLLocationCoordinate2D)fromCoordinate animated:(BOOL)animated{
    //找到最近的一个
    id<MKAnnotation> selecting = [self.mapView theNearestAnnotationFromCoordinate:fromCoordinate];
    if (!selecting) 
        return;
    
    //找到目前选中的
    id<MKAnnotation> selected = (self.mapView.selectedAnnotations.count > 0) 
                                    ? [self.mapView.selectedAnnotations objectAtIndex:0]
                                    : nil;
    
    if (![selected isKindOfClass: [IAAnnotation class]]) {//选中的不是pin，反选
        if (selected)
            [self.mapView deselectAnnotation:selected animated:animated];
    }else{//选中的是pin
        selecting = selected;
    }
    
    
    //使被选中的在可视范围内
    BOOL isVisible = [self.mapView isVisibleForAnnotation:selecting]; //是否在可视范围
    if (!isVisible) 
        [self.mapView setCenterCoordinate:selecting.coordinate animated:animated];
    
    //选中
    if (![self.mapView isSelectedForAnnotation:selecting])
        [self.mapView selectAnnotation:selecting animated:animated];
    
}

//tableView的编辑状态
- (void) handle_alarmListEditStateDidChange:(NSNotification*) notification {	
	
	//还没加载
	if (![self isViewLoaded]) return;
	
	NSNumber *isEditingObj = [[notification userInfo] objectForKey:IAEditStatusKey];
    [self setUIEditing:[isEditingObj boolValue]];
	 
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
	IAPinAnnotationView *annotationView = [[[self.mapPointAnnotationViews objectForKey:alarmId] retain] autorelease];
    IAAnnotation *annotation = [[(IAAnnotation*)annotationView.annotation retain] autorelease];
    MKCircle *circleOverlay = [[[self.circleOverlays objectForKey:alarmId] retain] autorelease];
    CLLocationCoordinate2D coordinate = annotation ? annotation.coordinate : kCLLocationCoordinate2DInvalid;
    
	switch (saveInfo.saveType) {
		case IASaveTypeDelete:
            
			if ([self.mapView.mapPointAnnotations count] == 0) break;//如果地图没有大头针，防系统bug
			
            [self.mapPointAnnotationViews removeObjectForKey:alarmId];
			[self.mapPointAnnotations removeObject:annotation];
            [self.circleOverlays removeObjectForKey:alarmId];
            
			if ([(NSNotification*)notification object] == self) {                
                
				[self animateRemoveAnnotion:annotation];  //在自己的上删除，动画效果。自己只能删除
                [self.mapView removeAnnotation:annotation];
                [self.mapView removeOverlay:circleOverlay];

                //播放删除完动画，再移动地图
                BOOL animated = YES;
                SEL selector = @selector(selectAndVisibleTheNearestAnnotationFromCoordinate:animated:);
                NSMethodSignature *signature = [self methodSignatureForSelector:selector];
                NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
                [invocaton setTarget:self];
                [invocaton setSelector:selector];
                [invocaton setArgument:&coordinate atIndex:2];  //self,_cmd分别占据0、1
                [invocaton setArgument:&animated atIndex:3];
                [invocaton performSelector:@selector(invoke) withObject:nil afterDelay:1.0];
                        
			}else {
                //列表上删除的。先都删除了。
				[self.mapView removeAnnotations:self.mapView.mapPointAnnotations];
                [self.mapView removeOverlay:circleOverlay];
                [self.mapView addAnnotations:self.mapPointAnnotations];
                [self selectAndVisibleTheNearestAnnotationFromCoordinate: annotation.coordinate animated:NO];//选中离被删除最近的
			}
			
			if ([self.mapPointAnnotations count] == 0) {
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
			if ([self.mapView.mapPointAnnotations count] == 0) break;//如果地图没有大头针，防系统bug
			if (!annotation) break;
			NSInteger index = [self.mapPointAnnotations indexOfObject:annotation];
			
			//先都删除了   
            [self.mapView removeAnnotation:annotation];
            [self.mapView removeOverlay:circleOverlay];
            [self.mapPointAnnotationViews removeObjectForKey:alarmId];
			[self.mapPointAnnotations removeObject:annotation];
            [self.circleOverlays removeObjectForKey:alarmId];
  
			//再增加
			annotation = [self insertAnnotationWithAlarm:[IAAlarm findForAlarmId:alarmId] atIndex:index];
			//[self.mapView performSelectorOnMainThread:@selector(addAnnotation:) withObject:annotation waitUntilDone:YES];
            [self.mapView addAnnotation:annotation];
            [self.mapView selectAnnotation:annotation];//刚加上的，竟然无法用动画选中！！
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.2) 
            {//before 4.2， addAnnotation后 等一会才能选中，等多久，不知道！    
                [self startOngoingSendingMessageWithTimeInterval:0.1];
                while (![self.mapView isSelectedForAnnotation:annotation]) {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    [self.mapView selectAnnotation:annotation];
                }
                [self stopOngoingSendingMessage];
            }
			
			if (![self.mapView isVisibleForAnnotation:annotation]) { //如果annotation不在可视范围
				if([self isViewAppeared])
					[self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
				else 
					[self.mapView setCenterCoordinate:annotation.coordinate];
			}
            
			break;
            
		case IASaveTypeAdd:
            
			annotation = [self insertAnnotationWithAlarm:[IAAlarm findForAlarmId:alarmId] atIndex:0];
			if (!annotation) break;
			
			//新增的要弄到可视范围内
            if (![self.mapView isVisibleForAnnotation:annotation]) {
                [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
            }
            
            [self.mapView addAnnotation:annotation];
            [self.mapView selectAnnotation:annotation];//刚加上的，竟然无法用动画选中！！
            
            //if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.2) 
            {//before 4.2， addAnnotation后 等一会才能选中，等多久，不知道！所有的版本都检测一下也没坏处 
                [self startOngoingSendingMessageWithTimeInterval:0.1];
                while (![self.mapView isSelectedForAnnotation:annotation]) {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    [self.mapView selectAnnotation:annotation];
                }
                [self stopOngoingSendingMessage];
            }
            
            
			break;
            
		default:
			break;
	}
	
	 
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
	
	
	//保存最后加载的区域
	if (self.mapView.region.span.latitudeDelta < 20.0) { //很大的地图就不存了
		[YCParam paramSingleInstance].lastLoadMapRegion = self.mapView.region;
		[[YCParam paramSingleInstance] saveParam];
	}
	 
}

- (void) handle_applicationWillEnterForeground: (id) notification{
	isAlreadyAlertForInternet = NO; //在mapview的加载地图数据失败时候中检查网络
}

- (void) handle_standardLocationDidFinish: (NSNotification*) notification{
    //还没加载
	if (![self isViewLoaded]) return;
    
    CLLocation *location = [[notification userInfo] objectForKey:IAStandardLocationKey];
    for (IAAnnotation *oneObj in self.mapPointAnnotations ) {
        [oneObj setDistanceSubtitleWithCurrentLocation:location];
    }
    
}

- (void) handle_applicationWillResignActive:(id)notification{	
	
    //关闭未关闭的对话框
    [checkNetAlert dismissWithClickedButtonIndex:checkNetAlert.cancelButtonIndex animated:NO];
}

- (void) handle_applicationDidBecomeActive:(id)notification{	
    
}

- (void) handle_letAlarmMapsViewHaveAPinVisibleAndSelected:(id)notification{	
	//没有选中的，选中第一个;使被选中的在可视范围内
    [self selectAndVisibleTheNearestAnnotationFromCoordinate:self.mapView.centerCoordinate animated:YES];
}

//为了延时调用
- (void)focusToPoint:(CGPoint)focusWhere{
		
	//动画期间不允许拖动地图，不允许其他事件
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

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
	if (CLLocationCoordinate2DIsValid(alarm.visualCoordinate)) {
		//使用闹钟里的坐标
        focusWhere = [self.mapView convertCoordinate:alarm.visualCoordinate toPointToView:self.mapView];
	}else {
        focusWhere = CGPointMake(viewFrame.size.width/ 2 , viewFrame.size.height/ 2 );
	}
	
	//判断聚焦点是否在可视范围内
	CLLocationCoordinate2D focusCoordinate = [self.mapView convertPoint:focusWhere toCoordinateFromView:self.mapView];
	MKMapPoint focusMapPoint = MKMapPointForCoordinate(focusCoordinate);
	MKMapRect visibleRect = [self.mapView visibleMapRect];
	if (!MKMapRectContainsPoint(visibleRect,focusMapPoint)){
		[self.mapView setCenterCoordinate:focusCoordinate animated:YES];//先把聚焦的点移到中心位置
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
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate,kDefaultLatitudinalMeters,kDefaultLongitudinalMeters);
	[self.mapView setRegion:region FromWorld:NO animatedToWorld:NO animatedToPlace:YES];
	[self.mapView performSelector:@selector(animateSelectAnnotation:) withObject:self.mapView.userLocation afterDelay:0.5]; //适当延长时间		
}

- (void)handle_focusButtonPressed:(NSNotification*)notification{
		
	//选中第一个
	if (self.mapPointAnnotations.count >0) {
		if (self.mapView.selectedAnnotations.count ==1) { 
			id selectedAnnotation = [self.mapView.selectedAnnotations objectAtIndex:0];
			if ([selectedAnnotation isKindOfClass:[MKUserLocation class]]) { 
				//目前选中是当前位置
				[self.mapView animateSelectAnnotation:[self.mapPointAnnotations objectAtIndex:0]];
			}
			
		}else if (self.mapView.selectedAnnotations.count <=0){
			//没有选中的
			[self.mapView animateSelectAnnotation:[self.mapPointAnnotations objectAtIndex:0]];
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
    
    if (!self.toolbarFloatingView.superview) 
        [[self.view.window.subviews objectAtIndex:0] addSubview:self.toolbarFloatingView];  //避免被toobar挡住， 加入到顶层的window
    [[self.view.window.subviews objectAtIndex:0] bringSubviewToFront:self.toolbarFloatingView];//为第一个view 

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

}

#pragma mark -
#pragma mark CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
	[self.focusBox removeFromSuperlayer];
	if (foucusOverlay)
		[self.mapView performSelector:@selector(removeOverlay:) withObject:foucusOverlay afterDelay:1.25];

	//详细页面出现后，再允许拖动地图、允许其他事件
    [[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:1.25];

}

#pragma mark - View lifecycle

//取得用户当前位置的超时时间
#define kTimeOutWaitingForUserLocation     20.0

- (void)viewDidLoad {
    [super viewDidLoad];	
	self.title = KViewTitleAlarmsListMaps;
	self.mapView.delegate = self;
	
	//mask view
    self.mapView.backgroundColor = [UIColor mapsMaskColor];
	self.maskLabel.text = KTextPromptWhenLoading;
    self.mapView.alpha = 1.0;
    //通知，打开了maskview
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmMapsMaskingDidChangeNotification 
                                                                  object:self
                                                                userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:IAAlarmMapsMaskingKey]];
    [notificationCenter postNotification:aNotification];
	
	
    //找到UIMapView自带的双点识别器
    UITapGestureRecognizer *doubleTapGesture = nil;
    for (UITapGestureRecognizer *anObj in self.mapView.gestureRecognizers) {
        if ([anObj isKindOfClass:[UITapGestureRecognizer class]] && anObj.numberOfTapsRequired == 2) {
            doubleTapGesture = anObj;
            break;
        }
    }
	//单点地图
    tapMapViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTap:)];
	tapMapViewGesture.delegate = self;
    tapMapViewGesture.numberOfTapsRequired = 1;//单点
    if (doubleTapGesture)
        [tapMapViewGesture requireGestureRecognizerToFail:doubleTapGesture];//双点处理失败才到单点
	[self.mapView addGestureRecognizer:tapMapViewGesture];
    tapCalloutViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTap:)];
	tapCalloutViewGesture.delegate = self;
	[self.mapView addGestureRecognizer:tapCalloutViewGesture];
	
	//长按地图
    longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewLongPressed:)];
    longPressGesture.minimumPressDuration = 1.0; //多长时间算长按
	longPressGesture.allowableMovement = 30.0;
	[self.mapView addGestureRecognizer:longPressGesture];
	 
	
	//检查网络
	isAlreadyAlertForInternet = NO;
	NSInteger alarmsCount = self.alarms.count;
    NSInteger launchNumber = [[UIApplication sharedApplication] applicationDidFinishLaunchNumber];
	if (0 == alarmsCount && 0 == launchNumber) { //闹钟数不等于0，就会直接加载地图了，在地图数据加载失败事件中会提示网络的。
        isAlreadyAlertForInternet = YES;
        [self performBlock:^{[self alertInternetAfterDelay:4.0];} afterDelay:1.0];
	}
		
	//浮动工具栏
	self.toolbarFloatingView.hidden = YES;
	self.mapsTypeButton = [[self.toolbarFloatingView buttons] objectAtIndex:0];
	self.satelliteTypeButton  = [[self.toolbarFloatingView  buttons] objectAtIndex:1];
	self.hybridTypeButton = [[self.toolbarFloatingView  buttons] objectAtIndex:2];

    [self registerNotifications];//下面的maskview已经要用了
    
    
    [UIView animateWithDuration:0.0 animations:^{;} completion:^(BOOL finished){
        
        //放大头针，选中
        [self updateMapAnnotations];
        if (self.mapPointAnnotations.count >0) 
            [self.mapView addAnnotations:self.mapPointAnnotations];
        
        //地图的region
        //1.显示所有pin的region
        //2.显示最后显示的
        //3.显示当前位置
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(kCLLocationCoordinate2DInvalid,0,0);
        if (alarmsCount > 0) {   //1.
            
            region = [self allPinsRegion];
            
        }else if(YCMKCoordinateRegionIsValid([YCParam paramSingleInstance].lastLoadMapRegion)){       //2.
            
            region = [YCParam paramSingleInstance].lastLoadMapRegion;
            
        }else {//3.
            
            [UIView animateWithDuration:0.25 animations:^{
                self.maskLabel.alpha = 1.0;
                self.maskActivityIndicator.hidden = 1.0;
                [self.maskActivityIndicator startAnimating];
            } completion:NULL];
            
            //app.isIdleTimerDisabled 作为标识变量
            UIApplication *app = [UIApplication sharedApplication];
            BOOL newStatus = !app.isIdleTimerDisabled;
            app.idleTimerDisabled = newStatus;
            [app performSelector:@selector(setIdleTimerDisabled:) onThread:[NSThread currentThread] withInteger:!newStatus waitUntilDone:NO afterDelay:kTimeOutWaitingForUserLocation];
            
            while (!self.mapView.userLocation.location && app.isIdleTimerDisabled == newStatus) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
            if (self.mapView.userLocation.location) 
                region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate,kDefaultLatitudinalMeters,kDefaultLongitudinalMeters);
        }
        
        
        if (CLLocationCoordinate2DIsValid(region.center)) 
            [self.mapView setRegion:region];
        
        
        //选中
        if (self.mapView.mapPointAnnotations.count >0) 
        {
            id selecting = [self.mapView.mapPointAnnotations objectAtIndex:0];
            [self.mapView selectAnnotation:selecting];
            
            //if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.2) //所有版本都检测一下，也没坏处
            {//before 4.2， addAnnotation后 等一会才能选中，等多久，不知道！
                [self startOngoingSendingMessageWithTimeInterval:0.1];
                while (![self.mapView isSelectedForAnnotation:selecting]) 
                {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    [self.mapView selectAnnotation:selecting];
                }
                [self stopOngoingSendingMessage];
            }
            
        }
        
        //关闭mask
        //先通知，让toolbar等显示
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmMapsMaskingDidChangeNotification 
																	  object:self
																	userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:IAAlarmMapsMaskingKey]];
		[notificationCenter postNotification:aNotification];
        [UIView animateWithDuration:0.75 animations:^{self.maskView.alpha = 0.0;}];
        
        
        
    }];//[UIView animateWithDuration: animations: completion:]

}

-(void)viewWillAppear:(BOOL)animated
{	
	[super viewWillAppear:animated];	
	    
    if (pinsEditing != [YCSystemStatus deviceStatusSingleInstance].isAlarmListEditing) {
		//刷新编辑状态
		[self setUIEditing:[YCSystemStatus deviceStatusSingleInstance].isAlarmListEditing];
	}
	
    //刷新距离
    CLLocation *location = [YCSystemStatus deviceStatusSingleInstance].lastLocation;
    if ([UIApplication sharedApplication].applicationDidFinishLaunchineTimeElapsing  < 5.0) {//小于x秒，刚启动，第一次显示view
        //第一次刷新距离，判断一下数据的时间戳，防止是很久前缓存的。
        NSTimeInterval ti = [location.timestamp timeIntervalSinceNow];
        if (ti < -120) location = nil; //120秒内的数据可用。最后位置过久，不用.
    }
    
    for (IAAnnotation *oneObj in self.mapPointAnnotations ) {
        [oneObj setDistanceSubtitleWithCurrentLocation:location];
    }
	
}

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

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
	if (tapCalloutViewGesture == sender) { //点pin的Callout不处理
        return; 
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        BOOL selectedPinIsVisible = NO; //选中的pin在屏幕中
        if (self.mapView.selectedAnnotations.count > 0){
            
            id selected = [self.mapView.selectedAnnotations objectAtIndex:0];
            if ([self.mapView isVisibleForAnnotation:selected]) 
                selectedPinIsVisible = YES;
            else
                selectedPinIsVisible = NO;
            
        }else{
            selectedPinIsVisible = NO;
        }

        
		//不显示工具条
		if (!self.toolbarFloatingView.hidden){
            
			[self mapTypeButtonPressed:nil];
            
        }else if(pinsEditing && selectedPinIsVisible){//pin在编辑状态，
            
            //[self setUIEditing:NO]; //收到通知，会做响应的设置
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmListEditStateDidChangeNotification 
                                                                          object:self
                                                                        userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:IAEditStatusKey]];
            [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
            
        }else {//隐藏bar
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            NSNotification *aNotification = [NSNotification notificationWithName:IADoHideBarNotification 
                                                                          object:self
                                                                        userInfo:nil];
            [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
            
        }
        
	}
    
}

-(void)pinTap:(UITapGestureRecognizer *)sender{	
	
}

- (void)pinLongPressed:(UILongPressGestureRecognizer *)sender{
	
	IAPinAnnotationView *annotationView = (IAPinAnnotationView*)sender.view;
	if(![annotationView isKindOfClass:[IAPinAnnotationView class]]) return; //按的不是pin
	
	
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
            alarm.visualCoordinate = coordinatePressed;
			
			NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
			NSNotification *aNotification = [NSNotification notificationWithName:IAAddIAlarmButtonPressedNotification 
																		  object:self
																		userInfo:[NSDictionary dictionaryWithObject:alarm forKey:IAAlarmAddedKey]];
			[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
		}
	}
	
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == checkNetAlert && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kAlertBtnSettings]) {
        NSString *str = @"prefs:root=General&path=Network"; //打开设置中的网络
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - IAAnnotationViewDelegete

//按下了删除按钮
- (void)annotationView:(IAPinAnnotationView *)annotationView didPressDeleteButton:(UIButton*)button{	
	//删除Alarm
	IAAlarm *alarmSelected =[(IAAnnotation*)annotationView.annotation alarm];
	[alarmSelected deleteFromSender:self];
}

- (void)annotationView:(IAPinAnnotationView *)annotationView didPressDetailButton:(UIButton*)button{
    // ">"按钮被按下，打开编辑alarm
	IAAlarm *theAlarm =[(IAAnnotation*)annotationView.annotation alarm];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IAEditIAlarmButtonPressedNotification 
                                                                  object:self
                                                                userInfo:[NSDictionary dictionaryWithObject:theAlarm forKey:IAEditIAlarmButtonPressedNotifyAlarmObjectKey]];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
}

- (void)annotationView:(IAPinAnnotationView *)annotationView didPressFlagButton:(UIButton*)button{
    
    IAAlarm *theAlarm = [(IAAnnotation*)annotationView.annotation alarm];
    IAPerson *newPerson = [[[IAPerson alloc] initWithAlarm:theAlarm image:nil] autorelease];
    self.contactManager.currentViewController = self.view.window.rootViewController;
    [self.contactManager presentContactViewControllerWithAlarm:theAlarm newPerson:newPerson];

}

#pragma mark -
#pragma mark Utility - UIGestureRecognizerDelegate


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{

    IAPinAnnotationView *pinViewLongPressed = nil;      
    UIView *gesView      =  gestureRecognizer.view;
    UIView *otherGesView =  otherGestureRecognizer.view;
    if ([gesView isKindOfClass:[IAPinAnnotationView class]]) {
        pinViewLongPressed = (IAPinAnnotationView*)gesView;
    }else if([otherGesView isKindOfClass:[IAPinAnnotationView class]]){
        pinViewLongPressed = (IAPinAnnotationView*)otherGesView;
    }
    
    BOOL isLongPressPin = pinViewLongPressed ? YES : NO;
    BOOL isPingEditing = pinViewLongPressed.isEditing;
    if (isLongPressPin && !isPingEditing) {//长按的是pin，而且pin不是编辑状态
        if (gestureRecognizer != tapMapViewGesture && otherGestureRecognizer != tapMapViewGesture) 
        {
            return YES;
        }
    }
    
    	
	return NO;
}


/*
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
}
 */

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
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
    
    
    BOOL isNavigationBarHidden = [(UINavigationController*)[(iAlarmAppDelegate*)[UIApplication sharedApplication].delegate viewController] isNavigationBarHidden];
    //注意: 依赖iAlarmAppDelegate 的viewController的类型
    
    BOOL selectedPinIsVisible = NO; //选中的pin在屏幕中
    if (self.mapView.selectedAnnotations.count > 0){
        
        id selected = [self.mapView.selectedAnnotations objectAtIndex:0];
        if ([self.mapView isVisibleForAnnotation:selected]) 
            selectedPinIsVisible = YES;
        else
            selectedPinIsVisible = NO;
        
    }else{
        selectedPinIsVisible = NO;
    }
    
    //UIView *tappedView = gestureRecognizer.view; //被点的view
    
    if (gestureRecognizer == tapCalloutViewGesture) {
        
        //CalloutView点的范围内
        if (touchInCalloutView)
            return YES;
            
        return NO; //除了测试UICalloutView，tapCalloutViewGesture这个就没用了
        
    }else if(gestureRecognizer == tapMapViewGesture){ //自定义的tapGesture
        
        //CalloutView点的范围内
        if (touchInCalloutView)
            return NO;
        
        //有浮动菜单
        if (!self.toolbarFloatingView.hidden)
            return YES;
        
        //点了一个pin或当前位置蓝点
        //if ([tappedView isKindOfClass:[YCPinAnnotationView class]] || [tappedView isKindOfClass:[MKUserLocation class]]) 
        //    return NO;
        
        //bar未隐藏 
        if (!isNavigationBarHidden  ) {
            if (selectedPinIsVisible) //屏幕有选中的pin
                return NO;
            return YES;
        }
            
        //bar隐藏,什么情况交给自定义的处理
        if (isNavigationBarHidden) 
            return YES;
        
        return NO;
        
    }else if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){//UIMapView固有的
        
        //CalloutView点的范围内
        if (touchInCalloutView)
            return NO;
        
        //有浮动菜单
        if (!self.toolbarFloatingView.hidden)
            return NO;
        
        //点了一个pin或当前位置蓝点
        //if ([tappedView isKindOfClass:[YCPinAnnotationView class]] || [tappedView isKindOfClass:[MKUserLocation class]]) 
        //    return YES;
        
        //bar未隐藏 
        if (!isNavigationBarHidden  ) {
            if (selectedPinIsVisible) //屏幕有选中的pin
                return YES;
            return NO;
        }
        
        //bar隐藏,什么情况交给自定义的处理
        if (isNavigationBarHidden) 
            return NO;
            
        return NO;
             
    }else{
        
        //CalloutView点的范围内
        if (touchInCalloutView)
            return NO;
        
        return YES;
    }
            
}

#pragma mark - Utility

#define kTimeOutForReverse 15.0
-(void)reverseGeocodeWithAnnotation:(IAAnnotation*)annotation
{	
    YCReverseGeocoder *geocoder = [[[YCReverseGeocoder alloc] initWithTimeout:kTimeOutForReverse] autorelease];
    CLLocationCoordinate2D visualCoordinate = annotation.coordinate;
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:visualCoordinate.latitude longitude:visualCoordinate.longitude] autorelease];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(YCPlacemark *placemark, NSError *error) {        
        NSString *coordinateString = YCLocalizedStringFromCLLocationCoordinate2D(visualCoordinate,kCoordinateFrmStringNorthLatitude,kCoordinateFrmStringSouthLatitude,kCoordinateFrmStringEastLongitude,kCoordinateFrmStringWestLongitude);
        
        IAAlarm *alarm = [IAAlarm findForAlarmId:[(IAAnnotation*)annotation identifier]];
        if (!error && placemark){
            
            //优先使用name，其次titleAddress，最后KDefaultAlarmName
            NSString *titleAddress = placemark.name ? placemark.name :(placemark.titleAddress ? placemark.titleAddress : KDefaultAlarmName);
            NSString *shortAddress = placemark.shortAddress ? placemark.shortAddress : coordinateString;
            NSString *longAddress = placemark.longAddress ? placemark.longAddress : coordinateString;
                       
            if (!alarm.nameChanged) {
                /*不灵
                annotation.title = nil;
                [annotation performSelector:@selector(setTitle:) withObject:titleAddress afterDelay:0.2];//先赋空，再赋值，为了拉伸view
                 */
                annotation.title = titleAddress;
            }
            alarm.position = longAddress;
            alarm.positionShort = shortAddress;
            alarm.positionTitle = titleAddress;  
            alarm.placemark = placemark;
            alarm.usedCoordinateAddress = NO;
            
            //test
            //[placemark debug];
            
        }else{
            
            if (!alarm.nameChanged) {
                /*不灵annotation.title = nil; 
                [annotation performSelector:@selector(setTitle:) withObject:KDefaultAlarmName afterDelay:0.2];//先赋空，再赋值，为了拉伸view
                 */
                annotation.title = KDefaultAlarmName; 
                alarm.alarmName = nil;//把以前版本生成的名称冲掉
            }
            
            alarm.position = coordinateString;
            alarm.positionShort = coordinateString;
            alarm.positionTitle = KDefaultAlarmName;
            alarm.placemark = nil;
            alarm.usedCoordinateAddress = YES; //反转失败，用坐标做地址
            
        }
        
        alarm.visualCoordinate = visualCoordinate;
        alarm.locationAccuracy = kCLLocationAccuracyBest;
        [alarm saveFromSender:self];
                
    }];
    
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[MKUserLocation class]])
	{
		return nil;
	}
    
	MKPinAnnotationView* pinView = nil;
	if ([annotation isKindOfClass:[IAAnnotation class]]) {
		pinView = [self.mapPointAnnotationViews objectForKey:((IAAnnotation*)annotation).identifier];
	}else {
		//临时的pin
		pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil] autorelease];
		pinView.pinColor = MKPinAnnotationColorRed;
		pinView.animatesDrop = YES;
	}
	return pinView;
    
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView
{	
    
	if ([annotationView.annotation isKindOfClass:[MKUserLocation class]])
		return;
	
	//警示圈
	IAAnnotation *annotation = (IAAnnotation*)annotationView.annotation;
	if ([annotation isKindOfClass:[IAAnnotation class]]){
        MKCircle *overlay = [self.circleOverlays objectForKey:annotation.identifier];
        [self.mapView addOverlay:overlay];
	}
     
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)annotationView{
    
    if ([annotationView.annotation isKindOfClass:[MKUserLocation class]])
		return;
    
    //警示圈
	IAAnnotation *annotation = (IAAnnotation*)annotationView.annotation;
	if ([annotation isKindOfClass:[IAAnnotation class]]){
        MKCircle *overlay = [self.circleOverlays objectForKey:annotation.identifier];
        [self.mapView removeOverlay:overlay];
	}    
     
}
 

#define kTimeOutForReverseUserLocation 30.0

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (userLocation.location == nil) //ios5.0 没有取得用户位置的时候也回调这个方法
        return;
    
    YCReverseGeocoder *geocoder = [[[YCReverseGeocoder alloc] initWithTimeout:kTimeOutForReverse] autorelease];
    CLLocationCoordinate2D visualCoordinate = userLocation.location.coordinate;
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:visualCoordinate.latitude longitude:visualCoordinate.longitude] autorelease];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(YCPlacemark *placemark, NSError *error) {
        if (!error){
            
            NSString *subtitle = placemark.shortAddress;
            if (![userLocation.subtitle isEqualToString:subtitle]) 
                userLocation.subtitle = placemark.longAddress;
            
        }else{
            userLocation.subtitle = nil;
        }
        
    }];
    
    //设置“回到当前位置按钮”的可用状态。
	BOOL isEnabled = NO;
    isEnabled =  ![self.mapView isViewCenterForCoordinate:visualCoordinate allowableOffset:3]; 
	
	NSDictionary *currentLocationDic = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithInteger:1],IAControlIdKey
										,[NSNumber numberWithBool:isEnabled],IAControlStatusKey
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
    
	for (MKAnnotationView *annotationView in views) {

		IAAnnotation *annoation = (IAAnnotation*)annotationView.annotation ;

		
		if ([annoation isKindOfClass:[IAAnnotation class]]) {
            
            //显示距离当前位置XX公里
            annoation.subtitle = nil;
            if ([YCSystemStatus deviceStatusSingleInstance].lastLocation) {
                [(IAAnnotation*)annoation setDistanceSubtitleWithCurrentLocation:[YCSystemStatus deviceStatusSingleInstance].lastLocation];
            }
		}

	}
	
}
 


	
- (void)mapView:(MKMapView *)theMapView regionDidChangeAnimated:(BOOL)animated{
	
	//设置“回到当前位置按钮”的可用状态。
	BOOL isEnabled = NO;
	if (self.mapView.userLocation.location)
		isEnabled = ![self.mapView isViewCenterForCoordinate:self.mapView.userLocation.location.coordinate allowableOffset:3];
	
	NSDictionary *currentLocationDic = [NSDictionary dictionaryWithObjectsAndKeys:
										 [NSNumber numberWithInteger:1],IAControlIdKey
										,[NSNumber numberWithBool:isEnabled],IAControlStatusKey
										,nil];
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *currentLocationNotification = [NSNotification notificationWithName:IAControlStatusShouldChangeNotification object:self userInfo:currentLocationDic];
	[notificationCenter performSelector:@selector(postNotification:) withObject:currentLocationNotification afterDelay:0.0];
    
	
	//设置“显示所有按钮”的可用状态。
    BOOL focusStatus = NO;
	if (self.mapView.mapPointAnnotations.count >0) {
		//有地图范围改变了，按钮就可用
		BOOL mapsChanged = !YCMKCoordinateRegionEqualToRegion(self.mapView.region, [self allPinsRegion]);
        
        //有一个pin不可视，按钮就可用
		BOOL isHaveAPinVisible = NO;
		for (IAAnnotation *anAnnotation in self.mapView.mapPointAnnotations) {
			isHaveAPinVisible = [self.mapView isVisibleForAnnotation:anAnnotation];
			if (!isHaveAPinVisible)
				break;
		}
        
		focusStatus = (!isHaveAPinVisible) || mapsChanged;
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
				IAAnnotation *selected = [self.mapView.selectedAnnotations objectAtIndex:0];
				if ([selected isKindOfClass:[IAAnnotation class]]) {
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

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{

	if (!isAlreadyAlertForInternet && [self isViewAppeared]) { //没警告过 而且 view在显示
        isAlreadyAlertForInternet = YES;
        //检查网络
		[self alertInternetAfterDelay:1.0];
	}
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{    
	IAAnnotation *annotation = (IAAnnotation*)annotationView.annotation;
	MKCircle *circleOverlay = [self.circleOverlays objectForKey:annotation.identifier];
	IAAlarm *alarm = [IAAlarm findForAlarmId:annotation.identifier];
     
	switch (newState) 
	{
			
		case MKAnnotationViewDragStateStarting:
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
			if ([annotation isKindOfClass:[IAAnnotation class]])
			{
				if (!alarm.nameChanged)
                    annotation.title = @" . . .                         ";
				
				//显示距离当前位置XX公里
				if ([YCSystemStatus deviceStatusSingleInstance].lastLocation) {
                    [(IAAnnotation*)annotation setDistanceSubtitleWithCurrentLocation:[YCSystemStatus deviceStatusSingleInstance].lastLocation];
				}
                
                //坐标改变了，保存
                alarm.visualCoordinate = annotation.coordinate;
                alarm.personId = kABRecordInvalidID;//地址改变了，断开可能关联的联系人。
                [alarm saveFromSender:self];
                
				//反转坐标－地址
				[self performSelector:@selector(reverseGeocodeWithAnnotation:) withObject:annotation afterDelay:0.0];
				
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
             
			break;
		default:
			break;
			
	}
	
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[self unRegisterNotifications];
    
    self.mapView = nil; 
    self.maskView = nil;
    self.maskLabel = nil;
    self.maskActivityIndicator = nil;

	self.toolbarFloatingView = nil;
	self.mapsTypeButton = nil;
	self.satelliteTypeButton = nil;                   
	self.hybridTypeButton = nil;
    self.contactManager = nil;
	
	[self.mapPointAnnotationViews removeAllObjects];
	[self.mapPointAnnotations removeAllObjects];
	[self.circleOverlays removeAllObjects];
    
    [viewLoadedDate release]; viewLoadedDate = nil;
    [tapMapViewGesture release]; tapMapViewGesture = nil;
    [tapCalloutViewGesture release]; tapCalloutViewGesture = nil;
    [longPressGesture release]; longPressGesture = nil;
}


- (void)dealloc {
	[self unRegisterNotifications];
	
	[mapView release];            
	[maskView release];
    [maskLabel release];
	[maskActivityIndicator release];
    
    [mapPointAnnotations release];                         
	[mapPointAnnotationViews release];  
	[circleOverlays release];

	[toolbarFloatingView release];
	[mapsTypeButton release];
	[satelliteTypeButton release];
	[hybridTypeButton release];
    
    [focusBox release];
	[foucusOverlay release];
	
	[animateRemoveFileView release]; 
    [viewLoadedDate release];
	    
    [tapMapViewGesture release];
    [tapCalloutViewGesture release];
	[longPressGesture release];
    
    [checkNetAlert release];
    
    [contactManager release];
    [super dealloc];
}



@end
