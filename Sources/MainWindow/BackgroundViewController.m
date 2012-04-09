//
//  BackgroundViewController.m
//  TestNewIAlarmUI
//
//  Created by li shiyong on 11-6-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IAAboutViewController.h"
#import "IAAlarmFindViewController.h"
#import "NSObject-YC.h"
#import "YCMapsUtility.h"
#import "MKMapView-YC.h"
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
@synthesize curViewController;
@synthesize searchBar;
@synthesize searchController;
@synthesize toolbar;
@synthesize animationBackgroundView;

-(id)forwardGeocoder{
	if (forwardGeocoder == nil) {
		forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
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
    
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	
    //////////////////////////
	//视图转换
	[UIView beginAnimations:@"View Switch" context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	
		
	UIViewController *changeToController = nil;
	UIViewAnimationTransition trType;
	if (self.curViewController == mapsViewController) {
		changeToController = listViewController; 
		trType = UIViewAnimationTransitionFlipFromRight;
		self.searchBar.hidden = YES;
	}else {
		changeToController = mapsViewController; 
		trType = UIViewAnimationTransitionFlipFromLeft;
		self.searchBar.hidden = NO;
	}
	

	
	[UIView setAnimationTransition:trType forView:self.animationBackgroundView cache:YES];
	
	[changeToController view];//防止内存警告后，view没有加载
	
	[changeToController viewWillAppear:YES];
	[self.curViewController viewWillDisappear:YES];
	[self.curViewController.view removeFromSuperview];
	[self.animationBackgroundView insertSubview:changeToController.view atIndex:0];
	[self.curViewController viewDidDisappear:YES];
	[changeToController viewDidAppear:YES];
	
	[UIView commitAnimations];
	
	self.curViewController = changeToController;

	
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
	
	
	if (self.curViewController == mapsViewController) {
		[button setImage:[UIImage imageNamed:@"IAButtonBarLists.png"] forState:UIControlStateNormal];
	}else {
		[button setImage:[UIImage imageNamed:@"IAButtonBarMaps.png"] forState:UIControlStateNormal];
	}
	
	[UIView setAnimationTransition:trType forView:button cache:YES];
	[UIView commitAnimations];
	

	//设置toolbar上的按钮
	if (self.curViewController == mapsViewController)  
		[self.toolbar setItems:[self mapsViewToolbarItems] animated:YES];
	else
		[self.toolbar setItems:[self listViewToolbarItems] animated:YES];
	

	//Nav的标题
	if ([self.curViewController isKindOfClass:[AlarmsListViewController class]]) {
		self.title = KViewTitleAlarmsList;
	}else {
		self.title = KViewTitleAlarmsListMaps;
	}
	
}

- (void)handle_editIAlarmButtonPressed:(NSNotification*)notification{
	
	id alarm = [[notification userInfo] objectForKey:IAEditIAlarmButtonPressedNotifyAlarmObjectKey];

	AlarmDetailTableViewController *detailController1 = [[[AlarmDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    UINavigationController *detailNavigationController1 = [[[UINavigationController alloc] initWithRootViewController:detailController1] autorelease];
	detailController1.alarm = alarm;
	detailController1.newAlarm = NO;
	[self.curViewController viewWillDisappear:YES];
	[self presentModalViewController:detailNavigationController1 animated:YES];
	[self.curViewController viewDidDisappear:YES];
	
	
	
	//页面消失，取消编辑状态
	BOOL isEditing = NO;
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmListEditStateDidChangeNotification 
                                                                  object:self
                                                                userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isEditing] forKey:IAEditStatusKey]];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
	
}

- (void)showAddAlarmView:(IAAlarm*)theAlarm{
	
	AlarmDetailTableViewController *detailController1 = [[[AlarmDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
	UINavigationController *detailNavigationController1 = [[[UINavigationController alloc] initWithRootViewController:detailController1] autorelease];
	detailController1.alarm = theAlarm;
	detailController1.newAlarm = YES;
	[self.curViewController viewWillDisappear:YES];
	[self presentModalViewController:detailNavigationController1 animated:YES];
	[self.curViewController viewDidDisappear:YES];
	
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
	if (self.curViewController == self.mapsViewController) {

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
	if ([isEditingObj boolValue])
		self.navigationItem.leftBarButtonItem = self.doneButtonItem;
	else
		self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

//闹钟列表发生变化
- (void)handle_alarmsDataListDidChange:(id)notification {
	NSUInteger alarmsCount = [IAAlarm alarmArray].count;
	if (alarmsCount == 0) {//空列表不显示编辑按钮
		//self.navigationItem.leftBarButtonItem = nil;
		[self.navigationItem performSelector:@selector(setLeftBarButtonItem:) withObject:nil afterDelay:0.25]; //按钮消失在列表空之后
	}else {
		if (self.navigationItem.leftBarButtonItem == nil) {
			self.navigationItem.leftBarButtonItem = self.editButtonItem;
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
		self.navigationItem.leftBarButtonItem = nil;
		self.navigationItem.rightBarButtonItem = nil;
		self.searchBar.hidden = YES;
		
		//map在当前显示做处理toolbar
		if (self.curViewController == self.mapsViewController) 
			[self.toolbar setItems:nil animated:YES]; 
		
		
	}else {//解除了覆盖
		
		//map在当前显示做处理toolbar
		if (self.curViewController == self.mapsViewController) 
			[self.toolbar setItems:[self mapsViewToolbarItems] animated:YES]; 
		else 
			[self.toolbar setItems:[self listViewToolbarItems] animated:YES]; 
		
		
		self.navigationItem.rightBarButtonItem = self.addButtonItem;
		self.searchBar.hidden = NO;
		
		NSUInteger alarmsCount = [IAAlarm alarmArray].count;		//空列表不显示编辑按钮
		if (alarmsCount > 0) {
			if (alarmsCount > 0 && [YCSystemStatus deviceStatusSingleInstance].isAlarmListEditing) {//原来是编辑状态，恢复成编辑状态
				self.navigationItem.leftBarButtonItem = self.doneButtonItem;
				
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
				self.navigationItem.leftBarButtonItem = self.editButtonItem;
			}
		}else {
			self.navigationItem.leftBarButtonItem = nil;
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
	
	/*
	//弹出Model View
	[self dismissModalViewControllerAnimated:YES];
	
	//切换到map视图
	if (self.curViewController != self.mapsViewController) {
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		NSNotification *aNotification = [NSNotification notificationWithName:IAListViewMapsViewSwitchNotification object:self userInfo:nil];
		[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];	
	}
	
	
	//再地图上找到它
	NSTimeInterval delay = 1.2;
	if ([self.mapsViewController isViewLoaded]) {
		delay = 0.0;
	}
	IAAlarm *theAlarm = [[notification userInfo] objectForKey:IAViewedAlarmKey];
	[self.mapsViewController performSelector:@selector(findAlarm:) withObject:theAlarm afterDelay:delay]; //为第一次打开，延后
	*/

    //[self dismissModalViewControllerAnimated:YES];
    
    //IAAlarm *theAlarm = [[notification userInfo] objectForKey:IAViewedAlarmKey];
    
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
    
}

- (void)focusButtonPressed:(id)sender{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	NSNotification *aNotification = [NSNotification notificationWithName:IAFocusButtonPressedNotification object:self userInfo:nil];
	[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
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
	
	if (self.mapsViewController == self.curViewController && self.mapsViewController.mapView.region.span.latitudeDelta < 10) {
		//地图范围比较小，取地图中央的坐标
		alarm.coordinate = self.mapsViewController.mapView.centerCoordinate; 
	}
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IAAddIAlarmButtonPressedNotification 
                                                                  object:self
                                                                userInfo:[NSDictionary dictionaryWithObject:alarm forKey:IAAlarmAddedKey]];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
	
}

-(IBAction)editOrDoneButtonItemPressed:(id)sender{
	
	//防止连续点击编辑按钮，pin的CalloutAccessoryView出现空白
	static NSDate *lastInvokeTime = nil;
	if (lastInvokeTime == nil) 
		lastInvokeTime = [[NSDate dateWithTimeIntervalSinceNow:-1.0] retain];
	NSTimeInterval ti = [[NSDate date] timeIntervalSinceDate:lastInvokeTime];
	if (ti < 0.8) 
    {
        return; 
    }
	
	//改变编辑状态
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
	
	
	[lastInvokeTime release];
	lastInvokeTime = [[NSDate date] retain];
	
}


#pragma mark -
#pragma mark animation delegate

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	UIView *backgroundView = [[self.switchBarButtonItem.customView subviews] objectAtIndex:0]; //一共2个，第1个是背景
	backgroundView.hidden = YES; //转换完成，背景设成透明，否则影响按钮的边框
	
	/*
	//转换完成后，事件重新绑定
	UIButton *button = (UIButton*)[[self.switchBarButtonItem.customView subviews] objectAtIndex:1]; //一共2个，第2个是按钮
	[button addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
     */
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark -
#pragma mark view life

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self registerNotifications];
	

	//view没有加载，先加载
	[self.mapsViewController view];
	[self.listViewController view];
	
	[self.mapsViewController viewWillAppear:NO];
	[self.animationBackgroundView insertSubview:self.mapsViewController.view atIndex:0];
	[self.mapsViewController viewDidAppear:NO];
	self.curViewController = self.mapsViewController;
	//[self.toolbar setItems:[self mapsViewToolbarItems] animated:NO];
	
	//Nav的标题
	if ([self.curViewController isKindOfClass:[AlarmsListViewController class]]) {
		self.title = KViewTitleAlarmsList;
	}else {
		self.title = KViewTitleAlarmsListMaps;
	}
	
	//searchBar
	//self.searchBar.placeholderBackup = KTextPromptPlaceholderOfSearchBar;
	self.searchBar.placeholder = KTextPromptPlaceholderOfSearchBar;
	[(YCSearchBar*)self.searchBar setCanResignFirstResponder:YES];
	self.searchController = [[YCSearchController alloc] initWithDelegate:self
												 searchDisplayController:self.searchDisplayController];
	self.searchController.originalSearchBarHidden = NO;//不自动隐藏

}

#pragma mark -
#pragma mark Utility - ForwardGeocoder

#define kTimeOutForForwardGeocoder    20.0
-(void)beginForwardGeocoderWithSearchString:(NSString *)searchString{
	
	//[forwardGeocoder cancel] 会把delegate置空
	self.forwardGeocoder.delegate = self;
	
	//先赋空相关数据
	self.forwardGeocoder.status = G_GEO_SERVER_ERROR; 
	self.forwardGeocoder.results = nil;
	
	// 开始搜    
    MKMapRect rect;
    CLLocation *curLocation = self.mapsViewController.mapView.userLocation.location;
    if (curLocation) { //使用当前位置的附近 作为查询优先
        MKMapPoint curPoint = MKMapPointForCoordinate(curLocation.coordinate);
        rect = MKMapRectMake(curPoint.x, curPoint.y, 6000, 6000); //取当前位置的x公里的范围
    }else{ //当前地图可视范围 作为查询优先
        rect = self.mapsViewController.mapView.visibleMapRect;
        //NSLog(@"curLocation = null rect.size.width = %.f rect.size.height = %.f",rect.size.width,rect.size.height);
    }
    
    [self.forwardGeocoder findLocation:searchString andMapRect:rect];
	[self performSelector:@selector(endForwardGeocoder) withObject:nil afterDelay:kTimeOutForForwardGeocoder];
}


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
	alarm.coordinate = place.coordinate;
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
 

-(void)endForwardGeocoder{
	
	//如果超时了，还没结束，结束它
	[self.forwardGeocoder cancel]; 
	//取消掉另一个调用
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endForwardGeocoder) object:nil];
	
	//结束搜索状态
	[self.searchController setActive:NO animated:YES];   //处理search状态
	
	if(self.forwardGeocoder.status == G_GEO_SUCCESS)
	{
		//加到最近查询list中
		[self.searchController addListContentWithString:self.forwardGeocoder.searchQuery];
		
		
		NSInteger searchResultsCount = self.forwardGeocoder.results.count;
		
		if (searchResultsCount == 1) {
			BSKmlResult *place = [self.forwardGeocoder.results objectAtIndex:0];
			[self resetAnnotationWithPlace:place];
			
			//[self.curlbackgroundView startHideSearchBarAfterTimeInterval:kTimeIntervalForSearchBarHide];  //可以隐藏searchbar了
			
		}else if (searchResultsCount > 1){
			/*
			 self->searchResultsAlert = [[[YCAlertTableView alloc] 
			 initWithTitle:kAlertTitleSearchResults delegate:nil tableViewDelegate:self tableViewDataSource:self cancelButtonTitle:kAlertBtnCancel] 
			 autorelease];*/
			
			NSMutableArray *places = [NSMutableArray arrayWithCapacity:self.forwardGeocoder.results.count];
			for(id oneObject in self.forwardGeocoder.results)
				[places addObject:((BSKmlResult *)oneObject).address];
			
			YCAlertTableView *searchResultsAlert = [[[YCAlertTableView alloc] 
													 initWithTitle:kAlertSearchTitleResults delegate:self tableCellContents:places cancelButtonTitle:kAlertBtnCancel] 
													autorelease];
			[searchResultsAlert show];
			
			
		}else { //==0
			[UIUtility simpleAlertBody:kAlertSearchBodyTryAgain 
							alertTitle:kAlertSearchTitleNoResults 
					 cancelButtonTitle:kAlertBtnCancel
						 OKButtonTitle:kAlertBtnRetry 
							  delegate:self];
		}
		
		
		
	}else {
		
		switch (self.forwardGeocoder.status) {
			case G_GEO_BAD_KEY:
				[UIUtility simpleAlertBody:kAlertSearchBodyTryAgain 
								alertTitle:kAlertSearchTitleDefaultError
						 cancelButtonTitle:kAlertBtnCancel
						     OKButtonTitle:kAlertBtnRetry
								  delegate:self];
				break;
				
			case G_GEO_UNKNOWN_ADDRESS:
				[UIUtility simpleAlertBody:kAlertSearchBodyTryAgain 
								alertTitle:kAlertSearchTitleNoResults 
						 cancelButtonTitle:kAlertBtnCancel
						     OKButtonTitle:kAlertBtnRetry 
								  delegate:self];
				
				break;
				
			case G_GEO_TOO_MANY_QUERIES:
				[UIUtility simpleAlertBody:kAlertSearchBodyTryTomorrow 
								alertTitle:kAlertSearchTitleTooManyQueries 
						 cancelButtonTitle:kAlertBtnOK 
								  delegate:nil];  //只用1个按钮，而且不用retry
				break;
				
			case G_GEO_SERVER_ERROR:
				[UIUtility simpleAlertBody:kAlertSearchBodyTryAgain 
								alertTitle:kAlertSearchTitleDefaultError 
						 cancelButtonTitle:kAlertBtnCancel
						     OKButtonTitle:kAlertBtnRetry
								  delegate:self];
				break;
				
				
			default:
				[UIUtility simpleAlertBody:kAlertSearchBodyTryAgain 
								alertTitle:kAlertSearchTitleDefaultError 
						 cancelButtonTitle:kAlertBtnCancel
						     OKButtonTitle:kAlertBtnRetry
								  delegate:self];
				break;
		}
		
	}
	
}


#pragma mark -
#pragma mark BSForwardGeocoderDelegate

-(void)forwardGeocoderFoundLocation
{
	[self performSelector:@selector(endForwardGeocoder) withObject:nil afterDelay:0.1];  //数据更新后，等待x秒
}


-(void)forwardGeocoderError:(NSString *)errorMessage
{
	[self performSelector:@selector(endForwardGeocoder) withObject:nil afterDelay:0.1];  //数据更新后，等待x秒
}

#pragma mark -
#pragma mark YCSearchControllerDelegete methods

- (NSArray*)searchController:(YCSearchController *)controller searchString:(NSString *)searchString
{
	//结束其他的搜索
	[self.forwardGeocoder cancel]; 
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endForwardGeocoder) object:nil];
	
	[self beginForwardGeocoderWithSearchString:searchString];
	
	//[self.curlbackgroundView stopHideSearchBar]; //停止隐藏，直到查询出结果
	
	return nil;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
		 
	 //取消了，还没结束，结束它
	 [self.forwardGeocoder cancel]; 
	 //取消掉另一个调用
	 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endForwardGeocoder) object:nil];
	 
}


#pragma mark -
#pragma mark YCAlertTableViewDelegete methods
- (void)alertTableView:(YCAlertTableView *)alertTableView didSelectRow:(NSInteger)row{
	BSKmlResult *place = [self.forwardGeocoder.results objectAtIndex:row];
	[self resetAnnotationWithPlace:place];
}

/*
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	[self.curlbackgroundView startHideSearchBarAfterTimeInterval:kTimeIntervalForSearchBarHide];  //可以隐藏searchbar了
}
 */

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)  
		[self.searchController setActive:YES animated:YES];   //search状态
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];	
	[self unRegisterNotifications];
	
	self.listViewController = nil;
	self.mapsViewController = nil;
	self.searchBar = nil;
	self.toolbar = nil;
	self.animationBackgroundView = nil;
}


- (void)dealloc {
	[listViewController release];
	[mapsViewController release];
	[curViewController release];
	
	
	[editButtonItem release];
	[doneButtonItem release];
	[addButtonItem release];
	
	[searchBar release];
	[forwardGeocoder release];
	[searchController release];
	
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
