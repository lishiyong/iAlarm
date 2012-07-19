//
//  AlarmBeginEndViewController.h
//  iAlarm
//
//  Created by li shiyong on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmBeginEndViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
    UITableView *_tableView;
    
    NSMutableArray *_sections;
    NSMutableArray *_heightOfCells;
    NSDate *_beginTime;
    NSDate *_endTime;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *beginCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *endCell;
@property (nonatomic, retain) IBOutlet UIDatePicker *timePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil beginTime:(NSDate *)beginTime endTime:(NSDate *)endTime;

@end
