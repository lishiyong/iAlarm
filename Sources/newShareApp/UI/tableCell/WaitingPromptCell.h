//
//  WaitingCell.h
//  iAlarm
//
//  Created by li shiyong on 11-8-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WaitingPromptCell : UITableViewCell {
	UIActivityIndicatorView *activityIndicatorView;
}

@property(nonatomic, retain, readonly) UIActivityIndicatorView *activityIndicatorView;


@end
