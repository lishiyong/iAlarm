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


@class YCTabToolbarController, YCSearchController;

@interface IABookmarkManager : NSObject<ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, IARecentAddressViewControllerDelegate>{
    YCTabToolbarController *_tabToolbarController;
    ABPeoplePickerNavigationController *_peoplePicker;
    UINavigationController *_recentAddressNav;
}


@property (nonatomic, assign) IBOutlet UIViewController *currentViewController; //相当于delegate,要用assign
@property (nonatomic, retain) YCSearchController *searchController;

- (void)presentBookmarViewController;

@end
