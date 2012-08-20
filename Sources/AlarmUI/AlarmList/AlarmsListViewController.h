//
//  RootViewController.h
//  TestLocationTableCell1
//
//  Created by li shiyong on 10-12-16.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IABuyManager;
@class AlarmDetailTableViewController;

@interface AlarmsListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	
	AlarmDetailTableViewController *detailController;
    UINavigationController *detailNavigationController;
	
    IBOutlet UITableView *alarmListTableView;
	IBOutlet UILabel *backgroundTextLabel;  //无闹钟时候的背景文字
	IBOutlet UIView *backgroundView;
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIImageView *backgroundShadowTop;
}


@property (nonatomic, retain, readonly) AlarmDetailTableViewController *detailController;
@property (nonatomic, retain, readonly) UINavigationController *detailNavigationController;

@property (nonatomic, retain) IBOutlet UITableView *alarmListTableView;
@property (nonatomic, retain) IBOutlet UILabel *backgroundTextLabel;
@property (nonatomic, retain) IBOutlet UIView *backgroundView;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundShadowTop;

@end
