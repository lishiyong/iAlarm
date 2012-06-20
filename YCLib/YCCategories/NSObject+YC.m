//
//  NSString.m
//  iAlarm
//
//  Created by li shiyong on 11-2-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCPair.h"
#import "NSObject+YC.h"

@interface NSObject (private) 

/**
 设计思路：_blockOperationPairs是一个Array，
 它包含若干由 objectId做为key，NSBlockOperation做为value的"对"
 (cocoa中没有“对”，用 NSDictionary对象代替)。
 **/
+ (NSMutableArray*)_blockOperationPairs;
+ (void)_addBlockOperation:(NSBlockOperation*)aBlockOperation withTarget:(id)aTarget;
//+ (void)_removeBlockOperationsWithTarget:(id)aTarget;
+ (void)_removeBlockOperationsWithBlockOperation:(id)aBlockOperation;
+ (void)_removeBlockOperationsWithBlockOperationId:(NSString*)aBlockOperationId;
+ (NSArray*)_blockOperationsForTarget:(id)aTarget;

//做这个方法，是为了在主线程中调用 _removeBlockOperationsWithBlockOperationId:
- (void)_instanceRemoveBlockOperationsWithBlockOperationId:(NSString*)aBlockOperationId;

@end


@implementation NSObject (YC)

#pragma mark - private

+ (NSMutableArray*)_blockOperationPairs{
    static NSMutableArray *array = nil;
    if (!array) {
        array = [[NSMutableArray array] retain];
    }
    return array;
}

+ (void)_addBlockOperation:(NSBlockOperation*)aBlockOperation withTarget:(id)aTarget{
    YCPair *aPair = [YCPair pairWithValue:aBlockOperation forKey:[aTarget objectId]];
    [[NSObject _blockOperationPairs] addObject:aPair];
}


+ (void)_removeBlockOperationsWithTarget:(id)aTarget{
    
    NSString *key = [aTarget objectId];
    NSMutableArray *removingArray = [NSMutableArray array];
    for (YCPair *aPair in [NSObject _blockOperationPairs]) {
        if ([(NSString *)aPair.key isEqualToString:key]){
            NSLog(@"(NSString *)aPair.key isEqualToString:key]");
            [removingArray addObject:aPair];
        }
    }
    if (removingArray.count > 0) 
        [[NSObject _blockOperationPairs] removeObjectsInArray:removingArray];
}
 

+ (void)_removeBlockOperationsWithBlockOperation:(id)aBlockOperation{
    YCPair* removing = nil;
    for (YCPair *aPair in [NSObject _blockOperationPairs]) {
        if (aPair.value == aBlockOperation ){
            removing = aPair;
            break;
        }
    }
    if (removing) 
        [[NSObject _blockOperationPairs] removeObject:removing];    
}

+ (void)_removeBlockOperationsWithBlockOperationId:(NSString*)aBlockOperationId{
    YCPair* removing = nil;
    for (YCPair *aPair in [NSObject _blockOperationPairs]) {
        if ([aPair.value.objectId isEqualToString:aBlockOperationId] ){
            removing = aPair;
            break;
        }
    }
    if (removing) 
        [[NSObject _blockOperationPairs] removeObject:removing];    
}

- (void)_instanceRemoveBlockOperationsWithBlockOperationId:(NSString*)aBlockOperationId{
    [NSObject _removeBlockOperationsWithBlockOperationId:aBlockOperationId ];
}

+ (NSArray*)_blockOperationsForTarget:(id)aTarget{
    NSString *key = [aTarget objectId];
    NSMutableArray *array = [NSMutableArray array];
    for (YCPair *aPair in [NSObject _blockOperationPairs]) {
        if ([(NSString*)aPair.key isEqualToString:key] ){
            [array addObject:aPair.value];
        }
    }
    return array;
}

#pragma mark -  

- (NSString *)objectId{
    return [NSString stringWithFormat:@"_objectId_%@:0x%x",NSStringFromClass([self class]),self];
}

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

#pragma mark - 

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

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument withDouble:(double)anDouble afterDelay:(NSTimeInterval)delay{
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self];
	[invocaton setSelector:aSelector];
	[invocaton setArgument:&anArgument atIndex:2];
	[invocaton setArgument:&anDouble atIndex:3]; 
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

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay{
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:block];
    //执行前加入到全局的列表中,为了让别人可以停止它
    [NSObject _addBlockOperation:blockOperation withTarget:self];
    [blockOperation performSelector:@selector(start) withObject:nil afterDelay:delay];
    NSString *blockOperationId = blockOperation.objectId;
    
    
    //执行完成就删除。
    blockOperation.completionBlock = 
    ^{ //这个块竟会放到其他线程中来执行，所以...
        //而且，块中不能有blockOperation出现，否则会造成内存泄露
        [self performSelectorOnMainThread:@selector(_instanceRemoveBlockOperationsWithBlockOperationId:) withObject:blockOperationId waitUntilDone:NO];
    };
}

+ (void)cancelPreviousPerformBlockRequestsWithTarget:(id)aTarget{
    NSArray *blockOperations = [NSObject _blockOperationsForTarget:aTarget];
    for (NSBlockOperation *aBO in blockOperations) {
        [NSObject cancelPreviousPerformRequestsWithTarget:aBO selector:@selector(start) object:nil];
        [aBO cancel];//这句有没有用不知道
        [NSObject _removeBlockOperationsWithBlockOperation:aBO];
    }
}



@end


