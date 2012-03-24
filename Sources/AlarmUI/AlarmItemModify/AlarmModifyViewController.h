//
//  AlarmModifyViewController.h
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class IAAlarm;
@interface AlarmModifyViewController : UIViewController {
	IAAlarm *alarm;
}

@property(nonatomic,retain,readonly) IAAlarm *alarm;
-(IBAction)doneButtonPressed:(id)sender;

//指定初始化
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarm:(IAAlarm*)theAlarm;

-(id)initWithAlarm:(IAAlarm*)theAlarm;


@end
