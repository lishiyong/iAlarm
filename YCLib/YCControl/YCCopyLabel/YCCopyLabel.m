//
//  YCCopyMenuLabel.m
//  TestResponder
//
//  Created by 李世勇 on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCCopyLabel.h"

@implementation YCCopyLabel

#pragma mark -
#pragma mark Notification

- (void)handleMenuControllerDidHideMenu: (NSNotification*)notification{
    //点父view，导致的menu的隐藏，并不能使Label失去第一响应者。在这里主动放弃
    [self resignFirstResponder];
}

- (void)registerNotifications{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter addObserver: self
						   selector: @selector (handleMenuControllerDidHideMenu:)
							   name: UIMenuControllerDidHideMenuNotification
							 object: nil];
	
}

- (void)unRegisterNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self	name: UIMenuControllerDidHideMenuNotification object: nil];
}


#pragma mark - Utility

- (void)otherInit{
    //打开用户响应
    self.userInteractionEnabled = YES;
    //默认的文本的属性
    self.highlightedTextColor = [UIColor colorWithRed:24.0/255.0 green:96.0/255.0 blue:225.0/255.0 alpha:1.0];//蓝色
    
    [self registerNotifications];
}

- (void)createGestureRecognizers {
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture]; 
    
    longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
    longGesture.minimumPressDuration = 0.1;
    [self addGestureRecognizer:longGesture];
}

#pragma mark - GestureRecognizer Event

- (IBAction)handleTapGesture:(UIGestureRecognizer *)sender {
	// 如果tap，而且menu显示，隐藏menu，放弃第一响应者
    if (UIGestureRecognizerStateEnded == sender.state) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        if ([menuController isMenuVisible]) {
            [menuController setMenuVisible:NO animated:YES];
            [self resignFirstResponder];
        }
    }
}

- (IBAction)handleLongGesture:(UIGestureRecognizer *)sender {
    // 如果longPress，先成为第一响应者，然后显示menu，
    if (UIGestureRecognizerStateEnded == sender.state && [self becomeFirstResponder]) {
        UIMenuController *theMenu = [UIMenuController sharedMenuController];
		[theMenu setTargetRect:self.bounds inView:self];
		[theMenu setMenuVisible:YES animated:YES];
    }
}

#pragma mark - UIResponderStandardEditActions Protocol

- (void)copy:(id)sender {	
	UIPasteboard *gpBoard = [UIPasteboard generalPasteboard];
    [gpBoard setValue:self.text forPasteboardType:@"public.plain-text"];
}

#pragma mark - Override super

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copy:)) {
        if (self.text) 
            return YES;
    }
    return NO;
}


- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (BOOL)canResignFirstResponder{
    return YES;
}

- (BOOL)becomeFirstResponder{
    BOOL b = [super becomeFirstResponder];
    self.highlighted = [self isFirstResponder];
    return b;
}

- (BOOL)resignFirstResponder{
    BOOL b = [super resignFirstResponder];
    self.highlighted = [self isFirstResponder];
    return b;
}



#pragma mark - Init and Memory Manager

- (id)initWithFrame:(CGRect)aRect{
    self = [super initWithFrame:aRect];
    if (self) {
        [self createGestureRecognizers];
        [self otherInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createGestureRecognizers];
        [self otherInit];
    }
    return self;
}

- (void)dealloc{
    [self unRegisterNotifications];
    [tapGesture release];
    [longGesture release];
    [super dealloc];
}

@end
