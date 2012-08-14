//
//  AlarmBeginEndViewController.m
//  iAlarm
//
//  Created by li shiyong on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCParam.h"
#import "LocalizedString.h"
#import "YCLib.h"
#import "IAAlarmSchedule.h"
#import "AlarmBeginEndViewController.h"

@interface AlarmBeginEndViewController ()

- (void)_updateUI;
- (void)setSkinWithType:(IASkinType)type;

@end

@implementation AlarmBeginEndViewController

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
    [self.tableView setYCBackgroundStyle:tableViewBgStyle];    
    [self.tableView reloadData];
}

@synthesize tableView = _tableView;
@synthesize beginCell = _beginCell, endCell = _endCell, timePicker = _timePicker;

- (void)_updateUI{
    //cell上的时间文本
    if (-1 != _alarmCalendar.weekDay) //有星期信息
        self.beginCell.detailTextLabel.text = [_alarmCalendar.beginTime stringOfTimeWeekDayShortStyle];
    else 
        self.beginCell.detailTextLabel.text = [_alarmCalendar.beginTime stringOfTimeShortStyle];
    
    
    if ( _alarmCalendar.endTimeInNextDay) {//结束与开始不在同一天
        if (-1 != _alarmCalendar.weekDay) 
            self.endCell.detailTextLabel.text = [_alarmCalendar.endTime stringOfTimeWeekDayShortStyle];
        else {
            NSString *s = [NSString stringWithFormat:@"%@, %@", KWDSTitleNextDay, [_alarmCalendar.endTime stringOfTimeShortStyle]];
            self.endCell.detailTextLabel.text = s;
        }
        
    }else 
        self.endCell.detailTextLabel.text = [_alarmCalendar.endTime stringOfTimeShortStyle];
}

- (IBAction)timePickerValueDidChange:(id)sender{
    
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.beginCell) {
        _alarmCalendar.beginTime = [self.timePicker.date retain];
    }else {
        _alarmCalendar.endTime = [self.timePicker.date retain];
    }
    
    [self _updateUI];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarmCalendar:(IAAlarmSchedule*)alarmCalendar{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _alarmCalendar = [alarmCalendar retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = KAPTitleBeginTimeAndEndTime;
    
    [self _updateUI];
        
    self.beginCell.textLabel.text = KAPTitleBeginTime;
    self.endCell.textLabel.text = KAPTitleEndTime;
    
    _sections = [[NSMutableArray array] retain];
    NSArray *beginEndSection = [NSArray arrayWithObjects:self.beginCell, self.endCell, nil];
    [_sections addObject:beginEndSection];
    
    CGFloat heightOfBeginCell = 44.0;
    CGFloat heightOfEndCell = 44.0;
    NSNumber *heightOfBeginCellObj = [NSNumber numberWithFloat:heightOfBeginCell];
    NSNumber *heightOfEndCellObj = [NSNumber numberWithFloat:heightOfEndCell];
    
    _heightOfCells = [[NSMutableArray array] retain];
    NSArray *heightOfBeginEndSection = [NSArray arrayWithObjects:heightOfBeginCellObj, heightOfEndCellObj, nil];
    [_heightOfCells addObject:heightOfBeginEndSection];
    
    //选中beginCell
    NSIndexPath *IndexPathOfbeginCell = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:IndexPathOfbeginCell animated:NO scrollPosition:UITableViewScrollPositionBottom];

    //skin Style
    [self setSkinWithType:[YCParam paramSingleInstance].skinType];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    if (cell == self.beginCell) {
        self.timePicker.date = _alarmCalendar.beginTime;
    }else {
        self.timePicker.date = _alarmCalendar.endTime;
    }
}


#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *heightObj = [[_heightOfCells objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return [heightObj floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.beginCell) {
        [self.timePicker setDate:_alarmCalendar.beginTime animated:YES];
    }else if (cell == self.endCell) {
        [self.timePicker setDate:_alarmCalendar.endTime animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56.0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" "; //4.2前没这个不行
}
 

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.beginCell = nil;
    self.endCell = nil;
    self.timePicker = nil;
    [_sections release]; _sections = nil;
    [_heightOfCells release];_heightOfCells = nil;
}

- (void)dealloc{
    [_tableView release];
    [_beginCell release];
    [_endCell release];
    [_timePicker release];
    [_sections release];
    [_heightOfCells release];
    [_alarmCalendar release];
    [super dealloc];
}


@end
