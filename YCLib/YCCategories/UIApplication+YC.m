//
//  UIApplication-YC.m
//  iAlarm
//
//  Created by li shiyong on 11-3-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIApplication+YC.h"

static NSString *kYCApplicationDidFinishLaunchNumberKey = @"kYCApplicationDidFinishLaunchNumberKey";
static NSString *kYCApplicationDidBecomeActiveNumberKey = @"kYCApplicationDidBecomeActiveNumberKey";

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
 
 

- (id)applicationDidFinishLaunchingTime{
	static  NSDate *d = nil;
	if (d==nil) {
		d = [[NSDate date] retain];
	}
	return d;
}

- (NSInteger)applicationDidFinishLaunchNumber{
	NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey: kYCApplicationDidFinishLaunchNumberKey];
	if (number == nil) {
		return 0;
	}
	return [number integerValue];
}

- (NSInteger)applicationDidBecomeActiveNumber{
	NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey: kYCApplicationDidBecomeActiveNumberKey];
	if (number == nil) {
		return 0;
	}
	return [number integerValue];
}

- (NSTimeInterval)applicationDidFinishLaunchineTimeElapsing{
	NSDate *now = [NSDate date];
	return [now timeIntervalSinceDate:self.applicationDidFinishLaunchingTime];
}

- (void)handleApplicationDidFinishLaunching:(id)notification {
	//启动计时
    [self applicationDidFinishLaunchingTime];
    
    //启动次数
    NSInteger i = self.applicationDidFinishLaunchNumber;
	NSNumber *number = [NSNumber numberWithInteger:i+1];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: number forKey: kYCApplicationDidFinishLaunchNumberKey];
	[defaults synchronize];
}

- (void)handleApplicationDidBecomeActive:(id)notification{
	NSInteger i = self.applicationDidBecomeActiveNumber;
	NSNumber *number = [NSNumber numberWithInteger:i+1];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: number forKey: kYCApplicationDidBecomeActiveNumberKey];
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
