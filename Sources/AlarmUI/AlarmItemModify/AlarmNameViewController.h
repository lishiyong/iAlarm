//
//  AlarmNameViewController.h
//  iArrived
//
//  Created by li shiyong on 10-10-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlarmModifyTableViewController;
@interface AlarmNameViewController : AlarmModifyTableViewController {
	
    
}

@property(nonatomic,retain) IBOutlet UITextField *alarmNameTextField;
@property(nonatomic,retain) IBOutlet UITableViewCell *alarmNameTextCell;

-(IBAction) textFieldDoneEditing:(id)sender;


@end
