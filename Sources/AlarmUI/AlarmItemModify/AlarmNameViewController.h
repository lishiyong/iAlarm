//
//  AlarmNameViewController.h
//  iArrived
//
//  Created by li shiyong on 10-10-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmModifyViewController.h"


@interface AlarmNameViewController : AlarmModifyViewController {
	
	UITextField *alarmNameTextField;
	UILabel *alarmPositionLabel;
    
    BOOL isNameTextFieldNullWhenAppear;
}

@property(nonatomic,retain) IBOutlet UITextField *alarmNameTextField;
@property(nonatomic,retain) IBOutlet UILabel *alarmPositionLabel;

-(IBAction) textFieldDoneEditing:(id)sender;
-(IBAction) textFieldChanged:(id)sender;


@end
