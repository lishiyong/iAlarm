//
//  UIApplication-YC.m
//  iAlarm
//
//  Created by li shiyong on 11-3-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIApplication+YC.h"

static NSString *kNumberOfApplicationDidFinishLaunchingKey = @"kNumberOfApplicationDidFinishLaunchingKey";
static NSString *kNumberOfApplicationDidBecomeActiveKey    = @"kNumberOfApplicationDidBecomeActiveKey";

@implementation UIApplication (YC)


- (NSString *)documentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


/*
- (NSString *)libraryDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
 */

- (NSString *)libraryDirectory {
    return [self documentsDirectory];
}


- (NSString *)applicationDirectory {
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
     NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
     return basePath;
}
 
 

- (id)timestampWhenApplicationDidFinishLaunching{
	static  NSDate *d = nil;
	if (d==nil) {
		d = [[NSDate date] retain];
	}
	return d;
}

- (NSInteger)numberOfApplicationDidFinishLaunching{
	NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey: kNumberOfApplicationDidFinishLaunchingKey];
	if (number == nil) {
		return 0;
	}
	return [number integerValue];
}

- (NSInteger)numberOfApplicationDidBecomeActive{
    
	NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey: kNumberOfApplicationDidBecomeActiveKey];
	if (number == nil) {
		return 0;
	}
	return [number integerValue];
     
}

- (NSTimeInterval)timeElapsingAfterApplicationDidFinishLaunching{
	NSDate *now = [NSDate date];
	return [now timeIntervalSinceDate:self.timestampWhenApplicationDidFinishLaunching];
}

static  NSInteger _numberOfApplicationDidBecomeActiveOnceLaunching = 0;
- (NSInteger)numberOfApplicationDidBecomeActiveOnceLaunching{
	return _numberOfApplicationDidBecomeActiveOnceLaunching;
}

- (void)handleApplicationDidFinishLaunching:(id)notification {
	//启动计时
    [self timestampWhenApplicationDidFinishLaunching];
    
    //启动次数
    NSInteger i = self.numberOfApplicationDidFinishLaunching;
	NSNumber *number = [NSNumber numberWithInteger:i+1];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: number forKey: kNumberOfApplicationDidFinishLaunchingKey];
	[defaults synchronize];
}

- (void)handleApplicationDidBecomeActive:(id)notification{
    
    //计次，不累计
    _numberOfApplicationDidBecomeActiveOnceLaunching ++;
    
    //计次，累计
	NSInteger i = self.numberOfApplicationDidBecomeActive;
	NSNumber *number = [NSNumber numberWithInteger:i+1];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: number forKey: kNumberOfApplicationDidBecomeActiveKey];
	[defaults synchronize];
}

- (void)registerNotifications {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver: self
						   selector: @selector (handleApplicationDidFinishLaunching:)
							   name: UIApplicationDidFinishLaunchingNotification
							 object: nil];
    
	[notificationCenter addObserver: self
						   selector: @selector (handleApplicationDidBecomeActive:)
							   name: UIApplicationDidBecomeActiveNotification
							 object: nil];

}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: UIApplicationDidFinishLaunchingNotification object: nil];
    [notificationCenter removeObserver:self	name: UIApplicationDidBecomeActiveNotification object: nil];
}

/*
-(void) dealloc
{
	[self unRegisterNotifications];
	[super dealloc];
}
 */



@end
