//
//  YCMaskView.h
//  iAlarm
//
//  Created by li shiyong on 11-3-25.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YCMaskView : UIView {
	UIAlertView *alertView;
	UIActivityIndicatorView *acView;
}

- (void)setHidden:(BOOL)theHidden;

@end
