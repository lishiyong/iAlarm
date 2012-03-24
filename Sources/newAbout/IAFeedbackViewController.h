//
//  IAFeedback.h
//  iAlarm
//
//  Created by li shiyong on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCMessageComposeControllerDelegate.h"
#import "SKPSMTPMessage.h"
#import <UIKit/UIKit.h>

@class YCSoundPlayer;
@interface IAFeedbackViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource, SKPSMTPMessageDelegate>{
    UIBarButtonItem *sendButtonItem;
    UIBarButtonItem *cancelButtonItem;
    UIProgressView *progressView;
	UIView *navTitleView;

    SKPSMTPMessage *smtpEngine;
    SKPSMTPState highestState;
    id<YCMessageComposeControllerDelegate> messageDelegate;
}

@property(nonatomic, retain) YCSoundPlayer *player;

@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, retain) IBOutlet UITextField *textField;

- (id)initWithStyle:(UITableViewStyle)style messageDelegate:(id)theDategate;


@end
