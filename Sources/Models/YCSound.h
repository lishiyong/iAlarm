//
//  YCSounds.h
//  iArrived
//
//  Created by li shiyong on 10-10-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define    ksoundId        @"ksoundId"
#define    ksoundName      @"ksoundName"
#define    ksoundFileName  @"ksoundFileName"
#define    ksoundFileURL   @"ksoundFileURL"
#define    ksoundSortId    @"ksortId"

@interface YCSound : NSObject <NSCoding>{
	NSString *soundId;         
	NSString *soundName;
	NSString *soundFileName;
	NSURL *soundFileURL;
	NSUInteger sortId;    //排序
	BOOL customSound;  //自定义的铃声
}

@property (nonatomic,retain) NSString *soundId;
@property (nonatomic,retain) NSString *soundName;
@property (nonatomic,retain) NSString *soundFileName;
@property (nonatomic,retain) NSURL *soundFileURL;
@property (nonatomic,assign) NSUInteger sortId;
@property (nonatomic,assign) BOOL customSound;

@end
