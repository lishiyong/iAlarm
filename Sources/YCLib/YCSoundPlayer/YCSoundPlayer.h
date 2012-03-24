//
//  YCSoundPlayer.h
//  iAlarm
//
//  Created by li shiyong on 11-1-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>


@interface YCSoundPlayer : NSObject {
	CFURLRef		soundFileURLRef;
	SystemSoundID	soundFileObject;
	
	BOOL playing;
	NSInteger repeatNumber; //重复播放次数
}

@property(nonatomic,assign) BOOL playing;
@property(nonatomic,assign) NSInteger repeatNumber;
@property(nonatomic,readonly,assign) SystemSoundID soundFileObject;

-(id)initWithSoundName:(CFStringRef)soundName soundType:(CFStringRef)soundType;
+(id)soundPlayerWithSoundName:(CFStringRef)soundName soundType:(CFStringRef)soundType;

-(id)initWithSoundFileName:(NSString*)soundFileName;
+(id)soundPlayerWithSoundFileName:(NSString*)soundFileName;

-(id)initWithVibrate;
+(id)soundPlayerWithVibrate;

-(void)play;
-(void)playRepeatNumber:(NSInteger)theRepeatNumber; //重复播放，theRepeatNumber==－1 一直播放
-(void)stop;

@end

//声音播放完成后的回调函数
void callback_playSystemSoundCompletion(SystemSoundID  ssID,void*clientData);