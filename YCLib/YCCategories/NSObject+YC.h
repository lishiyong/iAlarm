//
//  NSString.h
//  iAlarm
//
//  Created by li shiyong on 11-2-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YCObject<NSObject>

- (void)performSelector:(SEL)aSelector withInteger:(NSInteger)anInteger afterDelay:(NSTimeInterval)delay;
- (void)performSelector:(SEL)aSelector withFloat:(CGFloat)anFloat afterDelay:(NSTimeInterval)delay;
- (void)performSelector:(SEL)aSelector withObject:(id)anArgument withObject:(id)anotherObject afterDelay:(NSTimeInterval)delay;
- (void)performSelector:(SEL)aSelector withObject:(id)anArgument withInteger:(NSInteger)anInteger afterDelay:(NSTimeInterval)delay;
- (void)performSelector:(SEL)aSelector withInteger:(NSInteger)anInteger withInteger:(NSInteger)anotherInteger afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withInteger:(NSInteger)anInteger waitUntilDone:(BOOL)wait afterDelay:(NSTimeInterval)delay;
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;


@end

@interface NSObject (YC)

- (void)performSelector:(SEL)aSelector withInteger:(NSInteger)anInteger afterDelay:(NSTimeInterval)delay;
- (void)performSelector:(SEL)aSelector withFloat:(CGFloat)anFloat afterDelay:(NSTimeInterval)delay;
- (void)performSelector:(SEL)aSelector withObject:(id)anArgument withObject:(id)anotherObject afterDelay:(NSTimeInterval)delay;
- (void)performSelector:(SEL)aSelector withObject:(id)anArgument withInteger:(NSInteger)anInteger afterDelay:(NSTimeInterval)delay;
- (void)performSelector:(SEL)aSelector withInteger:(NSInteger)anInteger withInteger:(NSInteger)anotherInteger afterDelay:(NSTimeInterval)delay;

- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withInteger:(NSInteger)anInteger waitUntilDone:(BOOL)wait afterDelay:(NSTimeInterval)delay;
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;



//为当前runloop加一个持续不断发消息的Timer
- (void)startOngoingSendingMessageWithTimeInterval:(NSTimeInterval)sec;
- (void)stopOngoingSendingMessage;

@end
