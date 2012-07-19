//
//  AlarmLRepeatTypeViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmBeginEndViewController.h"
#import "YCLib.h"
#import "AlarmLRepeatTypeViewController.h"
#import "DicManager.h"
#import "YCRepeatType.h"
#import "IAAlarm.h"

@interface AlarmLRepeatTypeViewController (private)

- (void)_makeSections;

@end


@implementation AlarmLRepeatTypeViewController

@synthesize beginEndSwitchCell = _beginEndSwitchCell, beginEndCell = _beginEndCell, beginEndSwitch = _beginEndSwitch;
@synthesize sameSwitchCell = _sameSwitchCell, sameSwitch = _sameSwitch;

#pragma mark - private

- (void)_makeSections{
    [_sections release];
    _sections = [[NSMutableArray array] retain];
    
    //重复类型cells
    NSUInteger numberOfRepeatTypeSection = [DicManager repeatTypeDictionary].count;
    NSMutableArray *repeatTypeSection = [NSMutableArray arrayWithCapacity:numberOfRepeatTypeSection];
    
    for (NSUInteger i = 0; i < numberOfRepeatTypeSection; i++) {
        YCRepeatType *rep = [DicManager repeatTypeForSortId:i];
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        
        NSString *repeatString = rep.repeatTypeName;
		cell.textLabel.text = repeatString;
        
        if (i == _lastIndexPathOfType.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark ;
			cell.textLabel.textColor = [UIColor tableCellBlueTextYCColor];
        }else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.textColor = [UIColor darkTextColor];
		}
        
        [repeatTypeSection addObject:cell];
    }
    [_sections addObject:repeatTypeSection];//+ section
    
    
    //重置开关
    if ([self.beginEndSwitch respondsToSelector:@selector(setOnTintColor:)]) 
        self.beginEndSwitch.onTintColor = [UIColor switchBlue];
    self.beginEndSwitch.enabled = YES;
    self.beginEndSwitchCell.textLabel.enabled = YES;
    if ([self.sameSwitch respondsToSelector:@selector(setOnTintColor:)]) 
        self.sameSwitch.onTintColor = [UIColor switchBlue];
    self.sameSwitch.enabled = YES;
    self.sameSwitchCell.textLabel.enabled = YES;
    
    if (_lastIndexPathOfType.row == 0) {//仅闹一次
        //启用开关cell
        NSArray *beginEndSwitchSection = [NSArray arrayWithObjects:self.beginEndSwitchCell, nil];
        self.beginEndSwitchCell.textLabel.text = @"启用定时提醒";
        self.beginEndSwitchCell.accessoryView = self.beginEndSwitch;        
        [_sections addObject:beginEndSwitchSection]; //+ section
        
        
        //开始结束cell，
        _beginEndSection = [[NSArray arrayWithObjects:self.beginEndCell, nil] retain];
        self.beginEndCell.textLabel.text = @"开始\r\n结束";
        self.beginEndCell.detailTextLabel.text = @"2:00 AM\r\n4:00 PM";
        self.beginEndCell.textLabel.numberOfLines = 2;
        self.beginEndCell.detailTextLabel.numberOfLines = 2;
        
        if (self.beginEndSwitch.on) {
            [_sections addObject:_beginEndSection];//+ section
        }
        
    }else {//连续闹钟
        if (_selectedOfDays == nil) {
            _selectedOfDays = [[NSMutableSet setWithObjects: @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日",nil] retain];
        }
        
        //如果日期不连续，必须要启用定时
        if (!(_selectedOfDays.count == 7 || _selectedOfDays.count == 0)) {
            
            [self.beginEndSwitch setOn:YES animated:YES];
            
            if ([self.beginEndSwitch respondsToSelector:@selector(setOnTintColor:)]) 
                self.beginEndSwitch.onTintColor = [UIColor lightGrayColor];
            self.beginEndSwitch.enabled = NO;
            self.beginEndSwitchCell.textLabel.enabled = NO;
        }
        
        //一个日期也不选，就是仅闹一次。当然没有不同时间的选项了。
        if (_selectedOfDays.count == 0) {
            
            [self.sameSwitch setOn:YES animated:YES];
            
            if ([self.sameSwitch respondsToSelector:@selector(setOnTintColor:)]) 
                self.sameSwitch.onTintColor = [UIColor lightGrayColor];
            self.sameSwitch.enabled = NO;
            self.sameSwitchCell.textLabel.enabled = NO;
        }
       
        //星期cell
        NSMutableArray *daysSection = [NSMutableArray array];
        for (int i = 0; i<7; i++) {
            YCCheckMarkCell *dayCell = nil;
            if (self.sameSwitch.on) {
                dayCell = [[[YCCheckMarkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DayCell" checkMarkType:YCCheckMarkTypeRight] autorelease];
            }else {
                dayCell = [[[YCCheckMarkCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DayCell" checkMarkType:YCCheckMarkTypeLeft] autorelease];
                dayCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                dayCell.detailTextLabel.text = @"2:00 AM - 4:00 PM";
            }
            [daysSection addObject:dayCell];
            
            NSString *dayString = nil;
            switch (i) {
                case 0:
                    dayString = @"星期一";
                    break;
                case 1:
                    dayString = @"星期二";
                    break;
                case 2:
                    dayString = @"星期三";
                    break;
                case 3:
                    dayString = @"星期四";
                    break;
                case 4:
                    dayString = @"星期五";
                    break;
                case 5:
                    dayString = @"星期六";
                    break;
                case 6:
                    dayString = @"星期日";
                    break;
                default:
                    break;
            }

            dayCell.textLabel.text = dayString;
            dayCell.checkmark = [_selectedOfDays containsObject:dayString];
            
            
        }
        
        [_sections addObject:daysSection];//+ section
        
        //启用开关cell
        NSArray *beginEndSwitchSection = [NSArray arrayWithObjects:self.beginEndSwitchCell, nil];
        self.beginEndSwitchCell.textLabel.text = @"启用定时提醒";
        self.beginEndSwitchCell.accessoryView = self.beginEndSwitch;        
        [_sections addObject:beginEndSwitchSection]; //+ section
        
        
        
        if (self.beginEndSwitch.on) {
            
            //相同提醒时间cell
            NSArray *sameSection = [NSArray arrayWithObjects:self.sameSwitchCell, nil];
            self.sameSwitchCell.textLabel.text = @"开始结束时间相同";
            self.sameSwitchCell.accessoryView = self.sameSwitch;
            [_sections addObject:sameSection];//+ section
            
            //开始结束cell，
            if (self.sameSwitch.on) {
                _beginEndSection = [[NSArray arrayWithObjects:self.beginEndCell, nil] retain];
                self.beginEndCell.textLabel.text = @"开始\r\n结束";
                self.beginEndCell.detailTextLabel.text = @"2:00 AM\r\n4:00 PM";
                self.beginEndCell.textLabel.numberOfLines = 2;
                self.beginEndCell.detailTextLabel.numberOfLines = 2;
                
                [_sections addObject:_beginEndSection];//+ section
            }
            
        }
                
        
        
    }
   
}

#pragma mark -

//覆盖父类
- (void)saveData{	    
	YCRepeatType *rep = [DicManager repeatTypeForSortId:_lastIndexPathOfType.row];
	self.alarm.repeatType = rep;
}
 

- (IBAction)beginEndSwitchValueDidChange:(id)sender{
    if (_lastIndexPathOfType.row == 1) {
        if (!self.beginEndSwitch.on) { 
            self.sameSwitch.on = YES;//连续闹钟,不开启定时。必然是使用同一时间
        }
    }
    
    [self _makeSections];
    [self.tableView reloadDataAnimated:YES];
    
    //让最低部分可视
    if (_lastIndexPathOfType.row == 1) {
        if (self.beginEndSwitch.on) { 
            CGFloat x = 0.0;
            CGFloat y = self.tableView.contentSize.height-1.0;
            CGRect bottomRect = (CGRect){{x,y},{320.0,1.0}};
            
            [self.tableView scrollRectToVisible:bottomRect animated:YES];
        }
    }
}

- (IBAction)sameSwitchValueDidChange:(id)sender{
    [self _makeSections];
    [self.tableView reloadDataAnimated:YES];
    
    //让最低部分可视
    if (_lastIndexPathOfType.row == 1) {
        if (self.sameSwitch.on) { 
            CGFloat x = 0.0;
            CGFloat y = self.tableView.contentSize.height-1.0;
            CGRect bottomRect = (CGRect){{x,y},{320.0,1.0}};
            
            [self.tableView scrollRectToVisible:bottomRect animated:YES];
        }
    }
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad{
    
    [super viewDidLoad];
	self.title = KViewTitleRepeat;
    
    _lastIndexPathOfType = [[NSIndexPath indexPathForRow:self.alarm.repeatType.sortId inSection:0] retain];
    [self _makeSections];
}
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

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

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    switch (indexPath.section) {
        case 0://重复类型
        {
            int newRow = [indexPath row];
            int oldRow = (_lastIndexPathOfType != nil) ? [_lastIndexPathOfType row] : -1;
            
            if (newRow != oldRow)
            {
                UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
                newCell.accessoryType = UITableViewCellAccessoryCheckmark;
                newCell.textLabel.textColor = [UIColor tableCellBlueTextYCColor];
                
                UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastIndexPathOfType]; 
                oldCell.accessoryType = UITableViewCellAccessoryNone;
                oldCell.textLabel.textColor = [UIColor darkTextColor];
                [_lastIndexPathOfType release];
                _lastIndexPathOfType = [indexPath retain];
                
                
                [self _makeSections];
                [self.tableView reloadDataAnimated:YES];
            }
            
            break;
        }
        case 1:
        {
            if (_lastIndexPathOfType.row == 1) { //连续闹钟
                NSString *dayString = nil;
                switch (indexPath.row) {
                    case 0:
                        dayString = @"星期一";
                        break;
                    case 1:
                        dayString = @"星期二";
                        break;
                    case 2:
                        dayString = @"星期三";
                        break;
                    case 3:
                        dayString = @"星期四";
                        break;
                    case 4:
                        dayString = @"星期五";
                        break;
                    case 5:
                        dayString = @"星期六";
                        break;
                    case 6:
                        dayString = @"星期日";
                        break;
                    default:
                        break;
                }
                
                YCCheckMarkCell *dayCell = (YCCheckMarkCell*)[tableView cellForRowAtIndexPath:indexPath];
                if (dayCell.checkmark) {
                    [_selectedOfDays addObject:dayString];
                }else {
                    [_selectedOfDays removeObject:dayString];
                }
                
                
                //让beginEndSwitchCell可视   
                if (![self.tableView.visibleCells containsObject:self.beginEndSwitchCell])
                {
                    NSIndexPath *begionEndCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
                    [tableView scrollToRowAtIndexPath:begionEndCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
                [self _makeSections];
                [self.tableView reloadDataAnimated:NO];

            }
            
            break;

        }
        default:
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell == self.beginEndCell) {
                if (beginDate == nil) {
                    beginDate = [[NSDate date] retain];
                    endDate = [[NSDate date] retain];
                }

                if (_alarmBeginEndViewController == nil) {
                    _alarmBeginEndViewController = [[AlarmBeginEndViewController alloc] initWithNibName:@"AlarmBeginEndViewController" bundle:nil beginTime:beginDate endTime:endDate];
                }
                [self.navigationController pushViewController:_alarmBeginEndViewController animated:YES];
            }
            break;
        }
    }
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
         return 44;
    }else {
        if (_lastIndexPathOfType.row == 0) { //仅闹一次
            if (indexPath.section == 2) //开始结束cell
                return 64;
            else 
                return 44;
        }else {//连续闹钟
            if (self.sameSwitch.on && indexPath.section == 4) //开始结束cell
                return 64;
            else 
                return 44;
        }
    }
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_lastIndexPathOfType release];
    [_alarmBeginEndViewController release];
    [super dealloc];
}


@end

