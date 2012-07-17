//
//  AlarmLRepeatTypeViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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
    
    
    if (_lastIndexPathOfType.row == 0) {//仅闹一次
        //启用开关cell
        NSArray *switchSection = [NSArray arrayWithObjects:self.beginEndSwitchCell, nil];
        self.beginEndSwitchCell.textLabel.text = @"启用定时提醒";
        self.beginEndSwitchCell.accessoryView = self.beginEndSwitch;        
        [_sections addObject:switchSection]; //加
        
        
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
       
        
        //星期cell
        NSMutableArray *daysSection = [NSMutableArray array];
        if (_selectedOfDays == nil) {
            _selectedOfDays = [[NSMutableSet setWithObjects: @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日",nil] retain];
        }
        for (int i = 0; i<7; i++) {
            UITableViewCell *dayCell = nil;
            if (self.sameSwitch.on) {
                dayCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DayCell"] autorelease];
            }else {
                dayCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DayCell"] autorelease];
                [dayCell setCellYCType:YCTableViewCellTypeCanCheckDetailDisclosure];
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
        
        //开始结束cell，
        if (self.sameSwitch.on) {
            _beginEndSection = [[NSArray arrayWithObjects:self.beginEndCell, nil] retain];
            self.beginEndCell.textLabel.text = @"开始\r\n结束";
            self.beginEndCell.detailTextLabel.text = @"2:00 AM\r\n4:00 PM";
            self.beginEndCell.textLabel.numberOfLines = 2;
            self.beginEndCell.detailTextLabel.numberOfLines = 2;
            
            [_sections addObject:_beginEndSection];//+ section
        }
        
        //相同提醒时间cell
        NSArray *sameSection = [NSArray arrayWithObjects:self.sameSwitchCell, nil];
        self.sameSwitchCell.textLabel.text = @"开始结束时间相同";
        self.sameSwitchCell.accessoryView = self.sameSwitch;
        [_sections addObject:sameSection];//+ section
        
        
   

        
        //启用开关cell TODO
        
        
    }
   
}

#pragma mark -

//覆盖父类
- (void)saveData{	    
	YCRepeatType *rep = [DicManager repeatTypeForSortId:_lastIndexPathOfType.row];
	self.alarm.repeatType = rep;
}
 

- (IBAction)beginEndSwitchValueDidChange:(id)sender{
    /*
    if (self.beginEndSwitch.on) {
        if (NSNotFound == [_sections indexOfObject:_beginEndSection]) 
            [_sections addObject:_beginEndSection];
    }else{
        [_sections removeObject:_beginEndSection];
    }
    
    [self.tableView reloadData];
     */
    [self _makeSections];
    [self.tableView reloadData];
}

- (IBAction)sameSwitchValueDidChange:(id)sender{
    [self _makeSections];
    [self.tableView reloadData];
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
                [self.tableView reloadData];
            }
            
            break;
        }
        case 1:
        {
            
            UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
            selectedCell.checkmark = !selectedCell.checkmark;
            
            break;

        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    UITableViewCell *cell = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell.bounds.size.height-1;
     */
    if (indexPath.section == 0) {
         return 44;
    }else {
        if (_lastIndexPathOfType.row == 0) { //仅闹一次
            if (indexPath.section == 2) 
                return 64;
            else 
                return 44;
        }else {//连续闹钟
            if (self.sameSwitch.on && indexPath.section == 2) 
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
    [super dealloc];
}


@end

