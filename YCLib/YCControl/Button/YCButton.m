//
//  YCButton.m
//  iAlarm
//
//  Created by li shiyong on 11-2-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCButton.h"


@implementation YCButton
@synthesize identifier;
@synthesize typeButton;



+ (id)buttonWithType:(UIButtonType)buttonType{
	UIButton *s = [UIButton buttonWithType:buttonType];
	YCButton *t = [[[YCButton alloc] initWithFrame:s.frame] autorelease];
	t.backgroundColor = [UIColor clearColor];
	t.typeButton = s;
	
	[t addSubview:t.typeButton];
	return t;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
	if (self.typeButton) {
		[self.typeButton addTarget:target action:action forControlEvents:controlEvents];
	}else {
		[super addTarget:target action:action forControlEvents:controlEvents];
	}
}

- (NSArray *)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent{
	NSArray *array = nil;
	if (self.typeButton) {
		array = [self.typeButton actionsForTarget:target forControlEvent:controlEvent];
	}else {
		array = [super actionsForTarget:target forControlEvent:controlEvent];
	}
	return array;
}

- (void)dealloc 
{
	[identifier release];
	[super dealloc];
}

@end
