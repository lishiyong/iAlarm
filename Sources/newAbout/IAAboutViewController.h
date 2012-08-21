//
//  IAAboutViewcontroller.h
//  iAlarm
//
//  Created by li shiyong on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>

@class YCShareAppEngine, YCPromptView;
@interface IAAboutViewController : UITableViewController<MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>{
    
    UIBarButtonItem *_cancelButtonItem;
    YCShareAppEngine *_shareAppEngine;
    YCPromptView *_promptView;
    
    
    NSMutableArray *_sections; 
    NSMutableArray *_selectors;
    NSMutableArray *_sectionFooters;
    
    UITableViewCell *_rateAndReviewCell;//评分
    
    UITableViewCell *_followUsOnTwitterCell;//关注tw
    UITableViewCell *_visitUsOnFacebookCell;//关注fb
    UITableViewCell *_shareAppCell;//分享
    
    UITableViewCell *_foundABugCell;//反馈
    UITableViewCell *_hasACoolIdeaCell;
    UITableViewCell *_sayHiCell;
    
    UITableViewCell *_settingCell;//设置
    UITableViewCell *_versionCell;//版本
    UITableViewCell *_buyFullVersionCell;//购买
    
}



@end
