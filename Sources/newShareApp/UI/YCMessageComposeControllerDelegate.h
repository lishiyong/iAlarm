/*
 *  YCMessageComposeControllerDelegate.h
 *  iAlarm
 *
 *  Created by li shiyong on 11-8-12.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#import "NSObject-YC.h"
#import <UIKit/UIKit.h>

@protocol YCObject;
@protocol YCMessageComposeControllerDelegate<YCObject> 

@optional

- (void)messageComposeYCViewController:(UIViewController *)controller didFinishWithResult:(BOOL)result;

@end