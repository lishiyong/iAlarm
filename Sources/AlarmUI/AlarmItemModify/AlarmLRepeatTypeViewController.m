//
//  AlarmLRepeatTypeViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAParam.h"
#import "IAAlarmSchedule.h"
#import "AlarmBeginEndViewController.h"
#import "YCLib.h"
#import "AlarmLRepeatTypeViewController.h"
#import "DicManager.h"
#import "YCRepeatType.h"
#import "IAAlarm.h"

@interface AlarmLRepeatTypeViewController (private)

- (void)_makeSections;

/*
 *在7个中，有效的alarmCalendar。
 */
- (NSIndexSet*)_vaildIndexSetOfAlwaysAlarmCalendars;


- (void)setSkinWithType:(IASkinType)type;

@end


@implementation AlarmLRepeatTypeViewController

@synthesize beginEndSwitchCell = _beginEndSwitchCell, beginEndCell = _beginEndCell, beginEndSwitch = _beginEndSwitch;
@synthesize sameSwitchCell = _sameSwitchCell, sameSwitch = _sameSwitch;

- (void)setSkinWithType:(IASkinType)type{
    YCTableViewBackgroundStyle tableViewBgStyle = YCTableViewBackgroundStyleDefault;
    if (IASkinTypeDefault == type) {
        tableViewBgStyle = YCTableViewBackgroundStyleDefault;
    }else {
        tableViewBgStyle = YCTableViewBackgroundStyleSilver;
    }
    [self.tableView setYCBackgroundStyle:tableViewBgStyle];
    [self.tableView reloadData];
}

#pragma mark - private

- (NSIndexSet*)_vaildIndexSetOfAlwaysAlarmCalendars{
    return [_alwaysAlarmSchedules indexesOfObjectsPassingTest:^BOOL(IAAlarmSchedule *obj, NSUInteger idx, BOOL *stop) {
        return obj.vaild;
    }];
}

- (void)_makeSections{

    [_sections release];
    _sections = [[NSMutableArray array] retain];
    
    
    //重置开关
    if ([self.beginEndSwitch respondsToSelector:@selector(setOnTintColor:)]) 
        self.beginEndSwitch.onTintColor = [UIColor switchBlue];
    self.beginEndSwitch.enabled = YES;
    self.beginEndSwitchCell.textLabel.enabled = YES;
    if ([self.sameSwitch respondsToSelector:@selector(setOnTintColor:)]) 
        self.sameSwitch.onTintColor = [UIColor switchBlue];
    self.sameSwitch.enabled = YES;
    self.sameSwitchCell.textLabel.enabled = YES;
    
    
    //开始结束cell
    self.beginEndCell.textLabel.text = [NSString stringWithFormat:@"%@\r\n%@",KAPTitleBeginTime,KAPTitleEndTime];    
    if (_onceAlarmSchedule.endTimeInNextDay) { //endTime 比 beginTime早
        self.beginEndCell.detailTextLabel.text = [NSString stringWithFormat:@"%@\r\n%@, %@",[_onceAlarmSchedule.beginTime stringOfTimeShortStyle],KWDSTitleNextDay,[_onceAlarmSchedule.endTime stringOfTimeShortStyle]];//@"8:00 AM 次日, 21:00 PM"
    }else {
        self.beginEndCell.detailTextLabel.text = [NSString stringWithFormat:@"%@\r\n%@",[_onceAlarmSchedule.beginTime stringOfTimeShortStyle],[_onceAlarmSchedule.endTime stringOfTimeShortStyle]]; //@"8:00 AM 21:00 PM"
    }
    self.beginEndCell.textLabel.numberOfLines = 2;
    self.beginEndCell.detailTextLabel.numberOfLines = 2;
    
    //启用开关cell
    self.beginEndSwitchCell.textLabel.text = KAPTitleTimeSwitch;
    self.beginEndSwitchCell.accessoryView = self.beginEndSwitch;
    
    //相同提醒时间cell
    self.sameSwitchCell.textLabel.text = KAPTitleSameBeginEndTime;
    self.sameSwitchCell.accessoryView = self.sameSwitch;
    
    
    ///////////////////////////////////////////////////////////
    
    
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
        NSArray *beginEndSwitchSection = [NSArray arrayWithObjects:self.beginEndSwitchCell, nil];       
        [_sections addObject:beginEndSwitchSection]; //+ section
        
        
        //开始结束cell，
        NSArray *beginEndSection = [NSArray arrayWithObjects:self.beginEndCell, nil];
        if (self.beginEndSwitch.on) {
            [_sections addObject:beginEndSection];//+ section
        }
        
    }else {//连续闹钟
        
        //如果日期不连续，必须要启用定时
        if (!([self _vaildIndexSetOfAlwaysAlarmCalendars].count == 7 || [self _vaildIndexSetOfAlwaysAlarmCalendars].count == 0)) {
            
            [self.beginEndSwitch setOn:YES animated:YES];
            
            if ([self.beginEndSwitch respondsToSelector:@selector(setOnTintColor:)]) 
                self.beginEndSwitch.onTintColor = [UIColor lightGrayColor];
            self.beginEndSwitch.enabled = NO;
            self.beginEndSwitchCell.textLabel.enabled = NO;
        }
        
        //一个日期也不选，就是仅闹一次。当然没有不同时间的选项了。
        /*
        if ([self _vaildIndexSetOfAlwaysAlarmCalendars].count == 0) {
            
            [self.sameSwitch setOn:YES animated:YES];
            
            if ([self.sameSwitch respondsToSelector:@selector(setOnTintColor:)]) 
                self.sameSwitch.onTintColor = [UIColor lightGrayColor];
            self.sameSwitch.enabled = NO;
            self.sameSwitchCell.textLabel.enabled = NO;
        }
         */
       
        //星期cell
        NSMutableArray *daysSection = [NSMutableArray array];
        for (int i = 0; i<7; i++) {
            IAAlarmSchedule *aCalendar = (IAAlarmSchedule *)[_alwaysAlarmSchedules objectAtIndex:i];
            YCCheckMarkCell *dayCell = nil;
            if (self.sameSwitch.on) {
                dayCell = [[[YCCheckMarkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DayCell" checkMarkType:YCCheckMarkTypeRight] autorelease];
            }else {
                dayCell = [[[YCCheckMarkCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DayCell" checkMarkType:YCCheckMarkTypeLeft] autorelease];
                dayCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

                NSDate *endTime = aCalendar.endTime;
                NSDate *beginTime = aCalendar.beginTime;
                if (aCalendar.endTimeInNextDay) { //endTime 比 beginTime早
                    dayCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",[beginTime stringOfTimeShortStyle],[endTime stringOfTimeWeekDayShortStyle]]; //8:00 - 周五21:00
                }else {
                    dayCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",[beginTime stringOfTimeShortStyle],[endTime stringOfTimeShortStyle]]; //8:00 - 21:00
                }
            }
            [daysSection addObject:dayCell];
            
            dayCell.textLabel.text = aCalendar.name;  //每周一，每周二 ...每周日          
            dayCell.checkmark = [[self _vaildIndexSetOfAlwaysAlarmCalendars] containsIndex:i] ;
        }
        
        [_sections addObject:daysSection];//+ section
        
        //启用开关cell
        NSArray *beginEndSwitchSection = [NSArray arrayWithObjects:self.beginEndSwitchCell, nil];
        [_sections addObject:beginEndSwitchSection]; //+ section
        
        
        
        if (self.beginEndSwitch.on) {
            
            //相同提醒时间cell
            NSArray *sameSection = [NSArray arrayWithObjects:self.sameSwitchCell, nil];
            [_sections addObject:sameSection];//+ section
            
            //开始结束cell，
            if (self.sameSwitch.on) {
                NSArray *beginEndSection = [NSArray arrayWithObjects:self.beginEndCell, nil];
                [_sections addObject:beginEndSection];//+ section
            }
            
        }
        
    }
   
}

#pragma mark - 覆盖父类

- (void)saveData{	
  
    //一个也不选中，也等于仅闹一次
    BOOL once = (_lastIndexPathOfType.row == 0) || ([self _vaildIndexSetOfAlwaysAlarmCalendars].count == 0);
    
    //
    YCRepeatType *rep = [DicManager repeatTypeForSortId:once ? 0 : 1];
	self.alarm.repeatType = rep;
    
    //
    self.alarm.usedAlarmSchedule = self.beginEndSwitch.on;
    
    //
    if (self.alarm.usedAlarmSchedule) {
    
        if (once) {
            _onceAlarmSchedule.repeatInterval = 0; //不重复
            _onceAlarmSchedule.weekDay = -1;
            _onceAlarmSchedule.vaild = YES;
            self.alarm.alarmSchedules = [NSArray arrayWithObjects:_onceAlarmSchedule, nil];
        }else {
            [_alwaysAlarmSchedules enumerateObjectsUsingBlock:^(IAAlarmSchedule *obj, NSUInteger idx, BOOL *stop) {
                
                if (6 == idx) //1：周日 2：周1 ... 7：周六. 
                    obj.weekDay = 1;
                else 
                    obj.weekDay = idx + 2;
                
                obj.repeatInterval = NSWeekCalendarUnit;
                if (self.sameSwitch.on) { //使用相同的开始结束
                    obj.beginTime = _onceAlarmSchedule.beginTime;
                    obj.endTime = _onceAlarmSchedule.endTime;
                }
                //obj.vaild = ;
            }];
            
            self.alarm.alarmSchedules = _alwaysAlarmSchedules;
        }
        
    }else {
        self.alarm.alarmSchedules = nil;
    }
    
    //
    self.alarm.sameBeginEndTime = self.sameSwitch.on;
    
}

#pragma mark - 

- (IBAction)beginEndSwitchValueDidChange:(id)sender{

    //生成indexSet供cell动画用。必须在 self.sameSwitch.on 的前面
     NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    if (0 == _lastIndexPathOfType.row) {
        [indexSet addIndex:2];
    }else {
        [indexSet addIndex:3];
        if (self.sameSwitch.on) 
            [indexSet addIndex:4];
    }
    
    //保存变化前sections数量
    NSUInteger oldSectionCount = _sections.count; 
    
    //生成sections
    if (_lastIndexPathOfType.row == 1) {
        if (!self.beginEndSwitch.on) { 
            [self.sameSwitch setOn:YES animated:YES];//连续闹钟,不开启定时。为了使用“右选择cell”，通过sameSwitch.on = YES 做标识。
        }
    }
    [self _makeSections];
    
    //cell动画插入或删除
    if (self.beginEndSwitch.on) {
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }else {
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }

    //星期cell可能变化了，需要刷新一下
    if (_lastIndexPathOfType.row == 1) 
    {
        [self.tableView reloadData];
    }else {
        //刷新原来最后一个section，为了刷新sectionFooter
        if (oldSectionCount >0 && oldSectionCount <= _sections.count) {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:oldSectionCount -1] withRowAnimation:UITableViewRowAnimationNone];
        }
    }

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
    //生成sections
    [self _makeSections];
    
    //生成indexSet供cell动画用
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:4];
    
    //cell动画插入或删除
    if (self.sameSwitch.on) {
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }else {
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
    //星期cell可能变化了，需要刷新一下
    [self.tableView reloadData];

    
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
    _lastIndexPathOfType = [[NSIndexPath indexPathForRow:self.alarm.repeatType.sortId inSection:0] retain];
    
    self.beginEndSwitch.on = self.alarm.usedAlarmSchedule;
    self.sameSwitch.on = self.alarm.sameBeginEndTime;
    //临时的日历
    if (self.alarm.usedAlarmSchedule) {
        if (self.alarm.alarmSchedules.count == 1) {
            _onceAlarmSchedule = [[self.alarm.alarmSchedules objectAtIndex:0] retain];
        }else if (self.alarm.alarmSchedules.count == 7){
            _alwaysAlarmSchedules = [self.alarm.alarmSchedules retain];
            _onceAlarmSchedule = [[_alwaysAlarmSchedules objectAtIndex:0] copy];//
            
        }
    }
    _onceAlarmSchedule.repeatInterval = 0; //不重复
    _onceAlarmSchedule.weekDay = -1;
    
    [self _makeSections];
    
    
    //如果空
    if (_onceAlarmSchedule == nil) {
        _onceAlarmSchedule = [[IAAlarmSchedule alloc] init];
        _onceAlarmSchedule.repeatInterval = 0; //不重复
        _onceAlarmSchedule.weekDay = -1;  //不是星期中的天
    }
    if (_alwaysAlarmSchedules == nil) {
        NSMutableArray *temps =  [NSMutableArray arrayWithCapacity:7];
        for (int i = 0; i < 7; i++) {
            IAAlarmSchedule *anAlarmSchedule = [[[IAAlarmSchedule alloc] init] autorelease];
            [temps addObject:anAlarmSchedule];
            
            NSString *dayString = nil;
            switch (i) {
                case 0:
                    dayString = KWDTitleEveryMonday;
                    break;
                case 1:
                    dayString = KWDTitleEveryTuesday;
                    break;
                case 2:
                    dayString = KWDTitleEveryWednesday;
                    break;
                case 3:
                    dayString = KWDTitleEveryThursday;
                    break;
                case 4:
                    dayString = KWDTitleEveryFriday;
                    break;
                case 5:
                    dayString = KWDTitleEverySaturday;
                    break;
                case 6:
                    dayString = KWDTitleEverySunday;
                    break;
                default:
                    break;
            }
            anAlarmSchedule.name = dayString;
            anAlarmSchedule.repeatInterval = NSWeekCalendarUnit;
            if (6 == i) //1：周日 2：周1 ... 7：周六. 
                anAlarmSchedule.weekDay = 1;
            else 
                anAlarmSchedule.weekDay = i + 2;
            
        }
        _alwaysAlarmSchedules = [[NSArray arrayWithArray:temps] retain];
    }
    
    //使用相同的开始结束时间，字太多了
    self.sameSwitchCell.textLabel.adjustsFontSizeToFitWidth = YES;
    self.sameSwitchCell.textLabel.minimumFontSize = 12.0;
    
    //skin Style
    [self setSkinWithType:[IAParam sharedParam].skinType];
}
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = KViewTitleRepeat;
    [_lastIndexPathOfType release]; //重复类型cell,每次显示都重现生成
    _lastIndexPathOfType = [[NSIndexPath indexPathForRow:self.alarm.repeatType.sortId inSection:0] retain];
    [self _makeSections];
	[self.tableView reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
    self.title = nil;
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
    if (IASkinTypeDefault == [IAParam sharedParam].skinType) 
        cell.backgroundColor = [UIColor iPhoneTableCellGroupedBackgroundColor];
    else 
        cell.backgroundColor = [UIColor iPadTableCellGroupedBackgroundColor];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if (_lastIndexPathOfType.row == 1) { //连续闹钟
        if (indexPath.section == 1) {
            //打开开始与结束视图， 每次都新创建一个
            IAAlarmSchedule *anAlarmCalendar = [_alwaysAlarmSchedules objectAtIndex:indexPath.row];
            AlarmBeginEndViewController *beVC = [[[AlarmBeginEndViewController alloc] initWithNibName:@"AlarmBeginEndViewController" bundle:nil alarmCalendar:anAlarmCalendar] autorelease];
            [self.navigationController pushViewController:beVC animated:YES];
        }
    }
}

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
                
                //生成sections
                [self _makeSections];
                
                //生成indexSet供cell动画用
                NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
                [indexSet addIndex:1];//星期cells
                if (self.beginEndSwitch.on && self.sameSwitch.on) //
                    [indexSet addIndex:3];//sameCell
                
                //cell动画插入或删除
                if (_lastIndexPathOfType.row == 0) {
                    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                }else if (_lastIndexPathOfType.row == 1) {
                    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                }

            }
            
            break;
        }
        case 1:
        {
            if (_lastIndexPathOfType.row == 1) { //连续闹钟
                
                YCCheckMarkCell *dayCell = (YCCheckMarkCell*)[tableView cellForRowAtIndexPath:indexPath];
                IAAlarmSchedule *alarmCalendar = (IAAlarmSchedule*)[_alwaysAlarmSchedules objectAtIndex:indexPath.row];
                alarmCalendar.vaild = dayCell.checkmark;

                
                BOOL beginEndSwitchEnabled = self.beginEndSwitch.enabled; //因为_makeSections会改变它，所以先临时存储在这
                [self _makeSections];
                //[self.tableView reloadDataAnimated:NO];
                [self.tableView reloadData];
                
                
                //不是每个日期都被选中 && beginEndSwitch可用（日期第一次缺失）&& beginEndSwitchCell不在可视范围 && 使用相同时间
                if ([self _vaildIndexSetOfAlwaysAlarmCalendars].count != 7 && beginEndSwitchEnabled && ![self.tableView.visibleCells containsObject:self.beginEndSwitchCell] && self.sameSwitch.on)
                {
                    [self performBlock:^{
                        NSIndexPath *begionEndCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:4];//最后一个cell(设开始与结束时间cell);
                       [tableView scrollToRowAtIndexPath:begionEndCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    } afterDelay:0.1];
                }

            }
            
            break;

        }
        default:
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell == self.beginEndCell) {
                
                //打开开始与结束视图， 共用一个
                if (_alarmBeginEndViewController == nil) {
                    _alarmBeginEndViewController = [[AlarmBeginEndViewController alloc] initWithNibName:@"AlarmBeginEndViewController" bundle:nil alarmCalendar:_onceAlarmSchedule];
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

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    if ((_sections.count -1) == section) {
        NSString *s = nil;
        if (!self.beginEndSwitch.on) {
            s = KTextWhyTimeSwitch;
        }else {
            s = KTextWhyCanNotAutoLaunch;
        }
        return s;
    }
     
    return nil;
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    [super viewDidUnload];
	self.beginEndSwitchCell = nil;
    self.beginEndCell = nil;
    self.beginEndSwitch = nil;
    self.sameSwitchCell = nil;
    self.sameSwitch = nil;
    [_lastIndexPathOfType release]; _lastIndexPathOfType = nil;
    [_sections release]; _sections = nil;
    [_onceAlarmSchedule release]; _onceAlarmSchedule= nil;
    [_alwaysAlarmSchedules release]; _alwaysAlarmSchedules = nil;
    [_alarmBeginEndViewController release]; _alarmBeginEndViewController = nil;
    
}

- (void)dealloc {
    //NSLog(@"AlarmLRepeatTypeViewController dealloc");
    [_beginEndSwitchCell release];
    [_beginEndCell release];
    [_beginEndSwitch release];
    [_sameSwitchCell release];
    [_sameSwitch release];
    
    [_lastIndexPathOfType release];
    [_sections release];
    [_onceAlarmSchedule release];
    [_alwaysAlarmSchedules release];
    [_alarmBeginEndViewController release];
    [super dealloc];
}


@end

