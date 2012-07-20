//
//  AlarmBeginEndViewController.m
//  iAlarm
//
//  Created by li shiyong on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "IAAlarmCalendar.h"
#import "AlarmBeginEndViewController.h"

@interface AlarmBeginEndViewController ()

@end

@implementation AlarmBeginEndViewController

@synthesize tableView = _tableView;
@synthesize beginCell = _beginCell, endCell = _endCell, timePicker = _timePicker;

- (IBAction)timePickerValueDidChange:(id)sender{
    
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = [self.timePicker.date stringOfTimeShortStyle];
    if (cell == self.beginCell) {
        _alarmCalendar.beginTime = [self.timePicker.date retain];
    }else {
        _alarmCalendar.endTime = [self.timePicker.date retain];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarmCalendar:(IAAlarmCalendar*)alarmCalendar{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _alarmCalendar = [alarmCalendar retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"开始与结束";
    
    self.beginCell.detailTextLabel.text = [_alarmCalendar.beginTime stringOfTimeShortStyle];
    self.endCell.detailTextLabel.text = [_alarmCalendar.endTime stringOfTimeShortStyle];
    self.beginCell.textLabel.text = @"开始";
    self.endCell.textLabel.text = @"结束";
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
