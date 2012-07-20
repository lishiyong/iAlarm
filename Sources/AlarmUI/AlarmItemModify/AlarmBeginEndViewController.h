//
//  AlarmBeginEndViewController.h
//  iAlarm
//
//  Created by li shiyong on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IAAlarmCalendar;

@interface AlarmBeginEndViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *_sections;
    NSMutableArray *_heightOfCells;
    IAAlarmCalendar *_alarmCalendar;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *beginCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *endCell;
@property (nonatomic, retain) IBOutlet UIDatePicker *timePicker;

- (IBAction)timePickerValueDidChange:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarmCalendar:(IAAlarmCalendar *)alarmCalendar;

@end
