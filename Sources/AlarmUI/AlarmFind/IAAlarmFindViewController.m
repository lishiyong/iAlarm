//
//  IAAlarmFindViewController.m
//  iAlarm
//
//  Created by li shiyong on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "UIButton+YC.h"
#import "YCLocationManager.h"
#import "YCAlarmStatusBar.h"
#import "YCMapPointAnnotation+AlarmUI.h"
#import "YCShareContent.h"
#import "YCShareAppEngine.h"
#import "IAAlarmNotificationCenter.h"
#import "IANotifications.h"
#import "YCSystemStatus.h"
#import "LocalizedString.h"
#import "NSString+YC.h"
#import "IAAlarm.h"
#import "YCSound.h"
#import "YCPositionType.h"
#import "IAAlarmNotification.h"
#import "UIColor+YC.h"
#import <QuartzCore/QuartzCore.h>
#import "IAAlarmFindViewController.h"

NSString* YCTimeIntervalStringSinceNow(NSDate *date);

NSString* YCTimeIntervalStringSinceNow(NSDate *date){    
    
    NSString *returnString = nil;
    
    NSTimeInterval interval= fabs([date timeIntervalSinceNow]) ;
    if ((interval/60) < 1) {
        
        returnString = @"现在";
        
    }else if((interval/60) > 1 && (interval/(60*60)) < 1){
        
        returnString=[NSString stringWithFormat:@"%d分钟前", (NSInteger)(interval/60)];
        
    }else if((interval/(60*60)) > 1  && (interval/(60*60*24)) < 1){
        
        returnString=[NSString stringWithFormat:@"%d小时前", (NSInteger)(interval/(60*60))];
        
    }else if((interval/(60*60*24)) > 1  && (interval/(60*60*24*30)) < 1){
        
        returnString=[NSString stringWithFormat:@"%d天前", (NSInteger)(interval/(60*60*24))];
        
    }else if((interval/(60*60*24*30)) > 1  && (interval/(60*60*24*30*12)) < 1){
        
        returnString=[NSString stringWithFormat:@"%d月前", (NSInteger)(interval/(60*60*24*30))];
        
    }else {
        
        returnString=[NSString stringWithFormat:@"%d年前", (NSInteger)(interval/(60*60*24*30*12))];
    }
    
    return returnString;
}


@interface IAAlarmFindViewController(private)

- (UIImage*)takePhotoFromTheMapView;
- (void)loadViewDataWithIndexOfNotifications:(NSInteger)index;
- (void)reloadTimeIntervalLabel;
- (void)makeMoveAlarmAnimationWithStatus:(NSInteger)theStatus;
- (void)registerNotifications;
- (void)unRegisterNotifications;

@end


@implementation IAAlarmFindViewController

#pragma mark - property

@synthesize tableView;
@synthesize mapViewCell, takeImageContainerView, containerView, mapView, maskImageView, timeIntervalLabel, watchImageView;
@synthesize buttonCell, button1, button2, button3;
@synthesize notesCell, notesLabel;

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

- (id)mapViewCell{
    mapViewCell.frame = CGRectMake(0, 0, 300, 195);
    return mapViewCell;
}

- (id)notesCell{
    //notesCell.frame = CGRectMake(0, 0, 300, 0);
    //备注的高度会根据文本的多少自动调整
    CGRect frame = notesCell.frame;
    frame.origin = CGPointMake(0, 0);
    frame.size.width = 300;
    
    return notesCell;
}

- (id)buttonCell{
    buttonCell.frame = CGRectMake(0, 0, 300, 108);
    return buttonCell;
}
 
#pragma mark - Controll Event
- (IBAction)tellFriendsButtonPressed:(id)sender{
    NSString *title = viewedAlarmNotification.alarm.alarmName;
    NSString *message = viewedAlarmNotification.alarm.alarmName;
    UIImage *image = [self takePhotoFromTheMapView];
    [engine shareAppWithContent:[YCShareContent shareContentWithTitle:title message:message image:image]];
}

- (IBAction)delayAlarm1ButtonPressed:(id)sender{
    if (!actionSheet1) {
        actionSheet1 = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kAlertBtnCancel  destructiveButtonTitle:@"过5分钟再提醒" otherButtonTitles:nil];
    }
    [actionSheet1 showInView:self.view];
}

- (IBAction)delayAlarm2ButtonPressed:(id)sender{
    if (!actionSheet2) {
        actionSheet2 = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kAlertBtnCancel  destructiveButtonTitle:@"过30分钟再提醒" otherButtonTitles:nil];
    }
    [actionSheet2 showInView:self.view];
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

- (void)timerFireMethod:(NSTimer*)theTimer{
    [self reloadTimeIntervalLabel];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([actionSheet cancelButtonIndex] == buttonIndex) {
        return;
    }
    
    //闹钟弧形动画
    NSInteger status = (actionSheet == actionSheet1) ? 0 : 1;
    [self makeMoveAlarmAnimationWithStatus:status]; 
    
    if ( actionSheet == actionSheet1 || actionSheet == actionSheet2) {
        
        
        IAAlarm *alarmForNotif = viewedAlarmNotification.alarm;
        
        //保存到文件
        NSTimeInterval secs = 0;
        if (actionSheet == actionSheet1) {//延时1
            secs = 60*5;//5分钟
            
        }else if (actionSheet == actionSheet2) {//延时2
            secs = 60*30;//30分钟
        }
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:secs];

        IAAlarmNotification *alarmNotification = [[[IAAlarmNotification alloc] initWithSoureAlarmNotification:viewedAlarmNotification  fireTimeStamp:fireDate] autorelease];
        [[IAAlarmNotificationCenter defaultCenter] addNotification:alarmNotification];
        
        //发本地通知
        BOOL arrived = [alarmForNotif.positionType.positionTypeId isEqualToString:@"p002"];//是 “到达时候”提醒
        NSString *promptTemple = arrived?kAlertFrmStringArrived:kAlertFrmStringLeaved;
        
        NSString *alarmName = alarmForNotif.alarmName ? alarmForNotif.alarmName : alarmForNotif.positionTitle;
        NSString *alertTitle = [[[NSString alloc] initWithFormat:promptTemple,alarmName,0.0] autorelease];
        NSString *alarmMessage = [alarmForNotif.notes stringByTrim];
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:alarmNotification.notificationId forKey:@"knotificationId"];
        [userInfo setObject:alertTitle forKey:@"kTitleStringKey"];
        if (alarmMessage) 
            [userInfo setObject:alarmMessage forKey:@"kMessageStringKey"];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.2) {// iOS 4.2 带个闹钟的图标
            NSString *iconString = @"\ue02c";//这是钟表🕒
            alertTitle =  [NSString stringWithFormat:@"%@%@",iconString,alertTitle]; 
            [userInfo setObject:iconString forKey:@"kIconStringKey"];
        }
        
        
        NSString *notificationBody = alertTitle;
        if (alarmMessage && alarmMessage.length > 0) {
            notificationBody = [NSString stringWithFormat:@"%@: %@",alertTitle,alarmMessage];
        }
        
        UIApplication *app = [UIApplication sharedApplication];
        NSInteger badgeNumber = app.applicationIconBadgeNumber + 1; //角标数
        UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:secs];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.repeatInterval = 0;
        notification.soundName = alarmForNotif.sound.soundFileName;
        notification.alertBody = notificationBody;
        notification.applicationIconBadgeNumber = badgeNumber;
        notification.userInfo = userInfo;
        [app scheduleLocalNotification:notification];
    }
    
}


#pragma mark - Animation delegate

- (void)animationDidStart:(CAAnimation *)theAnimation{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    if ([theAnimation isKindOfClass:[CAKeyframeAnimation class]]) {
        //self.navigationController.wantsFullScreenLayout = YES;
        self.view.window.windowLevel = UIWindowLevelStatusBar+2; //自定义的状态栏：+1,所以这里+2。
        [[YCAlarmStatusBar shareStatusBar] setHidden:NO animated:YES];
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    if ([theAnimation isKindOfClass:[CAKeyframeAnimation class]]) {
        
        //动画结束后，把主window设置成正常状态
        self.view.window.windowLevel = UIWindowLevelNormal;
        //在bar上立刻显示闹钟图标
        [[YCAlarmStatusBar shareStatusBar] setAlarmIconHidden:NO animated:NO];    
        
        //动画结束，图就没用了
        [clockAlarmImageView removeFromSuperview];
        [clockAlarmImageView release];clockAlarmImageView = nil;
        //bar的闹钟数量累加
        [[YCAlarmStatusBar shareStatusBar] increaseAlarmCount];
    }
    if ([UIApplication sharedApplication].isIgnoringInteractionEvents) 
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark - Utility

- (UIImage*)takePhotoFromTheMapView{
    //UIGraphicsBeginImageContext(self.takeImageContainerView.frame.size);
    UIGraphicsBeginImageContextWithOptions(self.takeImageContainerView.frame.size,NO,0.0);
    [self.takeImageContainerView.layer renderInContext:UIGraphicsGetCurrentContext()]; 
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
    
    CLLocationCoordinate2D visualCoordinate = alarm.visualCoordinate;
    CLLocationDistance radius = alarm.radius;
    
    //大头针
    NSString *alarmName = alarm.alarmName ? alarm.alarmName : alarm.positionTitle;
    pointAnnotation = [[YCMapPointAnnotation alloc] initWithCoordinate:visualCoordinate title:alarmName subTitle:nil];
    [self.mapView addAnnotation:pointAnnotation];
    [pointAnnotation setDistanceSubtitleWithCurrentLocation:[YCSystemStatus deviceStatusSingleInstance].lastLocation];//距离
    
    //地图的显示region
    
    //先按老的坐标显示
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(visualCoordinate, radius*2.5, radius*2.5);
    MKCoordinateRegion regionFited =  [self.mapView regionThatFits:region];
    [self.mapView setRegion:regionFited animated:NO];
    
    CGPoint oldPoint = [self.mapView convertCoordinate:visualCoordinate toPointToView:self.mapView];
    CGPoint newPoint = CGPointMake(oldPoint.x, oldPoint.y - 15.0); //下移,避免pin的callout到屏幕外
    CLLocationCoordinate2D newCoord = [self.mapView convertPoint:newPoint toCoordinateFromView:self.mapView];
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(newCoord, radius*2.5, radius*2.5);
    MKCoordinateRegion newRegionFited =  [self.mapView regionThatFits:newRegion];
    [self.mapView setRegion:newRegionFited animated:NO];
    
    //圈
    circleOverlay = [[MKCircle circleWithCenterCoordinate:visualCoordinate radius:radius] retain];
    [self.mapView addOverlay:circleOverlay];
    
    //选中大头针
    [self.mapView selectAnnotation:pointAnnotation animated:NO];
    
    /**地图相关**/
    
    //时间间隔
    [self reloadTimeIntervalLabel];
    [timer invalidate];
    [timer release];
    timer = [[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES] retain];
    
    //备注
    self.notesLabel.text = @"";
    self.notesLabel.frame = CGRectMake(15, 0, 270, 21);
    self.notesLabel.text = viewedAlarmNotification.alarm.notes;
    [self.notesLabel sizeToFit];
    //self.notesCell.bounds.size.width = self.notesLabel.bounds.size.width;
    CGRect boundsOfnotesCell = self.notesCell.bounds;
    boundsOfnotesCell.size.height = self.notesLabel.bounds.size.height < 21 ? 21 : self.notesLabel.bounds.size.height;
    self.notesCell.bounds = boundsOfnotesCell;

    //状态栏
    [[YCAlarmStatusBar shareStatusBar] setHidden:YES animated:YES];
    //查寻文件得到延后通知的数量，免得重启后内存中就没了
    NSInteger nCount = [[IAAlarmNotificationCenter defaultCenter] notificationsForFired:NO alarmId:viewedAlarmNotification.alarm.alarmId].count;
    [[YCAlarmStatusBar shareStatusBar] setAlarmCount:nCount];
    
    //其他数据
    [self.tableView reloadData];

}

- (void)reloadTimeIntervalLabel{
    //转换动画 timeIntervalLabel的宽度调整
    [UIView transitionWithView:self.timeIntervalLabel duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^()
     {
         NSString *s = YCTimeIntervalStringSinceNow(viewedAlarmNotification.createTimeStamp);
         self.timeIntervalLabel.text = s;
         
         [self.timeIntervalLabel sizeToFit];//bounds调整到合适
         self.timeIntervalLabel.bounds = CGRectInset(self.timeIntervalLabel.bounds, -6, -2); //在字的周围留有空白
         //position在父view的左下角向上8像素
         CGSize superViewSize = self.timeIntervalLabel.superview.bounds.size;
         CGPoint thePosition = CGPointMake(superViewSize.width-8, superViewSize.height-8); //timeIntervalLabel调整后的Position
         self.timeIntervalLabel.layer.position = thePosition;
         
     } completion:NULL];
    
    self.watchImageView.hidden =  (viewedAlarmNotification.soureAlarmNotification) ? NO : YES; //延时提醒，显示时钟
    if (!watchImageView.hidden) {
        CGPoint labelPosition = self.timeIntervalLabel.layer.position; //timeIntervalLabel的Position
        //watchImageView在label x像素
        CGFloat timeIntervalLabelH = self.timeIntervalLabel.bounds.size.height; 
        self.watchImageView.layer.position = CGPointMake(labelPosition.x, labelPosition.y - timeIntervalLabelH - 3); 
    }
}

- (void)makeMoveAlarmAnimationWithStatus:(NSInteger)theStatus{
    
    if (!clockAlarmImageView) {
        clockAlarmImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCClockAlarm.png"]];
        clockAlarmImageView.frame = CGRectMake(-100, -100, 32, 32); //放到不可视区域，动画完成后删除
        clockAlarmImageView.contentMode = UIViewContentModeCenter;  //下面的要转换的图片不长宽不一致
    }
    [self.view.window addSubview:clockAlarmImageView];
    
    CGPoint moveEndPoint = [YCAlarmStatusBar shareStatusBar].alarmIconCenter;
    moveEndPoint = [self.view.window convertPoint:moveEndPoint fromWindow:[YCAlarmStatusBar shareStatusBar]];
    CGMutablePathRef thePath = CGPathCreateMutable();
    //屏幕底端
    if (0 == theStatus){ //右边的按钮
        CGPathMoveToPoint(thePath,NULL,100,480); 
        CGPathAddCurveToPoint(thePath,NULL,50.0,320.0, 300,160, moveEndPoint.x,moveEndPoint.y);//优美的弧线
    }else{
        CGPathMoveToPoint(thePath,NULL,200,480);
        CGPathAddCurveToPoint(thePath,NULL,250.0,320.0, 300,160, moveEndPoint.x,moveEndPoint.y);//优美的弧线
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    
    CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.delegate = self;
    moveAnimation.path=thePath;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.1f :0.1f :0.1f :1.0f];//前快，后慢;
    [clockAlarmImageView.layer addAnimation:moveAnimation forKey:@"MoveWatch"];
    
    CABasicAnimation *scaleAnimation=[CABasicAnimation animationWithKeyPath: @"transform.scale"];
	scaleAnimation.timingFunction= [CAMediaTimingFunction functionWithControlPoints:0.7f :0.1f :0.8f :1.0f];//前极慢，后极快  
	scaleAnimation.fromValue= [NSNumber numberWithFloat:1.0];
	scaleAnimation.toValue= [NSNumber numberWithFloat:0.32];   
	[clockAlarmImageView.layer addAnimation :scaleAnimation forKey :@"ScaleWatch" ];    
    
    CABasicAnimation *contentsAnimation =[ CABasicAnimation animationWithKeyPath: @"contents" ];
	contentsAnimation.timingFunction= [CAMediaTimingFunction functionWithControlPoints:0.7f :0.2f :0.9f :0.2f];//前极慢，后极快
	contentsAnimation.fromValue = clockAlarmImageView.layer.contents;
    contentsAnimation.toValue=  (id)[UIImage imageNamed:@"YCSilver_Alarm.png"].CGImage;   
	[clockAlarmImageView.layer addAnimation :contentsAnimation forKey :@"contentsAnimation" ];
    [CATransaction commit];
    
    CFRelease(thePath);
    
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
        //UIImageView *sfIconView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
        //sfIconView.image = [UIImage imageNamed:imageName];
        UIImageView *sfIconView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)] autorelease];
        UIImage *ringImage = [UIImage imageNamed:@"YCRing.png"];
        UIImage *ringImageClear = [UIImage imageNamed:@"YCRingClear.png"];
        
        sfIconView.image = ringImage;
        sfIconView.animationImages = [NSArray arrayWithObjects:ringImage,ringImageClear, nil];
        sfIconView.animationDuration = 1.75;
        //[sfIconView startAnimating];
        
        
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
		if ([anAnnotation isKindOfClass:[YCMapPointAnnotation class]]) {
            [self.mapView selectAnnotation:anAnnotation animated:NO];//选中
            [(UIImageView*)((MKAnnotationView*)oneObj).leftCalloutAccessoryView performSelector:@selector(startAnimating) withObject:nil afterDelay:0.5]; //x秒后开始闪烁
            
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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
/*
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == 1) {
        NSString *s = [viewedAlarmNotification.alarm.notes trim];
        if ([s length] == 0) s = @"\n";//备注为空，1空行占空间
        return s;
    }
	
    return nil;
}
 */

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
    //5.0以下 cell背景设成透明后，显示背景后面竟然是黑的。没搞懂，到底是谁的颜色。所以只好给加个背景view了。
    
    self.tableView.backgroundView = [[[UIView alloc] initWithFrame:self.tableView.frame] autorelease];
    self.tableView.backgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
     
    
    self.navigationItem.leftBarButtonItem = self.doneButtonItem;
    self.navigationItem.rightBarButtonItem = self.upDownBarItem;
    
    //containerView 显示阴影。因为mapView，imageView显示阴影均有问题
    self.mapView.layer.cornerRadius = 4;
    self.maskImageView.layer.cornerRadius = 4;
    self.maskImageView.layer.masksToBounds = YES;
    
    self.containerView.layer.cornerRadius = 4;
    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
    self.containerView.layer.borderWidth = 1.0;
    //self.containerView.layer.shadowRadius = 2.0;
    //self.containerView.layer.shadowOpacity = 0.3;
    //self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    //self.containerView.layer.shadowOffset = CGSizeMake(0, 1.0);
    
    //把position设置到左下角
    self.timeIntervalLabel.layer.anchorPoint = CGPointMake(1, 1);
    self.watchImageView.layer.anchorPoint = CGPointMake(1, 1);
    
    //备注
    self.notesLabel.textColor = [UIColor text1Color];
    
    //按钮
    [self.button1 setTitle:@"告诉朋友" forState:UIControlStateNormal];
    [self.button2 setTitle:@"过5分钟再提醒" forState:UIControlStateNormal];
    [self.button3 setTitle:@"过30分钟再提醒" forState:UIControlStateNormal];
     
    
    [self registerNotifications];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //加载数据
    [self loadViewDataWithIndexOfNotifications:indexForView]; 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [timer invalidate]; [timer release]; timer = nil;
    [actionSheet1 dismissWithClickedButtonIndex:1 animated:NO];
    [actionSheet2 dismissWithClickedButtonIndex:1 animated:NO];
    [[YCAlarmStatusBar shareStatusBar] setHidden:YES animated:YES];
}

#pragma mark - Notification

- (void)handle_standardLocationDidFinish: (NSNotification*) notification{
    //还没加载
	if (![self isViewLoaded]) return;
    CLLocation *location = [[notification userInfo] objectForKey:IAStandardLocationKey];
    [pointAnnotation setDistanceSubtitleWithCurrentLocation:location];
    
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
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil alarmNotifitions:theAlarmNotifitions indexForView:0];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarmNotifitions:(NSArray *)theAlarmNotifitions indexForView:(NSUInteger)theIndexForView{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        alarmNotifitions = [theAlarmNotifitions retain];
        indexForView = theIndexForView;
        engine = [[YCShareAppEngine alloc] initWithSuperViewController:self];
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
    self.maskImageView = nil;
    self.timeIntervalLabel = nil;
    self.watchImageView = nil;
    
    self.buttonCell = nil;
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    
    self.notesCell = nil;
    [actionSheet1 release];actionSheet1 = nil;
    [actionSheet2 release];actionSheet2 = nil;
}

- (void)dealloc {
    [self unRegisterNotifications];
	[tableView release];
    [doneButtonItem release];
    [upDownBarItem release];
    
    [mapViewCell release];
    [takeImageContainerView release];
    [containerView release];
    [mapView release];
    [maskImageView release];
    [timeIntervalLabel release];
    [watchImageView release];
    
    [buttonCell release];
    [button1 release];
    [button2 release];
    [button3 release];
    
    [notesCell release];
    [notesLabel release];
    
    [alarmNotifitions release];
    [viewedAlarmNotification release];
    [pointAnnotation release];
    [circleOverlay release];
    [engine release];
    [actionSheet1 release];
    [actionSheet2 release];
    [clockAlarmImageView release];
    [super dealloc];
}


@end
