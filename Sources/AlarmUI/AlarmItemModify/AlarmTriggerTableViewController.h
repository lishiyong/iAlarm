//
//  AlarmTriggerTableViewController.h
//  iAlarm
//
//  Created by li shiyong on 11-6-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmModifyTableViewController.h"


@interface AlarmTriggerTableViewController : AlarmModifyTableViewController {
	NSIndexPath    * lastIndexPath;
}

@property (nonatomic, retain) NSIndexPath *lastIndexPath;

//在整个tableView中indexPath的row在位置
-(NSInteger)gernarlRowInTableView:(UITableView *)tableView ForIndexPath:(NSIndexPath *)indexPath;

@end
