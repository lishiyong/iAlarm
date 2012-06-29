//
//  AlarmDescriptionViewController.h
//  iAlarm
//
//  Created by li shiyong on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AlarmModifyTableViewController.h"
#import <UIKit/UIKit.h>

@class YCTextView, AlarmModifyTableViewController;
@interface AlarmNotesViewController : AlarmModifyTableViewController

@property(nonatomic,retain) IBOutlet YCTextView *textView;
@property(nonatomic,retain) IBOutlet UITableViewCell *textViewCell;


@end
