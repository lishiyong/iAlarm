//
//  AlarmModifyTableViewController.h
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocalizedString.h"
#import <UIKit/UIKit.h>

@class IAAlarm;
@interface AlarmModifyTableViewController : UITableViewController {
	IAAlarm *alarm;
}

@property(nonatomic,retain,readonly) IAAlarm *alarm;
-(IBAction)doneButtonPressed:(id)sender;

//指定初始化
- (id)initWithStyle:(UITableViewStyle)style alarm:(IAAlarm*)theAlarm;


@end
