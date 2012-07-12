//
//  YCSoundPlayer.m
//  iAlarm
//
//  Created by li shiyong on 11-1-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCSoundPlayer.h"


@implementation YCSoundPlayer
@synthesize playing;
@synthesize repeatNumber;
@synthesize soundFileObject;


-(id)initWithSoundName:(CFStringRef)soundName soundType:(CFStringRef)soundType{
	
	if (self= [super init]) {
		// Get the main bundle for the app
		CFBundleRef mainBundle;
		mainBundle = CFBundleGetMainBundle ();
		
		// Get the URL to the sound file to play
		soundFileURLRef  =	CFBundleCopyResourceURL (mainBundle,
													 soundName,
													 soundType,
													 NULL
													 );
	}
	
	return self;
	
}

+(id)soundPlayerWithSoundName:(CFStringRef)soundName soundType:(CFStringRef)soundType{
	return [[[YCSoundPlayer alloc] initWithSoundName:soundName soundType:soundType] autorelease];
}


-(id)initWithSoundFileName:(NSString*)soundFileName{
	
	//拆分文件名
	NSArray *sArray = [soundFileName componentsSeparatedByString:@"."];
	NSString *soundName = @"";
	NSString *soundType = @"";
	if (sArray.count >= 2) {
		soundName = [sArray objectAtIndex:0];
		soundType = [sArray lastObject];
	}
	
	//转换字符串类型
	CFStringRef cfsSoundName = CFStringCreateWithCString(NULL,[soundName UTF8String],kCFStringEncodingUTF8);
	CFStringRef cfsSoundType = CFStringCreateWithCString(NULL,[soundType UTF8String],kCFStringEncodingUTF8);

	if (self= [self initWithSoundName:cfsSoundName soundType:cfsSoundType]) {
	}
    
    CFRelease(cfsSoundName);
    CFRelease(cfsSoundType);
	
	return self;
}

+(id)soundPlayerWithSoundFileName:(NSString*)soundFileName{
	return [[[YCSoundPlayer alloc] initWithSoundFileName:soundFileName] autorelease];
}

-(id)initWithVibrate{
	if (self= [super init]) {
		soundFileObject = kSystemSoundID_Vibrate;
	}
	return self;
}
+(id)soundPlayerWithVibrate{
	return [[[YCSoundPlayer alloc] initWithVibrate] autorelease];
}



-(void)innerPlay{
	//if (!self.playing) 
	{
		playing = YES;
		AudioServicesPlaySystemSound (soundFileObject);//to play
		if (self.repeatNumber >0)  self.repeatNumber--;
	}
}

-(void)play{
	if (self.soundFileObject != kSystemSoundID_Vibrate)
		AudioServicesCreateSystemSoundID (soundFileURLRef,&soundFileObject);
	AudioServicesAddSystemSoundCompletion(soundFileObject,NULL,NULL,&callback_playSystemSoundCompletion,self);	//注册回调函数
	self.repeatNumber = 1;//默认播放一次
	[self innerPlay];
}

-(void)playRepeatNumber:(NSInteger)theRepeatNumber{
	if(theRepeatNumber == 0) return;  //0不播放
	
	if (self.soundFileObject != kSystemSoundID_Vibrate)
		AudioServicesCreateSystemSoundID (soundFileURLRef,&soundFileObject);
	AudioServicesAddSystemSoundCompletion(soundFileObject,NULL,NULL,&callback_playSystemSoundCompletion,self);	//注册回调函数
	self.repeatNumber = theRepeatNumber;
	[self innerPlay];
}

-(void)stop{
	if (self.playing) {
		playing = NO; 
		AudioServicesRemoveSystemSoundCompletion(soundFileObject);//删除回调注册
		if (self.soundFileObject != kSystemSoundID_Vibrate){
			AudioServicesDisposeSystemSoundID(soundFileObject);
		}
	}
}

- (void)dealloc {
	AudioServicesRemoveSystemSoundCompletion(soundFileObject);//删除回调注册
	if (self.soundFileObject != kSystemSoundID_Vibrate){
		AudioServicesDisposeSystemSoundID (soundFileObject);
		CFRelease (soundFileURLRef);
	}
    [super dealloc];
}

@end

//声音播放完成后的回调函数
void callback_playSystemSoundCompletion(SystemSoundID  ssID,void*clientData){
	YCSoundPlayer* player = (YCSoundPlayer*)clientData;
	
	//player.playing = NO;
	if (player.repeatNumber == 0) {
		/*
		AudioServicesRemoveSystemSoundCompletion(player.soundFileObject);//删除回调注册
		if (player.soundFileObject != kSystemSoundID_Vibrate){
			AudioServicesDisposeSystemSoundID(ssID);//删除声音对象
		}
		player.playing = NO;
		 */
		[player stop];
		player.playing = NO;
	}else {
		[player innerPlay];  //重复播放
	}

}
