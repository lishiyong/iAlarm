//
//  AlarmPositionMapViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCFunctions.h"
#import "YCLocationManager.h"
#import "CLLocation+YC.h"
#import "IAAnnotationView.h"
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
#import "AnnotationInfoViewController.h"
#import "YCTapHideBarView.h"
#import "MapBookmarksListController.h"
#import "MapBookmark.h"

//toolbar显示的时间
#define kTimeIntervalForSearchBarHide  30.0
//取得用户当前位置的超时时间
#define kTimeSpanForUserLocation       15.0


@implementation AlarmPositionMapViewController


#pragma mark -
#pragma mark 属性
@synthesize lastUpdateDistanceTimestamp;
@synthesize locationServicesUsableAlert;
@synthesize mapView;
@synthesize maskView;
@synthesize curlView;
@synthesize curlbackgroundView;
@synthesize curlImageView;
@synthesize searchBar;
@synthesize toolbar;
@synthesize mapTypeSegmented;
@synthesize currentLocationBarItem;
@synthesize currentPinBarItem;
@synthesize searchBarItem;
@synthesize resetPinBarItem;
@synthesize pageCurlBarItem;


/////////////////////////////////////
//地址反转
@synthesize placemarkForUserLocation;
@synthesize placemarkForPin;
/////////////////////////////////////

@synthesize searchController;
@synthesize newAlarmAnnotation; 
@synthesize annotationAlarmEditing;
@synthesize circleOverlay;

@synthesize openToolbarBarItem;
@synthesize toolbarFloatingView;
@synthesize mapsTypeButton;
@synthesize satelliteTypeButton;                   
@synthesize hybridTypeButton;


- (MKCoordinateRegion)regionWithCoordinate:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)radius{
	CLLocationDistance distanceForRegion = self.alarm.radius*2*1.8;//直径的1.x倍
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, distanceForRegion, distanceForRegion);
	return region;
}

- (id)toolbarFloatingView{
	if (toolbarFloatingView == nil) {
		//浮动工具栏
		CGPoint p = CGPointMake(285.0, 382);
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
		NSValue *obj1 = [NSValue valueWithBytes:& @selector(mapTypeButtonPressed:) objCType:@encode(SEL)];
		NSValue *obj2 = [NSValue valueWithBytes:& @selector(mapTypeButtonPressed:) objCType:@encode(SEL)];
		NSValue *obj3 = [NSValue valueWithBytes:& @selector(mapTypeButtonPressed:) objCType:@encode(SEL)];
		
		NSArray *actionArray = [NSArray arrayWithObjects:obj1,obj2,obj3,nil];
		
		toolbarFloatingView = [[YCCalloutBar alloc] initWithButtonsTitle:titleArray buttonsImage:imageArray targets:targetArray 
															   actions:actionArray arrowPointer:p fromSuperView:self.view];

	}
	return toolbarFloatingView;
}

-(id)forwardGeocoder{
	if (forwardGeocoder == nil) {
		forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
        forwardGeocoder.timeoutInterval = 20.0;
        forwardGeocoder.useHTTP = YES;
	}
	return forwardGeocoder;
}

- (MKReverseGeocoder *)reverseGeocoder:(CLLocationCoordinate2D)coordinate
{
    if (reverseGeocoder) {
		[reverseGeocoder release];
	}
	reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
	reverseGeocoder.delegate = self;
	
	return reverseGeocoder;
}

-(id) locationingBarItem
{
	if (self->locationingBarItem == nil) 
	{
		CGRect frame = CGRectMake(0, 0, 20, 20);
		UIActivityIndicatorView *progressInd = [[[UIActivityIndicatorView alloc] initWithFrame:frame] autorelease];
		self->locationingBarItem = [[UIBarButtonItem alloc] initWithCustomView:progressInd];
		[progressInd startAnimating];
	}
	
	return self->locationingBarItem;
}

/*
-(id) openToolbarBarItem{
	if (self->openToolbarBarItem == nil) 
	{
		openToolbarBarItem = [[[YCBarButtonItem alloc] initWithFrame:CGRectMake(0, 0, 34, 30)] autorelease];
		openToolbarBarItem.target = self;
		openToolbarBarItem.action = @selector(openToolbarBarItemPressed:);
		
		openToolbarBarItem.normalImage = [UIImage imageNamed:@"IAOpenToolbarButton.png"];
		//openToolbarBarItem.highlightedImage = [UIImage imageNamed:@"IAOpenToolbarButtonHightLighted.png"];
		//openToolbarBarItem.styleDoneImage = [UIImage imageNamed:@"IAOpenToolbarButtonSelected.png"];
		openToolbarBarItem.style = UIBarButtonItemStyleBordered;
	}
	
	return self->openToolbarBarItem;
}
 */

-(id)annotationAlarmEditing{
	if (annotationAlarmEditing == nil) {
		annotationAlarmEditing = [[IAAnnotation alloc] initWithAlarm:alarm];
		[annotationAlarmEditing addObserver:self forKeyPath:@"coordinate" options:0 context:nil];
		[annotationAlarmEditing addObserver:self forKeyPath:@"subtitle" options:0 context:nil];
		
	}
	return annotationAlarmEditing;
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

	CLLocation *curLocation = [YCSystemStatus deviceStatusSingleInstance].lastLocation;
	if (curLocation) {
        
        CLLocationCoordinate2D realCoordinate = self.annotationAlarmEditing.realCoordinate;
		NSString *distance = [curLocation distanceStringFromCoordinate:realCoordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextPromptCurrentLocation];
		[self.navigationItem setTitleView:[self detailTitleViewWithContent:distance] animated:YES];
        
	}else
		self.navigationItem.titleView = nil;
    
}

-(void)alertInternet{
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
        
        [checkNetAlert show];
        
	}
}



-(void)updateAnnotationAlarmEditing
{
	IAAlarm *temp = self.alarm;
	self.annotationAlarmEditing.title = temp.alarmName;
	self.annotationAlarmEditing.subtitle = temp.position;
	self.annotationAlarmEditing.annotationType = IAMapAnnotationTypeLocating;
	self.annotationAlarmEditing.title = KLabelMapNewAnnotationTitle;
	self.annotationAlarmEditing.subtitle = temp.position;
    self.annotationAlarmEditing.coordinate = temp.visualCoordinate;
	
}


-(void)setToolBarItemsEnabled:(BOOL)enabled
{
	NSArray *baritems = self.toolbar.items ;
	for(NSUInteger i=0;i<baritems.count;i++)
	{
		[[baritems objectAtIndex:i] setEnabled:enabled];
	}
}



//关掉MaskView,加入Annotations
-(void)addAnnotationsAfterCloseMask{
	if (!CLLocationCoordinate2DIsValid(self.annotationAlarmEditing.coordinate)) //alarm坐标无效，取屏幕中心
		self.annotationAlarmEditing.coordinate = self.mapView.region.center;
	
	[self.mapView performSelectorOnMainThread:@selector(addAnnotation:) withObject:self.annotationAlarmEditing waitUntilDone:YES];
	
}

//显示覆盖视图
-(void)showMaskView
{
	self.maskView.hidden = NO;
}

//关掉覆盖视图
-(void)animateCloseMaskView
{	
	if (self.maskView.hidden == YES) return;
	
	[UIView beginAnimations:@"Unmask" context:NULL];
	[UIView setAnimationDuration:1.0];
	self.maskView.hidden = YES;
	[UIView commitAnimations];
	
	
	//显示SearchBar -animated:NO 
	[UIUtility setBar:self.searchBar topBar:YES visible:YES animated:NO animateDuration:1.0 animateName:@"showOrHideSearchBar"];
	[self.curlbackgroundView startHideSearchBarAfterTimeInterval:kTimeIntervalForSearchBarHide];
	
	[self performSelector:@selector(addAnnotationsAfterCloseMask) withObject:nil afterDelay:1.1];
	
}


////设置"正在定位"barItem处于定位状态
-(void)setLocationBarItem:(BOOL)locationing
{
	NSMutableArray *baritems = [NSMutableArray array];
	[baritems addObjectsFromArray:self.toolbar.items];
	
	if(locationing)
		[baritems replaceObjectAtIndex:0 withObject:self.locationingBarItem];
	else 
		[baritems replaceObjectAtIndex:0 withObject:self.currentLocationBarItem];

	[self.toolbar setItems:baritems animated:NO];
}

////设置“回到当前位置按钮”的可用状态。
-(void)setLocationBarItem{
	
	CLLocationCoordinate2D currentMapCenter = self.mapView.region.center;
	CGPoint currentMapCenterPoint = [self.mapView convertCoordinate:currentMapCenter toPointToView:nil];
	
	//比较的坐标转换后到屏幕上的点；相等：BarItem不可用
	CLLocationCoordinate2D userCurrentLocation = {-10000.0,-10000.0};
	if (self.mapView.userLocation.location) userCurrentLocation = self.mapView.userLocation.location.coordinate;
	if (!CLLocationCoordinate2DIsValid(userCurrentLocation)) return; //无效坐标
	
	CGPoint userCurrentLocationPoint = [self.mapView convertCoordinate:userCurrentLocation toPointToView:nil];
	if (YCCGPointEqualPointWithOffSet(currentMapCenterPoint, userCurrentLocationPoint,2)) {//允许误差2个像素
		self.currentLocationBarItem.enabled = NO;
	}else {
		self.currentLocationBarItem.enabled = YES;
	}
	
}

////设置“回到正在编辑按钮”的可用状态。
-(void)setCurrentPinBarItem{
	
	//取消由点击按钮CurrentPin引发的调用
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setCurrentPinBarItem) object:nil];
	
	CLLocationCoordinate2D currentMapCenter = self.mapView.region.center;
	CGPoint currentMapCenterPoint = [self.mapView convertCoordinate:currentMapCenter toPointToView:nil];
	
	//比较的坐标转换后到屏幕上的点；相等：BarItem不可用
	CLLocationCoordinate2D alarmEditing = self.annotationAlarmEditing.coordinate;
	if (!CLLocationCoordinate2DIsValid(alarmEditing)) return; //无效坐标
	
	CGPoint alarmEditingPoint = [self.mapView convertCoordinate:alarmEditing toPointToView:nil];
	if (YCCGPointEqualPointWithOffSet(currentMapCenterPoint, alarmEditingPoint,2)) {//允许误差2个像素
		self.currentPinBarItem.enabled = NO;
	}else {
		self.currentPinBarItem.enabled = YES;
	}
	
}


- (void)resetPinWithCoordinate:(CLLocationCoordinate2D)coordinate{
	/*
	NSArray *array = self.mapView.selectedAnnotations;
	if (array.count >0) {
		id selected = [self.mapView.selectedAnnotations objectAtIndex:0];
		[self.mapView deselectAnnotation:selected animated:NO];
	}
	 */

	
	[self.mapView removeAnnotation:self.annotationAlarmEditing];
	
	if (self.circleOverlay) { //删除警示圈
		[self.mapView removeOverlay:self.circleOverlay];
		//self.circleOverlay = nil;
	}
	 
	self.annotationAlarmEditing.coordinate = coordinate;
	//[self.mapView addAnnotation:self.annotationAlarmEditing];
	[self.mapView performSelectorOnMainThread:@selector(addAnnotation:) withObject:self.annotationAlarmEditing waitUntilDone:YES];
    

}


#pragma mark -
#pragma mark Notification

- (void) handle_applicationDidEnterBackground:(id)notification{
	//还没加载
	if (![self isViewLoaded]) return;
	
	if (self->isCurl) [self pageCurlButtonPressed:nil]; //处理卷页
	
	//恢复navbar 标题
	self.navigationItem.titleView = nil;
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	//还没加载
	if (![self isViewLoaded]) return;
	
	//if ([keyPath isEqualToString:@"radius"] || [keyPath isEqualToString:@"alarmRadiusType"]) 
	if (object == self.alarm)
	{//由其他视图改变的警示圈，在这里需要重新加载
	
		if(self.circleOverlay){
			//先移除
			[self.mapView removeAnnotation:self.annotationAlarmEditing];
			if (self.circleOverlay) { //删除警示圈
				[self.mapView removeOverlay:self.circleOverlay];
			}
			
			//更新
			[self updateAnnotationAlarmEditing];
			if (CLLocationCoordinate2DIsValid(self.annotationAlarmEditing.coordinate)){
				//中心
				[self.mapView setCenterCoordinate:self.annotationAlarmEditing.coordinate]; 
			}else {
				//alarm中的坐标无效，使用屏幕中心坐标
				self.annotationAlarmEditing.coordinate = self.mapView.centerCoordinate;
			}
			
			//加入Annotation
			[self.mapView addAnnotation:self.annotationAlarmEditing];
			
			//改变可视范围
			MKCoordinateRegion region = [self regionWithCoordinate:self.alarm.visualCoordinate radius:self.alarm.radius];
			[self.mapView setRegion:region];
			
		}
		
	}
	
	if (object == self.annotationAlarmEditing) 
	{ //坐标或地址变了，Done状态
		
		BOOL vaildCoordinate = CLLocationCoordinate2DIsValid(self.annotationAlarmEditing.coordinate);
		BOOL vaildSubtitle = (self.annotationAlarmEditing.subtitle != nil && [self.annotationAlarmEditing.subtitle length] > 0);
		if (!vaildCoordinate || !vaildSubtitle) { //任何一项无效都不行
			self.navigationItem.rightBarButtonItem.enabled = NO;
			return;
		}
		
		BOOL equalToCoordinate = YCCLLocationCoordinate2DEqualToCoordinate(self.alarm.visualCoordinate, self.annotationAlarmEditing.coordinate);
		BOOL equalToSubtitle = [self.alarm.position isEqualToString:self.annotationAlarmEditing.subtitle];
		if (!equalToCoordinate || !equalToSubtitle)
		{ //任何一项不等
			self.navigationItem.rightBarButtonItem.enabled = YES;
		}else {
			self.navigationItem.rightBarButtonItem.enabled = NO;
		}
		
	}

}

- (void) handle_standardLocationDidFinish: (NSNotification*) notification{
    //还没加载
	if (![self isViewLoaded]) return;
	
    //间隔20秒以上才更新
    if (!(self.lastUpdateDistanceTimestamp == nil || [self.lastUpdateDistanceTimestamp timeIntervalSinceNow] < -20)) 
        return;
    self.lastUpdateDistanceTimestamp = [NSDate date]; //更新时间戳
    
	//显示与当前位置的距离
	[self setDistanceLabel];
    
}

- (void) handle_applicationWillResignActive:(id)notification{	
    //关闭未关闭的对话框
    [checkNetAlert dismissWithClickedButtonIndex:searchResultsAlert.cancelButtonIndex animated:NO];
    [searchResultsAlert dismissWithClickedButtonIndex:searchResultsAlert.cancelButtonIndex animated:NO];
    [searchAlert dismissWithClickedButtonIndex:searchAlert.cancelButtonIndex animated:NO];
    [self.searchController setActive:NO animated:NO];
    [self.forwardGeocoder cancel];
}

- (void)registerNotifications 
{
	if (!self->isNotificationsRegistered) {
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

		//软件将进入后台状态－处理半卷动画等
		[notificationCenter addObserver: self
							   selector: @selector (handle_applicationDidEnterBackground:)
								   name: UIApplicationDidEnterBackgroundNotification
								 object: nil];
		
		[notificationCenter addObserver: self
							   selector: @selector (handle_standardLocationDidFinish:)
								   name: IAStandardLocationDidFinishNotification
								 object: nil];
        
        [notificationCenter addObserver: self
                               selector: @selector (handle_applicationWillResignActive:)
                                   name: UIApplicationWillResignActiveNotification
                                 object: nil];
		
		
		[self.alarm addObserver:self forKeyPath:@"radius" options:0 context:nil];
		[self.alarm addObserver:self forKeyPath:@"alarmRadiusType" options:0 context:nil];
		
		

		self->isNotificationsRegistered = YES;
	}
	
}


- (void)unRegisterNotifications{
	if (self->isNotificationsRegistered) {
		
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter removeObserver:self	name: UIApplicationDidEnterBackgroundNotification object: nil];
		[notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
        [notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];

		//[self.annotationAlarmEditing removeObserver:self forKeyPath:@"coordinate"];
		[self.alarm removeObserver:self forKeyPath:@"radius"];
		[self.alarm removeObserver:self forKeyPath:@"alarmRadiusType"];
		
			
		self->isNotificationsRegistered = NO;
	}
}





#pragma mark -
#pragma mark Event

-(void)setDoneStyleToBarButtonItem:(UIBarButtonItem*)buttonItem
{
	buttonItem.style =  UIBarButtonItemStyleDone;
}

//覆盖父类
-(IBAction)doneButtonPressed:(id)sender
{	
    if (sender == self) {
        return; //为了对应父类中，难看的代码: - (void)viewWillDisappear:(BOOL)animated
    }
    
	CLLocationCoordinate2D realCoordinate = self.annotationAlarmEditing.realCoordinate;
    
	MKPlacemark *placemark = self.annotationAlarmEditing.placemarkForReverse;
	BSKmlResult *place = self.annotationAlarmEditing.placeForSearch;
	NSString *addressTitle = nil;
	NSString *addressShort = nil;
	NSString *address = nil;

	self.alarm.usedCoordinateAddress = NO;  
	if (placemark != nil) {
		address = YCGetAddressString(placemark);
		
		addressShort = YCGetAddressShortString(placemark);
		addressShort = (addressShort != nil) ? addressShort : address;
		
		addressTitle = YCGetAddressTitleString(placemark);
		addressTitle = (addressTitle != nil) ? addressTitle : addressShort;
		

	}else if (place != nil) {
		address = place.address;
		address = [address trim];
		
		addressShort = place.address;
		addressShort = [addressShort trim];
		addressShort = (addressShort != nil) ? addressShort : address;
		
		addressTitle = place.searchString;
		addressTitle = [addressTitle trim];
		addressTitle = (addressTitle != nil) ? addressTitle : addressShort;

	}else {
		//反转坐标 失败，使用坐标作为地址
		addressTitle = KDefaultAlarmName;
		address = [UIUtility convertCoordinate:realCoordinate];
		addressShort = address;
		self.alarm.usedCoordinateAddress = YES;
	}
	
	//最后的判空
	addressTitle = (addressTitle != nil) ? addressTitle:KDefaultAlarmName;
	if (addressShort == nil) {
		self.alarm.usedCoordinateAddress = YES;
		addressShort = (addressShort != nil) ? addressShort : [UIUtility convertCoordinate:realCoordinate];
	}
	address = (address != nil) ? address : [UIUtility convertCoordinate:realCoordinate];



	
	if (!self.alarm.nameChanged) {
		self.alarm.alarmName = addressTitle;
	}
	self.alarm.coordinate = realCoordinate;
	self.alarm.position = address;
	self.alarm.positionShort = addressShort;
    self.alarm.reserve1 = addressTitle; //做为addressTitle
	self.alarm.locationAccuracy = kCLLocationAccuracyBest;
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
	[super doneButtonPressed:sender];
}

-(IBAction)cancelButtonPressed:(id)sender{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}



-(IBAction)currentLocationButtonPressed:(id)sender
{
	if (self->isCurl) [self pageCurlButtonPressed:nil]; //处理卷页
	
	
	//检测定位服务状态。如果不可用或未授权，弹出对话框
	[self.locationServicesUsableAlert locationServicesUsable];
	
	//选中当前位置
	if (self.mapView.userLocation.location)
	{
		[self setLocationBarItem:YES];    //把barItem改成正在定位的状态
		[self performSelector:@selector(setLocationBarItem:) withObject:nil afterDelay:0.5];//0.5秒后，把barItem改回正常状态
		MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.location.coordinate,kDefaultLatitudinalMeters,kDefaultLongitudinalMeters);
		[self.mapView setRegion:region FromWorld:NO animatedToWorld:NO animatedToPlace:YES];
		[self.mapView performSelector:@selector(animateSelectAnnotation:) withObject:self.mapView.userLocation afterDelay:0.5]; //适当延长时间
	}
	 
}



-(IBAction)currentPinButtonPressed:(id)sender
{	
	if (self->isCurl) [self pageCurlButtonPressed:nil]; //处理卷页
	
	if (self.annotationAlarmEditing) {
		[self.mapView setCenterCoordinate:self.annotationAlarmEditing.coordinate animated:YES];
		[self.mapView performSelector:@selector(animateSelectAnnotation:) withObject:self.annotationAlarmEditing afterDelay:0.2];
	}
	
	//解决：由resetPinButtonPressed引起的大头针位置变化
	[self performSelector:@selector(setCurrentPinBarItem) withObject:nil afterDelay:1.5];
}


-(IBAction)searchButtonPressed:(id)sender
{
	if (self->isCurl) [self pageCurlButtonPressed:nil]; //处理卷页
	
	[self.searchController setActive:YES animated:YES];   //处理search状态
	
}

-(IBAction)pageCurlButtonPressed:(id)sender
{
	
	//创建CATransition对象
	CATransition *animation = [CATransition animation];
	//相关参数设置
	[animation setDelegate:self];
	[animation setDuration:0.4f];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	//向上卷的参数
	if(!isCurl)
	{
		//设置动画类型为pageCurl，并只卷一半
		//[animation setType:@"pageCurl"];
		animation.endProgress=0.70;
		
		self.pageCurlBarItem.style = UIBarButtonItemStyleDone;
		
		self.curlView.enabled = YES;
	}
	//向下卷的参数
	else
	{
		//设置动画类型为pageUnCurl，并从一半开始向下卷
		//[animation setType:@"pageUnCurl"];
		animation.startProgress=0.30;
		
		self.pageCurlBarItem.style = UIBarButtonItemStyleBordered;
		
		self.curlView.enabled = NO;   //防止地图在改变时候，事件直接就传到curlView上了
	}
	//卷的过程完成后停止，并且不从层中移除动画
	//[animation setFillMode: @"extended"];
	[animation setFillMode:kCAFillModeForwards];
	[animation setSubtype:kCATransitionFromBottom];
	[animation setRemovedOnCompletion:NO];
	
	[self.curlbackgroundView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	[[self.curlbackgroundView layer] addAnimation:animation forKey:@"pageCurlAnimation"];

	isCurl=!isCurl;
	
}

-(IBAction)mapTypeSegmentedChanged:(id)sender;
{
	switch ([sender selectedSegmentIndex]) 
	{
		case 0:
			self.mapView.mapType = MKMapTypeStandard;
			break;
		case 1:
			self.mapView.mapType = MKMapTypeSatellite;
			break;
		case 2:
			self.mapView.mapType = MKMapTypeHybrid;
			break;
		default:
			break;
	}
    [self pageCurlButtonPressed:nil];
}

-(IBAction)resetPinButtonPressed:(id)sender
{
	[self resetPinWithCoordinate:self.mapView.region.center];
	if (self->isCurl) [self pageCurlButtonPressed:nil]; //处理卷页
}


- (void)mapViewLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
	
	if (UIGestureRecognizerStateBegan == gestureRecognizer.state){ //只处理长按开始
		
		CGPoint pointPressed = [gestureRecognizer locationInView:self.mapView];
		CLLocationCoordinate2D coordinatePressed = [self.mapView convertPoint:pointPressed toCoordinateFromView:self.mapView];
		
		if (CLLocationCoordinate2DIsValid(coordinatePressed))
			[self resetPinWithCoordinate:coordinatePressed];
	}
	
}

- (void)openToolbarBarItemPressed:(id)sender{
	self.toolbarFloatingView.hidden = !self.toolbarFloatingView.hidden;
	self.openToolbarBarItem.style = self.toolbarFloatingView.hidden ? UIBarButtonItemStyleBordered:UIBarButtonItemStyleDone;
	
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

- (void)mapTypeButtonPressed:(id)sender{
	
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
	
	[self openToolbarBarItemPressed:nil];
}



#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	//self.navigationItem.prompt = @"Distance to 距離目前位置 距离当前位置。";
	
	//由于是上下动画，与其他的修改view不一样，不能共用按钮
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								   target:self 
								   action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
	self.navigationItem.rightBarButtonItem.enabled = NO;
    [doneButton release];

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								   target:self 
								   action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
	
	
	
	mapView.delegate = self;
	self->isFirstShow = YES;
	self.curlView.enabled = NO;   //防止地图在改变时候，事件直接就传到curlView上了
	
	//Map type segmented
	[self.mapTypeSegmented setTitle:KDicMapTypeNameStandard forSegmentAtIndex:0];
	[self.mapTypeSegmented setTitle:KDicMapTypeNameSatellite forSegmentAtIndex:1];
	[self.mapTypeSegmented setTitle:KDicMapTypeNameHybrid forSegmentAtIndex:2];
	
	//searchBar,toolbar
	self.searchBar.hidden = NO;
	[(YCSearchBar*)self.searchBar setCanResignFirstResponder:YES];
	self.searchBar.placeholder = KTextPromptPlaceholderOfSearchBar;
	self.curlbackgroundView.canHideSearchBar = YES;
	self.curlbackgroundView.canHideToolBar = NO;
	self.toolbar.hidden = NO;
	
	
	
	self.searchController = [[YCSearchController alloc] initWithDelegate:self
												 searchDisplayController:self.searchDisplayController];
	
	
	//curView
	UIViewAutoresizing viewautoresizingMask = 0;
	viewautoresizingMask = UIViewAutoresizingFlexibleLeftMargin
						| UIViewAutoresizingFlexibleWidth
						| UIViewAutoresizingFlexibleRightMargin
						| UIViewAutoresizingFlexibleTopMargin
						| UIViewAutoresizingFlexibleHeight
						| UIViewAutoresizingFlexibleBottomMargin;
	
	self.curlbackgroundView.autoresizingMask = viewautoresizingMask;
	self.curlView.autoresizingMask = viewautoresizingMask;
	self.mapView.autoresizingMask = viewautoresizingMask;
	self.mapTypeSegmented.autoresizingMask = viewautoresizingMask;
	self.curlImageView.autoresizingMask = viewautoresizingMask;
	
	
	
	//pageCurlBarItem
	/*
	self.pageCurlBarItem = [[[YCBarButtonItem alloc] initWithFrame:CGRectMake(0, 0, 34, 30)] autorelease];
	self.pageCurlBarItem.target = self;
	self.pageCurlBarItem.action = @selector(pageCurlButtonPressed:);
	UIBarButtonItem *fixedBarItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL] autorelease];
	fixedBarItem.width = 3;
	
	NSMutableArray *baritems = [NSMutableArray array];
	[baritems addObjectsFromArray:self.toolbar.items];
	[baritems addObject:self.pageCurlBarItem];
	[baritems addObject:fixedBarItem];
	[self.toolbar setItems:baritems animated:NO];
	 
	self.pageCurlBarItem.normalImage = [UIImage imageNamed:@"UIButtonBarPageCurlDefault.png"];
	self.pageCurlBarItem.highlightedImage = [UIImage imageNamed:@"UIButtonBarPageCurlSelectedDown.png"];
	self.pageCurlBarItem.styleDoneImage = [UIImage imageNamed:@"UIButtonBarPageCurlSelected.png"];
	self.pageCurlBarItem.style = UIBarButtonItemStyleBordered;
	 */
	
	//打开浮动工具条按钮
	/*
	UIBarButtonItem *fixedBarItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL] autorelease];
	fixedBarItem.width = 3;
	
	NSMutableArray *baritems = [NSMutableArray array];
	[baritems addObjectsFromArray:self.toolbar.items];
	[baritems addObject:self.openToolbarBarItem];
	[baritems addObject:fixedBarItem];
	[self.toolbar setItems:baritems animated:NO];
	 */
	
	//浮动工具栏
	self.toolbarFloatingView.hidden = YES;
	[self.view addSubview:self.toolbarFloatingView];
	
	self.mapsTypeButton = [[self.toolbarFloatingView buttons] objectAtIndex:0];
	self.satelliteTypeButton  = [[self.toolbarFloatingView  buttons] objectAtIndex:1];
	self.hybridTypeButton = [[self.toolbarFloatingView  buttons] objectAtIndex:2];
	
	
	
	//长按地图
	UILongPressGestureRecognizer *longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewLongPressed:)] autorelease];
    longPressGesture.minimumPressDuration = 0.75; //多长时间算长按
	[self.mapView addGestureRecognizer:longPressGesture];
	 
	
	//覆盖
	[self showMaskView];
	 
	//1.Alarm的坐标为中心，默认的span的region
	//2.最后显示的region的中心，默认的span的region
	//3.当前位置
	
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(-1000.0, -1000.0), 0.0, 0.0);
	if (CLLocationCoordinate2DIsValid(self.alarm.visualCoordinate)){  //1
		
		region = [self regionWithCoordinate:self.alarm.visualCoordinate radius:self.alarm.radius];
	
	}else if(YCMKCoordinateRegionIsValid([YCParam paramSingleInstance].lastLoadMapRegion)){ //2
		
		//region = [YCParam paramSingleInstance].lastLoadMapRegion;
		CLLocationCoordinate2D lastLoadMapRegionCenter = [YCParam paramSingleInstance].lastLoadMapRegion.center;//使用最后一次加载地图的中心坐标
		region = [self regionWithCoordinate:lastLoadMapRegionCenter radius:self.alarm.radius];

		
	}else { //3
		
		if (!self.mapView.userLocation.location) { //设备当前位置
			[self performSelector:@selector(endUpdateUserLocation) withObject:nil afterDelay:kTimeSpanForUserLocation];
		}else {
			region = [self regionWithCoordinate:self.mapView.userLocation.location.coordinate radius:self.alarm.radius];
		}
		
	}
	
	[self updateAnnotationAlarmEditing];//生成annotationAlarmEditing;
	[self registerNotifications];

	//检查网络
	[self performSelector:@selector(alertInternet) withObject:nil afterDelay:1.5];
	
	
	if (YCMKCoordinateRegionIsValid(region)) {
		//先到世界地图，在下来
		[self.mapView setRegion:region FromWorld:YES animatedToWorld:NO animatedToPlace:YES];
		//关掉覆盖视图
		[self animateCloseMaskView];

	}
	

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
	self.title = KViewTitleAlarmPostion;
    
	//浮动工具条
	self.openToolbarBarItem.style = UIBarButtonItemStyleBordered;
	self.toolbarFloatingView.hidden = YES;
	
	//除了第一次外，每次WillAppear都显示Searchbar。-animated:NO 
	if (!isFirstShow) {
		if (self.searchBar.hidden == YES) {
			[self performSelector:@selector(performShowBar:) withObject:self.searchBar afterDelay:1.5];
		}
		[self.curlbackgroundView resetTimeIntervalForHideSearchBar:kTimeIntervalForSearchBarHide];
		
		
		if (self.newAlarmAnnotation ){//从详细页面进入
			
			
			if (!YCCLLocationCoordinate2DEqualToCoordinate(self.alarm.visualCoordinate, self.annotationAlarmEditing.coordinate)) 
			{//并且坐标不相等
				
				//先移除
				[self.mapView removeAnnotation:self.annotationAlarmEditing];
				if (self.circleOverlay) { //删除警示圈
					[self.mapView removeOverlay:self.circleOverlay];
				}
				
				//更新
				[self updateAnnotationAlarmEditing];
				if (CLLocationCoordinate2DIsValid(self.annotationAlarmEditing.coordinate)){
					//中心
					[self.mapView setCenterCoordinate:self.annotationAlarmEditing.coordinate]; 
				}else {
					//alarm中的坐标无效，使用屏幕中心坐标
					self.annotationAlarmEditing.coordinate = self.mapView.centerCoordinate;
				}
				
				//加入Annotation
				//[self.mapView addAnnotation:self.annotationAlarmEditing];
				[self.mapView performSelectorOnMainThread:@selector(addAnnotation:) withObject:self.annotationAlarmEditing waitUntilDone:YES];
				
				
			}/*else {
				if (self.alarm.usedCoordinateAddress) //使用坐标作为地址
					self.annotationAlarmEditing.coordinate = self.alarm.coordinate; //为了激活通知,反转地址
				
			}*/

			
		}


	}
	
	
	self->isFirstShow = NO;
	 
}




-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	self.title = nil;
	
	[reverseGeocoder cancel];
	[forwardGeocoder cancel];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:mapView];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:self.annotationAlarmEditing];//取消所有约定执行
	
	
	//保存最后加载的区域
	if (self.mapView.region.span.latitudeDelta < 10.0) { //很大的地图就不存了
		[YCParam paramSingleInstance].lastLoadMapRegion = self.mapView.region;
		[[YCParam paramSingleInstance] saveParam];
	}

}


#pragma mark - 
#pragma mark - MKMapViewDelegate


//重新地图设备当前地址共享结束，设这个函数是为了别的地方同步调用
-(void) endUpdateUserLocation{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endUpdateUserLocation) object:nil];
	
	
	//设置地图region，一般在初次显示时候
	if (self.maskView.hidden == NO) {
		
		if (self.mapView.userLocation.location) {
			MKCoordinateRegion region = [self regionWithCoordinate:self.mapView.userLocation.location.coordinate radius:self.alarm.radius];
			if (YCMKCoordinateRegionIsValid(region)) //区域有有效
				[self.mapView setRegion:region FromWorld:YES animatedToWorld:YES animatedToPlace:YES];
		}
		
		//关掉覆盖视图
		[self animateCloseMaskView];
	}
	
	///////////////////////////////////
	//不显示了，就不需要反转当前地址了
	if(![self isViewAppeared]) 
		return;
	
	if (self.mapView.userLocation.location) //反转坐标－地址。延时调用
		[self performSelector:@selector(beginReverseWithAnnotation:) withObject:self.mapView.userLocation afterDelay:0.0]; 
	
	
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (userLocation.location == nil) //ios5.0 没有取得用户位置的时候也回调这个方法
        return;
	
	NSTimeInterval delay = 0.0;
	if (self.maskView.hidden == YES)
		delay = 0.0;
	else 
		delay = 3.0;//除了第一次显示外。多延时，免得影响其他

    userLocation.subtitle = nil; //位置已经更新，地址需要用新的
	[self performSelector:@selector(endUpdateUserLocation) withObject:nil afterDelay:delay]; 
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{

	for (NSUInteger i=0; i<views.count; i++) 
	{
		MKAnnotationView *annotationView = [views objectAtIndex:i];
		
		//当前位置
		if ([annotationView.annotation isKindOfClass:[MKUserLocation class]]) 
		{
			
			UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
			[rightButton addTarget:self
							action:@selector(showDetails:)
				  forControlEvents:UIControlEventTouchUpInside];
			annotationView.rightCalloutAccessoryView = rightButton;
		}
		
		IAAnnotation *annotation = (IAAnnotation*)annotationView.annotation;
		if ([annotation isKindOfClass:[IAAnnotation class]])
		{
			//选中
			[self.mapView performSelector:@selector(animateSelectAnnotation:) withObject:annotation afterDelay:0.75];
			
			//////////////////////////////////////////
			//反转
			if (!annotation.changedBySearch) 
			{//查询引起的坐标改变，不需要反转
				
				
				CLLocationCoordinate2D new = annotation.coordinate;
				CLLocationCoordinate2D old = self.alarm.visualCoordinate;
				if (!YCCLLocationCoordinate2DEqualToCoordinate(new, old)) { //坐标不相等
					annotation.subtitle = @"";
				}
				
				if (!YCCLLocationCoordinate2DEqualToCoordinate(new, old) || self.alarm.usedCoordinateAddress) { //坐标不相等 或使用的的是坐标地址
				//反转坐标－地址
					[self performSelector:@selector(beginReverseWithAnnotation:) withObject:annotation afterDelay:0.0];
				}else {
					annotation.subtitle = self.alarm.position;
				}
				
			}
			
			annotation.changedBySearch = NO;
			//////////////////////////////////////////
			
			/////////////////////////////////////////
			//警示圈
			if(self.circleOverlay){
				[NSObject cancelPreviousPerformRequestsWithTarget:self.mapView selector:@selector(addOverlay:) object:self.circleOverlay];
				[self.mapView removeOverlay:self.circleOverlay];
				//self.circleOverlay = nil;
			}
			self.circleOverlay = [MKCircle circleWithCenterCoordinate:annotation.coordinate	radius:self.alarm.radius];
			[self.mapView performSelector:@selector(addOverlay:) withObject:self.circleOverlay afterDelay:1.0];
			/////////////////////////////////////////
			
			
			//显示与当前位置的距离,pin落下x秒后再显示
			[self performSelector:@selector(setDistanceLabel) withObject:nil afterDelay:0.5];
				
		}

	}

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{
	IAAnnotation *annotation = (IAAnnotation*)annotationView.annotation;
	switch (newState) 
	{
			
		case MKAnnotationViewDragStateStarting:
			if (self.circleOverlay) { //隐藏警示圈
				//[self.mapView removeOverlay:self.circleOverlay];
				MKOverlayView *overlayView = [self.mapView viewForOverlay:self.circleOverlay];
				overlayView.hidden = YES;
			}
			
			//显示与当前位置的距离。因为拖拽会引发pin的deselect，所以在Starting和Dragging加入显示距离代码
			[self setDistanceLabel];
			
			break;
		case MKAnnotationViewDragStateDragging:
			if (self.circleOverlay) { //隐藏警示圈
				//[self.mapView removeOverlay:self.circleOverlay];
				MKOverlayView *overlayView = [self.mapView viewForOverlay:self.circleOverlay];
				overlayView.hidden = YES;
			}
			
			//显示与当前位置的距离。因为拖拽会引发pin的deselect，所以在Starting和Dragging加入显示距离代码
			[self setDistanceLabel];
			
			break;
		case MKAnnotationViewDragStateEnding:   //结束拖拽－大头针落下

			//////////////////////////////////////////
			//反转
			if ([annotation isKindOfClass:[IAAnnotation class]])
			{
				CLLocationCoordinate2D new = annotation.coordinate;
				CLLocationCoordinate2D old = self.alarm.visualCoordinate;
				if (!YCCLLocationCoordinate2DEqualToCoordinate(new, old)) { //坐标不相等
					annotation.subtitle = @"";
				}
				
				if (!YCCLLocationCoordinate2DEqualToCoordinate(new, old) || self.alarm.usedCoordinateAddress) { //坐标不相等 或使用的的是坐标地址
					//反转坐标－地址
					[self performSelector:@selector(beginReverseWithAnnotation:) withObject:annotation afterDelay:0.0];
				}else {
					annotation.subtitle = self.alarm.position;
				}
				
				
			}
			//////////////////////////////////////////
			

			
			/////////////////////////////////////////
			//警示圈
			//先取消掉
			if(self.circleOverlay){
				[NSObject cancelPreviousPerformRequestsWithTarget:self.mapView selector:@selector(addOverlay:) object:self.circleOverlay];
				[self.mapView removeOverlay:self.circleOverlay];
			}
			self.circleOverlay = [MKCircle circleWithCenterCoordinate:annotation.coordinate	radius:self.alarm.radius];
			[self.mapView performSelector:@selector(addOverlay:) withObject:self.circleOverlay afterDelay:1.0];
			/////////////////////////////////////////
			
			//显示与当前位置的距离
			[self setDistanceLabel];
			
			break;
		case MKAnnotationViewDragStateCanceling: //取消拖拽
			//显示警示半径圈
			if (self.circleOverlay) {
				
				MKCoordinateRegion overlayRegion = MKCoordinateRegionMakeWithDistance(self.circleOverlay.coordinate, self.circleOverlay.radius, self.circleOverlay.radius);
				CGRect overlayRect = [self.mapView convertRegion:overlayRegion toRectToView:self.mapView];
				double w = overlayRect.size.width;
				MKOverlayView *overlayView = [self.mapView viewForOverlay:self.circleOverlay];
				if (w <12) 
					overlayView.hidden = YES;
				else 
					overlayView.hidden = NO;
				
			}
			break;
		default:
			break;
			
	}
	
	
}



- (void)showDetails:(id)sender
{
	//back按钮
	self.title = nil;
	
	
	//取得当前操作的Annotation
	MKAnnotationView *annotationView = (MKAnnotationView *)((UIView*)sender).superview.superview;
	//self.annotationAlarmEditing = annotationView.annotation;
	
	AnnotationInfoViewController *annotationInfoViewCtl = [[AnnotationInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    annotationInfoViewCtl.annotation = annotationView.annotation;
	annotationInfoViewCtl.annotationTitle = annotationView.annotation.title;
	if (annotationView.annotation.subtitle !=nil) 
	{
		annotationInfoViewCtl.annotationSubtitle = annotationView.annotation.subtitle;
	}else { //annotation.subtitle 没有被赋值
		IAAlarm *alarmObj = self.alarm;
		annotationInfoViewCtl.annotationSubtitle = alarmObj.position;
	}

	self.newAlarmAnnotation = NO;  //从info返回，不重置
	self.navigationController.navigationBarHidden = NO;//在闹钟标签页面上显示navbar
	[self.navigationController pushViewController:annotationInfoViewCtl animated:YES];
	[annotationInfoViewCtl release];
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[MKUserLocation class]])
	{
		return nil;
	}
	
	static NSString* pinViewAnnotationIdentifier = @"pinViewAnnotationIdentifier";
	MKPinAnnotationView* pinView = (MKPinAnnotationView *)
	[mapView dequeueReusableAnnotationViewWithIdentifier:pinViewAnnotationIdentifier];
	
	if (!pinView)
	{
		//pinView = [[[MKPinAnnotationView alloc]
		//			initWithAnnotation:annotation reuseIdentifier:pinViewAnnotationIdentifier] autorelease];
		pinView = [[[IAAnnotationView alloc]
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
	
	//警示半径图
	IAAlarm *alarmTemp = self.alarm;
	NSString *imageName = alarmTemp.alarmRadiusType.alarmRadiusTypeImageName;
	imageName = [NSString stringWithFormat:@"20_%@",imageName]; //使用20像素的图标
	sfIconView.image = [UIImage imageNamed:imageName];
	
	
	pinView.leftCalloutAccessoryView = sfIconView;
	pinView.annotation = annotation;

	return pinView;
	
}
 


- (void)mapView:(MKMapView *)theMapView regionDidChangeAnimated:(BOOL)animated{
	//设置“回到正在编辑按钮”的可用状态。
	[self setCurrentPinBarItem];
	//设置“回到当前位置按钮”的可用状态。
	[self setLocationBarItem];
	
	//设置警示半径圈
	if (self.circleOverlay) {

		MKCoordinateRegion overlayRegion = MKCoordinateRegionMakeWithDistance(self.circleOverlay.coordinate, self.circleOverlay.radius, self.circleOverlay.radius);
		CGRect overlayRect = [self.mapView convertRegion:overlayRegion toRectToView:self.mapView];
		double w = overlayRect.size.width;
		MKOverlayView *overlayView = [self.mapView viewForOverlay:self.circleOverlay];
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
 

-(void)animateSetHidden:(BOOL)hidden circleView:(MKOverlayView*)circleView{

	CATransition *animation = [CATransition animation];   
	[animation setDuration:0.75];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	[animation setType:kCATransitionFade];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:YES];
	
	circleView.hidden = hidden;  
	[[circleView layer] addAnimation:animation forKey:@"HideOrShowCircleView"];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView
{
		
	/////////////////////////////////////////
	//警示圈
	IAAnnotation *annotation = (IAAnnotation*)annotationView.annotation;
	if ([annotation isKindOfClass:[IAAnnotation class]])
	{

		MKOverlayView *circleView = [self.mapView viewForOverlay:self.circleOverlay];
		[self animateSetHidden:NO circleView:circleView];
		
		//显示与当前位置的距离
		[self setDistanceLabel];
		
	}
	/////////////////////////////////////////
	
	
}


- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)annotationView{
	
	//隐藏警示圈
	IAAnnotation *annotation = (IAAnnotation*)annotationView.annotation;
	if ([annotation isKindOfClass:[IAAnnotation class]])
	{		
		MKOverlayView *circleView = [self.mapView viewForOverlay:self.circleOverlay];
		[self animateSetHidden:YES circleView:circleView];
		
		//没有选中，就不在显示距离
		CLLocation *location = [YCSystemStatus deviceStatusSingleInstance].lastLocation;
		if (location) {
			[self.navigationItem setTitleView:nil animated:YES];
		}else
			//self.navigationItem.titleView = [self cannotLocationTitleView];
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark Utility - ReverseGeocoder


#define kTimeOutForReverse 5.0

-(void)beginReverseWithAnnotation:(id<MKAnnotation>)annotation
{	
	//初始化，reverseGeocoder对象必须根据特定坐标init。
	reverseGeocoder = [self reverseGeocoder:annotation.coordinate];
	reverseGeocoder.delegate = self;
	
	//反转坐标
	//先赋空相关数据
	if ([annotation isKindOfClass:[IAAnnotation class]]) {
		self.placemarkForPin = nil; 
	}else if ([annotation isKindOfClass:[MKUserLocation class]]){
		self.placemarkForUserLocation = nil; 
	}

	[reverseGeocoder start];
	[self performSelector:@selector(endReverseWithAnnotation:) withObject:annotation afterDelay:kTimeOutForReverse];
}


-(void)endReverseWithAnnotation:(id<MKAnnotation>)annotation
{
	
	//如果超时了，反转还没结束，结束它
	if ([reverseGeocoder respondsToSelector:@selector(cancel)])
		[reverseGeocoder cancel];
	//取消掉另一个调用
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endReverseWithAnnotation:) object:annotation];
	
	
	///////////////////////////////////
	//已经被释放了
	if (![annotation respondsToSelector:@selector(coordinate)])
		return;
	if (![self isKindOfClass:[AlarmPositionMapViewController class]])
		return;
	///////////////////////////////////
	
	MKPlacemark *placemark = nil;
	if ([annotation isKindOfClass:[IAAnnotation class]]) {
		placemark = self.placemarkForPin; 
	}else if ([annotation isKindOfClass:[MKUserLocation class]]){
		placemark = self.placemarkForUserLocation; 
	}
	
	CLLocationCoordinate2D coordinate = annotation.coordinate;
	NSString *address = nil;
	
	if (placemark == nil) {
		//反转坐标 失败，使用坐标
		address = [UIUtility convertCoordinate:coordinate];
	}else {
		address = YCGetAddressString(placemark);
		address = (address != nil) ? address : [UIUtility convertCoordinate:coordinate];
	}
	
	if ([annotation isKindOfClass:[IAAnnotation class]]) {
		////////////
		//Done按钮使用
		((IAAnnotation*)annotation).placemarkForReverse = placemark;
		((IAAnnotation*)annotation).placeForSearch = nil;
		////////////
		
		if (![((IAAnnotation*)annotation).subtitle isEqualToString:address]) { //不相等，才赋值。
			//[(IAAnnotation*)annotation performSelector:@selector(setSubtitle:) withObject:address afterDelay:0.0];
			[(IAAnnotation*)annotation setSubtitle:address];
		}
		
		
	}else if ([annotation isKindOfClass:[MKUserLocation class]]){
		((MKUserLocation*)annotation).subtitle = address;
	}	
	
}


#pragma mark -
#pragma mark MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	///////////////////////////////////
	//已经被释放了
	if (![self isKindOfClass:[AlarmPositionMapViewController class]])
		return;
	///////////////////////////////////
	
	
	
	if (YCCLLocationCoordinate2DEqualToCoordinate(placemark.coordinate, self.annotationAlarmEditing.coordinate)) {
		self.placemarkForPin = placemark;
		[self endReverseWithAnnotation:self.annotationAlarmEditing];
	}
	if (YCCLLocationCoordinate2DEqualToCoordinate(placemark.coordinate, self.mapView.userLocation.location.coordinate)) {
		self.placemarkForUserLocation = placemark;
		[self endReverseWithAnnotation:self.mapView.userLocation];
	}
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	///////////////////////////////////
	//已经被释放了
	if (![self isKindOfClass:[AlarmPositionMapViewController class]])
		return;
	///////////////////////////////////
	
	//无网络连接时候，收到失败数据，就结束反转
	BOOL connectedToInternet = [[YCSystemStatus deviceStatusSingleInstance] connectedToInternet];
	if (!connectedToInternet) {
		if (YCCLLocationCoordinate2DEqualToCoordinate(geocoder.coordinate, self.annotationAlarmEditing.coordinate)) {
			self.placemarkForPin = nil;
			[self endReverseWithAnnotation:self.annotationAlarmEditing];
		}
		
		if (YCCLLocationCoordinate2DEqualToCoordinate(geocoder.coordinate, self.mapView.userLocation.location.coordinate)) {
			self.placemarkForUserLocation = nil;
			[self endReverseWithAnnotation:self.mapView.userLocation];
		}
	}

}

#pragma mark - BSForwardGeocoderDelegate & Utility

-(void)resetAnnotationWithPlace:(BSKmlResult*)place{
	
	IAAnnotation *annotationTemp = nil;
	annotationTemp = self.annotationAlarmEditing;
	
	
	///////
	NSString *address = nil;
	NSString *addressShort = nil;
	NSString *addressTitle = nil;
	
	address = place.address;
	address = [address trim];
	
	addressShort = place.address;
	addressShort = [addressShort trim];
	addressShort = (addressShort != nil) ? addressShort : address;
	
	addressTitle = self.forwardGeocoder.searchQuery;;
	addressTitle = [addressTitle trim];
	addressTitle = (addressTitle != nil) ? addressTitle : addressShort;
	
	//最后的判空
	addressTitle = (addressTitle != nil) ? addressTitle:KDefaultAlarmName;
	addressShort = (addressShort != nil) ? addressShort : [UIUtility convertCoordinate:place.coordinate];
	address = (address != nil) ? address : [UIUtility convertCoordinate:place.coordinate];
	//////
	
	
	place.searchString = addressTitle;
	
	////////////
	//Done按钮使用,
	annotationTemp.placemarkForReverse = nil;
	annotationTemp.placeForSearch = place;
	////////////
	self.annotationAlarmEditing.changedBySearch = YES;//通知中不再反转的条件
	
	
	annotationTemp.subtitle = address;
	annotationTemp.coordinate = place.coordinate; 
	
	
	
	//先删除原来的annotation
	if (annotationTemp)
		[self.mapView removeAnnotation:annotationTemp];
	
	if (self.circleOverlay) { //删除警示圈
		[self.mapView removeOverlay:self.circleOverlay];
	}
	
	////////////////////////
	//Zoom into the location
	MKCoordinateRegion region = place.coordinateRegion;
	if (!YCMKCoordinateRegionIsValid(region))
		region = [self regionWithCoordinate:annotationTemp.coordinate radius:self.alarm.radius];
	
	
	double delay = [self.mapView setRegion:region FromWorld:YES animatedToWorld:YES animatedToPlace:YES];
	//Zoom into the location
	////////////////////////
	
	
	//再加上
	[self.mapView performSelector:@selector(addAnnotation:) withObject:annotationTemp afterDelay:delay+0.1];
	

}

- (void)forwardGeocoderConnectionDidFail:(BSForwardGeocoder *)geocoder withErrorMessage:(NSString *)errorMessage
{
    if (searchAlert) {
        [searchAlert release];
        searchAlert = nil;
    }
    
    searchAlert = [[UIAlertView alloc] initWithTitle:kAlertSearchTitleDefaultError
                                             message:kAlertSearchBodyTryAgain 
                                            delegate:self
                                   cancelButtonTitle:kAlertBtnCancel
                                   otherButtonTitles:kAlertBtnRetry,nil];
    [searchAlert show];
    
    [self.searchController setActive:NO animated:YES];   //search取消
}


- (void)forwardGeocodingDidSucceed:(BSForwardGeocoder *)geocoder withResults:(NSArray *)results
{
    //加到最近查询list中
    [self.searchController addListContentWithString:geocoder.searchQuery];
    //保存查询结果，以后还要用
    [searchResults release]; searchResults = nil;
    searchResults = [results retain];
    
    NSInteger searchResultsCount = results.count;
    if (searchResultsCount == 1) {
        
        BSKmlResult *place = [results objectAtIndex:0];
        [self resetAnnotationWithPlace:place];
        
    }else if (searchResultsCount > 1){
        
        NSMutableArray *places = [NSMutableArray arrayWithCapacity:results.count];
        for(id oneObject in results)
            [places addObject:((BSKmlResult *)oneObject).address];
        
        if (searchResultsAlert) {
            [searchResultsAlert release];
            searchResultsAlert = nil;
        }
        searchResultsAlert = [[YCAlertTableView alloc] 
                              initWithTitle:kAlertSearchTitleResults delegate:self tableCellContents:places cancelButtonTitle:kAlertBtnCancel];
        [searchResultsAlert show];
        
        
    }else { //==0
        if (searchAlert) {
            [searchAlert release];
            searchAlert = nil;
        }
        searchAlert = [[UIAlertView alloc] initWithTitle:kAlertSearchTitleNoResults
                                                 message:kAlertSearchBodyTryAgain 
                                                delegate:self
                                       cancelButtonTitle:kAlertBtnCancel
                                       otherButtonTitles:kAlertBtnRetry,nil];
        [searchAlert show];
        
    }
    
    [self.searchController setActive:NO animated:YES];   //search取消
}

- (void)forwardGeocodingDidFail:(BSForwardGeocoder *)geocoder withErrorCode:(int)errorCode andErrorMessage:(NSString *)errorMessage
{
    if (searchAlert) {
        [searchAlert release];
        searchAlert = nil;
    }
    
    switch (errorCode) {
        case G_GEO_BAD_KEY:
            searchAlert = [[UIAlertView alloc] initWithTitle:kAlertSearchTitleDefaultError
                                                     message:kAlertSearchBodyTryAgain 
                                                    delegate:self
                                           cancelButtonTitle:kAlertBtnCancel
                                           otherButtonTitles:kAlertBtnRetry,nil];
            break;
            
        case G_GEO_UNKNOWN_ADDRESS:
            searchAlert = [[UIAlertView alloc] initWithTitle:kAlertSearchTitleNoResults
                                                     message:kAlertSearchBodyTryAgain 
                                                    delegate:self
                                           cancelButtonTitle:kAlertBtnCancel
                                           otherButtonTitles:kAlertBtnRetry,nil];
            
            break;
            
        case G_GEO_TOO_MANY_QUERIES:
            searchAlert = [[UIAlertView alloc] initWithTitle:kAlertSearchTitleTooManyQueries
                                                     message:kAlertSearchBodyTryTomorrow 
                                                    delegate:self
                                           cancelButtonTitle:kAlertBtnOK
                                           otherButtonTitles:nil];//只用1个按钮，而且不用retry
            
            break;
            
        case G_GEO_SERVER_ERROR:
            searchAlert = [[UIAlertView alloc] initWithTitle:kAlertSearchTitleDefaultError
                                                     message:kAlertSearchBodyTryAgain 
                                                    delegate:self
                                           cancelButtonTitle:kAlertBtnCancel
                                           otherButtonTitles:kAlertBtnRetry,nil];
            break;
            
            
        default:
            searchAlert = [[UIAlertView alloc] initWithTitle:kAlertSearchTitleDefaultError
                                                     message:kAlertSearchBodyTryAgain 
                                                    delegate:self
                                           cancelButtonTitle:kAlertBtnCancel
                                           otherButtonTitles:kAlertBtnRetry,nil];
            break;
    }
    
    [searchAlert show];
    
    [self.searchController setActive:NO animated:YES];   //search取消
}


#pragma mark -
#pragma mark YCSearchControllerDelegete methods

- (NSArray*)searchController:(YCSearchController *)controller searchString:(NSString *)searchString
{
	// 开始搜    
    MKMapRect bounds;
    CLLocation *curLocation = self.mapView.userLocation.location;
    if (curLocation) { //使用当前位置的附近 作为查询优先
        MKMapPoint curPoint = MKMapPointForCoordinate(curLocation.coordinate);
        bounds = MKMapRectMake(curPoint.x, curPoint.y, 6000, 6000); //取当前位置的x公里的范围
    }else{ //当前地图可视范围 作为查询优先
        bounds = self.mapView.visibleMapRect;
    }
    
    NSString *regionBiasing = nil;//@"cn";
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.forwardGeocoder forwardGeocodeWithQuery:searchString regionBiasing:regionBiasing viewportBiasing:bounds success:^(NSArray *results) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self forwardGeocodingDidSucceed:self.forwardGeocoder withResults:results];
        
    } failure:^(int status, NSString *errorMessage) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (status == G_GEO_NETWORK_ERROR) {
            [self forwardGeocoderConnectionDidFail:self.forwardGeocoder withErrorMessage:errorMessage];
        }
        else {
            [self forwardGeocodingDidFail:self.forwardGeocoder withErrorCode:status andErrorMessage:errorMessage];
        }
        
    }];
    
	return nil;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{		 
    //取消了，还没结束，结束它
    [self.forwardGeocoder cancel]; 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - UIAlertViewDelegate YCAlertTableViewDelegete

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	[self.curlbackgroundView startHideSearchBarAfterTimeInterval:kTimeIntervalForSearchBarHide];  //可以隐藏searchbar了
}

- (void)alertTableView:(YCAlertTableView *)alertTableView didSelectRow:(NSInteger)row{
	if (searchResultsAlert == alertTableView) {
        BSKmlResult *place = [searchResults objectAtIndex:row];
        [self resetAnnotationWithPlace:place];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == searchAlert) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kAlertBtnRetry]) {
            [self.searchController setActive:YES animated:YES];   //search状态
        }else if(alertView.cancelButtonIndex == buttonIndex){
            [self.searchController setActive:NO animated:YES];   //search取消
        }
    }else if (alertView == checkNetAlert && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kAlertBtnSettings]) {
        NSString *str = @"prefs:root=General&path=Network"; //打开设置中的网络
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - 
#pragma mark - init and create 
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarm:(IAAlarm*)theAlarm{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil alarm:theAlarm];
    if (self) {
		//[self annotationAlarmEditing];//生成annotationAlarmEditing;
		//[self registerNotifications];
	}
	
	return self;
}


#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    [super viewDidUnload];
	
	[reverseGeocoder cancel];
	[forwardGeocoder cancel];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:mapView];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:self.annotationAlarmEditing];//取消所有约定执行
	
	
	[self unRegisterNotifications];
	
	 self.mapView = nil;            
	 self.maskView = nil;                           
	 self.curlView = nil;                           
	 self.curlbackgroundView = nil;                 
	 self.curlImageView = nil;                      
	 self.searchBar = nil;
	 self.toolbar = nil;
	 self.mapTypeSegmented = nil;          
	 self.currentLocationBarItem = nil;       
	 self.currentPinBarItem = nil;            
	 self.searchBarItem = nil;                
	 self.resetPinBarItem = nil;              
	 self.pageCurlBarItem = nil;      
	
	 self.openToolbarBarItem = nil;           
	 self.toolbarFloatingView = nil;             
	 self.mapsTypeButton = nil;                
	 self.satelliteTypeButton = nil;                   
	 self.hybridTypeButton = nil;

}



- (void)dealloc 
{
	
	mapView.showsUserLocation = NO;  //停止地图的定位
	
	[reverseGeocoder cancel];
	[forwardGeocoder cancel];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:mapView];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:self.annotationAlarmEditing];//取消所有约定执行
	
	 
	[self unRegisterNotifications];
	
	if (mapView) { //防止crash
		[mapView removeAnnotations:mapView.annotations];
		[mapView removeOverlays:mapView.overlays];
	}
	
	////////////////////////////
	if (annotationAlarmEditing) {
		[annotationAlarmEditing removeObserver:self forKeyPath:@"coordinate"];
		[annotationAlarmEditing removeObserver:self forKeyPath:@"subtitle"];
		//[mapView removeAnnotation:annotationAlarmEditing]; //防止crash
	}
	[annotationAlarmEditing release];
	////////////////////////////

	[locationServicesUsableAlert release];
	[reverseGeocoder release];
	[placemarkForUserLocation release];
	[placemarkForPin release];
	
	[forwardGeocoder release];
	[searchController release];
    [searchResults release];
	
	[mapView release];            
	[maskView release];                           
	[curlView release];                           
	[curlbackgroundView release];          
	[curlImageView release];                    
	[searchBar release];
	[toolbar release];
	[mapTypeSegmented release];          
	[currentLocationBarItem release];       
	[currentPinBarItem release];            
	[searchBarItem release];                
	[resetPinBarItem release];              
	[pageCurlBarItem release];              
	[locationingBarItem release]; 
	


	[circleOverlay release];
	
	[openToolbarBarItem release];           
	[toolbarFloatingView release];             
	[mapsTypeButton release];                
	[satelliteTypeButton release];                   
	[hybridTypeButton release];
        
    [lastUpdateDistanceTimestamp release];
    
    [checkNetAlert release];
    [searchResultsAlert release];
    [searchAlert release];
 
	[super dealloc];
}




@end
 