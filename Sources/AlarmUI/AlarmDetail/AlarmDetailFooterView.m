//
//  AlarmDetailFootView.m
//  iAlarm
//
//  Created by li shiyong on 11-4-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AlarmDetailFooterView.h"


@implementation AlarmDetailFooterView
@synthesize waitingAIView;
@synthesize distanceLabel;
@synthesize promptLabel;

+(id)viewWithXib 
{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AlarmDetailFooterView" owner:self options:nil];
	AlarmDetailFooterView *view =nil;
	for (id oneObject in nib){
		if ([oneObject isKindOfClass:[AlarmDetailFooterView class]]){
			view = (AlarmDetailFooterView *)oneObject;
		}
	}
	
	return view; 
}


- (void)dealloc
{
    [waitingAIView release];
    [distanceLabel release];
    [promptLabel release];
    [super dealloc];
}

@end
