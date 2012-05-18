//
//  UIApplication-YC.m
//  iAlarm
//
//  Created by li shiyong on 11-3-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIApplication-YC.h"


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

/*
 - (NSString *)applicationDirectory {
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
 NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
 return basePath;
 }
 
 */

- (id)applicationDidFinishLaunchingTime{
	static  NSDate *d = nil;
	if (d==nil) {
		d = [[NSDate date] retain];
	}
	return d;
}

- (NSTimeInterval)applicationDidFinishLaunchineTimeElapsing{
	NSDate *now = [NSDate date];
	return [now timeIntervalSinceDate:self.applicationDidFinishLaunchingTime];
}

- (void)handle_applicationDidFinishLaunching:(id)notification {
	[self applicationDidFinishLaunchingTime];//启动计时
}

- (void)registerNotifications {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver: self
						   selector: @selector (handle_applicationDidFinishLaunching:)
							   name: UIApplicationDidFinishLaunchingNotification
							 object: nil];

}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: UIApplicationDidFinishLaunchingNotification object: nil];

}


-(void) dealloc
{
	[self unRegisterNotifications];
	[super dealloc];
}



@end
