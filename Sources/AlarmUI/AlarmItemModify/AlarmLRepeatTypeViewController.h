//
//  AlarmLRepeatTypeViewController.h
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmModifyTableViewController.h"

@class AlarmBeginEndViewController;
@interface AlarmLRepeatTypeViewController : AlarmModifyTableViewController {
    NSIndexPath  *_lastIndexPathOfType;
    NSMutableArray *_sections;
    NSArray *_beginEndSection;
    NSMutableSet *_selectedOfDays;
    
    
    NSDate *beginDate;
    NSDate *endDate;
    AlarmBeginEndViewController *_alarmBeginEndViewController;
}

@property (nonatomic, retain) IBOutlet  UITableViewCell *beginEndSwitchCell;
@property (nonatomic, retain) IBOutlet  UITableViewCell *beginEndCell;
@property (nonatomic, retain) IBOutlet  UISwitch *beginEndSwitch;

@property (nonatomic, retain) IBOutlet  UITableViewCell *sameSwitchCell;
@property (nonatomic, retain) IBOutlet  UISwitch *sameSwitch;

- (IBAction)beginEndSwitchValueDidChange:(id)sender;
- (IBAction)sameSwitchValueDidChange:(id)sender;

@end
