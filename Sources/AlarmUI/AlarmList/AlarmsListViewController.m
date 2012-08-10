//
//  RootViewController.m
//  TestLocationTableCell1
//
//  Created by li shiyong on 10-12-16.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
//#import "iAlarmAppDelegate.h"
//#import "UIApplication-YC.h"

#import "YCLib.h"
#import "IARegionsCenter.h"
#import "YCSystemStatus.h"
#import "IANotifications.h"
#import "YCParam.h"
#import "IABuyManager.h"
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

-(void)setUIEditing:(BOOL)theEditing{
	NSUInteger rowCount = [self tableView:(UITableView*)self.view numberOfRowsInSection:0];
	self.backgroundTextLabel.hidden = (rowCount > 0); //背景文字
    
	if (rowCount == 0) {//行数>0,才可以编辑
		[self.alarmListTableView setEditing:NO animated:YES] ;
		self.navigationItem.leftBarButtonItem = nil; //编辑按钮 
	}else {
		[self.alarmListTableView setEditing:theEditing animated:YES];
	}
}

#pragma mark -
#pragma mark Notification

//tableView的编辑状态
- (void) handle_alarmListEditStateDidChange:(NSNotification*) notification {
	//还没加载
	if (![self isViewLoaded]) return;
	
	NSNumber *isEditingObj = [[notification userInfo] objectForKey:IAEditStatusKey];

    [self setUIEditing:[isEditingObj boolValue]];
}

//闹钟列表发生变化
- (void) handle_alarmsDataListDidChange:(id)notification {
	
	[self setUIEditing:self.alarmListTableView.editing];
	
	if ([(NSNotification*)notification object] != self) {  //自己改变就不用更新了，更新了还会有删除第一行问题
        [self.alarmListTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.0];
	}
}

- (void) handle_applicationWillResignActive:(id)notification{	
	//恢复navbar 标题
	self.navigationItem.titleView = nil;
}

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
	 	
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationWillResignActive:)
							   name: UIApplicationWillResignActiveNotification
							 object: nil];
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: IAAlarmListEditStateDidChangeNotification object: nil];
	[notificationCenter removeObserver:self	name: IAAlarmsDataListDidChangeNotification object: nil];
	[notificationCenter removeObserver:self	name: UIApplicationWillResignActiveNotification object: nil];
}



#pragma mark -
#pragma mark Events Handle

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
    [super viewDidLoad];
	[self registerNotifications];
    self.title = KViewTitleAlarmsList;

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
	
	//刷新编辑状态
	[self setUIEditing:[YCSystemStatus sharedSystemStatus].isAlarmListEditing];
    
    //刷新距离
    CLLocation *location = [YCSystemStatus sharedSystemStatus].lastLocation;
    if ([UIApplication sharedApplication].timeElapsingAfterApplicationDidFinishLaunching  < 5.0) {//小于x秒，刚启动，第一次显示view
        //第一次刷新距离，判断一下数据的时间戳，防止是很久前缓存的。
        NSTimeInterval ti = [location.timestamp timeIntervalSinceNow];
        if (ti < -120) location = nil; //120秒内的数据可用。最后位置过久，不用.
    }
    for (AlarmsListCell *aCell in self.alarmListTableView.visibleCells) {
        [aCell updateCell];
    }
    
}
 

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
    [self.alarmListTableView reloadData];//为了雷达扫描
}


- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
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
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;//展示按钮
		//cell.selectionStyle = UITableViewCellSelectionStyleNone;  //被选择后，无变化
	}
	
	NSArray *alarms = [IAAlarm alarmArray];
	IAAlarm *alarm =[alarms objectAtIndex:indexPath.row];
    cell.alarm = alarm;
    [cell updateCell]; //使用最后存储的位置
    
	
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{

    if (fromIndexPath.row == toIndexPath.row) 
        return;
    
    //列表顺序改变后 保存 
    NSMutableArray *alarms = (NSMutableArray*)[IAAlarm alarmArray];
    id object = [[alarms objectAtIndex:fromIndexPath.row] retain];
    [alarms removeObjectAtIndex:fromIndexPath.row];
    [alarms insertObject:object atIndex:toIndexPath.row];
    [object release];
    [IAAlarm saveAlarms];
        
    [UIView animateWithDuration:0.0 animations:^{;} completion:^(BOOL finished)
    {
        NSMutableArray *alarms = (NSMutableArray*)[IAAlarm alarmArray];
        
        NSDate *date = [NSDate date];
        while (self.alarmListTableView.visibleCells.count != alarms.count //如果cell总数小于4，可视cell数目等于所有的cell，说明着移动完成了。
               && self.alarmListTableView.visibleCells.count != 4 //可视cell的数目等于4，说明着移动完成了。
               && fabs([date timeIntervalSinceNow]) < 5.0) 
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        //上下阴影
        for (AlarmsListCell *aCell in self.alarmListTableView.visibleCells) {
            NSIndexPath *indexPath = [self.alarmListTableView indexPathForCell:aCell];
            
            if (alarms.count ==1) { //共一行
                aCell.topShadowView.hidden = NO;
                aCell.bottomShadowView.hidden = NO;
            }else if (indexPath.row == 0) {
                aCell.topShadowView.hidden = NO;
                aCell.bottomShadowView.hidden = YES;
            }else if(indexPath.row == (alarms.count -1)){
                aCell.topShadowView.hidden = YES;
                aCell.bottomShadowView.hidden = NO;
            }else{
                aCell.topShadowView.hidden = YES;
                aCell.bottomShadowView.hidden = YES;
            }
            
        }
 
    }];
        
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
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	NSLog(@"AlarmsListViewController dealloc");
    [super viewDidUnload];
	[self unRegisterNotifications];	 
    
	[detailController release];detailController = nil;
	[detailNavigationController release];detailNavigationController = nil;
    self.alarmListTableView = nil;
	self.backgroundTextLabel = nil;
	self.backgroundView = nil;
}


- (void)dealloc {
    NSLog(@"AlarmsListViewController dealloc");
	[self unRegisterNotifications];	 
	
	[detailController release];
	[detailNavigationController release];
    [alarmListTableView release];
	[backgroundTextLabel release];
	[backgroundView release];
    [super dealloc];
}


@end

