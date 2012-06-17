//
//  AlarmPositionMapViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+YC.h"
#import "NSObject+YC.h"
#import "YCFunctions.h"
#import "YCLocationManager.h"
#import "CLLocation+YC.h"
#import "IAPinAnnotationView.h"
#import "UINavigationItem+YC.h"
#import "UIViewController+YC.h"
#import "IANotifications.h"
#import "YCCalloutBar.h" 
#import "YCCalloutBarButton.h" 
#import "YClocationServicesUsableAlert.h"
#import "NSString+YC.h"
#import "MKMapView+YC.h"
#import "IAAlarmRadiusType.h"
#import "YCBarButtonItem.h"
#import "YCAlertTableView.h"
#import "YCSystemStatus.h"
#import "YCMaps.h"
#import "YCLocation.h"
#import "YCSearchBar.h"
#import "AlarmPositionMapViewController.h"
#import "IAAnnotation.h"
#import "IAAlarm.h"
#import "UIUtility.h"
#import "YCParam.h"


@implementation AlarmPositionMapViewController

@synthesize mapView = _mapView ,delegate = _delegate;

#pragma mark - 
#pragma mark - Utility

const CGFloat detailTitleViewW = 206.0; // 固定宽度
- (UIView*)detailTitleViewWithContent:(NSString*)content{
	
	CGRect titleLabelFrame = CGRectMake(0.0,0.0,detailTitleViewW,44.0);
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:titleLabelFrame] autorelease];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor colorWithRed:18.0/256.0 green:35.0/256.0 blue:70.0/256.0 alpha:1.0];
	titleLabel.text = content;
	titleLabel.font = [UIFont systemFontOfSize:14.0];
	titleLabel.adjustsFontSizeToFitWidth = YES;
	titleLabel.minimumFontSize = 10.0;
	titleLabel.shadowColor = [UIColor lightTextColor];
	titleLabel.shadowOffset = CGSizeMake(0.0, 1.0);
	titleLabel.textAlignment = UITextAlignmentCenter;
    
	return titleLabel;
}

//设置title为显示当前位置的距离
- (void)setDistanceLabel{

	CLLocation *curLocation = [YCSystemStatus deviceStatusSingleInstance].lastLocation;
	if (curLocation) {
        
        CLLocationCoordinate2D realCoordinate = _annotation.realCoordinate;
		NSString *distance = [curLocation distanceStringFromCoordinate:realCoordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextPromptCurrentLocation];
		[self.navigationItem setTitleView:[self detailTitleViewWithContent:distance] animated:YES];
        
	}else
		self.navigationItem.titleView = nil;
    
}

-(void)alertInternetAfterDelay:(NSTimeInterval)delay{
	//检查网络
	BOOL connectedToInternet = [[YCSystemStatus deviceStatusSingleInstance] connectedToInternet];
	if (!connectedToInternet) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            // iOS 5 code
            if (!_checkNetAlert) 
                _checkNetAlert = [[UIAlertView alloc] initWithTitle:kAlertNeedInternetTitleAccessMaps
                                                           message:kAlertNeedInternetBodyAccessMaps 
                                                          delegate:self
                                                 cancelButtonTitle:kAlertBtnSettings
                                                 otherButtonTitles:kAlertBtnCancel,nil];
            
            
            
            
        } else {
            // iOS 4.x code
            if (!_checkNetAlert) 
                _checkNetAlert = [[UIAlertView alloc] initWithTitle:kAlertNeedInternetTitleAccessMaps
                                                           message:kAlertNeedInternetBodyAccessMaps 
                                                          delegate:nil
                                                 cancelButtonTitle:kAlertBtnCancel
                                                 otherButtonTitles:nil];
        }
        
        _alreadyAlertForInternet = YES;
        [_checkNetAlert showWaitUntilBecomeKeyWindow:self.view.window afterDelay:delay];
        
	}
}


#pragma mark - Notification

- (void) handle_standardLocationDidFinish: (NSNotification*) notification{
    if ([self isViewLoaded] && [self isViewAppeared]) {
        //显示与当前位置的距离
        [self setDistanceLabel];
    }
}

- (void) handle_applicationWillResignActive:(id)notification{	
    //关闭未关闭的对话框
    [_checkNetAlert dismissWithClickedButtonIndex:_checkNetAlert.cancelButtonIndex animated:NO];
}

- (void)registerNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_standardLocationDidFinish:)
                               name: IAStandardLocationDidFinishNotification
                             object: nil];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_applicationWillResignActive:)
                               name: UIApplicationWillResignActiveNotification
                             object: nil];	
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
    [notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];
}

#pragma mark - Event

//覆盖父类
-(void)saveData{
    //
}

-(IBAction)doneButtonPressed:(id)sender
{	[self saveData];   
    if ([_delegate respondsToSelector:@selector(alarmPositionMapViewControllerDidPressDoneButton:)]) {
        [_delegate performSelector:@selector(alarmPositionMapViewControllerDidPressDoneButton:) withObject:self];
    }
}



#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
	
	//长按地图
	UILongPressGestureRecognizer *longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewLongPressed:)] autorelease];
    longPressGesture.minimumPressDuration = 0.75; //多长时间算长按
	[self.mapView addGestureRecognizer:longPressGesture];
    
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.title = KViewTitleAlarmPostion;
    
    CLLocationCoordinate2D centerCoordinate = kCLLocationCoordinate2DInvalid;
    if (CLLocationCoordinate2DIsValid(self.alarm.visualCoordinate)) {
        //使用闹钟坐标
        centerCoordinate = self.alarm.visualCoordinate;
    }else if(YCMKCoordinateRegionIsValid([YCParam paramSingleInstance].lastLoadMapRegion)){
        //使用最后一次加载地图的中心坐标
        centerCoordinate = [YCParam paramSingleInstance].lastLoadMapRegion.center;
    }else if (self.mapView.userLocation.location)   {
        //使用当前位置 地图上的
        centerCoordinate = self.mapView.userLocation.location.coordinate;
    }else if ([YCSystemStatus deviceStatusSingleInstance].lastLocation){
        //使用当前位置 定位得到的
        centerCoordinate = [YCSystemStatus deviceStatusSingleInstance].lastLocation.coordinate;
    }else{
        //缺省地图中心点 大概是世界地图
        centerCoordinate = self.mapView.centerCoordinate;
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate, 1500.0, 1500);
    [self.mapView setRegion:region];
    
    
    //nav button
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self 
                                    action:@selector(doneButtonPressed:)] autorelease];
    [self.navigationItem setRightBarButtonItem:doneButton animated:YES];
    
	//self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setHidesBackButton:YES animated:YES];
     
    
   
    
}

- (void)beginWork{
    //pin
    [_annotation release];
    _annotation = [[IAAnnotation alloc] initWithAlarm:self.alarm];
    _annotation.title = KLabelMapNewAnnotationTitle;
	_annotation.subtitle = self.alarm.position;
    [self.mapView addAnnotation:_annotation];
    
    //
    [self performBlock:^{
        self.mapView.showsUserLocation = YES;
    } afterDelay:2.5];
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	self.title = nil;
	
	//保存最后加载的区域
	if (self.mapView.region.span.latitudeDelta < 10.0) { //很大的地图就不存了
		[YCParam paramSingleInstance].lastLoadMapRegion = self.mapView.region;
		[[YCParam paramSingleInstance] saveParam];
	}
    
    //删除pin
    NSArray *pins = [self.mapView mapPointAnnotations];
    if (pins && pins.count > 0) {
        [self.mapView removeAnnotations:pins];
    }

}


#pragma mark - 
#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (userLocation.location == nil) //ios5.0 没有取得用户位置的时候也回调这个方法
        return;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if (_annotation) {
        [self performBlock:^{
            [self.mapView selectAnnotation:_annotation animated:YES];
        } afterDelay:1.0];        
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{
	//IAAnnotation *annotation = (IAAnnotation*)annotationView.annotation;
	switch (newState) 
	{
		case MKAnnotationViewDragStateStarting:
			
			//显示与当前位置的距离。因为拖拽会引发pin的deselect，所以在Starting和Dragging加入显示距离代码
			[self setDistanceLabel];
			break;
		case MKAnnotationViewDragStateDragging:
			//显示与当前位置的距离。因为拖拽会引发pin的deselect，所以在Starting和Dragging加入显示距离代码
			[self setDistanceLabel];
			break;
		case MKAnnotationViewDragStateEnding:   //结束拖拽－大头针落下
			//显示与当前位置的距离
			[self setDistanceLabel];
			break;
		case MKAnnotationViewDragStateCanceling: //取消拖拽
			break;
		default:
			break;
			
	}
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[MKUserLocation class]])
	{
		return nil;
	}
	
	static NSString* pinViewAnnotationIdentifier = @"pinViewAnnotationIdentifier";
	MKPinAnnotationView* pinView = (MKPinAnnotationView *)
	[self.mapView dequeueReusableAnnotationViewWithIdentifier:pinViewAnnotationIdentifier];
	
	if (!pinView)
	{
		pinView = [[[MKPinAnnotationView alloc]
					initWithAnnotation:annotation reuseIdentifier:pinViewAnnotationIdentifier] autorelease];

		
		pinView.canShowCallout = YES;
		
		UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		[rightButton addTarget:self
						action:@selector(showDetails:)
			  forControlEvents:UIControlEventTouchUpInside];
		pinView.rightCalloutAccessoryView = rightButton;
		
	}
	
	pinView.animatesDrop = YES;
	pinView.draggable = YES;
	pinView.pinColor = MKPinAnnotationColorPurple;
	UIImageView *sfIconView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
	
	//旗帜
	IAAlarm *alarmTemp = self.alarm;
	NSString *imageName = alarmTemp.alarmRadiusType.alarmRadiusTypeImageName;
	imageName = [NSString stringWithFormat:@"20_%@",imageName]; //使用20像素的图标
	sfIconView.image = [UIImage imageNamed:imageName];
	
	
	pinView.leftCalloutAccessoryView = sfIconView;
	pinView.annotation = annotation;

	return pinView;
	
}
 
- (void)mapView:(MKMapView *)theMapView regionDidChangeAnimated:(BOOL)animated{
	//设置警示半径圈
	if (_circleOverlay) {
		MKCoordinateRegion overlayRegion = MKCoordinateRegionMakeWithDistance(_circleOverlay.coordinate, _circleOverlay.radius, _circleOverlay.radius);
		CGRect overlayRect = [self.mapView convertRegion:overlayRegion toRectToView:self.mapView];
		double w = overlayRect.size.width;
		MKOverlayView *overlayView = [self.mapView viewForOverlay:_circleOverlay];
		if (w <12) 
			overlayView.hidden = YES;
		else
			overlayView.hidden = NO;
		
	}
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
	
	if ([overlay isKindOfClass:[MKCircle class]]) {
		MKCircleView *cirecleView = nil;
		cirecleView = [[[MKCircleView alloc] initWithCircle:overlay] autorelease];
		cirecleView.fillColor = [UIColor colorWithRed:160.0/255.0 green:127.0/255.0 blue:255.0/255.0 alpha:0.4]; //淡紫几乎透明
		cirecleView.strokeColor = [UIColor whiteColor];   //白
		cirecleView.lineWidth = 2.0;
		return cirecleView;
		
	}
	
	return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView{		
	//警示圈
	IAAnnotation *annotation = (IAAnnotation*)annotationView.annotation;
	if ([annotation isKindOfClass:[IAAnnotation class]]){
        
        [_circleOverlay release];
        _circleOverlay =  [[MKCircle circleWithCenterCoordinate:annotation.coordinate radius:self.alarm.radius] retain];
        [self.mapView addOverlay:_circleOverlay];

		//显示与当前位置的距离
		[self setDistanceLabel];		
	}
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)annotationView{
	
	IAAnnotation *annotation = (IAAnnotation*)annotationView.annotation;
	if ([annotation isKindOfClass:[IAAnnotation class]])
	{	
        //删除警示圈
        if (_circleOverlay) {
            [self.mapView removeOverlay:_circleOverlay];
            [_circleOverlay release];
            _circleOverlay = nil;
        }
        
		//没有选中，就不在显示距离
		CLLocation *location = [YCSystemStatus deviceStatusSingleInstance].lastLocation;
		if (location) {
			[self.navigationItem setTitleView:nil animated:YES];
		}else
			self.navigationItem.titleView = nil;
	}
	
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error{
    if (!_alreadyAlertForInternet && [self isViewAppeared]) { //没警告过 而且 view在显示
        _alreadyAlertForInternet = YES;
        //检查网络
		[self alertInternetAfterDelay:1.0];
	}
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _checkNetAlert && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kAlertBtnSettings]) {
        NSString *str = @"prefs:root=General&path=Network"; //打开设置中的网络
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - init and create

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarm:(IAAlarm*)theAlarm{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil alarm:theAlarm];
    if (self) {
		//[self annotationAlarmEditing];//生成annotationAlarmEditing;
		//[self registerNotifications];
	}
	
	return self;
}

#pragma mark - Memory management

- (void)viewDidUnload {
    [super viewDidUnload];
    [self unRegisterNotifications];
    [_checkNetAlert release];_checkNetAlert = nil;
    self.mapView = nil;
    [_annotation release];_annotation = nil;
    [_circleOverlay release]; _circleOverlay = nil;
}

- (void)dealloc {
    [self unRegisterNotifications];
    [_checkNetAlert release];
    [_mapView release];             
	[_annotation release];
    [_circleOverlay release];
    [super dealloc];
}

@end
 