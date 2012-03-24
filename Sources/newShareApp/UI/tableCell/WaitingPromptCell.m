//
//  WaitingCell.m
//  iAlarm
//
//  Created by li shiyong on 11-8-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WaitingPromptCell.h"


@implementation WaitingPromptCell

- (id)activityIndicatorView{
	if (activityIndicatorView == nil) {
		activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicatorView.hidesWhenStopped = YES;
	}
	return activityIndicatorView;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.accessoryView = self.activityIndicatorView;
		
		self.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
		self.textLabel.textColor = [UIColor grayColor];
		self.textLabel.textAlignment = UITextAlignmentCenter;
    }
    return self;
}



- (void)dealloc {
	[activityIndicatorView release];
    [super dealloc];
}


@end
