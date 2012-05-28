//
//  AlarmNameViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+YC.h"
#import "AlarmNameViewController.h"
#import "IAAlarm.h"
#import "UIUtility.h"


@implementation AlarmNameViewController


@synthesize alarmNameTextField;
@synthesize alarmPositionLabel;

-(IBAction)doneButtonPressed:(id)sender
{	
	//闹钟名是否为空
	if ([self.alarmNameTextField.text length] != 0) {
		//手工改动了闹钟的名字
		if (![self.alarm.alarmName isEqualToString:self.alarmNameTextField.text])
		{
			self.alarm.nameChanged = YES;
			self.alarm.alarmName = self.alarmNameTextField.text;
		}
		
	}else {
        /*
        if (!isNameTextFieldNullWhenAppear){ //手工删空了
            self.alarm.nameChanged = NO;
            if (!self.alarm.usedCoordinateAddress && self.alarm.reserve1 && [self.alarm.reserve1 length] > 0) { //能用addressTitle就用
                self.alarm.alarmName = self.alarm.reserve1; //reserve1存储了addressTitle
            }else{
                self.alarm.alarmName = KDefaultAlarmName;
            }
        }else{
            //原来就是空
        }
        */
        
        self.alarm.alarmName = nil;
        self.alarm.nameChanged = NO;
		
	} 
	
	[self.alarmNameTextField keyboardAppearance];
	[self.navigationController popViewControllerAnimated:YES];
	
	[super doneButtonPressed:sender];
}

-(IBAction) textFieldDoneEditing:(id)sender
{
	[self doneButtonPressed:nil];
}

-(IBAction) textFieldChanged:(id)sender
{
    /*
	if ( [self.alarm.alarmName isEqualToString:self.alarmNameTextField.text] //手工改动了闹钟的名字
		)//|| [self.alarmNameTextField.text length] == 0) //闹钟名是否为空
	{
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}else {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
     */
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //纵向可拖拽
    UIScrollView * sv = (UIScrollView*)self.view;
    sv.alwaysBounceVertical = YES;
	
	self.title = KViewTitleName;
	//修改输入文本筐的风格，设置焦点
	alarmNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    //alarmNameTextField.frame = CGRectMake(10, 84, 300, 45);
	alarmNameTextField.textColor = [UIUtility checkedCellTextColor];
	[alarmNameTextField becomeFirstResponder];  //调用键盘
	self.alarmNameTextField.enablesReturnKeyAutomatically = NO; 
	//self.alarmNameTextField.placeholder = 	KDefaultAlarmName;
    self.alarmNameTextField.placeholder = @"什么地方就要到了";

	
	self.alarmPositionLabel.font = [UIFont systemFontOfSize:15];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    if (self.alarm.nameChanged) {
        self.alarmNameTextField.text = self.alarm.alarmName;
    }
     
    //self.alarmNameTextField.text = self.alarm.alarmName;
	self.alarmPositionLabel.text = self.alarm.position;
	[self.view reloadInputViews];
    
    
    //存储alarmNameTextField的初始情况
    NSString *s = [self.alarmNameTextField.text trim];
    isNameTextFieldNullWhenAppear = (s==nil || [s length]<=0);
     
    
}


- (void)viewDidUnload {
    [super viewDidUnload];

	self.alarmNameTextField = nil;
	self.alarmPositionLabel = nil;
}


- (void)dealloc {
	[alarmNameTextField release];
	[alarmPositionLabel release];
    [super dealloc];
}


@end
