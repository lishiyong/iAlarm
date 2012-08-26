//
//  BackgroundViewController.m
//  TestNewIAlarmUI
//
//  Created by li shiyong on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IAParam.h"
#import "SearchDisplayManager.h"
#import "IARegionsCenter+Debug.h"
#import "IAPerson.h"
#import "IARecentAddressDataManager.h"
#import "IABookmarkManager.h"
#import "YCLib.h"
#import "IAAboutViewController.h"
#import "IAAlarmFindViewController.h"
#import "UIUtility.h"
#import "YCSystemStatus.h"
#import "LocalizedString.h"
#import "IAAlarm.h"
#import "AlarmDetailTableViewController.h"
#import "IANotifications.h"
#import "AlarmsListViewController.h"
#import "AlarmsMapListViewController.h"
#import "BackgroundViewController.h"

@interface AlarmDetailTableViewController (private)

- (void)setSkinWithType:(IASkinType)type;

@end

@implementation BackgroundViewController
@synthesize listViewController;
@synthesize mapsViewController;
@synthesize searchBar;
@synthesize bookmarkManager;
@synthesize animationBackgroundView;

- (void)setSkinWithType:(IASkinType)type{
    YCBarButtonItemStyle buttonItemStyle = YCBarButtonItemStyleDefault;
    YCBarStyle barStyle = YCBarStyleDefault;
    UIActivityIndicatorViewStyle activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    if (IASkinTypeDefault == type) {
        buttonItemStyle = YCBarButtonItemStyleDefault;
        barStyle = YCBarStyleDefault;
        activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }else {
        buttonItemStyle = YCBarButtonItemStyleSilver;
        barStyle = YCBarStyleSilver;
        activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }    
    [self.navigationController.navigationBar setYCBarStyle:barStyle];
    [self.navigationController.toolbar setYCBarStyle:barStyle forToolbarPosition:UIToolbarPositionBottom];
    //self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent ;
    [self.searchBar setYCBarStyle:barStyle];
    
    [self.editButtonItem setYCStyle:buttonItemStyle];
    [self.doneButtonItem setYCStyle:buttonItemStyle];
    [self.addButtonItem setYCStyle:buttonItemStyle];
    
    
	[currentLocationBarButtonItem setYCStyle:buttonItemStyle];
	[focusBarButtonItem setYCStyle:buttonItemStyle];
	[mapTypeBarButtonItem setYCStyle:buttonItemStyle];
	[locationingBarItem setYCStyle:buttonItemStyle];   
    [switchBarButtonItem setSwitchButtonYCStyle:buttonItemStyle];
    
    
    ////////////
    //白、灰信息按钮转换
    UIButton *infoButton = nil;
    if (IASkinTypeDefault == type) {
        infoButton =  [UIButton buttonWithType:UIButtonTypeInfoLight];
    }else {
        infoButton =  [UIButton buttonWithType:UIButtonTypeInfoDark];
    }
    [infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    infoBarButtonItem.customView = infoButton;
    ////////////
     
    /////////////
    //白、灰等待圈转换
    UIActivityIndicatorView *progressInd = (UIActivityIndicatorView*)locationingBarItem.customView;
    progressInd.activityIndicatorViewStyle = activityIndicatorViewStyle;
    /////////////
    
    /////////////
    //bar阴影
    if (IASkinTypeDefault == type) {
        self.navigationController.navigationBar.layer.masksToBounds = YES;
        self.navigationController.navigationBar.layer.shadowColor = NULL;

        self.navigationController.toolbar.layer.masksToBounds = YES;
        self.navigationController.toolbar.layer.shadowColor = NULL;
    }else {
        self.navigationController.navigationBar.layer.masksToBounds = NO;
        self.navigationController.navigationBar.layer.shadowOpacity = 0.15;
        self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
        self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        self.navigationController.navigationBar.layer.shadowRadius = 2.0;
        
        self.navigationController.toolbar.layer.masksToBounds = NO;
        self.navigationController.toolbar.layer.shadowOpacity = 0.15;
        self.navigationController.toolbar.layer.shadowColor = [UIColor blackColor].CGColor;
        self.navigationController.toolbar.layer.shadowOffset = CGSizeMake(0.0, -1.0);
        self.navigationController.toolbar.layer.shadowRadius = 2.0;
    }
     
}

- (id)editButtonItem{
	
	if (!self->editButtonItem) {
		self->editButtonItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
								target:self
								action:@selector(editOrDoneButtonItemPressed:)];
        editButtonItem.style = UIBarButtonItemStyleBordered;
	}
	
	return self->editButtonItem;
}

- (id)doneButtonItem{
	
	if (!self->doneButtonItem) {
		self->doneButtonItem = [[UIBarButtonItem alloc]
								initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								target:self
								action:@selector(editOrDoneButtonItemPressed:)];
        doneButtonItem.style = UIBarButtonItemStyleDone;
	}
	
	return self->doneButtonItem;
}

- (id)addButtonItem{
	
	if (!self->addButtonItem) {
		self->addButtonItem = [[UIBarButtonItem alloc]
							   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
							   target:self
							   action:@selector(addButtonPressed:)];
        addButtonItem.style = UIBarButtonItemStyleBordered;
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
		
		CGSize size = CGSizeMake(38,30);
        UIImage *image = [UIImage imageNamed:@"IAButtonBarLists.png"];
        switchBarButtonItem =  [[UIBarButtonItem alloc] initWithSize:size title:nil image:image style:YCBarButtonItemStyleDefault target:self action:@selector(switchButtonPressed:)];
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
        progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
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
    [self.switchBarButtonItem setHidesSwitchBackground:NO];//转换完成前，显示按钮背景
	
    UIButton *button = [self.switchBarButtonItem.customView.subviews objectAtIndex:1];//一共2个，第2个是按钮
	[UIView beginAnimations:@"switchButton Animation" context:nil];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	if (IAMapsViewController == curViewControllerType) {
        [self.switchBarButtonItem setSwitchTitle:nil switchImage:[UIImage imageNamed:@"IAButtonBarLists.png"]];
	}else {
        [self.switchBarButtonItem setSwitchTitle:nil switchImage:[UIImage imageNamed:@"IAButtonBarMaps.png"]];
	}
	
	[UIView setAnimationTransition:trType forView:button cache:YES];
	[UIView commitAnimations];
	

	//Nav的标题,toolbar上的按钮
    UIView *titleView = nil;
	if (IAListViewController == curViewControllerType) {
		self.title = KViewTitleAlarmsList;
        [self setToolbarItems:[self listViewToolbarItems] animated:YES];
        titleView = nil;
        self.searchBar.frame = CGRectInset(self.navigationController.navigationBar.bounds, 5.0, 0.0); //先调整到最大，为下次加入做准备
	}else {
		self.title = KViewTitleAlarmsListMaps;
        [self setToolbarItems:[self mapsViewToolbarItems] animated:YES];
        titleView = self.searchBar;
	}
    
    //searchBar
    [self.navigationItem setTitleView:titleView animated:YES];

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
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
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
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
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
	if ([isEditingObj boolValue]){
        [self.navigationItem setLeftBarButtonItem:self.doneButtonItem animated:YES];
	}else{
        [self.navigationItem setLeftBarButtonItem:self.editButtonItem animated:YES];
    }
}

//闹钟列表发生变化
- (void)handle_alarmsDataListDidChange:(id)notification {
	NSUInteger alarmsCount = [IAAlarm alarmArray].count;
	if (alarmsCount == 0) {//空列表不显示编辑按钮
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        self.focusBarButtonItem.enabled = NO;//没有pin，显示所有按钮当然不可用了
        if (IAMapsViewController == curViewControllerType) 
            [self.navigationController.navigationBar layoutTitleView];
        
	}else {
		if (self.navigationItem.leftBarButtonItem == nil) {
            [self.navigationItem setLeftBarButtonItem:self.editButtonItem animated:YES];
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
    //[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
    [notificationCenter postNotification:aNotification];
	
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
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
		self.searchBar.hidden = YES;		
        [self setToolbarItems:nil animated:NO];
	}else {//解除了覆盖
		
		//map在当前显示做处理toolbar
		if (IAMapsViewController == curViewControllerType) {
            [self setToolbarItems:[self mapsViewToolbarItems] animated:YES];
            self.searchBar.hidden = NO;
        }
		else{ 
            [self setToolbarItems:[self listViewToolbarItems] animated:YES];
        }
		
		
        [self.navigationItem setRightBarButtonItem:self.addButtonItem animated:YES];
		
		NSUInteger alarmsCount = [IAAlarm alarmArray].count;		//空列表不显示编辑按钮
		if (alarmsCount > 0) {
			if (alarmsCount > 0 && [YCSystemStatus sharedSystemStatus].isAlarmListEditing) {//原来是编辑状态，恢复成编辑状态
				//self.navBar.topItem.leftBarButtonItem = self.doneButtonItem;
                [self.navigationItem setLeftBarButtonItem:self.doneButtonItem animated:YES];
				
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
                [self.navigationItem setLeftBarButtonItem:self.editButtonItem animated:NO];
			}
		}else {
            [self.navigationItem setLeftBarButtonItem:nil animated:NO];
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

- (void)takeMaskViewWithBarDoHide:(BOOL)doHide{
    
    UIImage *myImage = [self.mapsViewController.mapView takeImageFullSize];
    
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
    //[[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:UINavigationControllerHideShowBarDuration+0.05];  
    [[UIApplication sharedApplication] performBlock:^{
        if ([UIApplication sharedApplication].isIgnoringInteractionEvents) 
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    } afterDelay:UINavigationControllerHideShowBarDuration+0.05];

    BOOL doHide = NO;
    CFBooleanRef doHideCF = (CFBooleanRef)[notification.userInfo objectForKey:IADoHideBarKey];
    if (doHideCF) 
        doHide = CFBooleanGetValue(doHideCF);
    else{
        //doHide = !self.navBar.hidden;
        doHide = !self.navigationController.navigationBarHidden;
    }
    
    if (doHide == self.navigationController.navigationBarHidden) {
        return; //状况相等
    }
       
    //截图遮挡，避免屏幕跳动
    [self takeMaskViewWithBarDoHide:doHide];

    self.navigationItem.titleView = nil;
    
    [self.navigationController setToolbarHidden:doHide animated:YES]; 
    [self setToolbarItems:[self mapsViewToolbarItems] animated:NO];
    [self.navigationController setNavigationBarHidden:doHide animated:YES searchBar:self.searchBar fromSuperView:self.animationBackgroundView];

    [self performBlock:^{
        self.navigationItem.titleView = doHide ? nil : self.searchBar;
    } afterDelay:UINavigationControllerHideShowBarDuration+ 0.1];
    
    [self performBlock:^{
        self.mapsViewController.mapView.userInteractionEnabled = YES;
    } afterDelay:UINavigationControllerHideShowBarDuration+ 0.05];
    
}

- (void)handle_applicationWillResignActive:(id)notification{	
    //关闭未关闭的对话框
    [searchResultsAlert dismissWithClickedButtonIndex:searchResultsAlert.cancelButtonIndex animated:NO];
    [searchAlert dismissWithClickedButtonIndex:searchAlert.cancelButtonIndex animated:NO];
    [ycSearchDisplayController setActive:NO animated:NO];
    [forwardGeocoderManager cancel];
}

- (void)IASkinStyleDidChange:(NSNotification*)notification{	
    //skin Style
    NSNumber *styleObj = [notification.userInfo objectForKey:IASkinStyleKey];
    [self setSkinWithType:[styleObj integerValue]];
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
    /*
    [notificationCenter addObserver: self
						   selector: @selector (handleHideBar:)
							   name: IADoHideBarNotification
							 object: nil];
     */
    [notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillResignActive:)
							   name: UIApplicationWillResignActiveNotification
							 object: nil];
    
    [notificationCenter addObserver: self
						   selector: @selector (IASkinStyleDidChange:)
							   name: IASkinStyleDidChange
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
    //[notificationCenter removeObserver:self	name: IADoHideBarNotification object: nil];
    [notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];
    [notificationCenter removeObserver:self	name: IASkinStyleDidChange object: nil];
}

#pragma mark -
#pragma mark Utility

////设置"正在定位"barItem处于定位状态
-(void)setLocationBarItem:(BOOL)locationing
{
	NSMutableArray *baritems = [NSMutableArray array];
	//[baritems addObjectsFromArray:self.toolbar.items];
    [baritems addObjectsFromArray:self.toolbarItems];
	
	if(locationing)
		[baritems replaceObjectAtIndex:2 withObject:self.locationingBarItem];
	else 
		[baritems replaceObjectAtIndex:2 withObject:self.currentLocationBarButtonItem];
	
	//[self.toolbar setItems:baritems animated:NO];
    [self setToolbarItems:baritems animated:NO];
}



#pragma mark -
#pragma mark Event

- (void)currentLocationButtonPressed:(id)sender{
    
	[self setLocationBarItem:YES];    //把barItem改成正在定位的状态
	[self performSelector:@selector(setLocationBarItem:) withInteger:NO afterDelay:0.5];//0.5秒后，把barItem改回正常状态
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IACurrentLocationButtonPressedNotification object:self userInfo:nil];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
    
    [UIView animateWithDuration:0.0 animations:^{;} completion:^(BOOL finished)
     {   
         //地图移动期间禁止用户操作
         [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
         NSDate *date = [NSDate date];
         while (self.currentLocationBarButtonItem.enabled && fabs([date timeIntervalSinceNow]) < 2.0) {
             [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
         }
         if ([UIApplication sharedApplication].isIgnoringInteractionEvents) 
             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         
     }];
     
}

- (void)focusButtonPressed:(id)sender{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAFocusButtonPressedNotification object:self userInfo:nil];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
    
    [UIView animateWithDuration:0.0 animations:^{;} completion:^(BOOL finished)
     {   
         //地图移动期间禁止用户操作
         [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
         NSDate *date = [NSDate date]; 
         while (self.focusBarButtonItem.enabled && fabs([date timeIntervalSinceNow]) < 2.5) {
             [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
         }
         if ([UIApplication sharedApplication].isIgnoringInteractionEvents) 
             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         
     }];
    
}

- (void)mapTypeButtonPressed:(id)sender{
    //debug
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAMapTypeButtonPressedNotification object:self userInfo:nil];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
}

- (void)infoButtonPressed:(id)sender{
    //debug
    //[[IARegionsCenter sharedRegionCenter] debug];
    
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
	
	//改变编辑状态
	//BOOL isEditing = (self.navBar.topItem.leftBarButtonItem == self.editButtonItem) ? YES : NO;
    BOOL isEditing = (self.navigationItem.leftBarButtonItem == self.editButtonItem) ? YES : NO;
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


#pragma mark -
#pragma mark animation delegate

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{ 
    [self.switchBarButtonItem setHidesSwitchBackground:YES];//转换完成，背景设成透明，否则影响按钮的边框
	
    if ([UIApplication sharedApplication].isIgnoringInteractionEvents) 
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark -
#pragma mark view life

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];    
    
    //self.navBar =self.navigationController.navigationBar;
    BOOL navigationBarHidden = self.navigationController.navigationBarHidden;
    [self.navigationController setToolbarHidden:navigationBarHidden animated:NO];
    [self registerNotifications];
    
    //searchBar
	self.searchBar.placeholder = KTextPromptPlaceholderOfSearchBar;
    
    searchDisplayManager = [[SearchDisplayManager alloc] init];
    ycSearchDisplayController = [[YCSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    ycSearchDisplayController.delegate = searchDisplayManager;
    ycSearchDisplayController.searchResultsDataSource = searchDisplayManager;
    ycSearchDisplayController.searchResultsDelegate = searchDisplayManager;
    self.searchBar.delegate = searchDisplayManager;
    searchDisplayManager.searchDisplayController = ycSearchDisplayController;
    searchDisplayManager.delegate = self;
    self.bookmarkManager.searchDisplayManager = searchDisplayManager;

    
    
    //当前控制器、 Nav的标题、searchBar
    UIViewController *curViewController = nil;
    switch (curViewControllerType) {
        case IAListViewController:
            curViewController = self.listViewController;
            //self.navBar.topItem.title = KViewTitleAlarmsList;
            self.title = KViewTitleAlarmsList;
            [self setToolbarItems:[self listViewToolbarItems] animated:NO];                                                                   
            self.searchBar.hidden = YES;
            self.navigationItem.titleView = nil;
            break;
        case IAMapsViewController:
            curViewController = self.mapsViewController;
            self.title = KViewTitleAlarmsListMaps;
            [self setToolbarItems:[self mapsViewToolbarItems] animated:NO];
            self.searchBar.hidden = NO;
            self.navigationItem.titleView = self.searchBar;
        default:
            break;
    }
    
    //Nav按钮
    //self.navigationItem.rightBarButtonItem = self.addButtonItem;
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    
	//view没有加载，先加载
	[curViewController view];
    
    //toolbar,navbar隐藏后，在其他界面内存警告后。修正animationBackgroundView.view的尺寸
    [self performBlock:^{
        animationBackgroundView.frame = self.view.bounds;
    } afterDelay:0.2];
          
	
	[self.mapsViewController viewWillAppear:NO];
	[self.animationBackgroundView insertSubview:curViewController.view atIndex:0];
	[self.mapsViewController viewDidAppear:NO];
    
    
    //skin Style
    [self setSkinWithType:[IAParam sharedParam].skinType];
    
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
    self.navigationController.toolbar.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
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
-(void)resetAnnotationWithPlacemark:(YCPlacemark*)placemark{
    
    //地图缩放期间，不允许其他事件（尤其是searchbar获得焦点）。
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    CLLocationCoordinate2D visualCoordinate = placemark.region.center;
    ////////////////////////
	//Zoom into the location
    
    CLLocationDistance latitudinalMeters = placemark.region.radius*2; 
    CLLocationDistance longitudinalMeters = MKMetersPerMapPointAtLatitude(placemark.region.center.latitude) * placemark.region.radius *2;
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(visualCoordinate, latitudinalMeters,longitudinalMeters);
    region = [self.mapsViewController.mapView regionThatFits:region];
    
    
	if (!YCMKCoordinateRegionIsValid(region))
		region = self.mapsViewController.mapView.region;
	
	
	double delay = [self.mapsViewController.mapView setRegion:region FromWorld:YES animatedToWorld:YES animatedToPlace:YES];
	//Zoom into the location
	////////////////////////
    
    //[[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:delay+2.0];
    [[UIApplication sharedApplication] performBlock:^{
        if ([UIApplication sharedApplication].isIgnoringInteractionEvents) 
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    } afterDelay:delay+2.0];
    
    
    NSString *coordinateString = YCLocalizedStringFromCLLocationCoordinate2D(visualCoordinate,kCoordinateFrmStringNorthLatitude,kCoordinateFrmStringSouthLatitude,kCoordinateFrmStringEastLongitude,kCoordinateFrmStringWestLongitude);
    
    //优先使用name，其次titleAddress，最后KDefaultAlarmName
    NSString *titleAddress = placemark.name ? placemark.name :(placemark.titleAddress ? placemark.titleAddress : KDefaultAlarmName);
    NSString *shortAddress = placemark.shortAddress ? placemark.shortAddress : coordinateString;
    NSString *longAddress = placemark.longAddress ? placemark.longAddress : coordinateString;
    
    
	IAAlarm *alarm = [[[IAAlarm alloc] init] autorelease];
	alarm.visualCoordinate = visualCoordinate;
	alarm.positionTitle = (forwardGeocoderManager.personName.length > 0) ? forwardGeocoderManager.personName : titleAddress; //如果是从联系人搜索来的
	alarm.positionShort = shortAddress;
	alarm.position = longAddress;
    alarm.placemark = placemark;
	alarm.usedCoordinateAddress = NO;
    
    
    IAPerson *contact = [[[IAPerson alloc] initWithPersonId:forwardGeocoderManager.personId] autorelease];
    IAPerson *person = [[[IAPerson alloc] initWithPerson:contact.ABPerson] autorelease];//弄个不关联数据库的
    alarm.person = person; //关联到一个联系人
    	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IAAddIAlarmButtonPressedNotification 
                                                                  object:self
                                                                userInfo:[NSDictionary dictionaryWithObject:alarm forKey:IAAlarmAddedKey]];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:delay+1.75];
}


- (void)_forwardGeocodingDidCompleteWithPlacemarks:(NSArray*)placemarks error:(NSError*)error{
    
    if (searchAlert) {
        [searchAlert release];
        searchAlert = nil;
    }
    
    if (error) {
        
        switch (error.code) {
            case kCLErrorGeocodeFoundNoResult:
            case kCLErrorGeocodeFoundPartialResult:
            case kCLErrorGeocodeCanceled:
                searchAlert = [[UIAlertView alloc] initWithTitle:kAlertSearchTitleNoResults
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
        
    }else if (placemarks.count == 0){
        searchAlert = [[UIAlertView alloc] initWithTitle:kAlertSearchTitleNoResults
                                                 message:kAlertSearchBodyTryAgain 
                                                delegate:self
                                       cancelButtonTitle:kAlertBtnCancel
                                       otherButtonTitles:kAlertBtnRetry,nil];

        [searchAlert show];
    }else{
        
        //加入最近搜索
        NSString *theKey = nil;
        id theObject = nil;
        if (forwardGeocoderManager.personId != kABRecordInvalidID) {
            theKey = forwardGeocoderManager.personName;
            theObject = [[[IAPerson alloc] initWithPersonId:forwardGeocoderManager.personId organization:forwardGeocoderManager.personName addressDictionary:forwardGeocoderManager.addressDictionary] autorelease];
        }else{
            theKey = forwardGeocoderManager.addressString;
            if (placemarks.count == 1) 
                 theObject = [(YCPlacemark*)[placemarks objectAtIndex:0] formattedAddress];
            else
                theObject = @"...";
        }
        
        [[IARecentAddressDataManager sharedManager] addObject:theObject forKey:theKey];
        
        
        //排序，优先使用当前位置坐标
        CLLocationCoordinate2D coordinateForSort = kCLLocationCoordinate2DInvalid;
        if (self.mapsViewController.mapView.userLocation.location) {
            coordinateForSort = self.mapsViewController.mapView.userLocation.location.coordinate;
        }else{
            coordinateForSort = self.mapsViewController.mapView.centerCoordinate;
        }
        
        NSArray *sortedPlacemarks = [placemarks sortedArrayUsingComparator:^(YCPlacemark *obj1, YCPlacemark *obj2){
            CLLocationDistance distance1 = [obj1.location distanceFromCoordinate:coordinateForSort];
            CLLocationDistance distance2 = [obj2.location distanceFromCoordinate:coordinateForSort];
            return YCCompareDouble(distance1, distance2);
        }];
        
        //保存查询结果，以后还要用
        [searchResults release]; searchResults = nil;
        searchResults = [sortedPlacemarks retain];
        
        if (placemarks.count == 1) {            
            
            [self resetAnnotationWithPlacemark:[placemarks objectAtIndex:0]];
        }else if (placemarks.count > 1){
            
            if (searchResultsAlert) {
                [searchResultsAlert release];
                searchResultsAlert = nil;
            }
            
            //生成地址列表
            NSMutableArray *addresses = [NSMutableArray arrayWithCapacity:searchResults.count];
            for(id oneObject in searchResults){
                NSString *formattedAddress = ((YCPlacemark *)oneObject).formattedAddress;
                NSString *placemarkName = ((YCPlacemark *)oneObject).name;
                if (placemarkName && [formattedAddress rangeOfString:placemarkName].location == NSNotFound) 
                {
                    //判断是否是单字节
                    BOOL isSingle = [placemarkName canBeConvertedToEncoding:NSNEXTSTEPStringEncoding];
                    if (isSingle) //全角括号
                        formattedAddress = [NSString stringWithFormat:@"%@ (%@)",formattedAddress,placemarkName];
                    else
                        formattedAddress = [NSString stringWithFormat:@"%@ （%@）",formattedAddress,placemarkName];
                }//把name加到末尾，如果名字不包含的话
                
                [addresses addObject:formattedAddress];
            }
            
            //解决列表中地址名称重复问题 在末尾加[1],[2]...
            NSCountedSet *countedSet= [NSCountedSet setWithArray:addresses]; //为了得到重复的数量
            
            for (NSUInteger i = 0; i < addresses.count; i++) {
                
                NSString *anAddress = [addresses objectAtIndex:i];
                [anAddress retain]; //下面的replaceObjectAtIndex后，anAddress会release。
                                
                NSUInteger sameNameIdx = 1;
                NSUInteger count = [countedSet countForObject:anAddress];
                NSUInteger idx = [addresses indexOfObject:anAddress];
                
                while (NSNotFound != idx && count > 1) {
                    NSString *newAnAddress = [anAddress stringByAppendingFormat:@" (%d)",sameNameIdx];
                    [addresses replaceObjectAtIndex:idx withObject:newAnAddress];
                    idx = [addresses indexOfObject:anAddress];
                    sameNameIdx++;
                }
                
                [anAddress release];
            }
            
            searchResultsAlert = [[YCAlertTableView alloc] 
                                  initWithTitle:kAlertSearchTitleResults delegate:self tableCellContents:addresses cancelButtonTitle:kAlertBtnCancel];
            [searchResultsAlert performSelector:@selector(show) withObject:nil afterDelay:0.1];
            
            
        }
    }
            
    [ycSearchDisplayController setActive:NO animated:YES];   //search取消
}

#pragma mark -
#pragma mark SearchDisplayManagerDelegate methods

- (void)searchWithString:(NSString *)searchString;
{
    
    searchString = [searchString stringByTrim];
    
    //加到最近查询list中
    if (searchString && searchString.length > 0) 
        [searchDisplayManager addListContentWithString:searchString];
    
    //当前地图可视范围的视口
    MKMapRect visibleBounds = self.mapsViewController.mapView.visibleMapRect;
    //当前位置的视口
    CLLocation *curLocation = self.mapsViewController.mapView.userLocation.location;
    if (!curLocation) 
        curLocation = [YCSystemStatus sharedSystemStatus].lastLocation;
    
    if (!forwardGeocoderManager) 
        forwardGeocoderManager = [[YCForwardGeocoderManager alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [forwardGeocoderManager forwardGeocodeAddressString:searchString visibleMapRect:visibleBounds currentLocation:curLocation completionHandler:^(NSArray *placemarks, NSError *error){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self _forwardGeocodingDidCompleteWithPlacemarks:placemarks error:error];
    }];  
     
}
- (void)searchWithaddressDictionary:(NSDictionary *)addressDictionary personName:(NSString *) personName personId:(int32_t)personId{
    
    if (!forwardGeocoderManager) 
        forwardGeocoderManager = [[YCForwardGeocoderManager alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [forwardGeocoderManager forwardGeocodeAddressDictionary:addressDictionary personName:personName personId:personId completionHandler:^(NSArray *placemarks, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self _forwardGeocodingDidCompleteWithPlacemarks:placemarks error:error];
    }];    
}

- (void)cancelSearch{
	 //取消了，还没结束，结束它
    [forwardGeocoderManager cancel]; 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    [self.bookmarkManager presentBookmarViewController];
}

#pragma mark - UIAlertViewDelegate YCAlertTableViewDelegete

- (void)alertTableView:(YCAlertTableView *)alertTableView didSelectRow:(NSInteger)row{
	if (searchResultsAlert == alertTableView) {
        YCPlacemark *placemark = [searchResults objectAtIndex:row];
        [self resetAnnotationWithPlacemark:placemark];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == searchAlert) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:kAlertBtnRetry]) {
            [ycSearchDisplayController setActive:YES animated:YES];   //search状态
        }else if(alertView.cancelButtonIndex == buttonIndex){
            [ycSearchDisplayController setActive:NO animated:YES];   //search取消
        }
    }
}

#pragma mark - Memery Manager

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    NSLog(@"BackgroundViewController viewDidUnload");
    [super viewDidUnload];	
	[self unRegisterNotifications];
	
	self.listViewController = nil;
	self.mapsViewController = nil;
	self.searchBar = nil;
    self.bookmarkManager = nil;
	self.animationBackgroundView = nil;
    
    [ycSearchDisplayController release]; ycSearchDisplayController = nil;
    [searchDisplayManager clearCaches];
    [searchDisplayManager release];searchDisplayManager = nil;
    
}


- (void)dealloc {
    NSLog(@"BackgroundViewController dealloc");
	[listViewController release];
	[mapsViewController release];	
	
	[editButtonItem release];
	[doneButtonItem release];
	[addButtonItem release];
	
	[searchBar release];
    [ycSearchDisplayController release];
    [searchDisplayManager release];
    [searchResultsAlert release];
    [searchAlert release];
    [searchResults release];
    [forwardGeocoderManager release];
    [bookmarkManager release];
	
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
