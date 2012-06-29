//
//  IAAddressInfoViewController.h
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//未使用

#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <UIKit/UIKit.h>

@class IAPerson, IAAlarm;
@interface IAAddressInfoViewController : UITableViewController<UIActionSheetDelegate>{
    NSArray *_sections;
    IAPerson *_person;
    IAAlarm *_alarm;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *saveAsPersonCell;

- (IBAction)saveAsPersonButtonPressed:(id)sender;

- (id)initWithStyle:(UITableViewStyle)style person:(IAPerson*)person;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil person:(IAPerson*)person;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarm:(IAAlarm*)alarm;

@end
