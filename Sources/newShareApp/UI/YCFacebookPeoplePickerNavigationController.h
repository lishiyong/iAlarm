//
//  facebookContactsTableViewController.h
//  TestShareApp
//
//  Created by li shiyong on 11-8-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "YCFacebookGlobalData.h"
#import "IconDownloader.h"


@class YCFacebookPeoplePickerNavigationController;
@protocol YCFacebookPeoplePickerNavigationControllerDelegate<NSObject> 

@optional
- (void)peoplePickerNavigationControllerDidCancel:(YCFacebookPeoplePickerNavigationController *)peoplePicker;
- (void)peoplePickerNavigationControllerDidDone:(YCFacebookPeoplePickerNavigationController *)peoplePicker checkedPeoples:(NSArray*)checkedPeoples;

@end

@class Facebook;
@protocol IconDownloaderDelegate;
@protocol YCFBDataParseDelegate;
@class YCFacebookPeople;
@class YCMaskView;
@class WaitingPromptCell;

@interface YCFacebookPeoplePickerNavigationController : UIViewController
<UITableViewDelegate,UITableViewDataSource, FBRequestDelegate,FBDialogDelegate,FBSessionDelegate,IconDownloaderDelegate> {
	
	UIBarButtonItem *cancelButtonItem;
	UIBarButtonItem *doneButtonItem;
    IBOutlet UITableView *tableView;
    WaitingPromptCell *waitingPromptCell;

	
	NSMutableDictionary *checkedPeoples;  //临时
	UIImage *maleImage;
	UIImage *femaleImage;
	NSMutableDictionary *imageDownloadsInProgress;  // the set of IconDownloader objects for each app
    
    id<YCFacebookPeoplePickerNavigationControllerDelegate> pickerDelegate;
    Facebook *facebookEngine;
    
    BOOL downloading;
	BOOL allFriendDownloaded; //是否下载了所有的FB朋友
}

@property (nonatomic, retain, readonly) UIBarButtonItem *cancelButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *doneButtonItem;
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain,readonly) WaitingPromptCell *waitingPromptCell;

@property(nonatomic,retain,readonly) NSMutableDictionary *checkedPeoples;
@property(nonatomic,retain,readonly) UIImage *maleImage;
@property(nonatomic,retain,readonly) UIImage *femaleImage;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil engine:(Facebook*)theEngine pickerDelegate:(id<YCFacebookPeoplePickerNavigationControllerDelegate>)theDategate;


@end
