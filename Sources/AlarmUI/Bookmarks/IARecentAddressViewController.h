//
//  IARecentAddressViewController.h
//  TestABController
//
//  Created by li shiyong on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IARecentAddressViewController, YCPair;
@protocol IARecentAddressViewControllerDelegate <NSObject>

- (void)recentAddressPickerNavigationControllerDidCancel:(IARecentAddressViewController *)recentAddressPicker;
- (BOOL)recentAddressPickerNavigationController:(IARecentAddressViewController *)recentAddressPicker shouldContinueAfterSelectingRecentAddressData:(YCPair*)anRecentAddressData;

@end

@interface IARecentAddressViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic, assign) id<IARecentAddressViewControllerDelegate> delegate;

@end
