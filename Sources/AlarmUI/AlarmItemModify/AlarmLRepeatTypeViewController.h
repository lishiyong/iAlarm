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

    NSIndexPath    * lastIndexPath;
}
@property (nonatomic, retain) NSIndexPath * lastIndexPath;


@end
