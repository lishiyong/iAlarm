//
//  BackgroundViewController.m
//  TestNewIAlarmUI
//
//  Created by li shiyong on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "YCLocation.h"
#import "YCFunctions.h"
#import "YCLocationManager.h"
#import "UINavigationController+YC.h"
#import "YCSearchBarNotification.h"
#import "IAAboutViewController.h"
#import "IAAlarmFindViewController.h"
#import "NSObject+YC.h"
#import "YCMaps.h"
#import "MKMapView+YC.h"
#import "UIUtility.h"
#import "YCSearchBar.h"
#import "YCSystemStatus.h"
#import "LocalizedString.h"
#import "IAAlarm.h"
#import "AlarmDetailTableViewController.h"
#import "IANotifications.h"
#import "AlarmsListViewController.h"
#import "AlarmsMapListViewController.h"
#import "BackgroundViewController.h"
#import "YCAlertTableView.h"



@implementation BackgroundViewController
@synthesize listViewController;
@synthesize mapsViewController;
@synthesize navBar;
@synthesize searchBar;
@synthesize searchController;
@synthesize toolbar;
@synthesize animationBackgroundView;

-(id)forwardGeocoder{
	if (forwardGeocoder == nil) {
		forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
        forwardGeocoder.timeoutInterval = 20.0;
        forwardGeocoder.useHTTP = YES;
	}
	return forwardGeocoder;
}


- (id)editButtonItem{
	
	if (!self->editButtonItem) {
		self->editButtonItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
								target:self
								action:@selector(editOrDoneButtonItemPressed:)];
	}
	
	return self->editButtonItem;
}

- (id)doneButtonItem{
	
	if (!self->doneButtonItem) {
		self->doneButtonItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								target:self
								action:@selector(editOrDoneButtonItemPressed:)];
	}
	
	return self->doneButtonItem;
}

- (id)addButtonItem{
	
	if (!self->addButtonItem) {
		self->addButtonItem = [[UIBarButtonItem alloc]
							   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
							   target:self
							   action:@selector(addButtonPressed:)];
	}
	
	return self->addButtonItem;
}


- (id)infoBarButtonItem{
	if (infoBarButtonItem == nil) {
		UIButton *infoButton =  [UIButton buttonWithType:UIButtonTypeInfoLight];
		[infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		infoBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	}
	
	return infoBarButtonItem;
}

- (id)switchBarButtonItem{
	if (switchBarButtonItem == nil) {
		
		CGRect customFrame = CGRectMake(0, 0, 38, 30);
		
		
		UIView *switchBackgroundView = [[[UIView alloc] initWithFrame:customFrame] autorelease];
		//动画转换的黑背景
		UIImage *backgroundImage = [UIImage imageNamed:@"YCDefaultBarButtonItemBackground.png"];
		backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:5 topCapHeight:0];
		UIImageView *switchBackgroundImageView = [[[UIImageView alloc] initWithFrame:customFrame] autorelease];
		switchBackgroundImageView.image = backgroundImage;
		switchBackgroundImageView.hidden = YES;//转换时候再显示，否则影响按钮的边框
		[switchBackgroundView addSubview:switchBackgroundImageView];
		
		
		//按钮
		UIButton *switchButton =  [[[UIButton alloc] initWithFrame:customFrame] autorelease];
		[switchBackgroundView addSubview:switchButton];
		[switchButton setImage:[UIImage imageNamed:@"IAButtonBarLists.png"] forState:UIControlStateNormal];
		[switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		//按钮的背景
		UIImage *normalImage = [UIImage imageNamed:@"YCDefaultBarButtonItem.png"];
		normalImage = [normalImage stretchableImageWithLeftCapWidth:5 topCapHeight:5];
		[switchButton setBackgroundImage:normalImage forState:UIControlStateNormal];
		UIImage *pressedImage = [UIImage imageNamed:@"YCDefaultBarButtonItemPressed.png"];
		pressedImage = [pressedImage stretchableImageWithLeftCapWidth:5 topCapHeight:5];
		[switchButton setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
		
		switchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:switchBackgroundView];
	}
	
	return switchBarButtonItem;
}

- (id)currentLocationBarButtonItem{
	if (currentLocationBarButtonItem == nil) {
		currentLocationBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IAButtonBarLocationArrow.png"] 
																		 style:UIBarButtonItemStylePlain 
																		target:self 
																		action:@selector(currentLocationButtonPressed:)];
	}
	
	return currentLocationBarButtonItem;
}

- (id)focusBarButtonItem{
	if (focusBarButtonItem == nil) {
		focusBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IAButtonBarFocusing.png"] 
																style:UIBarButtonItemStylePlain 
															   target:self 
															   action:@selector(focusButtonPressed:)];		
	}
	
	return focusBarButtonItem;
}

- (id)mapTypeBarButtonItem{
	if (mapTypeBarButtonItem == nil) {
		mapTypeBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
																				target:self 
																				action:@selector(mapTypeButtonPressed:)];
		mapTypeBarButtonItem.style = UIBarButtonItemStylePlain;
		
	}
	
	return mapTypeBarButtonItem;
}

- (id)locationingBarItem
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


- (NSArray*)mapsViewToolbarItems{
	//隔开1
	UIBarButtonItem *spItem1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL] autorelease];
	spItem1.width = 34;
    //当前位置
	/*
	UIBarButtonItem *curLocBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IAButtonBarLocationArrow.png"] 
																			 style:UIBarButtonItemStylePlain 
																			target:self 
																			action:@selector(currentLocationButtonPressed:)] autorelease];
	*/
	
	//隔开2
	UIBarButtonItem *spItem2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL] autorelease];
	spItem2.width = 25;
	//聚焦
	/*
	UIBarButtonItem *focusBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"IAButtonBarFocusing.png"] 
																			style:UIBarButtonItemStylePlain 
																		   target:self 
																		   action:@selector(focusButtonPressed:)] autorelease];
	 */
	
	//隔开3
	UIBarButtonItem *spItem3 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL] autorelease];
	spItem3.width = 25;
	//地图类型
	/*
	UIBarButtonItem *mapTypeButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
																						target:self 
																						action:@selector(mapTypeButtonPressed:)] autorelease];
	mapTypeButtonItem.style = UIBarButtonItemStylePlain;
	 */
	
	
	//隔开4
	UIBarButtonItem *spItem4 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease];
	
	
	NSArray *array = [NSArray arrayWithObjects:self.infoBarButtonItem,spItem1,self.currentLocationBarButtonItem,spItem2,self.focusBarButtonItem,spItem3,self.mapTypeBarButtonItem,spItem4,self.switchBarButtonItem,nil];
	return array;
}

- (NSArray*)listViewToolbarItems{
	
	//隔开
	UIBarButtonItem *spItem1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease];
	
	
	NSArray *array = [NSArray arrayWithObjects:self.infoBarButtonItem,spItem1,self.switchBarButtonItem,nil];
	return array;
}


#pragma mark -
#pragma mark notification


- (void)handle_listViewMapsViewSwitch:(id)notification{	
    
    if (self.navigationController.isNavigationBarHidden) {//隐藏bar 与 listview 只能做一个
        return;
    }
    
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    //////////////////////////
	//视图转换
	[UIView beginAnimations:@"View Switch" context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	UIViewController *curViewController = nil;
    UIViewController *changeToController = nil;
    IASwitchViewControllerType changeToControllerType;
    switch (curViewControllerType) {
        case IAListViewController:
            curViewController = self.listViewController;
            changeToController = self.mapsViewController;
            changeToControllerType = IAMapsViewController;
            break;
        case IAMapsViewController:
            curViewController = self.mapsViewController;
            changeToController = self.listViewController;
            changeToControllerType = IAListViewController;
        default:
            break;
    }
		
	UIViewAnimationTransition trType;
	if (IAMapsViewController == curViewControllerType) {
		trType = UIViewAnimationTransitionFlipFromRight;
		self.searchBar.hidden = YES;
	}else {
		trType = UIViewAnimationTransitionFlipFromLeft;
		self.searchBar.hidden = NO;
	}
	

	
	[UIView setAnimationTransition:trType forView:self.animationBackgroundView cache:YES];
	
	[changeToController view];//防止内存警告后，view没有加载
	
	[changeToController viewWillAppear:YES];
	[curViewController viewWillDisappear:YES];
	[curViewController.view removeFromSuperview];
	[self.animationBackgroundView insertSubview:changeToController.view atIndex:0];
	[curViewController viewDidDisappear:YES];
	[changeToController viewDidAppear:YES];
	
	[UIView commitAnimations];
	
	curViewControllerType = changeToControllerType;

	
	//////////////////////////
	//按钮转换
	UIView *backgroundView = [[self.switchBarButtonItem.customView subviews] objectAtIndex:0]; //一共2个，第1个是按钮背景
	backgroundView.hidden = NO;//转换完成前，显示按钮背景
	UIButton *button = [[self.switchBarButtonItem.customView subviews] objectAtIndex:1]; //一共2个，第2个是按钮
	//转换完成前，事件解除绑定
	//[button removeTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	
	[UIView beginAnimations:@"switchButton Animation" context:nil];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	
	if (IAMapsViewController == curViewControllerType) {
		[button setImage:[UIImage imageNamed:@"IAButtonBarLists.png"] forState:UIControlStateNormal];
	}else {
		[button setImage:[UIImage imageNamed:@"IAButtonBarMaps.png"] forState:UIControlStateNormal];
	}
	
	[UIView setAnimationTransition:trType forView:button cache:YES];
	[UIView commitAnimations];
	

	//Nav的标题,toolbar上的按钮
	if (IAListViewController == curViewControllerType) {
		self.title = KViewTitleAlarmsList;
        [self.toolbar setItems:[self listViewToolbarItems] animated:YES];
	}else {
		self.title = KViewTitleAlarmsListMaps;
        [self.toolbar setItems:[self mapsViewToolbarItems] animated:YES];
	}

}

- (void)handle_editIAlarmButtonPressed:(NSNotification*)notification{
    
    UIViewController *curViewController = nil;
    switch (curViewControllerType) {
        case IAListViewController:
            curViewController = self.listViewController;
            break;
        case IAMapsViewController:
            curViewController = self.mapsViewController;
        default:
            break;
    }
	
	id alarm = [[notification userInfo] objectForKey:IAEditIAlarmButtonPressedNotifyAlarmObjectKey];

	AlarmDetailTableViewController *detailController1 = [[[AlarmDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    UINavigationController *detailNavigationController1 = [[[UINavigationController alloc] initWithRootViewController:detailController1] autorelease];
	detailController1.alarm = alarm;
	detailController1.newAlarm = NO;
	[curViewController viewWillDisappear:YES];
	[self presentModalViewController:detailNavigationController1 animated:YES];
	[curViewController viewDidDisappear:YES];
	
	
	
	//页面消失，取消编辑状态
	BOOL isEditing = NO;
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmListEditStateDidChangeNotification 
                                                                  object:self
                                                                userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isEditing] forKey:IAEditStatusKey]];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
	
}

- (void)showAddAlarmView:(IAAlarm*)theAlarm{
    
    UIViewController *curViewController = nil;
    switch (curViewControllerType) {
        case IAListViewController:
            curViewController = self.listViewController;
            break;
        case IAMapsViewController:
            curViewController = self.mapsViewController;
        default:
            break;
    }
	
	AlarmDetailTableViewController *detailController1 = [[[AlarmDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
	UINavigationController *detailNavigationController1 = [[[UINavigationController alloc] initWithRootViewController:detailController1] autorelease];
	detailController1.alarm = theAlarm;
	detailController1.newAlarm = YES;
	[curViewController viewWillDisappear:YES];
	[self presentModalViewController:detailNavigationController1 animated:YES];
	[curViewController viewDidDisappear:YES];
	
	//页面消失，取消编辑状态
	BOOL isEditing = NO;
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmListEditStateDidChangeNotification 
                                                                  object:self
                                                                userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isEditing] forKey:IAEditStatusKey]];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
	
	//动画结束，允许
	self.navBar.topItem.leftBarButtonItem.enabled = YES;
	self.navBar.topItem.rightBarButtonItem.enabled = YES;
	[self.view setUserInteractionEnabled:YES];
}

- (void)handle_addIAlarmButtonPressed:(NSNotification*)notification{
	/*
#ifndef FULL_VERSION 
	//购买
	YCParam *param = [YCParam paramSingleInstance];
	if (!param.isProUpgradePurchased  && [IAAlarm alarmArray].count >=1) {
		[[IABuyManager shareBuyManager] buyWithAlert];
		return;
	}
#endif
	 */
	
	
	IAAlarm *alarm = [[notification userInfo] objectForKey:IAAlarmAddedKey];
	if (IAMapsViewController == curViewControllerType) {

		//为定位动画留出时间
		[self performSelector:@selector(showAddAlarmView:) withObject:alarm afterDelay:1.5];
		//动画期间，不允许
		self.navBar.topItem.leftBarButtonItem.enabled = NO;
		self.navBar.topItem.rightBarButtonItem.enabled = NO;
		[self.view setUserInteractionEnabled:NO];
	}else {
		[self performSelector:@selector(showAddAlarmView:) withObject:alarm afterDelay:0.0];
	}


	 
}


- (void)handle_alarmListEditStateDidChange:(NSNotification*) notification {
	NSUInteger alarmsCount = [IAAlarm alarmArray].count;
	if (alarmsCount == 0) //空列表不显示编辑按钮
		return;
	
	NSNumber *isEditingObj = [[notification userInfo] objectForKey:IAEditStatusKey];
	//改变按钮
	if ([isEditingObj boolValue])
		self.navBar.topItem.leftBarButtonItem = self.doneButtonItem;
	else
		self.navBar.topItem.leftBarButtonItem = self.editButtonItem;
}

//闹钟列表发生变化
- (void)handle_alarmsDataListDidChange:(id)notification {
	NSUInteger alarmsCount = [IAAlarm alarmArray].count;
	if (alarmsCount == 0) {//空列表不显示编辑按钮
		//self.navBar.topItem.leftBarButtonItem = nil;
		[self.navBar.topItem performSelector:@selector(setLeftBarButtonItem:) withObject:nil afterDelay:0.25]; //按钮消失在列表空之后
        self.focusBarButtonItem.enabled = NO;//没有pin，显示所有按钮当然不可用了
	}else {
		if (self.navBar.topItem.leftBarButtonItem == nil) {
			self.navBar.topItem.leftBarButtonItem = self.editButtonItem;
		}
	}

}

- (void)handle_applicationDidEnterBackground: (id) notification{
	//改变编辑状态
	BOOL isEditing = NO;
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmListEditStateDidChangeNotification 
                                                                  object:self
                                                                userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isEditing] forKey:IAEditStatusKey]];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
	
	//弹出 没有保存的alarm详细视图、About视图
	[self dismissModalViewControllerAnimated:NO]; 
}

- (void)handle_alarmMapsMaskingDidChange: (NSNotification*) notification{
	
	/*
	if (self.curViewController != self.mapsViewController) {
		return; //只有map在当前显示才做下一步处理
	}
	 */
	
	
	NSNumber *isMaskObj = [[notification userInfo] objectForKey:IAAlarmMapsMaskingKey];
	if ([isMaskObj boolValue]) {//发生了覆盖
		self.navBar.topItem.leftBarButtonItem = nil;
		self.navBar.topItem.rightBarButtonItem = nil;
		self.searchBar.hidden = YES;		
        [self.toolbar performSelector:@selector(setItems:) withObject:nil afterDelay:0.0];
	}else {//解除了覆盖
		
		//map在当前显示做处理toolbar
		if (IAMapsViewController == curViewControllerType) 
			[self.toolbar setItems:[self mapsViewToolbarItems] animated:YES]; 
		else 
			[self.toolbar setItems:[self listViewToolbarItems] animated:YES]; 
		
		
		self.navBar.topItem.rightBarButtonItem = self.addButtonItem;
		self.searchBar.hidden = NO;
		
		NSUInteger alarmsCount = [IAAlarm alarmArray].count;		//空列表不显示编辑按钮
		if (alarmsCount > 0) {
			if (alarmsCount > 0 && [YCSystemStatus deviceStatusSingleInstance].isAlarmListEditing) {//原来是编辑状态，恢复成编辑状态
				self.navBar.topItem.leftBarButtonItem = self.doneButtonItem;
				
				//改变编辑状态
				BOOL isEditing = YES;
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
			}else {
				self.navBar.topItem.leftBarButtonItem = self.editButtonItem;
			}
		}else {
			self.navBar.topItem.leftBarButtonItem = nil;
		}

		
	}

	
}

- (void)handle_infoButtonPressed: (id) notification{
    
	//弹出 about view
    
    /*
	AboutViewController *viewController1 = [[[AboutViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    UINavigationController *navigationController1 = [[[UINavigationController alloc] initWithRootViewController:viewController1] autorelease];
	[self presentModalViewController:navigationController1 animated:YES];
     */
     
    
    IAAboutViewController *viewController1 = [[[IAAboutViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    UINavigationController *navigationController1 = [[[UINavigationController alloc] initWithRootViewController:viewController1] autorelease];
	[self presentModalViewController:navigationController1 animated:YES];
     
     
}


- (void)handle_alarmDidView:(NSNotification*)notification{
    
    IAAlarmFindViewController *ctler = [[[IAAlarmFindViewController alloc] initWithNibName:@"IAAlarmFindViewController" bundle:nil] autorelease];
    UINavigationController *navCtler = [[[UINavigationController alloc] initWithRootViewController:ctler] autorelease];
	[self presentModalViewController:navCtler animated:YES];
	
}

- (void)handle_controlStatusShouldChange:(NSNotification*)notification{
	
	//取控件Id
	NSNumber *controlIdObj = [[notification userInfo] objectForKey:IAControlIdKey];
	NSInteger controlId = [controlIdObj integerValue];
	UIBarButtonItem *theControl = nil;
	switch (controlId) {
		case 1:
			theControl = self.currentLocationBarButtonItem;
			break;
		case 2:
			theControl = self.focusBarButtonItem;
			break;
		default:
			break;
	}
	
	//取控件状态
	NSNumber *controlStatusObj = [[notification userInfo] objectForKey:IAControlStatusKey];
	BOOL controlStatus = [controlStatusObj boolValue];
	
	theControl.enabled = controlStatus;
	
}
/*
- (void)takeMaskViewWithBarDoHide:(BOOL)doHide{

    UIGraphicsBeginImageContextWithOptions(self.mapsViewController.mapView.frame.size,YES,0.0);
    [self.mapsViewController.mapView.layer renderInContext:UIGraphicsGetCurrentContext()]; 
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();       
    
    
    CGRect containerViewFrame = [self.navigationController.view convertRect:self.mapsViewController.mapView.bounds fromView:self.mapsViewController.mapView];
    CGRect imageFrame = CGRectMake(0, 0, containerViewFrame.size.width, containerViewFrame.size.height);

    if (!doHide) //为searchbar让出44
        containerViewFrame = CGRectOffset(containerViewFrame, 0, 44);
    
    //地图的截图放到容器view上
    UIView *containerView = [[[UIView alloc] initWithFrame:containerViewFrame] autorelease];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.clipsToBounds = YES;
    
    if (!doHide) //为searchbar让出44
        imageFrame = CGRectOffset(imageFrame, 0, -44);
    
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:myImage] autorelease];
    imageView.frame = imageFrame;

    [containerView addSubview:imageView];
    
    [self.navigationController.view insertSubview:containerView aboveSubview:self.view];
    [containerView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:UINavigationControllerHideShowBarDuration + 0.05];
    
}
 */

- (void)takeMaskViewWithBarDoHide:(BOOL)doHide{
    
    UIGraphicsBeginImageContextWithOptions(self.mapsViewController.mapView.frame.size,YES,0.0);
    [self.mapsViewController.mapView.layer renderInContext:UIGraphicsGetCurrentContext()]; 
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();       
    
    
    CGRect containerViewFrame = [self.navigationController.view convertRect:self.mapsViewController.mapView.bounds fromView:self.mapsViewController.mapView];
    CGRect imageFrame = CGRectMake(0, 0, containerViewFrame.size.width, containerViewFrame.size.height);
    
    
    //地图的截图放到容器view上
    UIView *containerView = [[[UIView alloc] initWithFrame:containerViewFrame] autorelease];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.clipsToBounds = YES;
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:myImage] autorelease];
    imageView.frame = imageFrame;
    [containerView addSubview:imageView];
    
    //地图的截图加入到背景中
    [self.navigationController.view insertSubview:containerView aboveSubview:self.view];

    [containerView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:UINavigationControllerHideShowBarDuration + 0.05];
    
}


- (void)handleHideBar:(NSNotification*)notification{
    
    if (IAListViewController == curViewControllerType) {//隐藏bar 于 listview 只能做一个
        return;
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:UINavigationControllerHideShowBarDuration+0.05];  

    BOOL doHide = NO;
    CFBooleanRef doHideCF = (CFBooleanRef)[notification.userInfo objectForKey:IADoHideBarKey];
    if (doHideCF) 
        doHide = CFBooleanGetValue(doHideCF);
    else
        doHide = !self.navBar.hidden;
    
    if (doHide == self.navBar.hidden) {
        return; //状况相等
    }
       
    //截图遮挡，避免屏幕跳动
    [self takeMaskViewWithBarDoHide:doHide];

    [self.navigationController setToolbarHidden:doHide animated:YES]; 
    [self.toolbar setItems:[self mapsViewToolbarItems] animated:NO];
    //[self.navigationController setNavigationBarHidden:doHide animated:YES];
    [self.navigationController setNavigationBarHidden:doHide animated:YES searchBar:self.searchBar fromSuperView:self.animationBackgroundView];

    [self.mapsViewController.mapView performSelector:@selector(setUserInteractionEnabled:) withObject:(id)kCFBooleanTrue afterDelay:UINavigationControllerHideShowBarDuration + 0.05];//MKMapView有bug:地图到了最细致后，再放大mapview的尺寸，就禁止用户事件。
    
}

- (void)handle_applicationWillResignActive:(id)notification{	
    //关闭未关闭的对话框
    [searchResultsAlert dismissWithClickedButtonIndex:searchResultsAlert.cancelButtonIndex animated:NO];
    [searchAlert dismissWithClickedButtonIndex:searchAlert.cancelButtonIndex animated:NO];
    [self.searchController setActive:NO animated:NO];
    [self.forwardGeocoder cancel];
}

- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_listViewMapsViewSwitch:)
							   name: IAListViewMapsViewSwitchNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_editIAlarmButtonPressed:)
							   name: IAEditIAlarmButtonPressedNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_addIAlarmButtonPressed:)
							   name: IAAddIAlarmButtonPressedNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmListEditStateDidChange:)
							   name: IAAlarmListEditStateDidChangeNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_infoButtonPressed:)
							   name: IAInfoButtonPressedNotification
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
						   selector: @selector (handle_alarmMapsMaskingDidChange:)
							   name: IAAlarmMapsMaskingDidChangeNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmDidView:)
							   name: IAAlarmDidViewNotification
							 object: nil];
	[notificationCenter addObserver: self
						   selector: @selector (handle_controlStatusShouldChange:)
							   name: IAControlStatusShouldChangeNotification
							 object: nil];
    [notificationCenter addObserver: self
						   selector: @selector (handleHideBar:)
							   name: IADoHideBarNotification
							 object: nil];
    [notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillResignActive:)
							   name: UIApplicationWillResignActiveNotification
							 object: nil];
	
}



- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: IAListViewMapsViewSwitchNotification object: nil];
	[notificationCenter removeObserver:self	name: IAEditIAlarmButtonPressedNotification object: nil];
	[notificationCenter removeObserver:self	name: IAAddIAlarmButtonPressedNotification object: nil];
	[notificationCenter removeObserver:self	name: IAInfoButtonPressedNotification object: nil];
	[notificationCenter removeObserver:self	name: IAAlarmListEditStateDidChangeNotification object: nil];
	[notificationCenter removeObserver:self	name: IAAlarmsDataListDidChangeNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationDidEnterBackgroundNotification object: nil];
	[notificationCenter removeObserver:self	name: IAAlarmMapsMaskingDidChangeNotification object: nil];
	[notificationCenter removeObserver:self	name: IAAlarmDidViewNotification object: nil];
	[notificationCenter removeObserver:self	name: IAControlStatusShouldChangeNotification object: nil];
    [notificationCenter removeObserver:self	name: IADoHideBarNotification object: nil];
    [notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];
}

#pragma mark -
#pragma mark Utility

////设置"正在定位"barItem处于定位状态
-(void)setLocationBarItem:(BOOL)locationing
{
	NSMutableArray *baritems = [NSMutableArray array];
	[baritems addObjectsFromArray:self.toolbar.items];
	
	if(locationing)
		[baritems replaceObjectAtIndex:2 withObject:self.locationingBarItem];
	else 
		[baritems replaceObjectAtIndex:2 withObject:self.currentLocationBarButtonItem];
	
	[self.toolbar setItems:baritems animated:NO];
}



#pragma mark -
#pragma mark Event

- (void)currentLocationButtonPressed:(id)sender{
    
	[self setLocationBarItem:YES];    //把barItem改成正在定位的状态
	[self performSelector:@selector(setLocationBarItem:) withInteger:NO afterDelay:0.5];//0.5秒后，把barItem改回正常状态
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IACurrentLocationButtonPressedNotification object:self userInfo:nil];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
    
    //地图移动期间禁止用户操作
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:2.0];//加解禁的保险
    
    [UIView animateWithDuration:0.0 animations:^{;} completion:^(BOOL finished)
     {   
         [self startOngoingSendingMessageWithTimeInterval:0.5];
         while (self.currentLocationBarButtonItem.enabled && [UIApplication sharedApplication].isIgnoringInteractionEvents) {
             [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
         }
         [self stopOngoingSendingMessage];
         if ([UIApplication sharedApplication].isIgnoringInteractionEvents) 
             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         
     }];
     
}

- (void)focusButtonPressed:(id)sender{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAFocusButtonPressedNotification object:self userInfo:nil];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
    
    //地图移动期间禁止用户操作
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:2.5];//加解禁的保险
    
    [UIView animateWithDuration:0.0 animations:^{;} completion:^(BOOL finished)
     {   
         [self startOngoingSendingMessageWithTimeInterval:0.5];
         while (self.focusBarButtonItem.enabled && [UIApplication sharedApplication].isIgnoringInteractionEvents) {
             [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
         }
         [self stopOngoingSendingMessage];
         if ([UIApplication sharedApplication].isIgnoringInteractionEvents) 
             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         
     }];
    
}

- (void)mapTypeButtonPressed:(id)sender{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAMapTypeButtonPressedNotification object:self userInfo:nil];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
}

- (void)infoButtonPressed:(id)sender{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAInfoButtonPressedNotification object:self userInfo:nil];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
}

- (void)switchButtonPressed:(id)sender{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAListViewMapsViewSwitchNotification object:self userInfo:nil];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];	
}



- (void)addButtonPressed:(id)sender{
	IAAlarm *alarm = [[[IAAlarm alloc] init] autorelease];
	
	if (IAMapsViewController == curViewControllerType) {
        
        CLLocationCoordinate2D theCoordinate = kCLLocationCoordinate2DInvalid;
        
        if (self.mapsViewController.mapView.region.span.latitudeDelta < 10) {//地图范围比较小，取地图中央的坐标
            theCoordinate = self.mapsViewController.mapView.centerCoordinate;
        }else{
            if (self.mapsViewController.mapView.userLocation.location) {//使用当前位置
                theCoordinate = self.mapsViewController.mapView.userLocation.location.coordinate;
            }else {//没办法，还得使用屏幕中央点
                theCoordinate = self.mapsViewController.mapView.centerCoordinate;
            }
        }
		
        alarm.visualCoordinate = theCoordinate; 
	}
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IAAddIAlarmButtonPressedNotification 
                                                                  object:self
                                                                userInfo:[NSDictionary dictionaryWithObject:alarm forKey:IAAlarmAddedKey]];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
	
}

-(IBAction)editOrDoneButtonItemPressed:(id)sender{
	/*
	//防止连续点击编辑按钮，pin的CalloutAccessoryView出现空白
	static NSDate *lastInvokeTime = nil;
	if (lastInvokeTime == nil) 
		lastInvokeTime = [[NSDate dateWithTimeIntervalSinceNow:-1.0] retain];
	NSTimeInterval ti = [[NSDate date] timeIntervalSinceDate:lastInvokeTime];
	if (ti < 0.8) 
    {
        return; 
    }
     */
	
	//改变编辑状态
	BOOL isEditing = (self.navBar.topItem.leftBarButtonItem == self.editButtonItem) ? YES : NO;
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
	
	/*
	[lastInvokeTime release];
	lastInvokeTime = [[NSDate date] retain];
     */
	
}


#pragma mark -
#pragma mark animation delegate

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	UIView *backgroundView = [[self.switchBarButtonItem.customView subviews] objectAtIndex:0]; //一共2个，第1个是背景
	backgroundView.hidden = YES; //转换完成，背景设成透明，否则影响按钮的边框
	
    if ([UIApplication sharedApplication].isIgnoringInteractionEvents) 
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark -
#pragma mark view life

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
    self.navBar =self.navigationController.navigationBar;
    [self.navigationController setToolbarHidden:NO animated:NO];
    self.toolbar = self.navigationController.toolbar;
    [self registerNotifications];
    
    //searchBar
	self.searchBar.placeholder = KTextPromptPlaceholderOfSearchBar;
	[(YCSearchBar*)self.searchBar setCanResignFirstResponder:YES];
	self.searchController = [[YCSearchController alloc] initWithDelegate:self
												 searchDisplayController:self.searchDisplayController];
	self.searchController.originalSearchBarHidden = NO;//不自动隐藏
    

    //当前控制器、 Nav的标题、searchBar
    UIViewController *curViewController = nil;
    switch (curViewControllerType) {
        case IAListViewController:
            curViewController = self.listViewController;
            self.navBar.topItem.title = KViewTitleAlarmsList;
            [self.toolbar performSelector:@selector(setItems:) withObject: [self listViewToolbarItems] afterDelay:0.0]; 
                                                                        //toolbar有bug，竟然需要延时设置才行
            self.searchBar.hidden = YES;
            break;
        case IAMapsViewController:
            curViewController = self.mapsViewController;
            self.navBar.topItem.title = KViewTitleAlarmsListMaps;
            [self.toolbar performSelector:@selector(setItems:) withObject: [self mapsViewToolbarItems] afterDelay:0.0];
            self.searchBar.hidden = NO;
        default:
            break;
    }
    
    //Nav按钮
    self.navBar.topItem.rightBarButtonItem = self.addButtonItem;
    self.navBar.topItem.leftBarButtonItem = self.editButtonItem;
    
    
	//view没有加载，先加载
	[curViewController view];
	
	[self.mapsViewController viewWillAppear:NO];
	[self.animationBackgroundView insertSubview:curViewController.view atIndex:0];
	[self.mapsViewController viewDidAppear:NO];

    //debug
    //[self debug];
   
}

- (void)viewDidAppear:(BOOL)animated{
    //加高的自适应。如果父视图有这个值，新加入的子视图的高度会有问题。why，没搞明白。
    self.animationBackgroundView.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
}

#pragma mark - debug
- (void)debug{
    //[self.searchBar performSelector:@selector(setHidden:) withObject:(id)kCFBooleanTrue afterDelay:1.0];
    
    
    self.searchBar.alpha = 0.5;
    self.toolbar.alpha = 0.5;
    self.navBar.alpha = 0.5;
    //self.mapsViewController.view.alpha = 0.5;
    //self.mapsViewController.mapView.alpha = 0.2;
     
    
    ((UIWindow*)[[UIApplication sharedApplication].windows objectAtIndex:0]).backgroundColor = [UIColor yellowColor];
    
    self.view.layer.backgroundColor = [UIColor greenColor].CGColor;
    self.view.layer.cornerRadius = 10;
    
    self.animationBackgroundView.layer.backgroundColor = [UIColor blueColor].CGColor;
    self.animationBackgroundView.layer.cornerRadius = 20;
    
    self.mapsViewController.view.layer.backgroundColor = [UIColor redColor].CGColor;
    self.mapsViewController.view.layer.cornerRadius = 30;
    
    self.mapsViewController.mapView.layer.cornerRadius = 40;
}


#pragma mark -
#pragma mark Utility - ForwardGeocoder

-(void)resetAnnotationWithPlace:(BSKmlResult*)place{
    
	////////////////////////
	//Zoom into the location
	MKCoordinateRegion region = place.coordinateRegion;
    
	if (!YCMKCoordinateRegionIsValid(region))
		region = self.mapsViewController.mapView.region;
	
	
	double delay = [self.mapsViewController.mapView setRegion:region FromWorld:YES animatedToWorld:YES animatedToPlace:YES];
	//Zoom into the location
	////////////////////////

	IAAlarm *alarm = [[[IAAlarm alloc] init] autorelease];
	alarm.visualCoordinate = place.coordinate;
	alarm.alarmName = self.forwardGeocoder.searchQuery;
	alarm.positionShort = place.address;
	alarm.position = place.address;
	alarm.usedCoordinateAddress = NO;
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IAAddIAlarmButtonPressedNotification 
                                                                  object:self
                                                                userInfo:[NSDictionary dictionaryWithObject:alarm forKey:IAAlarmAddedKey]];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:delay+1.75];
	
	
}

#pragma mark -
#pragma mark BSForwardGeocoderDelegate

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
    CLLocationCoordinate2D centerCoordinate = self.mapsViewController.mapView.centerCoordinate;
    CLRegion *curLoctionRegion = [[[CLRegion alloc] initCircularRegionWithCenter:centerCoordinate radius:6000.0 identifier:@"Maps Center Region"] autorelease];
    
    YCGeocoder *aforwardGeocoder = [[YCGeocoder alloc] initWithTimeout:30.0];
    [aforwardGeocoder geocodeAddressString:searchString inRegion:curLoctionRegion completionHandler:
     ^(NSArray *placemarks, NSError *error){
         ;
     }];
    
    
    return nil;
    
    ///////////////////////////////
    //当前地图可视范围的视口
    MKMapRect visibleBounds = self.mapsViewController.mapView.visibleMapRect;
    //当前位置的视口
    MKMapRect curLoctionBounds = MKMapRectNull; 
    CLLocation *curLocation = self.mapsViewController.mapView.userLocation.location;
    if (curLocation) { 
        MKMapPoint curPoint = MKMapPointForCoordinate(curLocation.coordinate);
        curLoctionBounds = MKMapRectMake(curPoint.x, curPoint.y, 6000, 6000); //取当前位置的x公里的范围
    }
    
    MKMapRect searchBounds = !MKMapRectIsNull(curLoctionBounds) ? curLoctionBounds : visibleBounds;//当前位置有可能不可用
    

	
    NSString *regionBiasing = nil;//@"cn";
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.forwardGeocoder forwardGeocodeWithQuery:searchString regionBiasing:regionBiasing viewportBiasing:searchBounds success:^(NSArray *results1) 
    {//第一次查询成功
        NSLog(@"results1 = %@",[results1 debugDescription]);
            
        //开始第二次查询， 当前地图视口查询
        if (MKMapRectEqualToRect(searchBounds, curLoctionBounds)) {
            
            MKMapRect newSearchBounds = visibleBounds;
            
            [self.forwardGeocoder forwardGeocodeWithQuery:searchString regionBiasing:regionBiasing viewportBiasing:newSearchBounds success:^(NSArray *results2) 
            {//第二次查询成功
                NSLog(@"results2 = %@",[results2 debugDescription]);
                
                NSMutableArray *results = nil;
                if (results1.count > 0 && results2.count > 0) {//合并结果
                    BOOL (^filterBlock)(id evaluatedObject, NSDictionary *bindings);
                    
                    filterBlock = ^(id evaluatedObject, NSDictionary *bindings){
                        for (BSKmlResult *anResult in results2) {
                            CLLocationCoordinate2D coordinateA = anResult.coordinate;
                            CLLocationCoordinate2D coordinateB = [(BSKmlResult*) evaluatedObject coordinate];
                            if (YCCLLocationCoordinate2DEqualToCoordinate(coordinateA, coordinateB)){
                                return NO;
                            }
                        }
                        return YES;
                    };
                    NSPredicate *pred = [NSPredicate predicateWithBlock: filterBlock];

                    
                    NSArray *resultsFilter1 = [results1 filteredArrayUsingPredicate:pred];
                    results = [NSMutableArray arrayWithArray:results2];
                    [results addObjectsFromArray:resultsFilter1];
                    
                    NSLog(@"resultsFilter1 = %@",[resultsFilter1 debugDescription]);
                    NSLog(@"results = %@",[results debugDescription]);
                    
                    
                }else{//第一次或第二次查询结果数量 == "0"
                    results = (results1.count > 0) ? [NSMutableArray arrayWithArray:results1] : [NSMutableArray arrayWithArray:results2];
                }
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [self forwardGeocodingDidSucceed:self.forwardGeocoder withResults:results];
                
                
                
            } failure:^(int status, NSString *errorMessage) 
            {//第二次查询失败
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [self forwardGeocodingDidSucceed:self.forwardGeocoder withResults:results1];
            }];
                
            
        }else{//不需要查第二次了
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self forwardGeocodingDidSucceed:self.forwardGeocoder withResults:results1];
        }
        
        
    } failure:^(int status, NSString *errorMessage) 
    {//第一次查询失败
        
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
    }
}

#pragma mark - Memery Manager

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];	
	[self unRegisterNotifications];
	
	self.listViewController = nil;
	self.mapsViewController = nil;
    self.navBar = nil;
	self.searchBar = nil;
	self.toolbar = nil;
	self.animationBackgroundView = nil;
}


- (void)dealloc {
	[listViewController release];
	[mapsViewController release];	
	
	[editButtonItem release];
	[doneButtonItem release];
	[addButtonItem release];
	
    [navBar release];
	[searchBar release];
	[forwardGeocoder release];
	[searchController release];
    [searchResultsAlert release];
    [searchAlert release];
    [searchResults release];
	
	[toolbar release];
	[infoBarButtonItem release];
	[switchBarButtonItem release];
	[currentLocationBarButtonItem release];
	[focusBarButtonItem release];
	[mapTypeBarButtonItem release];
	[locationingBarItem release];                    
	
	[animationBackgroundView release];
	
    [super dealloc];
}


@end
