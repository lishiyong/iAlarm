//
//  UINavigationController+YC.m
//  testMap
//
//  Created by li shiyong on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UINavigationController+YC.h"

@implementation UINavigationController (YC)

#define kSearchBarTag 100
- (void)addSearchBar:(UISearchBar*)theSearchBar{
    
    CGRect searchBarFrame = CGRectNull;
    if (self.navigationBarHidden)
        searchBarFrame = (CGRect){{0,20},{320,44}};
    else
        searchBarFrame = (CGRect){{0,64},{320,44}};
    
    theSearchBar.frame = searchBarFrame;
    theSearchBar.tag = kSearchBarTag;
    [self.view addSubview:theSearchBar];
    
}

- (UISearchBar*)seachBar{
    return (UISearchBar*)[self.view viewWithTag:kSearchBarTag];
}

- (void)setNavigationBarAndSearchBarHidden:(BOOL)hidden animated:(BOOL)animated{
    
    CGPoint newPosition;
    if (hidden) 
        newPosition = (CGPoint){160,20+22};
    else
        newPosition = (CGPoint){160,20+44+22};
    
    if (animated){
        /*
         [CATransaction begin];
         [CATransaction setValue:[NSNumber numberWithFloat:10.0f]
         forKey:kCATransactionAnimationDuration];
         [self seachBar].layer.position = newPosition;
         [CATransaction commit];
         */
        
        [CATransaction begin];
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        animation.fromValue = [NSNumber numberWithFloat:[self seachBar].layer.position.y];
        animation.toValue = [NSNumber numberWithFloat:newPosition.y];
        animation.duration = UINavigationControllerHideShowBarDuration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.delegate = self;
        [[self seachBar].layer addAnimation:animation forKey:@"YCNavigationBarHidden"];
        [CATransaction commit];
        
        [self seachBar].layer.position = newPosition;
        
    }else{
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        [self seachBar].layer.position = newPosition;
        [CATransaction commit]; 
    }
    
    [self setNavigationBarHidden:hidden animated:animated];
    
}

//为了延时调用
- (void)laySearchBar:(UISearchBar*)searchBar frame:(CGRect)frame oldSuperView:(UIView*)oldSuperView{
    searchBar.frame = frame;
    [oldSuperView addSubview:searchBar];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated searchBar:(UISearchBar*)theSearchBar fromSuperView:(UIView*)fromSuperView{
    //记下原来的frame为了下面用
    CGRect oldSearchBarFrame = theSearchBar.frame;
    
    //吧bar加入到本控制器的view
    [self addSearchBar:theSearchBar];
    
    //动画后的位置
    CGPoint newPosition;
    if (hidden) 
        newPosition = (CGPoint){160,20+22};
    else
        newPosition = (CGPoint){160,20+44+22};
    
    if (animated){
        [CATransaction begin];
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        animation.fromValue = [NSNumber numberWithFloat:[self seachBar].layer.position.y];
        animation.toValue = [NSNumber numberWithFloat:newPosition.y];
        animation.duration = UINavigationControllerHideShowBarDuration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.delegate = self;
        [[self seachBar].layer addAnimation:animation forKey:@"YCNavigationBarHidden"];
        [CATransaction commit];
        [self seachBar].layer.position = newPosition;
    }else{
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        [self seachBar].layer.position = newPosition;
        [CATransaction commit]; 
    }
    //调用系统的隐藏或显示navigationBar函数
    [self setNavigationBarHidden:hidden animated:animated];
    
    //在动画结束后，把searchBar加回到原来的视图
    NSMethodSignature *signature = [self methodSignatureForSelector:@selector(laySearchBar:frame:oldSuperView:)];
	NSInvocation *invocaton = [NSInvocation invocationWithMethodSignature:signature];
	[invocaton setTarget:self];
	[invocaton setSelector:@selector(laySearchBar:frame:oldSuperView:)];
	[invocaton setArgument:&theSearchBar atIndex:2];
	[invocaton setArgument:&oldSearchBarFrame atIndex:3]; 
    [invocaton setArgument:&fromSuperView atIndex:4]; 
	[invocaton performSelector:@selector(invoke) withObject:nil afterDelay:UINavigationControllerHideShowBarDuration+0.05];
    
    
}

- (void)animationDidStart:(CAAnimation *)theAnimation{
    self.view.userInteractionEnabled = NO;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    self.view.userInteractionEnabled = YES;
}

@end
