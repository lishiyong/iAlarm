//
//  IAAlarmFindViewController.m
//  iAlarm
//
//  Created by li shiyong on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IANotifications.h"
#import "YCSystemStatus.h"
#import "LocalizedString.h"
#import "NSString-YC.h"
#import "IAAlarm.h"
#import "IAAlarmNotification.h"
#import "UIColor+YC.h"
#import <QuartzCore/QuartzCore.h>
#import "IAAlarmFindViewController.h"


@interface MapPointAnnotation : NSObject<MKAnnotation> {
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic) CLLocationDistance distanceFromCurrentLocation;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coord title:(NSString *) theTitle subTitle:(NSString *) theSubTitle;

@end


@implementation MapPointAnnotation
@synthesize coordinate, title, subtitle, distanceFromCurrentLocation;

-(id) initWithCoordinate:(CLLocationCoordinate2D) coord title:(NSString *) theTitle subTitle:(NSString *) theSubTitle{
    self = [super init];
    if (self) {
        coordinate = coord;
        title = [theTitle copy];
        subtitle = [theSubTitle copy];
        distanceFromCurrentLocation = -1.0; //小于0，表示未初始化
    }
    return self;
}

- (void)dealloc{
    [title release];
    [subtitle release];
    [super dealloc];
}

@end


@interface IAAlarmFindViewController(private)

- (UIImage*)takePhotoFromTheMapView;
- (void)loadViewDataWithIndexOfNotifications:(NSInteger)index;
- (void)setDistanceWithCurrentLocation:(CLLocation*)location;//显示距离当前位置XX公里
- (void)registerNotifications;
- (void)unRegisterNotifications;

@end


@implementation IAAlarmFindViewController

#pragma mark - property

@synthesize tableView;
@synthesize mapViewCell, containerView, mapView, imageView, timeStampLabel, timeStampBackgroundView;
@synthesize buttonCell, button1, button2, button3;
@synthesize notesCell;

- (id)doneButtonItem{
	
	if (!self->doneButtonItem) {
		self->doneButtonItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								target:self
								action:@selector(doneButtonItemPressed:)];
	}
	
	return self->doneButtonItem;
}

- (id)upDownBarItem{
    if (!upDownBarItem) {
        UISegmentedControl *segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                                                [NSArray arrayWithObjects:
                                                 [UIImage imageNamed:@"UIButtonBarArrowUpSmall.png"],
                                                 [UIImage imageNamed:@"UIButtonBarArrowDownSmall.png"],
                                                 nil]] autorelease];
        
        [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        segmentedControl.frame = CGRectMake(0, 0, 90, 30);
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.momentary = YES;
        
        upDownBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
        
    }
    return upDownBarItem;
}

/*
cell使用后height竟然会加1。奇怪！
   所以必须每次都重新做它的frame。
 注意：IBOutlet类型，在view加载后在使用下面属性，才会有正确的frame。
 */

- (UIColor*)clearCellBackupgroundColor{ 
    //根据ios版本,为透明颜色的cell采用不同的背景色
    NSString *systemVerionString = [[UIDevice currentDevice] systemVersion];
    float systemVerion = [systemVerionString floatValue];
    if (systemVerion - 5.0 >= 0.0) //5.0以上
        return [UIColor clearColor];
    else
        return [UIColor groupTableViewBackgroundColor];
    //5.0以下 cell背景设成透明后，显示背景后面竟然是黑的。没搞懂，到底是谁的颜色。
}

- (id)mapViewCell{
    mapViewCell.backgroundColor = [self clearCellBackupgroundColor];
    mapViewCell.frame = CGRectMake(0, 0, 300, 195);
    return mapViewCell;
}

- (id)notesCell{
    notesCell.backgroundColor = [self clearCellBackupgroundColor];
    notesCell.frame = CGRectMake(0, 0, 300, 0);
    return notesCell;
}

- (id)buttonCell{
    buttonCell.backgroundColor = [self clearCellBackupgroundColor]; 
    buttonCell.frame = CGRectMake(0, 0, 300, 108);
    return buttonCell;
}
 
#pragma mark - Controll Event
- (IBAction)tellFriendsButtonPressed:(id)sender{
    
}
- (IBAction)delayAlarm10ButtonPressed:(id)sender{
    
}
- (IBAction)delayAlarm30ButtonPressed:(id)sender{
    
}


- (void)doneButtonItemPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)segmentAction:(id)sender
{
    NSInteger index = 0;
    if (!viewedAlarmNotification) {
        [self loadViewDataWithIndexOfNotifications:index];
        return;
    }
    
    NSString *animationSubtype = nil;
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            index = [alarmNotifitions indexOfObject:viewedAlarmNotification] - 1; //up
            animationSubtype = kCATransitionFromBottom;
            break;
        case 1:
            index = [alarmNotifitions indexOfObject:viewedAlarmNotification] + 1; //down
            animationSubtype = kCATransitionFromTop;
            break;
        default:
            break;
    }
    
    [self loadViewDataWithIndexOfNotifications:index];
    
    //动画
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.type = kCATransitionPush;
    animation.subtype = animationSubtype;
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.tableView.layer addAnimation:animation forKey:@"upDown AlarmNotification"];
}

#pragma mark - Animation delegate

- (void)animationDidStart:(CAAnimation *)theAnimation{
    //self.view.userInteractionEnabled = NO;
    //self.navigationController.navigationBar.userInteractionEnabled = NO;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    //self.view.userInteractionEnabled = YES;
    //self.navigationController.navigationBar.userInteractionEnabled = YES;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark - Utility

- (UIImage*)takePhotoFromTheMapView{
    UIGraphicsBeginImageContext(self.containerView.frame.size);
    [self.containerView.layer renderInContext:UIGraphicsGetCurrentContext()]; 
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();     
    return viewImage;
}

- (void)loadViewDataWithIndexOfNotifications:(NSInteger)index{
    
    if (index >= alarmNotifitions.count || index <0)
        index = 0;
    [viewedAlarmNotification release];
    viewedAlarmNotification = (IAAlarmNotification*)[[alarmNotifitions objectAtIndex:index] retain];
    IAAlarm *alarm = viewedAlarmNotification.alarm;
    
    //title 查看 1/3
    self.title = [NSString stringWithFormat:@"%@ %d/%d",kAlertBtnView,(index+1),alarmNotifitions.count];
    
    //SegmentedControl
    UISegmentedControl *sc = (UISegmentedControl*)self.upDownBarItem.customView;
    if (alarmNotifitions.count <= 1) {
        [sc setEnabled:NO forSegmentAtIndex:0];
        [sc setEnabled:NO forSegmentAtIndex:1];
    }else if (0 == index){
        [sc setEnabled:NO forSegmentAtIndex:0];
        [sc setEnabled:YES forSegmentAtIndex:1];
    }else if ((alarmNotifitions.count -1) == index){
        [sc setEnabled:YES forSegmentAtIndex:0];
        [sc setEnabled:NO forSegmentAtIndex:1];
    }else{
        [sc setEnabled:YES forSegmentAtIndex:0];
        [sc setEnabled:YES forSegmentAtIndex:1];
    }
    
    
    /**地图相关**/
    
    if (circleOverlay) {
        [self.mapView removeOverlay:circleOverlay];
        [circleOverlay release];
    }
    if (pointAnnotation) {
        [self.mapView removeAnnotation:pointAnnotation];
        [pointAnnotation release];
    }
    
    CLLocationCoordinate2D coord = alarm.coordinate;
    CLLocationDistance radius = alarm.radius;
    
    //大头针
    pointAnnotation = [[MapPointAnnotation alloc] initWithCoordinate:alarm.coordinate title:alarm.alarmName subTitle:nil];    
    [self.mapView addAnnotation:pointAnnotation];
    [self setDistanceWithCurrentLocation:[YCSystemStatus deviceStatusSingleInstance].lastLocation];//距离
    
    //地图的显示region
    
    //先按老的坐标显示
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, radius*2.5, radius*2.5);
    MKCoordinateRegion regionFited =  [self.mapView regionThatFits:region];
    [self.mapView setRegion:regionFited animated:NO];
    
    CGPoint oldPoint = [self.mapView convertCoordinate:coord toPointToView:self.mapView];
    CGPoint newPoint = CGPointMake(oldPoint.x, oldPoint.y - 15.0); //下移,避免pin的callout到屏幕外
    CLLocationCoordinate2D newCoord = [self.mapView convertPoint:newPoint toCoordinateFromView:self.mapView];
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(newCoord, radius*2.5, radius*2.5);
    MKCoordinateRegion newRegionFited =  [self.mapView regionThatFits:newRegion];
    [self.mapView setRegion:newRegionFited animated:NO];
    
    //圈
    circleOverlay = [[MKCircle circleWithCenterCoordinate:coord radius:radius] retain];
    [self.mapView addOverlay:circleOverlay];
    
    //选中大头针
    [self.mapView selectAnnotation:pointAnnotation animated:NO];
    
    //其他数据
    [self.tableView reloadData];

}

- (void)setDistanceWithCurrentLocation:(CLLocation*)location{
    
    if (pointAnnotation == nil || location == nil || ![location isKindOfClass:[CLLocation class]]) {
        pointAnnotation.subtitle = nil;
        pointAnnotation.distanceFromCurrentLocation = 0.0;
        return;
    }
    
    CLLocation *aLocation = [[[CLLocation alloc] initWithLatitude:pointAnnotation.coordinate.latitude longitude:pointAnnotation.coordinate.longitude] autorelease];
	CLLocationDistance distance = [location distanceFromLocation:aLocation];
    
    NSString *s = nil;
    if (distance > 100.0) 
        s = [NSString stringWithFormat:KTextPromptDistanceCurrentLocation,[location distanceFromLocation:aLocation]/1000.0];
    else
        s = KTextPromptCurrentLocation;
    
    //未设置过 或 与上次的距离超过100米
    if (pointAnnotation.distanceFromCurrentLocation < 0.0 || fabs(pointAnnotation.distanceFromCurrentLocation - distance) > 100.0) {
        pointAnnotation.distanceFromCurrentLocation = distance;
        pointAnnotation.subtitle = s;
    }
    
}

#pragma mark - MapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)theAnnotation{
    
    if([theAnnotation isKindOfClass:[MKUserLocation class]])
        return nil;

    NSString *annotationIdentifier = @"PinViewAnnotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!pinView){
        
        IAAlarm *alarm = viewedAlarmNotification.alarm;
        NSString *imageName = alarm.alarmRadiusType.alarmRadiusTypeImageName;
        imageName = [NSString stringWithFormat:@"20_%@",imageName]; //使用20像素的图标
        UIImageView *sfIconView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
        sfIconView.image = [UIImage imageNamed:imageName];
        
        
        pinView = [[[MKPinAnnotationView alloc]
                                      initWithAnnotation:theAnnotation
                                         reuseIdentifier:annotationIdentifier] autorelease];
        
        [pinView setPinColor:MKPinAnnotationColorGreen];
        pinView.canShowCallout = YES;
         
        pinView.leftCalloutAccessoryView = sfIconView;
        
    }else{
        pinView.annotation = theAnnotation;
    }
    
    return pinView;
   
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

- (void)mapView:(MKMapView *)theMapView didAddAnnotationViews:(NSArray *)views{
	for (id oneObj in views) {
		id anAnnotation = ((MKAnnotationView*)oneObj).annotation;
		if ([anAnnotation isKindOfClass:[MapPointAnnotation class]]) {
            [self.mapView selectAnnotation:anAnnotation animated:NO];
		}
	}
}


#pragma mark - Table view data source & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell  = nil;
    switch (indexPath.section) {
        case 0:
            cell = self.mapViewCell;
            break;
        case 1:
            cell = self.notesCell;
            break;
        case 2:
            cell = self.buttonCell;
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"备注：";
    }
	
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == 1) {
        NSString *s = [viewedAlarmNotification.alarm.description trim];
        if ([s length] == 0) s = @"\n";//备注为空，1空行占空间
        return s;
    }
	
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return self.mapViewCell.frame.size.height;
            break;
        case 1:
            return self.notesCell.frame.size.height;
            break;
        case 2:
            return self.buttonCell.frame.size.height;
            break;
        default:
            return 0.0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 23.0; //备注 上下空太大了，缩小点
    }
    return 0.0;
}
 

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.doneButtonItem;
    self.navigationItem.rightBarButtonItem = self.upDownBarItem;
    
    //containerView 显示阴影。因为mapView，imageView显示阴影均有问题
    self.mapView.layer.cornerRadius = 6;
    self.imageView.layer.cornerRadius = 6;
    self.imageView.layer.masksToBounds = YES;
    
    self.containerView.layer.cornerRadius = 6;
    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
    self.containerView.layer.borderWidth = 1.0;
    self.containerView.layer.shadowRadius = 2.0;
    self.containerView.layer.shadowOpacity = 0.3;
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 1.0);
    
    [self loadViewDataWithIndexOfNotifications:0]; //加载数据
    
    [self registerNotifications];
    
}

#pragma mark - Notification

- (void)handle_standardLocationDidFinish: (NSNotification*) notification{
    //还没加载
	if (![self isViewLoaded]) return;
    CLLocation *location = [[notification userInfo] objectForKey:IAStandardLocationKey];
	[self setDistanceWithCurrentLocation:location];
    
}

- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	//有新的定位数据产生
	[notificationCenter addObserver: self
						   selector: @selector (handle_standardLocationDidFinish:)
							   name: IAStandardLocationDidFinishNotification
							 object: nil];
    
	
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
}

#pragma mark - memory manager

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarmNotifitions:(NSArray *)theAlarmNotifitions{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        alarmNotifitions = [theAlarmNotifitions retain];
    }
    return self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self unRegisterNotifications];
	self.tableView = nil;
    [doneButtonItem release];doneButtonItem = nil;
    [upDownBarItem release];upDownBarItem = nil;
    [pointAnnotation release];pointAnnotation = nil;
    [circleOverlay release];circleOverlay = nil; 
    
    self.mapViewCell = nil;
    self.containerView = nil;
    self.mapView = nil;
    self.imageView = nil;
    self.timeStampLabel = nil;
    self.timeStampBackgroundView = nil;
    
    self.buttonCell = nil;
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    
    self.notesCell = nil;
}

- (void)dealloc {
    [self unRegisterNotifications];
	[tableView release];
    [doneButtonItem release];
    [upDownBarItem release];
    
    [mapViewCell release];
    [containerView release];
    [mapView release];
    [imageView release];
    [timeStampLabel release];
    [timeStampBackgroundView release];
    
    [buttonCell release];
    [button1 release];
    [button2 release];
    [button3 release];
    
    [notesCell release];
    
    [alarmNotifitions release];
    [viewedAlarmNotification release];
    [pointAnnotation release];
    [circleOverlay release];
    [super dealloc];
}


@end
