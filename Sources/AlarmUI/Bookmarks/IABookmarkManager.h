//
//  IABookmarkManager.h
//  iAlarm
//
//  Created by li shiyong on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IARecentAddressViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <UIKit/UIKit.h>


@class YCTabToolbarController, SearchDisplayManager;

@interface IABookmarkManager : NSObject<ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, IARecentAddressViewControllerDelegate,UINavigationControllerDelegate>{
    YCTabToolbarController *_tabToolbarController;
    ABPeoplePickerNavigationController *_peoplePicker;
    UINavigationController *_recentAddressNav;
}

@property (nonatomic, assign) IBOutlet UIViewController *currentViewController; //相当于delegate,要用assign
@property (nonatomic, retain) SearchDisplayManager *searchDisplayManager;

- (void)presentBookmarViewController;

@end
