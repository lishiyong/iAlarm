//
//  YCLog.h
//  iAlarm
//
//  Created by li shiyong on 10-11-8.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface YCLog : NSObject {
	NSArray *logs;
	NSUInteger  sizeOflogs;
}

@property (nonatomic,retain,readonly) NSArray *logs;
@property (nonatomic,assign)NSUInteger sizeOflogs;

-(void)addlog:(NSString*) log;
-(NSString*)stringLogs;

+(YCLog*) logSingleInstance;

@end
