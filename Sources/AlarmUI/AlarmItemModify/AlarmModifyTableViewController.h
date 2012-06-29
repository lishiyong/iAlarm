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
@interface AlarmModifyTableViewController : UITableViewController 

@property(nonatomic,retain,readonly) IAAlarm *alarm;

//子类的接口
- (void)saveData; 

//指定初始化
- (id)initWithStyle:(UITableViewStyle)style alarm:(IAAlarm*)theAlarm;

//指定初始化
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarm:(IAAlarm*)theAlarm;


@end
