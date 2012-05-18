//
//  YCCalloutBar.m
//  TestBgTask
//
//  Created by li shiyong on 11-3-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCCalloutBarButton.h"
#import "YCUIKit.h"
#import "YCCalloutBar.h"


@implementation YCCalloutBar

-(id) arrowView{
	if (arrowView == nil) {
		arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCCalloutBarArrowBottom.png"]];
	}
	
	return arrowView;
	
}

-(id)buttons{
	if (buttons == nil) {
		buttons = [[NSMutableArray array] retain];
	}
	return buttons;
}

-(UIImageView*)shadowLeft
{
	if (shadowLeft == nil) {
		shadowLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCCalloutBarShadowLeft.png"]];
	}
	return shadowLeft;
}
-(UIImageView*)shadowRight
{
	if (shadowRight == nil) {
		shadowRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCCalloutBarShadowRight.png"]];
	}
	return shadowRight;
}
-(UIImageView*)shadowMiddle1
{
	if (shadowMiddle1 == nil) {
		shadowMiddle1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCCalloutBarShadowMiddle.png"]];
	}
	return shadowMiddle1;
}

-(UIImageView*)shadowMiddle2
{
	if (shadowMiddle2 == nil) {
		shadowMiddle2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCCalloutBarShadowMiddle.png"]];
	}
	return shadowMiddle2;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithButtonsTitle:nil buttonsImage:nil targets:nil actions:nil arrowPointer:CGPointMake(0.0, 0.0) fromSuperView:nil];
}

//通过按钮初title或image始化bar，没有：NSNull。只为bar上的按钮绑定 UIControlEventTouchUpInside 
- (id)initWithButtonsTitle:(NSArray*)buttonsTitle buttonsImage:(NSArray*)buttonsImage targets:(NSArray*)targets actions:(NSArray*)actions 
			  arrowPointer:(CGPoint)arrowPointer fromSuperView:(UIView*)superView{	
	
	UIFont *kFont = [UIFont boldSystemFontOfSize:14];                                            //title的字体
	
	//const CGFloat kMaxButtonWidth = 120.0;                                                       //按钮的最大宽度
	const CGFloat kMinButtonWidth = kCalloutBarLeftButtonInset.left + kCalloutBarLeftButtonInset.right;  //按钮的最小宽度
	const CGFloat kButtonHeight = 39.0;                                                          //按钮的高度
	const CGSize  kArrowSize = CGSizeMake(24.0, 17.0);                                           //三角箭头的size
	const CGFloat kBarHeight = kButtonHeight + kArrowSize.height;                                //bar（self）的高度
	
	const CGFloat kCutWidth = 2.0;                                                               //分隔线的宽度
	
	const CGFloat kshadowHeight = 17.0;                                                          //下部阴影高度
	const CGFloat kshadowLeftWidth = 11.0;                                                       //左阴影宽
	const CGFloat kshadowRightWidth = 11.0;                                                      //右阴影宽
	
	
	
	
	////////////////////////////////////////
	//计算各个button的宽度，view的总宽度

	CGFloat *buttonWidths = malloc(buttonsTitle.count * sizeof(CGFloat));
	CGFloat barWidth = 0.0;
	for (NSInteger i = 0; i < buttonsTitle.count; i++) {
		
		
		UIEdgeInsets kCalloutBarButtonInset;
		if (buttonsTitle.count == 1) {                    //只有一个
			
			kCalloutBarButtonInset = kCalloutBarMiddleButtonInset;
			
		}else if (i == 0) {                                //左
			
			kCalloutBarButtonInset = kCalloutBarLeftButtonInset;
			
		}else if (i == buttonsTitle.count -1){             //右边的
			
			kCalloutBarButtonInset = kCalloutBarRightButtonInset;
			
		}else {                                            //中间的，
			
			kCalloutBarButtonInset = kCalloutBarMiddleButtonInset;
			
		}

		CGFloat buttonWidth =0.0;
		NSString *title = [buttonsTitle objectAtIndex:i];
		UIImage *image = [buttonsImage objectAtIndex:i];
		
		//title,image只能设置一种
		if(![title isKindOfClass:[NSNull class]] ) {
			//CGFloat width = textLabelWidth(title, kFont) ;
			//buttonWidth = width > kMaxButtonWidth ? kMaxButtonWidth : width;
			//buttonWidth = width < kMinButtonWidth ? kMinButtonWidth : width;
			buttonWidth = textLabelWidth(title, kFont) + kCalloutBarButtonInset.left + kCalloutBarButtonInset.right;
		}else {
			if(![image isKindOfClass:[NSNull class]] ) {
				//CGFloat width = image.size.width;
				//buttonWidth = width > kMaxButtonWidth ? kMaxButtonWidth : width;
				//buttonWidth = width < kMinButtonWidth ? kMinButtonWidth : width;
				buttonWidth = image.size.width + kCalloutBarButtonInset.left + kCalloutBarButtonInset.right;
			}
		}
		
		if (buttonWidth == 0.0) 
				buttonWidth = kMinButtonWidth;

		barWidth += buttonWidth;
		buttonWidths[i] = buttonWidth;
		
	}


	double ratePointerInWindow = (arrowPointer.x/320.0);  //三角箭头分隔屏幕的比例
	ratePointerInWindow = (ratePointerInWindow < 0.15) ? 0.12 : ratePointerInWindow; // 0.12< ratePointerInWindow > 0.88
	ratePointerInWindow = (ratePointerInWindow > 0.85) ? 0.88 : ratePointerInWindow;
	
	CGFloat frontBarWidth = barWidth * ratePointerInWindow; //bar的前半段的宽度
	CGFloat barOriginX = (arrowPointer.x - frontBarWidth); //
	CGFloat barOriginY = arrowPointer.y - kBarHeight; //分别减去bar的高度

	CGRect barFrame = CGRectMake(barOriginX, barOriginY, barWidth, kBarHeight);
	////////////////////////////////////////
	
	

	self = [super initWithFrame:barFrame];
	if (self) {
		
		
		//////////////////////////////
		//三角箭头
		CGFloat arrowOriginXInBar = barWidth * ratePointerInWindow - kArrowSize.width/2;
		CGRect arrowRectInBar = CGRectMake(arrowOriginXInBar,kButtonHeight, kArrowSize.width,kArrowSize.height);
		self.arrowView.frame = arrowRectInBar;
		[self addSubview:self.arrowView];
		//////////////////////////////
		
		
		//////////////////////////////
		//下部阴影
		CGFloat middleWidth  = barWidth - kshadowLeftWidth - kshadowRightWidth;
		CGFloat middle1Width = arrowRectInBar.origin.x - kshadowLeftWidth;
		CGFloat middle2Width = middleWidth - middle1Width - arrowRectInBar.size.width;
		CGFloat middle2X = arrowRectInBar.origin.x+arrowRectInBar.size.width;
		CGFloat rightX = barWidth - kshadowRightWidth;
		
		self.shadowLeft.frame    = CGRectMake(0.0,               kButtonHeight, kshadowLeftWidth,  kshadowHeight);
		self.shadowMiddle1.frame = CGRectMake(kshadowLeftWidth,  kButtonHeight, middle1Width,      kshadowHeight);
		self.shadowMiddle2.frame = CGRectMake(middle2X,          kButtonHeight, middle2Width,      kshadowHeight);
		self.shadowRight.frame   = CGRectMake(rightX,            kButtonHeight, kshadowRightWidth, kshadowHeight);
		[self addSubview:self.shadowLeft];
		[self addSubview:self.shadowMiddle1];
		[self addSubview:self.shadowMiddle2];
		[self addSubview:self.shadowRight];
		//////////////////////////////


		
		///////////////////////////////
		//buttons
		
		CGFloat x = 0;
		for (NSInteger i = 0; i < buttonsTitle.count; i++) {
			
			UIImageView *cutImageView = nil;
			YCCalloutBarButtonType barButtontype = 0;
			if (buttonsTitle.count == 1) {                    //只有一个
				
				x = 0;
				cutImageView = nil;
				barButtontype = YCCalloutBarButtonTypeSigle;
				
			}else if (i == 0) {                                //左
				
				x = 0;
				cutImageView = nil;
				barButtontype = YCCalloutBarButtonTypeLeft;
			
			}else if (i == buttonsTitle.count -1){             //右边的
			
				x += buttonWidths[i-1] ;
				cutImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCCalloutBarCut.png"]] autorelease];
				barButtontype = YCCalloutBarButtonTypeRight;
			
			}else {                                            //中间的，
				
				x += buttonWidths[i-1] ;
				cutImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCCalloutBarCut.png"]] autorelease];
				barButtontype = YCCalloutBarButtonTypeMiddle;
			
			}
			
			
			CGRect buttonsFrame = CGRectMake(x, 0.0, buttonWidths[i],kButtonHeight);
			NSString *title = [buttonsTitle objectAtIndex:i];
			title = [title isKindOfClass:[NSNull class]]?nil:title;
			UIImage *image = [buttonsImage objectAtIndex:i];
			image = [image isKindOfClass:[NSNull class]]?nil:image;
			YCCalloutBarButton *button = [[[YCCalloutBarButton alloc] initWithFrame:buttonsFrame barButtontype:barButtontype title:title image:image arrowButtonFrame:arrowRectInBar fromSuperView:self] autorelease];
			button.titleLabel.font = kFont;


			
			//消息绑定，目前就支持UIControlEventTouchUpInside
			id target = [targets objectAtIndex:i];
			SEL action ;
			NSValue *actionObj =[actions objectAtIndex:i];
			[actionObj getValue:&action];
			[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
			
			
			//加
			[(NSMutableArray*)self.buttons addObject:button];
			[self addSubview:button];
			[button genArrowButtonWithFrame:arrowRectInBar fromSuperView:self];

			//分隔线
			if (cutImageView) {
				cutImageView.frame = CGRectMake(0.0, 0.0, kCutWidth,kButtonHeight);
				[button addSubview:cutImageView];
			}

		}
		

		free(buttonWidths);
		///////////////////////////////
		
		 
    }
	 
	 
	return self;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[buttons release];
	[arrowView release];
	[shadowLeft release];
	[shadowRight release];
	[shadowMiddle1 release];
	[shadowMiddle2 release];
    [super dealloc];
}


@end
