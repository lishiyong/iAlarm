//
//  IAContactManager.h
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <Foundation/Foundation.h>

@class IAAlarm, IAPerson;
@interface IAContactManager : NSObject<ABUnknownPersonViewControllerDelegate, ABPersonViewControllerDelegate>{
    IAAlarm *_alarm; //不能用于多线程和并发
    UIBarButtonItem *_cancelButtonItem;
    BOOL _isPush;
}

@property (nonatomic, assign) IBOutlet UIViewController *currentViewController; //相当于delegate,要用assign

- (void)presentContactViewControllerWithAlarm:(IAAlarm*)theAlarm newPerson:(IAPerson*)newPerson;
- (void)pushContactViewControllerWithAlarm:(IAAlarm*)theAlarm newPerson:(IAPerson*)newPerson;

@end
