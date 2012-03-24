//
//  AlarmRadiusViewController.m
//  iAlarm
//
//  Created by li shiyong on 11-1-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IAGlobal.h"
#import "YCAnnotation.h"
#import "YCLocationUtility.h"
#import "CustomPickerController.h"
#import "UIUtility.h"
#import "IAAlarm.h"
#import "IAAlarmRadiusType.h"
#import "DicManager.h"
#import "LocalizedString.h"
#import "AlarmRadiusViewController.h"
#include <math.h>


//Custom的行号
#define kCustomRow 3

@implementation AlarmRadiusViewController

#pragma mark -
#pragma mark property

@synthesize mapView;
@synthesize mapViewContainer;
@synthesize alarmRadiusPickerViewContainer;
@synthesize lastCircleOverlay;
@synthesize alarmRadiusPickerView;
@synthesize alarmRadiusUnitLabel;
@synthesize customPickerViewContainer;
@synthesize customPickerController;

-(double)alarmRadiusValue{
	double alarmRadius = 0.0;
	
	NSInteger row = [self.alarmRadiusPickerView selectedRowInComponent:0];
	if (kCustomRow == row) {
		alarmRadius = self.customPickerController.customAlarmRadiusValue;
	}else {
		IAAlarmRadiusType *alarmRadiusType = (IAAlarmRadiusType*)[[DicManager alarmRadiusTypeArray] objectAtIndex:row];
		alarmRadius = alarmRadiusType.alarmRadiusValue;
	}
	
	return alarmRadius;
}

/*
- (NSString*)alarmRadiusUnit{

	NSInteger n = ceil(self.alarmRadiusValue/1000.0);
	NSString *temple= kAlarmRadiusUnitKilometre;
	if (n > 1) //复数
		temple= kAlarmRadiusUnitKilometres;
	
	return temple;
}
 */

-(double)alarmRadiusValueForRow:(NSInteger)row{
	double alarmRadius = 0.0;	
	if (kCustomRow == row) {
		alarmRadius = self.customPickerController.customAlarmRadiusValue;
	}else {
		IAAlarmRadiusType *alarmRadiusType = (IAAlarmRadiusType*)[[DicManager alarmRadiusTypeArray] objectAtIndex:row];
		alarmRadius = alarmRadiusType.alarmRadiusValue;
	}
	
	return alarmRadius;
}

/*
- (NSString*)alarmRadiusUnitForRow:(NSInteger)row{
	
	NSInteger n = ceil([self alarmRadiusValueForRow:row]/1000.0);
	NSString *temple= kAlarmRadiusUnitKilometre;
	if (n > 1) //复数
		temple= kAlarmRadiusUnitKilometres;
	
	return temple;
}
 */



-(id)middlePointAnnotion{
	if (middlePointAnnotion == nil) {
		middlePointAnnotion = [[YCAnnotation alloc] initWithIdentifier:@"middlePointAnnotion"];
	}
	
	return middlePointAnnotion;
}

#pragma mark -
#pragma mark Events Handle

-(IBAction)doneButtonPressed:(id)sender
{	
	NSInteger row = [self.alarmRadiusPickerView selectedRowInComponent:0];
	self.alarm.alarmRadiusType = [[DicManager alarmRadiusTypeArray] objectAtIndex:row];
	self.alarm.alarmRadiusTypeId = self.alarm.alarmRadiusType.alarmRadiusTypeId;
	double rd = [self alarmRadiusValue];
	self.alarm.radius = (rd < kMixAlarmRadius) ? kMixAlarmRadius:rd;
	
	[self.navigationController popViewControllerAnimated:YES];
	
	[super doneButtonPressed:sender];
	 
}


#pragma mark -
#pragma mark Utility
-(void)updateAlarmRadiusCircleOverlay:(MKCircle*)circleOverlay{
	
	[self.mapView removeAnnotation:self.middlePointAnnotion]; //删除半径标签提示
	[self.mapView removeOverlays:self.mapView.overlays];
	[self.mapView addOverlay:circleOverlay];
	
}

-(void)animateUpdateAlarmRadiusCircleOverlay:(MKCircle*)circleOverlay{
	
	
	CATransition *animation = [CATransition animation];  
	//[animation setDelegate:self];  
	[animation setDuration:0.70];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	[animation setType:kCATransitionFade];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:YES];
	NSString *subtype = nil;
	[animation setSubtype:subtype];
	
	[self updateAlarmRadiusCircleOverlay:circleOverlay];
	
	[[self.mapView layer] addAnimation:animation forKey:@"updateAlarmRadiusCircleOverlay"];
	 
	/*
	if (self.lastCircleOverlay) {
		CLLocationDistance lastRadius = self.lastCircleOverlay.radius;
		CLLocationDistance newRadius  = circleOverlay.radius;
		
		MKMapRect lastMapRect = self.lastCircleOverlay.boundingMapRect;
		MKMapRect newMapRect  = circleOverlay.boundingMapRect;
		MKCoordinateRegion lastRegion = MKCoordinateRegionForMapRect(lastMapRect);
		MKCoordinateRegion newRegion  = MKCoordinateRegionForMapRect(newMapRect);
		
		CGRect lastRect = [self.mapView convertRegion:lastRegion toRectToView:self.mapView];
		CGRect newRect  = [self.mapView convertRegion:newRegion  toRectToView:self.mapView];
		
		NSInteger updateValue = abs( (NSInteger)(newRect.size.width - lastRect.size.width) );
		if (updateValue > 2) {
			if (updateValue >20) updateValue = 20;
			CLLocationCoordinate2D centerCoordinate = circleOverlay.coordinate;
			for (NSInteger i = 0; i < updateValue; i++) {
				CLLocationDistance tempRadius = (lastRadius >= newRadius)?(lastRadius-(lastRadius - newRadius)/updateValue):(lastRadius+(newRadius - lastRadius)/updateValue);
				
				MKCircle *circle = [MKCircle circleWithCenterCoordinate:centerCoordinate radius:tempRadius];
				[self performSelector:@selector(updateAlarmRadiusCircleOverlay:) withObject:circle afterDelay:i*5/20];
				//[self updateAlarmRadiusCircleOverlay:circle];
			}
		}
		
	}
	 */
	
	
}

//为了延时调用
-(void)animateSetMapRegionObj:(id/*MKCoordinateRegion*/)obj{
	MKCoordinateRegion target;
	[obj getValue:&target];
	[self.mapView setRegion:target animated:YES];
}



//警示半径－最大值
#define kMaxCircleRadius                    (190.0/2)

//警示半径－最小值
#define kMinCircleRadius                    (160.0/2)

//地图的宽
#define kWidthOfMap                         (320.0)

//地图的高
#define kHightOfMap                         (200.0)

//地图的宽高较短的一边
#define kMinSideWidthAndHightOfMap          kHightOfMap

//所在地图的边长（短边）与最大半径圆直径的比例
#define kRateOfMapAndMaxCircleDiameter      (200.0/190.0)

//地图的宽高比
#define kRateOfWidthAndHightInMap           (kWidthOfMap/kHightOfMap)


-(void)setCircleOverlayAndMapRegionWithAlarmRadius:(CLLocationDistance)alarmRadius{
	
	CLLocationCoordinate2D centerCoordinate = self.alarm.coordinate;
	if (!CLLocationCoordinate2DIsValid(centerCoordinate)) {
		centerCoordinate = YCDefaultCoordinate(); //缺省坐标－apple公司总部坐标
	}
	MKCoordinateRegion newCircleRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, alarmRadius*2, alarmRadius*2);
	
	
	//新的圆，画在地图上
	MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:centerCoordinate radius:alarmRadius];
	if (self->isFirstShow) //改变半径圈的大小
		[self updateAlarmRadiusCircleOverlay:circleOverlay];
	else 
		[self animateUpdateAlarmRadiusCircleOverlay:circleOverlay];
	
	//MKMapRect newCircleMapRect = circleOverlay.boundingMapRect;
	//MKCoordinateRegion newCircleRegion = MKCoordinateRegionForMapRect(newCircleMapRect);
		

	//包括圆的矩形－画完改变后新的
	CGRect newCircleRect = [self.mapView convertRegion:newCircleRegion toRectToView:self.mapView];
	
	//判断是否需要改变地图：通过检测圈直径(像素),
	BOOL b =
	(newCircleRect.size.width > kMaxCircleRadius*2 || newCircleRect.size.height > kMaxCircleRadius*2)
	|| 
	(newCircleRect.size.width < kMinCircleRadius*2 || newCircleRect.size.height < kMinCircleRadius*2);
	
	if (b) {
		
		/*
		 //根据包括圆的矩形的区域，得到地图区域:宽 = 宽*(200/180),高 = 高*(200/180)
		 CLLocationDegrees latitudeDelta = newCircleRegion.span.latitudeDelta *kRateOfMapAndMaxCircleDiameter;
		 CLLocationDegrees longitudeDelta = newCircleRegion.span.longitudeDelta *kRateOfMapAndMaxCircleDiameter;
		 MKCoordinateSpan newSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
		 MKCoordinateRegion newMapRegion = MKCoordinateRegionMake(centerCoordinate, newSpan);
		 //修正
		 MKCoordinateRegion newMapRegionFited = [self.mapView regionThatFits:newMapRegion];
		*/
		 
		MKCoordinateRegion newMapRegionFited = newCircleRegion;//[self.mapView regionThatFits:newCircleRegion];
		if (self->isFirstShow){
			[self.mapView setRegion:newMapRegionFited animated:NO];
		}else {
			NSValue *obj = [NSValue valueWithBytes:&newMapRegionFited objCType:@encode(MKCoordinateRegion)];
			[self performSelector:@selector(animateSetMapRegionObj:) withObject:obj afterDelay:0.75];//播放上个动画需要时间
		}
	}
	
	
}

#pragma mark -
#pragma mark Notification

//警示半径改变
- (void) handle_alarmRadiusDidChange: (id) notification {
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	CLLocationDistance newAlarmRadius = [self alarmRadiusValue];
	[self setCircleOverlayAndMapRegionWithAlarmRadius:newAlarmRadius];
}


//在custom picker上选中的不是Custom行
- (void) handle_didDeSelecteCustomRow: (id) notification {
	[self animateSetCustomPickerShowOrHide];
	
	
	selectedRowForCustomPicker = [self.customPickerController.pickerView selectedRowInComponent:0];
	inComponentForCustomPicker = 0;
	isAnimatedForAlarmRadiusPicker = YES;

	//延时执行
	//[self.alarmRadiusPickerView selectRow:selectedRowForCustomPicker inComponent:0 animated:YES];
	SEL selector = @selector(selectRow:inComponent:animated:);
	NSMethodSignature *signature = [self.alarmRadiusPickerView methodSignatureForSelector:selector];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self.alarmRadiusPickerView];
	[invocaton setSelector:selector];
	[invocaton setArgument:&selectedRowForCustomPicker atIndex:2];  //self,_cmd分别占据0、1
	[invocaton setArgument:&inComponentForCustomPicker atIndex:3];
	[invocaton setArgument:&isAnimatedForAlarmRadiusPicker atIndex:4];
	[invocaton performSelector:@selector(invoke) withObject:nil afterDelay:0.3];
	
	/*
	///////////////////////////////////////////
	//单位的单复数
	NSString *unit = [self alarmRadiusUnitForRow:selectedRowForCustomPicker];
	[self.alarmRadiusUnitLabel performSelector:@selector(setText:) withObject:unit afterDelay:0.3];
	///////////////////////////////////////////
	*/
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmRadiusDidChangeNotification object:self];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.4];	
	
	
}


- (void) registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmRadiusDidChange:)
							   name: IAAlarmRadiusDidChangeNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_didDeSelecteCustomRow:)
							   name: IAAlarmDidDeSelecteCustomRowNotification
							 object: nil];
}

- (void) unRegisterNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter removeObserver: self
								  name: IAAlarmRadiusDidChangeNotification
							    object: nil];
	
	[notificationCenter removeObserver: self
								  name: IAAlarmDidDeSelecteCustomRowNotification
							    object: nil];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.mapView.delegate = self;
	self.title = KViewTitleAlarmRadius;
	[self registerNotifications];

}

- (void)viewWillAppear:(BOOL)animated{  
	[super viewWillAppear:animated];
	
	isFirstShow = YES;
	
	self.customPickerViewContainer.hidden = YES;
	[self.customPickerController updatePickerViewWithAlarmRadius:self.alarm.radius];  //更新CustomPicker的显示
	
	//是否显示CustomPicker
	//id obj = [[DicManager alarmRadiusTypeDictionary] objectForKey:self.alarm.AlarmRadiusTypeId];
	id obj = self.alarm.alarmRadiusType;
	NSInteger row = [[DicManager alarmRadiusTypeArray] indexOfObject:obj];
	if (row != NSNotFound) {
		[self.alarmRadiusPickerView selectRow:row inComponent:0 animated:NO];
		if (kCustomRow == row) {
			self.customPickerViewContainer.hidden = NO;
		}
	}
	
	
	//大头针
	CLLocationCoordinate2D coordinate = self.alarm.coordinate;
	if (!CLLocationCoordinate2DIsValid(coordinate)) {
		coordinate = YCDefaultCoordinate(); //缺省作弊－apple公司总部坐标
	}
	[self.mapView removeAnnotations:self.mapView.annotations];
	MKPlacemark *annotation = [[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil] autorelease];
	//[self.mapView addAnnotation:annotation];
	[self.mapView performSelectorOnMainThread:@selector(addAnnotation:) withObject:annotation waitUntilDone:YES];
	//[self.mapView performSelector:@selector(addAnnotation:) withObject:annotation afterDelay:0.0];

	
	//圈、线、线标签
	CLLocationDistance alarmRadius = self.alarm.radius;
	[self setCircleOverlayAndMapRegionWithAlarmRadius:alarmRadius];
	
	/*
	///////////////////////////////////////////
	//单位的单复数
	self.alarmRadiusUnitLabel.text = self.alarmRadiusUnit;
	///////////////////////////////////////////
	 */
	self.alarmRadiusUnitLabel.text = kUnitKilometre;
	
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	isFirstShow = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:mapView];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:alarmRadiusPickerView];  //取消所有约定执行
}




#pragma mark -
#pragma mark Utility
-(void)animateSetCustomPickerShowOrHide{
	CATransition *animation = [CATransition animation];  
	//[animation setDelegate:self];  
	[animation setDuration:0.70];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	[animation setType:kCATransitionPush];
	[animation setFillMode:kCAFillModeForwards];
	[animation setRemovedOnCompletion:YES];
	NSString *subtype = nil;
	
	BOOL isHidden = self.customPickerViewContainer.hidden;
	if (isHidden == YES) 
		subtype = kCATransitionFromTop;
	else 
		subtype = kCATransitionFromBottom;
	[animation setSubtype:subtype];	
	
	self.customPickerViewContainer.hidden = !isHidden;
	
	[[self.customPickerViewContainer layer] addAnimation:animation forKey:@"Custom Picker Hide or Show"];
	
}

#pragma mark -
#pragma mark UIPickerViewDelegate

//解决轮子滚动后上不上，下不下的问题
-(void)delaySelectRowAtPickerView:(UIPickerView *)pickerView{
	NSInteger row = [pickerView selectedRowInComponent:0];
	[pickerView selectRow:row inComponent:0 animated:YES]; 
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	[self performSelector:@selector(delaySelectRowAtPickerView:) withObject:pickerView afterDelay:0.5];//解决轮子滚动后上不上，下不下的问题
	
	if (kCustomRow == row) {  
		NSInteger selectedRow = [self.alarmRadiusPickerView selectedRowInComponent:0];
		[self.customPickerController.pickerView selectRow:selectedRow inComponent:0 animated:NO];
		
		[self animateSetCustomPickerShowOrHide];
	}
	
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmRadiusDidChangeNotification object:self];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];	
	
	/*
	///////////////////////////////////////////
	//单位的单复数
	self.alarmRadiusUnitLabel.text = self.alarmRadiusUnit;
	///////////////////////////////////////////
	 */
	
}

#define KRadiusComponentWidth   250.0
#define KRadiusComponentHeight  32.0

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{	
	return KRadiusComponentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return KRadiusComponentHeight+8;
}

- (UIView *)labelCellWidth:(CGFloat)width rightOffset:(CGFloat)offset viewForRow:(NSInteger)row{
	
	NSArray *array = [DicManager alarmRadiusTypeArray];
	
	
	NSString *imageName = [(IAAlarmRadiusType*)[array objectAtIndex:row] alarmRadiusTypeImageName];	
	UIImageView *subImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
	subImageView.frame = CGRectMake(15, (KRadiusComponentHeight-16)/2,16, 16);
	subImageView.backgroundColor = [UIColor clearColor];
	subImageView.userInteractionEnabled = NO;
	

	
	CGFloat subLeftLabelWidth = 200.0;
	CGRect subLeftLabelFrame = CGRectMake(35, 0, subLeftLabelWidth, KRadiusComponentHeight); //左空出20
	UILabel *subLeftLabel = [[[UILabel alloc] initWithFrame:subLeftLabelFrame] autorelease];
	subLeftLabel.textAlignment = UITextAlignmentLeft;
	subLeftLabel.backgroundColor = [UIColor clearColor];
	subLeftLabel.font = [UIFont boldSystemFontOfSize:20.0];
	subLeftLabel.shadowColor = [UIColor whiteColor];
	subLeftLabel.shadowOffset = CGSizeMake(0, 1);
	subLeftLabel.userInteractionEnabled = NO;
	NSString *alarmRadiusName = [(IAAlarmRadiusType*)[array objectAtIndex:row] alarmRadiusName];
	subLeftLabel.text = alarmRadiusName;
	 
	
	CGRect subRightLabelFrame = CGRectMake(20,0,KRadiusComponentWidth-20-offset, KRadiusComponentHeight);//与上个Label重叠，但是是右对齐
	UILabel *subRightLabel = [[[UILabel alloc] initWithFrame:subRightLabelFrame] autorelease];
	subRightLabel.textAlignment = UITextAlignmentRight;
	subRightLabel.backgroundColor = [UIColor clearColor];
	subRightLabel.font = [UIFont boldSystemFontOfSize:21.0];
	subRightLabel.shadowColor = [UIColor whiteColor];
	subRightLabel.shadowOffset = CGSizeMake(0, 1);
	subRightLabel.userInteractionEnabled = NO;
	NSString *alarmRadiusValue = [NSString stringWithFormat:@"%.1f",[(IAAlarmRadiusType*)[array objectAtIndex:row] alarmRadiusValue]/1000]; //显示单位公里
	subRightLabel.text = alarmRadiusValue;
	if (kCustomRow == row) subRightLabel.text = @"....";

	
	CGRect viewFrame = CGRectMake(0.0, 0.0, width, KRadiusComponentHeight);
	UIView *view = [[[UIView alloc] initWithFrame:viewFrame] autorelease];
	[view addSubview:subImageView];
	[view addSubview:subLeftLabel];
	[view addSubview:subRightLabel];
	
	
	return view;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component 
		   reusingView:(UIView *)view
{
	CGFloat offset = self.alarmRadiusUnitLabel.frame.size.width+10.0; //让出单位“kms”的位置，再空出10
	return [self labelCellWidth:KRadiusComponentWidth rightOffset:offset viewForRow:row];
}
 

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [[DicManager alarmRadiusTypeArray] count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

#pragma mark - 
#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[MKUserLocation class]])
	{
		return nil;
	}
	
	static NSString* pinViewAnnotationIdentifier = nil;
	
	if ([annotation isKindOfClass:[YCAnnotation class]]) {
		pinViewAnnotationIdentifier = @"edgeViewAnnotationIdentifier";
		MKAnnotationView* middlePointView = (MKPinAnnotationView *)
		[theMapView dequeueReusableAnnotationViewWithIdentifier:pinViewAnnotationIdentifier];
		
		if (!middlePointView)
		{
			middlePointView = [[[MKAnnotationView alloc]
						initWithAnnotation:annotation reuseIdentifier:pinViewAnnotationIdentifier] autorelease];
			
			middlePointView.canShowCallout = YES;
			middlePointView.draggable = NO;
			//middlePointView.userInteractionEnabled = NO;
		}
		
		UIImageView *sfIconView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
		NSInteger row = [self.alarmRadiusPickerView selectedRowInComponent:0];
		NSString *imageName = [(IAAlarmRadiusType*)[[DicManager alarmRadiusTypeArray] objectAtIndex:row] alarmRadiusTypeImageName];
		imageName = [NSString stringWithFormat:@"20_%@",imageName]; //使用20像素的图标
		sfIconView.image = [UIImage imageNamed:imageName];
		middlePointView.leftCalloutAccessoryView = sfIconView;
		
		//标签，例如：3.0kms
		CLLocationDistance radius = [self alarmRadiusValue];
		((YCAnnotation*)annotation).title =  [UIUtility convertDistance:radius];
		
		return middlePointView;
	}else {
		pinViewAnnotationIdentifier = @"pinViewAnnotationIdentifier";
		
		MKPinAnnotationView* pinView = (MKPinAnnotationView *)
		[theMapView dequeueReusableAnnotationViewWithIdentifier:pinViewAnnotationIdentifier];
		
		if (!pinView)
		{
			pinView = [[[MKPinAnnotationView alloc]
						initWithAnnotation:annotation reuseIdentifier:pinViewAnnotationIdentifier] autorelease];
			
			pinView.canShowCallout = NO;
			pinView.draggable = NO;
			//pinView.userInteractionEnabled = NO;
			pinView.pinColor = MKPinAnnotationColorGreen;
			
		}
		
		return pinView;
	}

	
}

/*
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
	//[self.mapView selectAnnotation:middlePointAnnotion animated:NO];  //必须显示警示距离提示
	//view.selected = YES;
	[view setSelected:YES animated:YES];
}
 */


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
	
	if ([overlay isKindOfClass:[MKCircle class]]) {
		MKCircleView *cirecleView = nil;
		cirecleView = [[[MKCircleView alloc] initWithCircle:overlay] autorelease];
		//cirecleView.fillColor = [UIColor colorWithRed:0.0902 green:0.3804 blue:0.9176 alpha:0.1]; //淡蓝几乎透明
		//cirecleView.strokeColor = [UIColor colorWithRed:0.0 green:0.3725 blue:0.7922 alpha:1.0];   //蓝
		cirecleView.fillColor = [UIColor colorWithRed:160.0/255.0 green:127.0/255.0 blue:255.0/255.0 alpha:0.35]; //淡紫几乎透明
		cirecleView.strokeColor = [UIColor whiteColor];   //白
		cirecleView.lineWidth = 2.0;
		return cirecleView;

	}else if ([overlay isKindOfClass:[MKPolyline class]]) {
		MKPolylineView *lineView = nil;
		lineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
		//lineView.fillColor = [UIColor redColor]; 
		//lineView.strokeColor = [UIColor colorWithRed:0.0 green:0.3725 blue:0.7922 alpha:1.0];   //蓝
		lineView.strokeColor = [UIColor colorWithRed:160.0/255.0 green:127.0/255.0 blue:255.0/255.0 alpha:1.0];   //紫
		lineView.strokeColor =  [UIColor whiteColor];   //白
		lineView.lineWidth = 2.0;
		return lineView;
	}
	
	return nil;
}

//为了延时调用
-(void)animateSelectAnotation:(id)annotation{
	//[self.mapView selectAnnotation:annotation animated:YES]; 
	[self.mapView selectAnnotation:annotation animated:NO]; //使用动画，快速切换会有问题
}

- (void)mapView:(MKMapView *)theMapView didAddAnnotationViews:(NSArray *)views{
	for (id oneObj in views) {
		id annotation = ((MKAnnotationView*)oneObj).annotation;
		if ([ annotation isKindOfClass:[YCAnnotation class]]) {
			[self performSelector:@selector(animateSelectAnotation:) withObject:annotation afterDelay:0.3];
		}
	}
}

//为了延时调用
-(void)addRadiusLineAndMiddleAnnotionWithCircleOverlay:(MKCircle*)circleOverlay{
	
	//原始的坐标与半径 －WGS84坐标系统
	CLLocationDistance radius = circleOverlay.radius;
	CLLocationCoordinate2D center = circleOverlay.coordinate;
	
	
	//在屏幕坐标系的下的坐标与半径
	MKCoordinateRegion region1 = MKCoordinateRegionMakeWithDistance(center, radius, radius);
	CGRect rect1 = [self.mapView convertRegion:region1 toRectToView:self.mapView];
	CGFloat radiusView = rect1.size.width;
	CGPoint centerView = [self.mapView convertCoordinate:center toPointToView:self.mapView];
	
	//得到偏移点 －屏幕坐标系的
	double offsetValue = 2*M_PI * (120.0/360.0);  //向下偏移60度
	CGFloat edgeView_x = centerView.x - cos(offsetValue) * radiusView;  
	CGFloat edgeView_y = centerView.y + sin(offsetValue) * radiusView;
	CGPoint edgeView = CGPointMake(edgeView_x, edgeView_y);
	
	CGFloat middleView_x = centerView.x - cos(offsetValue) * radiusView*0.85; //取线上一点,在线中后段，不遮挡其他 
	CGFloat middleView_y = centerView.y + sin(offsetValue) * radiusView*0.85;
	CGPoint middleView = CGPointMake(middleView_x, middleView_y);
	
	
	//偏移点 －WGS84坐标系统
	CLLocationCoordinate2D edge = [self.mapView convertPoint:edgeView toCoordinateFromView:self.mapView];
	CLLocationCoordinate2D middle = [self.mapView convertPoint:middleView toCoordinateFromView:self.mapView];
	
	//加线
	CLLocationCoordinate2D coords[2] = {center,edge};
	MKPolyline *lineOverlay = [MKPolyline polylineWithCoordinates:coords count:2];
	[self.mapView addOverlay:lineOverlay];
	
	//加线标签
	self.middlePointAnnotion.coordinate = middle;
	//self.middlePointAnnotion.title = [UIUtility convertDistance:radius];
	[self.mapView removeAnnotation:self.middlePointAnnotion];
	[self.mapView addAnnotation:self.middlePointAnnotion];
}


- (void)mapView:(MKMapView *)theMapView didAddOverlayViews:(NSArray *)overlayViews{
	for (id oneObj in overlayViews) {
		if ([ oneObj isKindOfClass:[MKCircleView class]]) {

			NSTimeInterval delay = isFirstShow ? 0.0:3.0;
			
			MKCircleView *obj = oneObj;
			MKCircle *circleOverlay = obj.circle;
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addRadiusLineAndMiddleAnnotionWithCircleOverlay:) object:self.lastCircleOverlay];
			[self performSelector:@selector(addRadiusLineAndMiddleAnnotionWithCircleOverlay:) withObject:circleOverlay afterDelay:delay];
			self.lastCircleOverlay = circleOverlay;
			
		}
	}
	
}
 



#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    [super viewDidUnload];
	[self unRegisterNotifications];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:mapView];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:alarmRadiusPickerView];  //取消所有约定执行
	
	self.mapView = nil;
	self.mapViewContainer = nil;
	
	self.alarmRadiusPickerViewContainer = nil;
	self.alarmRadiusPickerView = nil;
	self.alarmRadiusUnitLabel = nil;
	
	self.customPickerViewContainer = nil;
	self.customPickerController = nil;
}


- (void)dealloc {
	[self unRegisterNotifications];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:mapView];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:alarmRadiusPickerView];  //取消所有约定执行
	if (mapView) { //防止crash
		[mapView removeAnnotations:mapView.annotations];
		[mapView removeOverlays:mapView.overlays];
	}
	
	
	[mapView release];
	[mapViewContainer release];
	[middlePointAnnotion release];
	[lastCircleOverlay release];
	
	[alarmRadiusPickerViewContainer release];
	[alarmRadiusPickerView release];
	[alarmRadiusUnitLabel release];
	
	[customPickerViewContainer release];
	[customPickerController release];
    [super dealloc];
}


@end
