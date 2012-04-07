//
//  AlarmDescriptionViewController.m
//  iAlarm
//
//  Created by li shiyong on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YCTextView.h"
#import "NSString-YC.h"
#import "IAAlarm.h"
#import "AlarmDescriptionViewController.h"

@implementation AlarmDescriptionViewController
@synthesize textView;

- (IBAction)doneButtonPressed:(id)sender
{	
	
    self.alarm.description = self.textView.text;
	
	[self.textView keyboardAppearance];
	[self.navigationController popViewControllerAnimated:YES];
	
	[super doneButtonPressed:sender];
}
/*
- (IBAction)textFieldDoneEditing:(id)sender
{
	[self doneButtonPressed:nil];
}
 */


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //纵向可拖拽
    UIScrollView * sv = (UIScrollView*)self.view;
    sv.alwaysBounceVertical = YES;

    self.title = @"备注";//KViewTitleName;
	//修改输入文本筐的风格，设置焦点
	self.textView.textColor = [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1.0];
	[self.textView becomeFirstResponder];  //调用键盘
	self.textView.enablesReturnKeyAutomatically = NO; 
	self.textView.font = [UIFont systemFontOfSize:17];
    self.textView.placeholder = @"如:到达后要做什么事情";
    
    //圆角的UITextView
    self.textView.layer.cornerRadius = 10;
    self.textView.layer.masksToBounds = YES;
    //UITextView 加边框
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    /*
    NSString *s = nil;
    if (self.alarm.description && [[self.alarm.description trim] length] > 0) {
        s = self.alarm.description;
        self.textView.textColor = [UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:135.0/255.0 alpha:1.0];
    }else{
        s = @"例如：到达后要做什么";//KDefaultAlarmName;;
        self.textView.textColor = [UIColor lightGrayColor];
    }*/
    
	self.textView.text = self.alarm.description;
	[self.view reloadInputViews];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.textView = nil;
}


- (void)dealloc {
	[textView release];
    [super dealloc];
}

@end
