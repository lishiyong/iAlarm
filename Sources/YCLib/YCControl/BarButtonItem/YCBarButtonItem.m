//
//  YCBarItem.m
//  iAlarm
//
//  Created by li shiyong on 11-1-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCBarButtonItem.h"


@implementation YCBarButtonItem

@synthesize frame;
@synthesize normalImage;
@synthesize highlightedImage;
@synthesize styleDoneImage;

-(void)setFrame:(CGRect)theFrame{
	frame = theFrame;
	self.customView.frame = theFrame;
	self.width = theFrame.size.width;
}

-(void)setNormalImage:(UIImage*)newObj{
	[newObj retain];
	[normalImage release];
	normalImage = newObj;
	
	[self.barButton setBackgroundImage:newObj forState:UIControlStateNormal];
}

-(void)setHighlightedImage:(UIImage*)newObj{
	[newObj retain];
	[highlightedImage release];
	highlightedImage = newObj;
	
	[self.barButton  setBackgroundImage:newObj forState:UIControlStateHighlighted];
}

-(void)setStyleDoneImage:(UIImage*)newObj{
	[newObj retain];
	[styleDoneImage release];
	styleDoneImage = newObj;
}

-(id)barButton{
	if (!barButton) {
		barButton = [[UIButton alloc] initWithFrame:self.frame];
	}
	return barButton;
}


//覆盖超类
-(id) customView{
	
	if (!super.customView) {
		super.customView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
		[super.customView addSubview:self.barButton];
		//事件绑定
		[self.barButton addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside ];
	}
	 
	
	return super.customView;
}

//覆盖超类
-(void)setStyle:(UIBarButtonItemStyle)style{
	//[super setStyle:style];

	
	switch (style) {
		case UIBarButtonItemStyleDone:
			[self.barButton setBackgroundImage:self.styleDoneImage forState:UIControlStateNormal];
			break;
		case UIBarButtonItemStyleBordered:
		case UIBarButtonItemStylePlain:
			[self.barButton setBackgroundImage:self.normalImage forState:UIControlStateNormal];
			break;
		default:
			[self.barButton setBackgroundImage:self.normalImage forState:UIControlStateNormal];
			break;
	}
	 
}


//覆盖超类,@property(nonatomic, assign) id target
-(void)setTarget:(id)newObj{
	super.target = newObj;
	//事件绑定
	[self.barButton addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside ];
}

//覆盖超类,@property(nonatomic) SEL action
-(void)setAction:(SEL)newVal{
	super.action = newVal;
	//事件绑定
	[self.barButton addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside ];
}
 



-(id)initWithFrame:(CGRect)theFrame{
	return [self initWithFrame:theFrame normalImage:nil highlightedImage:nil styleDoneImage:nil];
}
 

-(id)initWithCustomView:(UIView *)customView{
	return [self initWithFrame:customView.frame normalImage:nil highlightedImage:nil styleDoneImage:nil];
}

-(id)initWithFrame:(CGRect)theFrame normalImage:(UIImage*)theImage highlightedImage:(UIImage*)theHighlightedImage styleDoneImage:(UIImage*)theStyleDoneImage {
	frame = theFrame;
	if (self = [super initWithCustomView:self.customView]) {
		normalImage = [theImage retain];
		highlightedImage = [theHighlightedImage retain];
		styleDoneImage = [theStyleDoneImage retain];
	}
	return self;
}

 

- (void)dealloc {
	[normalImage release];
	[highlightedImage release];
	[styleDoneImage release];
	[barButton release];
    [super dealloc];
}


@end
