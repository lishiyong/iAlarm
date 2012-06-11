//
//  IAContactManager.h
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IAAlarm;
@interface IAContactManager : NSObject

@property (nonatomic, assign) IBOutlet UIViewController *currentViewController; //相当于delegate,要用assign

- (void)presentContactViewControllerWithAlarm:(IAAlarm*)theAlarm;

@end
