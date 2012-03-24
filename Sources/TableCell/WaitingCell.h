//
//  WaitingCell.h
//  iAlarm
//
//  Created by li shiyong on 10-12-21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WaitingCell : UITableViewCell {
	
	BOOL waiting;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UILabel *activityLabel;
	IBOutlet UIImageView *activityImageView;
	IBOutlet UIView *activityView;
	
	///////////////////////////////////////////////////////////////////////
	
	IBOutlet UIImageView *accessoryImageView0;
	UIImage *accessoryImageView0Disabled;  
	UIImage *accessoryImageView0TempImage; //存储，为Disable、hightLighted替换
	
	IBOutlet UIImageView *accessoryImageView1;
	UIImage *accessoryImageView1Disabled; 
	UIImage *accessoryImageView1TempImage;  //存储，为Disable、hightLighted替换
	
	IBOutlet UIImageView *accessoryImageView2;
	UIImage *accessoryImageView2Disabled; 
	UIImage *accessoryImageView2TempImage;  //存储，为Disable、hightLighted替换
	
	UIControl *accessoryButton;             //绑定事件时候使用       
	
	BOOL accessoryViewEnabled;
	
	UITableViewCellAccessoryType accessoryType;     //覆盖父类
	UITableViewCellAccessoryType accessoryTypeTemp; //存储，为setWaiting替换
}

@property(nonatomic,retain,readonly) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain,readonly) IBOutlet UILabel *activityLabel;
@property(nonatomic,retain,readonly) IBOutlet UIImageView *activityImageView;
@property(nonatomic,retain,readonly) IBOutlet UIView *activityView;

//////////////////////////////////////////////////////////////////////////////////////////////////

@property(nonatomic,retain,readonly) IBOutlet UIImageView *accessoryImageView0;
@property(nonatomic,retain) UIImage *accessoryImageView0Disabled;  
@property(nonatomic,retain) UIImage *accessoryImageView0TempImage;

@property(nonatomic,retain,readonly) IBOutlet UIImageView *accessoryImageView1;
@property(nonatomic,retain) UIImage *accessoryImageView1Disabled;  
@property(nonatomic,retain) UIImage *accessoryImageView1TempImage;

@property(nonatomic,retain,readonly) IBOutlet UIImageView *accessoryImageView2;
@property(nonatomic,retain) UIImage *accessoryImageView2Disabled;  
@property(nonatomic,retain) UIImage *accessoryImageView2TempImage;

@property(nonatomic,retain) UIControl *accessoryButton; 

@property(nonatomic,assign) BOOL accessoryViewEnabled;
@property(nonatomic,assign) BOOL waiting;

@property(nonatomic,assign) UITableViewCellAccessoryType accessoryType;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

//设置AccessoryButton的响应函数
- (void)setAccessoryButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

//设置AccessoryView Disable
- (void)setAccessoryViewEnabled:(BOOL)enabled;

@end
