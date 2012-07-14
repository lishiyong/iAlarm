//
//  YCPromptView.m
//  iAlarm
//
//  Created by li shiyong on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import <QuartzCore/QuartzCore.h>
#import "YCPromptView.h"

#define kSelfW     120.0
#define kSelfH     120.0

#define kIconViewW 45.0
#define kIconViewH 45.0

@interface YCPromptView (private)

- (void)selfPressed:(id)sender;

@end



@implementation YCPromptView

@synthesize promptViewStatus = _promptViewStatus, dismissByTouch = _dismissByTouch;

- (void)selfPressed:(id)sender{
    if (_dismissByTouch) 
        [self dismissAnimated:YES];
}

- (void)setPromptViewStatus:(YCPromptViewStatus)promptViewStatus{
    
    if (_promptViewStatus == promptViewStatus) {
        return;
    }
    

    _promptViewStatus = promptViewStatus;
    //先把其他都删除
    [[_iconView subviews ] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    switch (_promptViewStatus) {
        case YCPromptViewStatusWaiting:
        {
            //加入waitingView
            UIActivityIndicatorView *waitingView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
            waitingView.center = YCRectCenter(_iconView.bounds);
            [waitingView startAnimating];
            [_iconView addSubview:waitingView];
            break;
        }
        case YCPromptViewStatusOK:
        case YCPromptViewStatusFailture:
        case YCPromptViewStatusWarn:
        {
            //加入√，x,!等
            UIImage *image = nil;
            if (YCPromptViewStatusOK == _promptViewStatus) 
                image = [UIImage imageNamed:@"YCPromptViewCheck.png"];
            else if (YCPromptViewStatusFailture == _promptViewStatus) 
                image = [UIImage imageNamed:@"YCPromptViewStop.png"];
            else if (YCPromptViewStatusWarn == _promptViewStatus) 
                image = [UIImage imageNamed:@"YCPromptViewWarn.png"];
            
            UIImageView *imgeView = [[[UIImageView alloc] initWithImage:image] autorelease];
            imgeView.center = YCRectCenter(_iconView.bounds);
            [_iconView addSubview:imgeView];
            break;
        }
        default:
            break;
    }
    
}

- (void)setText:(NSString *)text{
    if (text == nil) {
        self.bounds = (CGRect){{0,0},{kSelfW,kSelfH}};
    }else {
        CGSize textSize = [text sizeWithFont:_textLabel.font constrainedToSize:(CGSize){220.0,600.0} lineBreakMode:_textLabel.lineBreakMode];
        //self
        CGFloat selfW = textSize.width +20.0;//左右边各留白10
        CGFloat selfH = 10.0 + textSize.height + 2.0 + _iconView.bounds.size.height + 20.0; //上下边各留白10,间距2
        self.bounds = (CGRect){{0,0},{selfW,selfH}};
        
        //icon
        CGFloat newIconViewCenterX = self.bounds.size.width/2;
        CGFloat newIconViewCenterY = 10.0 + _iconView.bounds.size.height/2;  //上留边10
        _iconView.center = (CGPoint){newIconViewCenterX, newIconViewCenterY};
        
        //文本
        _textLabel.bounds = (CGRect){{0,0},textSize};
        CGFloat textLabelCenterX = self.bounds.size.width/2;
        CGFloat textLabelCenterY = 10.0 + _iconView.bounds.size.height + 2.0 +_textLabel.bounds.size.height/2; //上留边10,间距2
        _textLabel.center = (CGPoint){textLabelCenterX, textLabelCenterY};
         
    }
    
    _textLabel.text = text;
}

- (id)text{
    return _textLabel.text;
}

- (id)initWithFrame:(CGRect)frame
{
    frame = (CGRect){{0,0},{kSelfW,kSelfH}};
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(selfPressed:) forControlEvents:UIControlEventTouchUpInside];
        _promptViewStatus = -1;
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
        self.layer.cornerRadius = 10.0;
        self.autoresizesSubviews = YES;
        
        CGRect iconViewFrame = (CGRect){{0,0},{kIconViewW,kIconViewH}};
        _iconView = [[UIImageView alloc] initWithFrame:iconViewFrame];
        _iconView.center = YCRectCenter(self.bounds);
        _iconView.backgroundColor = [UIColor clearColor];
        [self addSubview:_iconView];
        
        
        CGRect textLabelFrame = (CGRect){{0,0},{220,1000.0}};
        _textLabel = [[UILabel alloc] initWithFrame:textLabelFrame];
        _textLabel.numberOfLines = 10;//最多5行
        _textLabel.textAlignment = UITextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont boldSystemFontOfSize:22.0];
        //_textLabel.adjustsFontSizeToFitWidth = YES;
        //_textLabel.minimumFontSize = 16.0;
        _textLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_textLabel];
                
    }
    return self;
}

- (id)init{
    return [self initWithFrame:CGRectZero];
}

- (void)show{
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor clearColor];
        _window.windowLevel = UIWindowLevelNormal;
        
        UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfPressed:)] autorelease];
        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;//单点
        [_window addGestureRecognizer:tapGesture];
        
    }
    [_window makeKeyAndVisible];
    
    CGPoint centerPoint = YCRectCenter(_window.bounds);
    
    //如果有状态栏
    if (![UIApplication sharedApplication].statusBarHidden) { 
        CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
        centerPoint.y = centerPoint.y + statusBarH/2;
    };
    
    self.center = centerPoint;
    self.alpha = 0.0;
    [_window addSubview:self];

    [UIView transitionWithView:_window duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.alpha = 1.0;
    } completion:NULL];
 
     
}

- (void)dismissAnimated:(BOOL)animated{
    if (animated) {
        [UIView transitionWithView:_window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self removeFromSuperview];
        } completion:^(BOOL finished) {
            [_window resignKeyWindow];
            [_window release];
            _window = nil;
        }];
    }else {
        [self removeFromSuperview];
        [_window resignKeyWindow];
        [_window release];
        _window = nil;
    }
}

- (void)dealloc{
    NSLog(@"YCPromptView dealloc");
    [_window release];
    [_iconView release];
    [_textLabel release];
    [super dealloc];
}


@end
