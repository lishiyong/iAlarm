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


- (void)callBlock:(void (^)(id anArgument))block withObject:(id)anArgument{
    block(anArgument);
}

- (void)performWithObject:(id)anArgument afterDelay:(NSTimeInterval)delay block:(void (^)(id anArgument))block{
    SEL aSelector = @selector(callBlock:withObject:);
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self];
	[invocaton setSelector:aSelector];
	[invocaton setArgument:&block atIndex:2];
	[invocaton setArgument:&anArgument atIndex:3]; 
	[invocaton performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}
///
// xx waitUntilDone xx 方法的 中间方法
- (void)proxyPerformSelector:(SEL)aSelector onThread:(NSThread *)thr withInteger:(NSInteger)anInteger waitUntilDone:(BOOL)wait{
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self];
	[invocaton setSelector:aSelector];
	[invocaton setArgument:&anInteger atIndex:2];
	[invocaton performSelector:@selector(invoke) onThread:thr withObject:nil waitUntilDone:wait];
}

- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withInteger:(NSInteger)anInteger waitUntilDone:(BOOL)wait afterDelay:(NSTimeInterval)delay{
    //实现思路:由于waitUntilDone，afterDelay不能同时使用， 所以通过调用中间方法中转。
    SEL proxySelector = @selector(proxyPerformSelector: onThread: withInteger: waitUntilDone:);
    NSMethodSignature *signature = [self methodSignatureForSelector:proxySelector];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self];
	[invocaton setSelector:proxySelector];
	[invocaton setArgument:&aSelector atIndex:2];
    [invocaton setArgument:&thr atIndex:3];
    [invocaton setArgument:&anInteger atIndex:4];
    [invocaton setArgument:&wait atIndex:5];
    [invocaton performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}
///


///
- (void)timerFired:(NSTimer *)timer{
    [self performSelector:@selector(retainCount) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];//通过调用一个无害的函数，来发消息，目的是让runLoop循环一次。
}

static NSTimer *gTimer = nil;
- (void)startOngoingSendingMessageWithTimeInterval:(NSTimeInterval)sec{
    if (gTimer != nil) {
        return;
    }
    
    [gTimer invalidate];
    [gTimer release];
    
    gTimer = [[NSTimer timerWithTimeInterval:sec target:self selector:@selector(timerFired:) userInfo:nil repeats:YES] retain];
    [[NSRunLoop currentRunLoop] addTimer:gTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopOngoingSendingMessage{
    [gTimer invalidate];
    [gTimer release];
    gTimer = nil;
}

///



@end


