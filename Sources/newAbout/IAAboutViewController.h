//
//  IAAboutViewcontroller.h
//  iAlarm
//
//  Created by li shiyong on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCMessageComposeControllerDelegate.h"
#import "SA_OAuthTwitterController.h"
#import <UIKit/UIKit.h>

@class IAFeedbackViewController;
@class YCShareAppEngine;
@class TableViewCellDescription;
@interface IAAboutViewController : UITableViewController<SA_OAuthTwitterControllerDelegate,YCMessageComposeControllerDelegate>{
    
    UIBarButtonItem *cancelButtonItem;
    YCShareAppEngine *shareAppEngine;
    
    NSArray *cellDescriptions;
	TableViewCellDescription *rateAndReviewCellDescription;            //评分
	TableViewCellDescription *facebookCellDescription;                 //facebook
	TableViewCellDescription *twitterCellDescription;                  //twitter
    TableViewCellDescription *kxCellDescription;                       //开心网
	TableViewCellDescription *versionCellDescription;                  //版本
	TableViewCellDescription *buyFullVersionCellDescription;           //购买
    TableViewCellDescription *feedbackCellDescription;                 //反馈
    TableViewCellDescription *shareAppCellDescription;                 //分享
    
}

@property(nonatomic,readonly) UIBarButtonItem *cancelButtonItem;
@property(nonatomic,readonly) YCShareAppEngine *shareAppEngine;

@property(nonatomic,retain) NSArray *cellDescriptions;   
@property(nonatomic,retain) TableViewCellDescription *rateAndReviewCellDescription;
@property(nonatomic,retain) TableViewCellDescription *facebookCellDescription;
@property(nonatomic,retain) TableViewCellDescription *twitterCellDescription;
@property(nonatomic,retain) TableViewCellDescription *kxCellDescription;
@property(nonatomic,retain) TableViewCellDescription *versionCellDescription;
@property(nonatomic,retain) TableViewCellDescription *buyFullVersionCellDescription;
@property(nonatomic,retain) TableViewCellDescription *feedbackCellDescription;
@property(nonatomic,retain) TableViewCellDescription *shareAppCellDescription;                 


@end
