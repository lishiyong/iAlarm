//
//  AlarmLRepeatTypeViewController.h
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmModifyTableViewController.h"


@interface AlarmLRepeatTypeViewController : AlarmModifyTableViewController {
    NSIndexPath  *_lastIndexPath;
    NSMutableArray *_sections;
    NSArray *_beginEndCellArray;
}

@property (nonatomic, retain) NSIndexPath * lastIndexPath;
@property (nonatomic, retain) IBOutlet  UITableViewCell *switchCell;
@property (nonatomic, retain) IBOutlet  UITableViewCell *beginEndCell;
@property (nonatomic, retain) IBOutlet  UISwitch *switchControl;

- (IBAction)switchControlValueDidChange:(id)sender;

@end
