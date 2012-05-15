//
//  YCAnimateRemoveFileView.h
//  iAlarm
//
//  Created by li shiyong on 11-3-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@class YCSoundPlayer;
@interface YCAnimateRemoveFileView : UIView {
	
	UIImage *animationImage01;
	UIImage *animationImage02;
	UIImage *animationImage03;
	UIImage *animationImage04;
	UIImage *animationImage05;
	NSArray *openAnimationImages; 
	UIImageView *animationImageView;
	
	YCSoundPlayer *removeSoundPlayer;
	//AVAudioPlayer *removeSoundPlayer;
	
}


@property(nonatomic,readonly) UIImage *animationImage01;
@property(nonatomic,readonly) UIImage *animationImage02;
@property(nonatomic,readonly) UIImage *animationImage03;
@property(nonatomic,readonly) UIImage *animationImage04;
@property(nonatomic,readonly) UIImage *animationImage05;
@property(nonatomic,readonly) NSArray *openAnimationImages;
@property(nonatomic,readonly) UIImageView *animationImageView;

@property (nonatomic, retain,readonly) YCSoundPlayer *removeSoundPlayer;
//@property (nonatomic, retain,readonly) AVAudioPlayer *removeSoundPlayer;

- (void)startAnimating;
- (void)startPlaying;

- (id)initWithOrigin:(CGPoint)origin;

@end
