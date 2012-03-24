//
//  YCAnimateRemoveFileView.m
//  iAlarm
//
//  Created by li shiyong on 11-3-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "YCSoundPlayer.h"
#import "YCAnimateRemoveFileView.h"


@implementation YCAnimateRemoveFileView

- (id)animationImage01{
	if (animationImage01 == nil) {
		animationImage01 = [[UIImage imageNamed:@"YCPoof1.png"] retain];
	}
	return animationImage01;
}

- (id)animationImage02{
	if (animationImage02 == nil) {
		animationImage02 = [[UIImage imageNamed:@"YCPoof2.png"] retain];
	}
	return animationImage02;
}

- (id)animationImage03{
	if (animationImage03 == nil) {
		animationImage03 = [[UIImage imageNamed:@"YCPoof3.png"] retain];
	}
	return animationImage03;
}

- (id)animationImage04{
	if (animationImage04 == nil) {
		animationImage04 = [[UIImage imageNamed:@"YCPoof4.png"] retain];
	}
	return animationImage04;
}

- (id)animationImage05{
	if (animationImage05 == nil) {
		animationImage05 = [[UIImage imageNamed:@"YCPoof5.png"] retain];
	}
	return animationImage05;
}


- (id)openAnimationImages{
	if (openAnimationImages == nil) {
		openAnimationImages = [[NSArray arrayWithObjects:
								self.animationImage01
								,self.animationImage02
								,self.animationImage03
								,self.animationImage04
								,self.animationImage05
								,nil] retain];
	}
	return openAnimationImages;
}

- (id)animationImageView{
	if (animationImageView == nil) {
		animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
		animationImageView.animationImages = self.openAnimationImages;
		animationImageView.animationRepeatCount = 1;
		animationImageView.animationDuration = 1.0;
	}
	return animationImageView;
}

- (id)removeSoundPlayer{
	if (removeSoundPlayer == nil) {
		removeSoundPlayer = [[YCSoundPlayer alloc]initWithSoundFileName:@"removeFile.caf"];
		/*
		NSString *filePath = [[NSBundle mainBundle] pathForResource:@"removeFile" ofType:@"caf"];
		NSURL *fileURL = [[[NSURL alloc] initFileURLWithPath:filePath] autorelease];
		removeSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
		 */
	}
	return removeSoundPlayer;
}

- (id)initWithOrigin:(CGPoint)origin{

	self = [super initWithFrame:CGRectMake(origin.x, origin.y, 32.0, 32.0)];
    if (self) {
        // Initialization code.
		[self addSubview:self.animationImageView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [self initWithOrigin:frame.origin];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)startAnimating{
	[self.animationImageView startAnimating];
}

- (void)startPlaying{
	[self.removeSoundPlayer play];
}

- (void)dealloc {
	[animationImage01 release];
	[animationImage02 release];
	[animationImage03 release];
	[animationImage04 release];
	[animationImage05 release];
	[openAnimationImages release]; 
	[animationImageView release];
	
	[removeSoundPlayer release];
	
    [super dealloc];
}


@end
