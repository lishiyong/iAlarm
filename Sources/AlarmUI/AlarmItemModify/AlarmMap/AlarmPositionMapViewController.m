//
//  AlarmPositionMapViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "IAPinAnnotationView.h"
#import "IANotifications.h"
#import "IAAlarmRadiusType.h"
#import "YCSystemStatus.h"
#import "AlarmPositionMapViewController.h"
#import "IAAlarm.h"
#import "UIUtility.h"
#import "IAParam.h"


@implementation AlarmPositionMapViewController

@synthesize mapView = _mapView ,delegate = _delegate;

- (void)setSkinWithType:(IASkinType)type{
    YCBarButtonItemStyle buttonItemStyle = YCBarButtonItemStyleDefault;
    YCTableViewBackgroundStyle tableViewBgStyle = YCTableViewBackgroundStyleDefault;
    YCBarStyle barStyle = YCBarStyleDefault;
    if (IASkinTypeDefault == type) {
        buttonItemStyle = YCBarButtonItemStyleDefault;
        tableViewBgStyle = YCTableViewBackgroundStyleDefault;
        barStyle = YCBarStyleDefault;
    }else {
        buttonItemStyle = YCBarButtonItemStyleSilver;
        tableViewBgStyle = YCTableViewBackgroundStyleSilver;
        barStyle = YCBarStyleSilver;
    }
    [self.navigationItem.rightBarButtonItem setYCStyle:buttonItemStyle];
}

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

	CLLocation *curLocation = [YCSystemStatus sharedSystemStatus].lastLocation;
	if (curLocation) {
        
        CLLocationCoordinate2D realCoordinate = _annotation.realCoordinate;
		NSString *distance = [curLocation distanceStringFromCoordinate:realCoordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextPromptCurrentLocation];
		[self.navigationItem setTitleView:[self detailTitleViewWithContent:distance] animated:YES];
        
	}else
		self.navigationItem.titleView = nil;
    
}

-(void)alertInternetAfterDelay:(NSTimeInterval)delay{
	//检查网络
	BOOL connectedToInternet = [[YCSystemStatus sharedSystemStatus] connectedToInternet];
	if (!connectedToInternet) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
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

#define kTimeOutForReverse 30.0
-(void)reverseGeocodeWithAnnotation:(YCMapPointAnnotation*)annotation
{	
    CLLocationCoordinate2D visualCoordinate = annotation.coordinate;
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:visualCoordinate.latitude longitude:visualCoordinate.longitude] autorelease];
    
    if (!_geocoder) 
        _geocoder = [[YCReverseGeocoder alloc] initWithTimeout:kTimeOutForReverse];
    if (_geocoder.geocoding) 
        [_geocoder cancel];
    
    _annotation.subtitle = @" . . . ";;
    [_geocoder reverseGeocodeLocation:location completionHandler:^(YCPlacemark *placemark, NSError *error) {        
        NSString *coordinateString = YCLocalizedStringFromCLLocationCoordinate2D(visualCoordinate,kCoordinateFrmStringNorthLatitude,kCoordinateFrmStringSouthLatitude,kCoordinateFrmStringEastLongitude,kCoordinateFrmStringWestLongitude);
                
        IAAlarm *alarm = self.alarm;
        if (!error && placemark){
            
            //优先使用name，其次titleAddress，最后KDefaultAlarmName
            NSString *titleAddress = placemark.name ? placemark.name :(placemark.titleAddress ? placemark.titleAddress : KDefaultAlarmName);
            NSString *shortAddress = placemark.shortAddress ? placemark.shortAddress : coordinateString;
            NSString *longAddress = placemark.longAddress ? placemark.longAddress : coordinateString;
            
            
            annotation.subtitle = longAddress;
            
            alarm.position = longAddress;
            alarm.positionShort = shortAddress;
            alarm.positionTitle = titleAddress;  
            alarm.placemark = placemark;
            alarm.usedCoordinateAddress = NO;
            
        }else{
            
            [_annotation performSelector:@selector(setSubtitle:) withObject:nil afterDelay:1.5]; //"..."多显示一会
            
            if (!alarm.nameChanged) {
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
        
    }];
    
}

- (void)resetPinWithCoordinate:(CLLocationCoordinate2D)coordinate{
	
	[self.mapView removeAnnotation:_annotation];
	
	if (_circleOverlay) { //删除警示圈
		[self.mapView removeOverlay:_circleOverlay];
	}
    
	_annotation.coordinate = coordinate;
	[self.mapView addAnnotation:_annotation];
    
}

//根据圈的在屏幕上的半径来决定OverlayView是否可视
- (void)hideOrShowCircleOverlayView:(MKCircle *)circleOverlay{
    if (circleOverlay) {
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

#pragma mark - Notification

- (void) handle_standardLocationDidFinish: (NSNotification*) notification{
    if ([self isViewLoaded] && [self isViewAppeared]) {
        //显示与当前位置的距离
        [self setDistanceLabel];
    }
}

- (void) handle_applicationWillResignActive:(id)notification{	
    
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
    if (_annotation && CLLocationCoordinate2DIsValid(_annotation.coordinate)) {
        self.alarm.visualCoordinate = _annotation.coordinate;
    }
}

-(IBAction)doneButtonPressed:(id)sender
{	
    [self saveData];   
    if ([_delegate respondsToSelector:@selector(alarmPositionMapViewControllerDidPressDoneButton:)]) {
        [_delegate performSelector:@selector(alarmPositionMapViewControllerDidPressDoneButton:) withObject:self];
    }
}

- (void)mapViewLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
	
	if (UIGestureRecognizerStateBegan == gestureRecognizer.state){ //只处理长按开始
		
		CGPoint pointPressed = [gestureRecognizer locationInView:self.mapView];
		CLLocationCoordinate2D coordinatePressed = [self.mapView convertPoint:pointPressed toCoordinateFromView:self.mapView];
		
		if (CLLocationCoordinate2DIsValid(coordinatePressed)){
            _annotation.subtitle = nil;
			[self resetPinWithCoordinate:coordinatePressed];
            //反转坐标－地址
            [self performSelector:@selector(reverseGeocodeWithAnnotation:) withObject:_annotation afterDelay:0.1];
        }
	}
	
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
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
    }else if(YCMKCoordinateRegionIsValid([IAParam sharedParam].lastLoadMapRegion)){
        //使用最后一次加载地图的中心坐标
        centerCoordinate = [IAParam sharedParam].lastLoadMapRegion.center;
    }else if (self.mapView.userLocation.location)   {
        //使用当前位置 地图上的
        centerCoordinate = self.mapView.userLocation.location.coordinate;
    }else if ([YCSystemStatus sharedSystemStatus].lastLocation){
        //使用当前位置 定位得到的
        centerCoordinate = [YCSystemStatus sharedSystemStatus].lastLocation.coordinate;
    }else{
        //缺省
        centerCoordinate = kYCDefaultCoordinate;
    }
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate, 1500.0, 1500);
    [self.mapView setRegion:region];
    
    
    //nav button
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                    target:self 
                                    action:@selector(doneButtonPressed:)] autorelease];
    doneButton.style = UIBarButtonItemStyleDone;
    
    [self.navigationItem setRightBarButtonItem:doneButton animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO; //地图返回动画，不能马上执行
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    //pin
    [self performBlock:^{
        
        [_annotation release];
        CLLocationCoordinate2D visualCoordinate = self.alarm.visualCoordinate;
        visualCoordinate = CLLocationCoordinate2DIsValid(visualCoordinate) ? visualCoordinate : self.mapView.centerCoordinate;
        _annotation = [[YCMapPointAnnotation alloc] initWithCoordinate:visualCoordinate title:KLabelMapNewAnnotationTitle subTitle:self.alarm.position];
        [self.mapView addAnnotation:_annotation];
        
        if (!CLLocationCoordinate2DIsValid(self.alarm.visualCoordinate)) //反转坐标
            [self reverseGeocodeWithAnnotation:_annotation];
        
        
    } afterDelay:0.2];
    
    
    
    //当前位置和Done按钮
    [self performBlock:^{
        self.mapView.showsUserLocation = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES; //地图返回动画，不能马上执行
    } afterDelay:2.0];
    
    //skin Style
    [self setSkinWithType:[IAParam sharedParam].skinType];
     
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	self.title = nil;
	
	//保存最后加载的区域
	if (self.mapView.region.span.latitudeDelta < 10.0) { //很大的地图就不存了
		[IAParam sharedParam].lastLoadMapRegion = self.mapView.region;
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

//为了能取消执行
- (void)selectTheAnnotationAnimated{
    if (_annotation) {
        [self.mapView selectAnnotation:_annotation animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    [self performSelector:@selector(selectTheAnnotationAnimated) withObject:nil afterDelay:1.0];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{
    
    //取消pin将要选中
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(selectTheAnnotationAnimated) object:nil];
    
	YCMapPointAnnotation *annotation = (YCMapPointAnnotation*)annotationView.annotation;
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
            
            //////////////////////////////////////////
			//反转
			if ([annotation isKindOfClass:[YCMapPointAnnotation class]])
			{
                annotation.subtitle = nil;
				
                //坐标改变了，保存
                self.alarm.visualCoordinate = annotation.coordinate;
				//反转坐标－地址
				[self performSelector:@selector(reverseGeocodeWithAnnotation:) withObject:annotation afterDelay:0.0];
				
			}
			//////////////////////////////////////////
        
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
	}
	
    pinView.canShowCallout = YES;
	pinView.animatesDrop = YES;
	pinView.draggable = YES;
	pinView.pinColor = MKPinAnnotationColorPurple;
	
	//旗帜
	IAAlarm *alarmTemp = self.alarm;
	NSString *imageName = alarmTemp.alarmRadiusType.alarmRadiusTypeImageName;
	imageName = [NSString stringWithFormat:@"20_%@",imageName]; //使用20像素的图标
    
    UIButton *flagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flagButton.frame = CGRectMake(0, 0, 20, 20);
    [flagButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [flagButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	pinView.leftCalloutAccessoryView = flagButton;
	pinView.annotation = annotation;

	return pinView;
	
}
 
- (void)mapView:(MKMapView *)theMapView regionDidChangeAnimated:(BOOL)animated{
	//圈是否显示
    [self hideOrShowCircleOverlayView:_circleOverlay];
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
	YCMapPointAnnotation *annotation = (YCMapPointAnnotation*)annotationView.annotation;
	if ([annotation isKindOfClass:[YCMapPointAnnotation class]]){
        
        [_circleOverlay release];
        _circleOverlay =  [[MKCircle circleWithCenterCoordinate:annotation.coordinate radius:self.alarm.radius] retain];
        [self.mapView addOverlay:_circleOverlay];
        
        //圈是否显示
        [self hideOrShowCircleOverlayView:_circleOverlay];

		//显示与当前位置的距离
		[self setDistanceLabel];		
	}
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)annotationView{
	
	YCMapPointAnnotation *annotation = (YCMapPointAnnotation*)annotationView.annotation;
	if ([annotation isKindOfClass:[YCMapPointAnnotation class]])
	{	
        //删除警示圈
        if (_circleOverlay) {
            [self.mapView removeOverlay:_circleOverlay];
            [_circleOverlay release];
            _circleOverlay = nil;
        }
        
		//没有选中，就不在显示距离
		CLLocation *location = [YCSystemStatus sharedSystemStatus].lastLocation;
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
    NSLog(@"AlarmPositionMapViewController viewDidUnload");
    [super viewDidUnload];
    [self unRegisterNotifications];
    /*
    self.mapView = nil;
    [_checkNetAlert release];_checkNetAlert = nil;
    [_annotation release];_annotation = nil;
    [_circleOverlay release]; _circleOverlay = nil;
     */
}

- (void)dealloc {
    NSLog(@"AlarmPositionMapViewController dealloc");
    [_checkNetAlert dismissWithClickedButtonIndex:_checkNetAlert.cancelButtonIndex animated:NO];
    [self unRegisterNotifications];
    [_checkNetAlert release];
	[_annotation release];
    [_circleOverlay release];
    [_mapView release];
    [_geocoder release];
    [super dealloc];
}

@end
 