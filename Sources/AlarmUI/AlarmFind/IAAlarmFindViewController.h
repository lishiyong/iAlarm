//
//  IAAlarmFindViewController.h
//  iAlarm
//
//  Created by li shiyong on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IAAlarmFindViewController : UIViewController{
    UIBarButtonItem *doneButtonItem;

    
    UITextView *textView;
    UIButton *button1;
    UIButton *button2;
}

@property(nonatomic,retain,readonly) UIBarButtonItem *doneButtonItem;


@property (nonatomic,retain) IBOutlet UITextView *textView;

@property (nonatomic,retain) IBOutlet UIButton *button1;
@property (nonatomic,retain) IBOutlet UIButton *button2;

@end
