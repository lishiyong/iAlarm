//
//  AlarmsListCell.m
//  iAlarm
//
//  Created by li shiyong on 11-1-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import "PeoplesLabelCell.h"


@implementation PeoplesLabelCell

@synthesize sendToLabel;
@synthesize moreLabel;

@synthesize view0;
@synthesize imageView0;
@synthesize label0;

@synthesize view1;
@synthesize imageView1;
@synthesize label1;

@synthesize view2;
@synthesize imageView2;
@synthesize label2;


+(id)viewWithXib 
{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PeoplesLabelCell" owner:self options:nil];
	PeoplesLabelCell *cell =nil;
	for (id oneObject in nib){
		if ([oneObject isKindOfClass:[PeoplesLabelCell class]]){
			cell = (PeoplesLabelCell *)oneObject;
		}
	}
        
	return cell; 
}


- (void)dealloc {
	[sendToLabel release];	
    [super dealloc];
}


@end
