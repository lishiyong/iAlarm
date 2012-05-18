//
//  NSString.m
//  iAlarm
//
//  Created by li shiyong on 11-2-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSObject+YC.h"


@implementation NSObject (YC)


- (void)performSelector:(SEL)aSelector withInteger:(NSInteger)anInteger afterDelay:(NSTimeInterval)delay{

	NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self];
	[invocaton setSelector:aSelector];
	[invocaton setArgument:&anInteger atIndex:2];  //self,_cmd分别占据0、1
	[invocaton performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}

- (void)performSelector:(SEL)aSelector withFloat:(CGFloat)anFloat afterDelay:(NSTimeInterval)delay{
	
	NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self];
	[invocaton setSelector:aSelector];
	[invocaton setArgument:&anFloat atIndex:2];  //self,_cmd分别占据0、1
	[invocaton performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument withObject:(id)anotherObject afterDelay:(NSTimeInterval)delay{
	NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self];
	[invocaton setSelector:aSelector];
	[invocaton setArgument:&anArgument atIndex:2];
	[invocaton setArgument:&anotherObject atIndex:3]; 
	[invocaton performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument withInteger:(NSInteger)anInteger afterDelay:(NSTimeInterval)delay{
	NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self];
	[invocaton setSelector:aSelector];
	[invocaton setArgument:&anArgument atIndex:2];
	[invocaton setArgument:&anInteger atIndex:3]; 
	[invocaton performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}

- (void)performSelector:(SEL)aSelector withInteger:(NSInteger)anInteger withInteger:(NSInteger)anotherInteger afterDelay:(NSTimeInterval)delay{
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self];
	[invocaton setSelector:aSelector];
	[invocaton setArgument:&anInteger atIndex:2];
	[invocaton setArgument:&anInteger atIndex:3]; 
	[invocaton performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}


@end
