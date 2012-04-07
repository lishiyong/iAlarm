//
//  AlarmDescriptionViewController.h
//  iAlarm
//
//  Created by li shiyong on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmModifyViewController.h"

@class YCTextView;
@interface AlarmDescriptionViewController : AlarmModifyViewController{
	YCTextView *textView;
}

@property(nonatomic,retain) IBOutlet YCTextView *textView;


@end
