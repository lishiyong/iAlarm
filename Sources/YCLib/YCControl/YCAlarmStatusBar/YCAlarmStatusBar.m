//
//  StatusBarWindow.m
//  TestKeyFrameAnimation
//
//  Created by li shiyong on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YCAlarmStatusBar.h"

static const NSInteger kMaskIcons        = 4;                        //覆盖4个标

static const CGPoint kAlarmBarOrigin     = {296-22*kMaskIcons, 0};   //电池截止到296。
static const CGSize  kAlarmBarSize       = {22*kMaskIcons, 20};      //22个像素一个图标。覆盖5个标

static const CGPoint kBackgroundPosition  = {22*kMaskIcons/2, 10};   //anchor点设置在(0.5,0.5)
static const CGSize  kBackgroundSize      = {22*kMaskIcons, 20};
static const CGPoint kAlarmIconPosition   = {22*kMaskIcons, 10};     //anchor点设置在(1.0,0.5)
static const CGSize  kAlarmIconSize       = {22, 20};
/*
static const CGSize  kNumberSize          = {8, 20-2};
static const CGSize  kXContainerSize      = {3*8, 20-2};
//static const CGPoint kXContainerOrigin    = {296-22*kMaskIcons, 0}; //下面算出来

static const CGPoint kThreeNumberOrigin      = {0, 0};
static const CGPoint kTwoNumberOrigin       = {8, 0};
static const CGPoint kOneNumberOrigin       = {16, 0};
 */

static const CGSize  kXContainerSize      = {3*8, 20-2};
static const CGSize  kOneNumberSize       = {22, 20-2};
static const CGPoint kOneNumberOrigin     = {0, 0};




@implementation YCAlarmStatusBar

@synthesize autoHide, alarmCount, autoHideInterval;

static YCAlarmStatusBar *bar = nil;
+ (YCAlarmStatusBar*)shareStatusBar{
    if (!bar) {
        bar = [[super allocWithZone:NULL] init];
    }
    return bar;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self shareStatusBar] retain];
}

- (id)initWithFrame:(CGRect)aRect{
    self = [self init];
    return self;
}

- (id)init{
    self = [super initWithFrame:(CGRect){kAlarmBarOrigin,kAlarmBarSize}];
    if(self){
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = [UIColor clearColor];
        autoHide = YES;
        autoHideInterval = 8.0;
        
        backgroundLayer = [[CALayer layer] retain];
        backgroundLayer.position = kBackgroundPosition;
        backgroundLayer.bounds = (CGRect){{0,0},kBackgroundSize};
        backgroundLayer.contents = (id)[UIImage imageNamed:@"YCSilver_Base.png"].CGImage;
        //backgroundLayer.hidden = YES;
        [self.layer addSublayer:backgroundLayer];
        
        alarmIconLayer = [[CALayer layer] retain];
        alarmIconLayer.anchorPoint = CGPointMake(1.0, 0.5);
        alarmIconLayer.contentsGravity = kCAGravityResizeAspect;
        alarmIconLayer.position = kAlarmIconPosition;
        alarmIconLayer.bounds = (CGRect){{0,0},kAlarmIconSize};
        alarmIconLayer.contents = (id)[UIImage imageNamed:@"YCSilver_Alarm.png"].CGImage;
        alarmIconLayer.hidden = YES;
        [backgroundLayer addSublayer:alarmIconLayer];

        /*
        oneLabel   = [[UILabel alloc] initWithFrame:(CGRect){kOneNumberOrigin,kNumberSize}];
        twoLabel   = [[UILabel alloc] initWithFrame:(CGRect){kTwoNumberOrigin,kNumberSize}];
        threeLabel = [[UILabel alloc] initWithFrame:(CGRect){kThreeNumberOrigin,kNumberSize}];
        
        UIFont *xFont = [UIFont boldSystemFontOfSize:11.0];
        UIColor *xTextColor = [UIColor colorWithRed:100.0/255.0 green:120.0/255.0 blue:128.0/255.0 alpha:1.0]; 
        UIColor *xShadowColor = [UIColor whiteColor];
        CGSize xShadowOffset = CGSizeMake(0,1);
        
        oneLabel.font = xFont;
        oneLabel.textColor = xTextColor;
        oneLabel.shadowColor = xShadowColor;
        oneLabel.shadowOffset = xShadowOffset;
        oneLabel.textAlignment = UITextAlignmentRight;
        oneLabel.baselineAdjustment = UIBaselineAdjustmentNone;
        oneLabel.backgroundColor = [UIColor clearColor];
        
        twoLabel.font = xFont;
        twoLabel.textColor = xTextColor;
        twoLabel.shadowColor = xShadowColor;
        twoLabel.shadowOffset = xShadowOffset;
        twoLabel.textAlignment = UITextAlignmentRight;
        twoLabel.backgroundColor = [UIColor clearColor];
        
        threeLabel.font = xFont;//[UIFont italicSystemFontOfSize:12.0];
        threeLabel.textColor = xTextColor;
        threeLabel.shadowColor = xShadowColor;
        threeLabel.shadowOffset = xShadowOffset;
        threeLabel.textAlignment = UITextAlignmentRight;
        threeLabel.backgroundColor = [UIColor clearColor];
         */
        
        oneLabel   = [[UILabel alloc] initWithFrame:(CGRect){kOneNumberOrigin,kOneNumberSize}];
        UIFont *xFont = [UIFont boldSystemFontOfSize:11.0];
        UIColor *xTextColor = [UIColor colorWithRed:100.0/255.0 green:120.0/255.0 blue:128.0/255.0 alpha:1.0]; 
        UIColor *xShadowColor = [UIColor whiteColor];
        CGSize xShadowOffset = CGSizeMake(0,1);
        
        oneLabel.font = xFont;
        oneLabel.textColor = xTextColor;
        oneLabel.shadowColor = xShadowColor;
        oneLabel.shadowOffset = xShadowOffset;
        oneLabel.textAlignment = UITextAlignmentRight;
        oneLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        oneLabel.backgroundColor = [UIColor clearColor];
        
        //计算得到xContainerView的Frame
        CGRect xContainerViewFrame = CGRectOffset(alarmIconLayer.frame, -kXContainerSize.width+5, 0.0);
        xContainerViewFrame = (CGRect){xContainerViewFrame.origin, kXContainerSize};
        xContainerView = [[UIView alloc] initWithFrame:xContainerViewFrame];
        xContainerView.backgroundColor = [UIColor clearColor];
        
        [xContainerView addSubview:oneLabel];
        //[xContainerView addSubview:twoLabel];
        //[xContainerView addSubview:threeLabel];

        [self addSubview:xContainerView];
        
    }
    
    return self;
}

- (void)hideSelf{
    if (!autoHide) 
        return;
    
    [UIView transitionWithView:self
                      duration:0.25
                       options:UIViewAnimationOptionShowHideTransitionViews | UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ 
                        self.hidden = YES;
                        [self resignKeyWindow];
                    }
                    completion:NULL];

}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated{
    
    if (!hidden) {
        //设置自动隐藏
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideSelf) object:nil];
        if (autoHideInterval > 0) {
            [self performSelector:@selector(hideSelf) withObject:nil afterDelay:autoHideInterval];
        }
    }
    
    if (animated) {
        [UIView transitionWithView:self
                          duration:0.25
                           options:UIViewAnimationOptionShowHideTransitionViews | UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{ 
                            self.hidden = hidden;
                            if (hidden) 
                                [self resignKeyWindow];
                            else
                                [self makeKeyWindow];
                        }
                        completion:NULL];
        
    }else{
        self.hidden = hidden;
        if (hidden) 
            [self resignKeyWindow];
        else
            [self makeKeyWindow];
    }
    
}

- (void)setAlarmIconHidden:(BOOL)hidden animated:(BOOL)animated{
   
    [CATransaction begin];
    
    if (animated) {
        [CATransaction setValue:[NSNumber numberWithFloat:0.25] forKey:kCATransactionAnimationDuration]; 
    }else{
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    }
    xContainerView.hidden = hidden;
    alarmIconLayer.hidden = hidden;
    [CATransaction commit];
}

- (CGPoint)alarmIconCenter{
    CGPoint theOrigin = alarmIconLayer.frame.origin;
    CGSize theSize = alarmIconLayer.frame.size;
    CGFloat centerX = theOrigin.x + theSize.width/2;
    CGFloat centerY = theSize.height/2;
    return (CGPoint){centerX,centerY};
}

- (void)setNumber{
    /*
    NSString *oneS = nil;
    NSString *twoS = nil;
    NSString *threeS = nil;
    if (alarmCount <= 1) {
        oneS = nil;
        twoS = nil;
        threeS = nil;
    }else{
        NSString *alarmCountString = [NSString stringWithFormat:@"%d",alarmCount];
        switch (alarmCountString.length) {
            case 1:
                oneS = alarmCountString;
                twoS = nil;
                threeS = nil;
                break;
            case 2:
            {
                unichar uc = [alarmCountString characterAtIndex:1];
                oneS = [NSString stringWithCharacters:&uc length:1] ;
                
                uc = [alarmCountString characterAtIndex:0];
                twoS = [NSString stringWithCharacters:&uc length:1];
                
                threeS = nil;
                break;    
            }
            default:
                oneS = @"9";
                twoS = @"9";
                threeS = @"+";
                break;
        }
    }
    
    [CATransaction begin];
    CATransition *tranAnimation = [CATransition animation];
    tranAnimation.type = kCATransitionPush;
    tranAnimation.subtype = kCATransitionFromTop;
    tranAnimation.duration = 0.5;
    tranAnimation.startProgress = 0.75;
    [oneLabel.layer addAnimation:tranAnimation forKey:@"YCOneTran"];
    oneLabel.text = oneS;
    twoLabel.text = twoS;
    threeLabel.text = threeS;
    
    [CATransaction commit];
     */
    
    NSString *oneS = nil;

    if (alarmCount <= 1) {
        oneS = nil;
    }else {
        oneS = [NSString stringWithFormat:@"%d",alarmCount];
    }
    
    oneLabel.text = oneS;
    
    
}

- (void)increaseAlarmCount{
    alarmCount++;
    [self setNumber];
}
- (void)decreaseAlarmCount{
    if (alarmCount > 0) 
        alarmCount--;
    [self setNumber];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
