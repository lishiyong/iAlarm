//
//  facebookFeedViewController.h
//  TestShareApp
//
//  Created by li shiyong on 11-7-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "YCFacebookPeoplePickerNavigationController.h"
#import "YCMessageComposeControllerDelegate.h"

@protocol YCMessageComposeControllerDelegate;
@protocol YCFacebookPeoplePickerNavigationControllerDelegate;
@class YCFacebookPeoplePickerNavigationController;
@class YCMaskView;
@class TableViewCellDescription;
@class YCShareContent;

@interface YCFacebookFeedViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource, FBRequestDelegate,FBDialogDelegate,FBSessionDelegate
,YCFacebookPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate> {
	
    YCMaskView *maskView;
	UIBarButtonItem *cancelButtonItem;
	UIBarButtonItem *shareButtonItem;
    UIProgressView *progressView;
	UIView *navTitleView;
    IBOutlet UITableView *tableView;


	NSArray *cellDescriptions;
	TableViewCellDescription *peoplesLabelCellDescription;                 
	TableViewCellDescription *messageBodyCellDescription;
	YCFacebookPeoplePickerNavigationController *fbPeoplePicker;
	UINavigationController *fbPeoplePickerNavController;
    
    NSMutableDictionary *searchParam; //查询的
	NSMutableDictionary *publishParam; //发布到墙上的
		
	id<YCMessageComposeControllerDelegate> messageDelegate;
    YCShareContent *shareContent;  
    Facebook *facebookEngine;
    
    NSInteger publishI;  //当前发送的
	BOOL sending;

}

@property (nonatomic, retain, readonly) YCMaskView *maskView;
@property (nonatomic, retain, readonly) UIBarButtonItem *cancelButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *shareButtonItem;
@property (nonatomic, retain, readonly) UIProgressView *progressView;  
@property (nonatomic, retain, readonly) UIView *navTitleView;
@property (nonatomic,retain) IBOutlet   UITableView *tableView;

@property(nonatomic,retain) NSArray *cellDescriptions;
@property(nonatomic,retain) TableViewCellDescription *peoplesLabelCellDescription;
@property(nonatomic,retain) TableViewCellDescription *messageBodyCellDescription;
@property(nonatomic,retain) YCFacebookPeoplePickerNavigationController *fbPeoplePicker;
@property(nonatomic,retain) UINavigationController *fbPeoplePickerNavController;

@property (nonatomic, retain, readonly) NSMutableDictionary *searchParam; 
@property (nonatomic, retain, readonly) NSMutableDictionary *publishParam; 


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil engine:(Facebook*)theEngine messageDelegate:(id)theDategate shareData:(YCShareContent*)theShareData;


@end




