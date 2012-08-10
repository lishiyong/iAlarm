//
//  YCLog.m
//  iAlarm
//
//  Created by li shiyong on 10-11-8.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "YCLib.h"
#import "YCLog.h"


@implementation YCLog
@synthesize logs;
@synthesize sizeOflogs;

+(YCLog*) logSingleInstance
{
	static YCLog* obj = nil;
	if (obj == nil) {
		obj = [[YCLog alloc] init];
		obj.sizeOflogs = 100;
		[obj retain];
	}
	
	return obj;
}


-(void)addlog:(NSString*) log
{
	
	NSLog(@"%@",log);
	
    
	if (logs == nil) {
		logs = [[NSMutableArray alloc] init];
	}
	if (logs.count > self.sizeOflogs) {
		[(NSMutableArray*)logs removeObjectAtIndex:0];
	}
	NSDate *date = [NSDate date];
	NSString *dateStr = [date description];
	
	
	NSString *temp = [[NSString alloc] initWithFormat:@"[%@]-%@",[dateStr substringToIndex:19],log];
	//NSString *temp = [NSString  stringWithFormat:@"[%@]-%@",[dateStr substringToIndex:19],log];
	[(NSMutableArray*)logs addObject:temp];
	[temp release];
	
	
	//////////////////
	NSString *documentsDirectory = [UIApplication sharedApplication].documentsDirectory;
    NSString *filePathName = [documentsDirectory stringByAppendingPathComponent:@"log.txt"];
	
	temp = [temp stringByAppendingString:@"\n"];
    NSMutableData *mydata =[[NSMutableData alloc] init]; 
    [mydata appendData:[temp dataUsingEncoding:NSUnicodeStringEncoding]];

	
    NSFileHandle *logFile = nil;
    logFile = [NSFileHandle fileHandleForWritingAtPath: filePathName];
    
    [logFile truncateFileAtOffset:[logFile seekToEndOfFile]];//定位到filename4的文件末尾
    
    [logFile writeData: mydata];//写入数据
    
    [logFile closeFile];
	///////////////////
	 
}

-(NSString*)stringLogs
{
	NSMutableString *logString = [NSMutableString string];
	/*if (self.logs.count == 0) return logString;
	for (NSInteger i = self.logs.count-1 ; i>=0; i--) {
		[logString appendString:[self.logs objectAtIndex:i]];
		[logString appendString:@"\n"];
	}
	 */
	for (NSUInteger i = 0 ; i<self.logs.count; i++) {
		[logString appendString:[self.logs objectAtIndex:i]];
		[logString appendString:@"\n"];
	}
	return logString;
}

- (void)dealloc {
	
	[logs release];
    [super dealloc];
}

@end
