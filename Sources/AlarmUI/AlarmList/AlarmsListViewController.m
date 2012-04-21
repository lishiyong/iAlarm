//
//  RootViewController.m
//  TestLocationTableCell1
//
//  Created by li shiyong on 10-12-16.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
//#import "iAlarmAppDelegate.h"
//#import "UIApplication-YC.h"

#import "IARegionsCenter.h"
#import "YCSystemStatus.h"
#import "UIViewController-YC.h"
#import "IANotifications.h"
#import "YCParam.h"
#import "IABuyManager.h"
#import "YCSoundPlayer.h"
#import "AlarmListNotifications.h"
#import "UIUtility.h"
#import "IAAlarmRadiusType.h"
#import "AlarmsListCell.h"
#import "LocalizedString.h"
#import "IAAlarm.h"
#import "AlarmsListViewController.h"
#import "AlarmDetailTableViewController.h"




@implementation AlarmsListViewController


#pragma mark -
#pragma mark property

@synthesize lastUpdateDistanceTimestamp;
@synthesize backgroundView;
@synthesize alarmListTableView;
@synthesize backgroundTextLabel;


- (AlarmDetailTableViewController *)detailController
{
    if (detailController == nil)
    {
        detailController = [[AlarmDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return detailController;
}

- (UINavigationController *)detailNavigationController
{
    if (detailNavigationController == nil)
    {
        detailNavigationController = [[UINavigationController alloc] initWithRootViewController:self.detailController];
    }
    return detailNavigationController;
	 
}

#pragma mark - 
#pragma mark Utility 


//不能定位图标
- (void)setNavBarTitleViewWithCanValidLocation:(BOOL)canValidLocation{
	
	if (canValidLocation)
		self.navigationItem.titleView = nil;
	else{
		if (self.navigationItem.titleView == nil) 
			self.navigationItem.titleView = [self cannotLocationTitleView];
	}
}

- (void)setNavBarTitleViewWithCanValidLocationObj:(NSNumber*/*BOOL*/)canValidLocationObj{
	[self setNavBarTitleViewWithCanValidLocation:[canValidLocationObj boolValue]];
}


/*
-(id)backgroundTextLabel{

	if (backgroundTextLabel == nil) {
		backgroundTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 95, 300, 45)];
		backgroundTextLabel.textAlignment = UITextAlignmentCenter;
		backgroundTextLabel.font = [UIFont boldSystemFontOfSize:20];
		backgroundTextLabel.textColor = [UIColor whiteColor];
		backgroundTextLabel.backgroundColor = [UIColor clearColor];
		backgroundTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		backgroundTextLabel.text = KTextPromptNoiAlarms;
		backgroundTextLabel.hidden = YES;
		backgroundTextLabel.shadowColor = [UIColor darkGrayColor];
		backgroundTextLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	}
	return backgroundTextLabel;

}
 */


#pragma mark -
#pragma mark Notification

-(void)setUIEditing:(BOOL)theEditing{
	
	NSUInteger rowCount = [self tableView:(UITableView*)self.view numberOfRowsInSection:0];
	self.backgroundTextLabel.hidden = (rowCount > 0); //背景文字
	if (rowCount == 0) {//行数>0,才可以编辑
		[self.alarmListTableView setEditing:NO animated:YES] ;
		self.navigationItem.leftBarButtonItem = nil; //编辑按钮 
	}else {
		[self.alarmListTableView setEditing:theEditing animated:YES] ;
	}
}

//tableView的编辑状态
- (void) handle_alarmListEditStateDidChange:(NSNotification*) notification {
	//还没加载
	if (![self isViewLoaded]) return;
	
	NSNumber *isEditingObj = [[notification userInfo] objectForKey:IAEditStatusKey];

	//if(isApparing)
		[self setUIEditing:[isEditingObj boolValue]];
}

//闹钟列表发生变化
- (void) handle_alarmsDataListDidChange:(id)notification {
	
	[self setUIEditing:self.alarmListTableView.editing];
	
	if ([(NSNotification*)notification object] != self) {  //自己改变就不用更新了，更新了还会有删除第一行问题
		[self.alarmListTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:self->isApparing];
	}
	
}

/*
- (void) handle_applicationDidEnterBackground: (id) notification{
	[self setUIEditing:NO];//改成非编辑
}
 */

- (void) handle_standardLocationDidFinish: (NSNotification*) notification{
    //还没加载
	if (![self isViewLoaded]) return;
    
    //间隔20秒以上才更新
    if (!(self.lastUpdateDistanceTimestamp == nil || [self.lastUpdateDistanceTimestamp timeIntervalSinceNow] < -20)) 
        return;
    self.lastUpdateDistanceTimestamp = [NSDate date]; //更新时间戳
    
	//不能定位图标
    CLLocation *location = [[notification userInfo] objectForKey:IAStandardLocationKey];
	[self setNavBarTitleViewWithCanValidLocation:(location!=nil)];

}

- (void) handle_applicationWillResignActive:(id)notification{	
	//恢复navbar 标题
	self.navigationItem.titleView = nil;
}



- (void) handle_regionTypeDidChange:(NSNotification*)notification{	
    //把所有cell重新生成一遍
    [self.alarmListTableView reloadData];
}

/*
- (void) handle_applicationWillEnterForeground: (id) notification{
    if (self->isApparing) {
        [self.alarmListTableView reloadData];//为了雷达扫描
    }
}
 */



- (void) registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmListEditStateDidChange:)
							   name: IAAlarmListEditStateDidChangeNotification
							 object: nil];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_alarmsDataListDidChange:)
							   name: IAAlarmsDataListDidChangeNotification
							 object: nil];
	/*
	//编辑状态
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidEnterBackground:)
							   name: UIApplicationDidEnterBackgroundNotification
							 object: nil];
	 */
	//有新的定位数据产生
	[notificationCenter addObserver: self
						   selector: @selector (handle_standardLocationDidFinish:)
							   name: IAStandardLocationDidFinishNotification
							 object: nil];
	 
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillResignActive:)
							   name: UIApplicationWillResignActiveNotification
							 object: nil];
    
    //区域的类型发生了改变
    [notificationCenter addObserver: self
						   selector: @selector (handle_regionTypeDidChange:)
							   name: IARegionTypeDidChangeNotification
							 object: nil];
    /*
    [notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillEnterForeground:)
							   name: UIApplicationWillEnterForegroundNotification
							 object: nil];
     */
    

	 
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: IAAlarmListEditStateDidChangeNotification object: nil];
	[notificationCenter removeObserver:self	name: IAAlarmsDataListDidChangeNotification object: nil];
	//[notificationCenter removeObserver:self	name: UIApplicationDidEnterBackgroundNotification object: nil];
	[notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];
    [notificationCenter removeObserver:self	name: IARegionTypeDidChangeNotification object: nil];
    //[notificationCenter removeObserver:self	name: UIApplicationWillEnterForegroundNotification object: nil];
}



#pragma mark -
#pragma mark Events Handle

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
    [super viewDidLoad];
	self.title = KViewTitleAlarmsList;
	
	[self registerNotifications];
	
	
	// Configure the table view.
    self.alarmListTableView.rowHeight = 93.0;
    //self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.alarmListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	
	//背景图
	self.alarmListTableView.backgroundView = self.backgroundView;
	
	NSInteger count = [IAAlarm alarmArray].count;
	
	
	[self.alarmListTableView.backgroundView addSubview:self.backgroundTextLabel];
	//空list的 y背景文字
	self.backgroundTextLabel.hidden = (count > 0); //背景文字
	self.backgroundTextLabel.text = KTextPromptNoiAlarms;
	
		
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	//不能定位图标,1.5秒后等定位结束后，再定夺
	[self performSelector:@selector(setNavBarTitleViewWithCanValidLocationObj:) withObject:[NSNumber numberWithBool:[YCSystemStatus deviceStatusSingleInstance].canValidLocation] afterDelay:1.5];
	
	//刷新编辑状态
	[self setUIEditing:[YCSystemStatus deviceStatusSingleInstance].isAlarmListEditing];
	
}
 

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	self->isApparing = YES;
    [self.alarmListTableView reloadData];//为了雷达扫描
}


- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	self->isApparing = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


 


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger n = [[IAAlarm alarmArray] count];
    return n;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"AlarmsListCell";
	
	AlarmsListCell *cell = (AlarmsListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [AlarmsListCell viewWithNibName:nil bundle:nil];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;//展示按钮
		cell.selectionStyle = UITableViewCellSelectionStyleNone;  //被选择后，无变化
	}
	
	NSArray *alarms = [IAAlarm alarmArray];
	IAAlarm *alarm =[alarms objectAtIndex:indexPath.row];
    cell.alarm = alarm;
    [cell setDistanceWithCurrentLocation:[YCSystemStatus deviceStatusSingleInstance].lastLocation]; //使用最后存储的位置
    
	
	if (indexPath.row != [IAAlarm alarmArray].count -1) { //最后的cell有bottomShadow
		cell.bottomShadowView.hidden = YES;
	}else {
		cell.bottomShadowView.hidden = NO;
	}
	
	if (indexPath.row != 0 ) { //第一个cell有topShadow
		cell.topShadowView.hidden = YES;
	}else {
		cell.topShadowView.hidden = NO;
	}
	
    
	return cell;
	
}




#pragma mark -
#pragma mark Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!tableView.editing)
        return UITableViewCellEditingStyleNone;  //禁止横滑出“删除” 按钮
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	NSArray *alarms = [IAAlarm alarmArray];
	IAAlarm *alarm =[alarms objectAtIndex:indexPath.row];
	
	/*
	self.detailController.alarm = alarm;
	self.detailController.newAlarm = NO;
	self.detailController.view = nil;
	[self presentModalViewController:self.detailNavigationController animated:YES];
	 */
	 
	
	/*
	AlarmDetailTableViewController *detailController1 = [[[AlarmDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    UINavigationController *detailNavigationController1 = [[[UINavigationController alloc] initWithRootViewController:detailController1] autorelease];
	detailController1.alarm = alarm;
	detailController1.newAlarm = NO;
	[self presentModalViewController:detailNavigationController1 animated:YES];
	
	*/
	
	
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *aNotification = [NSNotification notificationWithName:IAEditIAlarmButtonPressedNotification 
                                                                  object:self
                                                                userInfo:[NSDictionary dictionaryWithObject:alarm forKey:IAEditIAlarmButtonPressedNotifyAlarmObjectKey]];
    [notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:0.0];
	 
	
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    NSUInteger row = [indexPath row];
	NSArray *alarms = [IAAlarm alarmArray];
	NSUInteger countOfBeforeDelete = alarms.count;   //删除前的总数,为下面使用
	
	IAAlarm *alarm = [alarms objectAtIndex:row];
	[alarm deleteFromSender:self];
	//[alarm sendNotifyToUpdateAllViewsFromSender:self];
	
    
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                     withRowAnimation:UITableViewRowAnimationLeft];
	
	//行数＝＝0，转成不可编辑的状态
	NSUInteger rowCount = [self tableView:(UITableView*)self.view numberOfRowsInSection:0];
	if (rowCount == 0 && self.alarmListTableView.editing) {
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter postNotificationName:IAAlarmListEditStateDidChangeNotification object:self];
	}
	
	
	//重新加载 - 重新生成cell的阴影
	if (row == countOfBeforeDelete-1)  //删除的是最后一个
		[self.alarmListTableView reloadData];
	else 
		[self.alarmListTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

#pragma mark -
#pragma mark IABuyManagerDelegate
- (void)buyBeginWithManager:(IABuyManager *)manager{
	/*
	UIView *superView ;//= self.view.superview.superview.superview;
	NSArray *array = [UIApplication sharedApplication].windows;
	//superView = [[UIApplication sharedApplication].windows objectAtIndex:0];
	superView = [[UIApplication sharedApplication].delegate window];
	
	
	superView.clipsToBounds = NO;
	self.maskView.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
	[superView addSubview:self.maskView];
	self.maskView.hidden = NO;
	 
	//[self presentModalViewController:self.maskViewController animated:YES]; 
	 */
}
- (void)buyEndWithManager:(IABuyManager *)manager{
	//[self.maskView removeFromSuperview];
	//self.maskView.hidden = YES;
	//[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Memory management

//释放资源，在viewDidLoad或能按要求重新创建的
-(void)freeResouceRecreated{
	[self unRegisterNotifications];	 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
	[detailController release];
	detailController = nil;
    [detailNavigationController release];
	detailNavigationController = nil;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	[self freeResouceRecreated];
	
	self.backgroundTextLabel = nil;
	self.backgroundView = nil;
	self.alarmListTableView = nil;
	
}


- (void)dealloc {
	
	[self freeResouceRecreated];
	
	[detailController release];
	[detailNavigationController release];
	[backgroundTextLabel release];
	[backgroundView release];
	[alarmListTableView release];
    [lastUpdateDistanceTimestamp release];
    [super dealloc];
}


@end

