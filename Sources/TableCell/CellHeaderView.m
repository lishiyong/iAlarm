//
//  CellHearderView.m
//  iAlarm
//
//  Created by li shiyong on 10-12-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CellHeaderView.h"


@implementation CellHeaderView

@synthesize textLabel;

+(id)viewWithXib
{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellHeaderView" owner:self options:nil];
	id cell =nil;
	for (id oneObject in nib){
		if ([oneObject isKindOfClass:[CellHeaderView class]]){
			cell = (CellHeaderView *)oneObject;
		}
	}
	return cell;
}

- (void)dealloc {
	[textLabel release];
    [super dealloc];
}

@end
