//
//  YCTwitterFeedViewController.h
//  iAlarm
//
//  Created by li shiyong on 11-8-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGTwitterEngineDelegate.h"
#import "YCMessageComposeControllerDelegate.h"
#import <UIKit/UIKit.h>

@protocol MGTwitterEngineDelegate;
@class MGTwitterEngine;
@protocol YCMessageComposeControllerDelegate;
@class YCShareContent;
@interface YCTwitterTweetViewController : UIViewController<MGTwitterEngineDelegate> {
	
	UIBarButtonItem *cancelButtonItem;
	UIBarButtonItem *shareButtonItem;
	UIProgressView *progressView;
	UIView *navTitleView;
	UIView *navTitleView1;
	IBOutlet UITextView *textView;

	
	MGTwitterEngine *twitterEngine;
    YCShareContent *shareContent;  
    id<YCMessageComposeControllerDelegate> messageDelegate;

}

@property (nonatomic, retain, readonly) UIBarButtonItem *cancelButtonItem;
@property (nonatomic, retain, readonly) UIBarButtonItem *shareButtonItem;
@property (nonatomic, retain, readonly) UIProgressView *progressView;  
@property (nonatomic, retain, readonly) UIView *navTitleView; 
@property (nonatomic, retain, readonly) UIView *navTitleView1;
@property(nonatomic,retain) IBOutlet UITextView *textView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil engine:(MGTwitterEngine*)theEngine messageDelegate:(id)theDategate shareData:(YCShareContent*)theShareData;


@end
