//
//  IARecentAddressViewController.h
//  TestABController
//
//  Created by li shiyong on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IARecentAddressViewController, YCPlacemark;
@protocol IARecentAddressViewControllerDelegate <NSObject>

- (void)recentAddressPickerNavigationControllerDidCancel:(IARecentAddressViewController *)recentAddressPicker;
- (BOOL)recentAddressPickerNavigationController:(IARecentAddressViewController *)recentAddressPicker shouldContinueAfterSelectingPerson:(YCPlacemark*)placemark;

@end

@interface IARecentAddressViewController : UITableViewController

@property (nonatomic, assign) id<IARecentAddressViewControllerDelegate> delegate;

@end
