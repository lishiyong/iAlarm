//
//  IAContactManager.m
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "YCLib.h"
#import "IAPerson.h"
#import "IAAlarm.h"
#import "LocalizedString.h"
#import "IAContactManager.h"

@interface IAContactManager (private) 

- (UIBarButtonItem*)_cancelButtonItem;

- (ABUnknownPersonViewController*)_unknownPersonViewControllerWithIAPerson:(IAPerson*)thePerson;
- (ABPersonViewController*)_personViewControllerWithIAPerson:(IAPerson*)thePerson;
- (ABPersonViewController*)_personViewControllerWithABPerson:(ABRecordRef)thePerson;

/**
 根据contactPerson和newPerson来来判断是ABUnknownPersonViewController还是ABPersonViewController。
 并判断多地址索引l
 **/
- (UIViewController*)_viewControllerWithContactIAPerson:(IAPerson*)contactPerson newIAPerson:(IAPerson*)newPerson;

@end

@implementation IAContactManager
@synthesize currentViewController = _currentViewController; 

- (id)_cancelButtonItem{
    if (!_cancelButtonItem) {
        _cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonItemPressed:)];
    }
    return _cancelButtonItem;
}

- (ABUnknownPersonViewController*)_unknownPersonViewControllerWithIAPerson:(IAPerson*)thePerson{
    
    BOOL isAllowsAddingToAddressBook = (thePerson.addressDictionaries.count >0);
    
    ABUnknownPersonViewController *picker = [[[ABUnknownPersonViewController alloc] init] autorelease];
    picker.unknownPersonViewDelegate = self;
    picker.displayedPerson = thePerson.ABPerson;
    picker.allowsAddingToAddressBook = isAllowsAddingToAddressBook;
    picker.alternateName = thePerson.personName;
    if (_isPush) 
        picker.title = KLabelAlarmPostion;
    else
        picker.title = @"简介";
    
    return picker;
}

- (ABPersonViewController*)_personViewControllerWithABPerson:(ABRecordRef)thePerson{
    ABPersonViewController *picker = [[[ABPersonViewController alloc] init] autorelease];
    picker.personViewDelegate = self;
    picker.displayedPerson = thePerson;
    picker.allowsEditing = YES; //不能让编辑。编辑状态会把关闭按钮给冲掉的。//但没有编辑，高亮不好用
    if (_isPush) 
        picker.title = KLabelAlarmPostion;
    else
        picker.title = @"简介";
    
    NSArray *displayedItems = [NSArray arrayWithObjects:
                               [NSNumber numberWithInt:kABPersonPhoneProperty]
                               ,[NSNumber numberWithInt:kABPersonAddressProperty]
                               ,[NSNumber numberWithInt:kABPersonNoteProperty]
                               ,nil];
    picker.displayedProperties = displayedItems;
    
    
    return picker;
}

- (UIViewController*)_viewControllerWithContactIAPerson:(IAPerson*)contactPerson newIAPerson:(IAPerson*)newPerson{
    UIViewController *picker;
    NSUInteger newPersonDicIndex = 0;
    if (contactPerson) {
        
        //找到闹钟地址在通信录中地址的索引位置
        NSDictionary *newPersonDic = newPerson.addressDictionary;
        if (newPersonDic){
            //dic -> string
            NSString *newAddress = [ABCreateStringWithAddressDictionary(newPersonDic,NO) stringByTrim];
            newAddress = [newAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
            newAddress = [newAddress stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            newPersonDicIndex = [contactPerson.addressDictionaries indexOfObjectPassingTest:^BOOL(NSDictionary *aDic, NSUInteger idx, BOOL *stop) {
                
                //dic -> string
                NSString *anAddress = [ABCreateStringWithAddressDictionary(aDic,NO) stringByTrim];
                anAddress = [anAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
                anAddress = [anAddress stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                if ([anAddress isEqualToString:newAddress]){
                    *stop = YES;
                    return YES;
                }
                return NO;
            }];
        }
        
        if (NSNotFound == newPersonDicIndex) { //没找到 == 还没加到通信录中呢
            newPersonDicIndex = 0;
            picker = [self _unknownPersonViewControllerWithIAPerson:newPerson];
        }else{
            picker = [self _personViewControllerWithIAPerson:contactPerson];
        }
        
    }else{//还没加到通信录中呢
        newPersonDicIndex = 0;
        picker = [self _unknownPersonViewControllerWithIAPerson:newPerson];
    }
    
    //高亮闹钟地址
    if ([picker respondsToSelector:@selector(setHighlightedItemForProperty:withIdentifier:)]) {
        [(ABPersonViewController*)picker setHighlightedItemForProperty:kABPersonAddressProperty withIdentifier:newPersonDicIndex];
    }
    
    return picker;
}

- (ABPersonViewController*)_personViewControllerWithIAPerson:(IAPerson*)thePerson{
    return [self _personViewControllerWithABPerson:thePerson.ABPerson];
}

- (void)dealloc{
    [_alarm release];
    [_cancelButtonItem release];
    [super dealloc];
}

- (void)cancelButtonItemPressed:(id)sender{
    
    if ([_currentViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [_currentViewController dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [_currentViewController dismissModalViewControllerAnimated:YES];
    }
}


- (void)presentContactViewControllerWithAlarm:(IAAlarm*)theAlarm newPerson:(IAPerson*)newPerson{
    _isPush = NO;
    [_alarm release];
    _alarm = [theAlarm retain];
    
    IAPerson *contactPerson = [[[IAPerson alloc] initWithPersonId:theAlarm.personId] autorelease];
    UIViewController *picker = [self _viewControllerWithContactIAPerson:contactPerson newIAPerson:newPerson];
    
    UINavigationController *navc = [[[UINavigationController alloc] initWithRootViewController:picker] autorelease];    
    if ([_currentViewController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [_currentViewController presentViewController:navc animated:YES completion:NULL];
    }else{
        [_currentViewController presentModalViewController:navc animated:YES];
    }
    
    picker.navigationItem.leftBarButtonItem = [self _cancelButtonItem];
    picker.navigationItem.rightBarButtonItem = nil; //4.x右边也有一个取消按钮
    
}

- (void)pushContactViewControllerWithAlarm:(IAAlarm*)theAlarm newPerson:(IAPerson*)newPerson{
    _isPush = YES;
    [_alarm release];
    _alarm = [theAlarm retain];
    
    IAPerson *contactPerson = [[[IAPerson alloc] initWithPersonId:theAlarm.personId] autorelease];
    UIViewController *picker = [self _viewControllerWithContactIAPerson:contactPerson newIAPerson:newPerson];
    
    [(UINavigationController*)_currentViewController pushViewController:picker animated:YES];
    //picker.navigationItem.rightBarButtonItem = nil; //4.x右边也有一个取消按钮

}


#pragma mark - ABUnknownPersonViewControllerDelegate

- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person{
    if (person) {
        
        ABRecordID thePersonId = kABRecordInvalidID;
        if (person) 
            thePersonId = ABRecordGetRecordID(person);
        
        _alarm.personId = thePersonId;
        if (_isPush) {
            //push的情况，先找到正主，偷着把正主保存了
            IAAlarm *alarmNotTemp = [IAAlarm findForAlarmId:_alarm.alarmId];
            alarmNotTemp.personId = thePersonId;
            [alarmNotTemp save];
        }else{//在主界面上直接保存
            [_alarm save];
        }
        
        if (!_isPush) {
            //先关掉原来的ABUnknownPersonViewController
            if ([_currentViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
                [_currentViewController dismissViewControllerAnimated:NO completion:NULL];
            }else{
                [_currentViewController dismissModalViewControllerAnimated:NO];
            }
        }else{
            [(UINavigationController*) _currentViewController popToRootViewControllerAnimated:NO];
        }
        
        //再打开ABPersonViewController
        IAPerson *contactPerson = [[[IAPerson alloc] initWithPerson:person] autorelease];
        IAPerson *newPerson = [[[IAPerson alloc] initWithAlarm:_alarm image:nil] autorelease];
        UIViewController *picker = [self _viewControllerWithContactIAPerson:contactPerson newIAPerson:newPerson];
        
        if (!_isPush) {
            UINavigationController *navc = [[[UINavigationController alloc] initWithRootViewController:picker] autorelease];    
            if ([_currentViewController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
                [_currentViewController presentViewController:navc animated:NO completion:NULL];
            }else{
                [_currentViewController presentModalViewController:navc animated:NO];
            }
            
            picker.navigationItem.leftBarButtonItem = [self _cancelButtonItem];
            picker.navigationItem.rightBarButtonItem = nil; //4.x右边也有一个取消按钮
        }else{
            [(UINavigationController*) _currentViewController pushViewController:picker animated:NO];
            //picker.navigationItem.rightBarButtonItem = nil; //4.x右边也有一个取消按钮
        }
        
    }
    
}

- (BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
     NSLog(@"unknownPersonViewController shouldPerformDefaultActionForPerson");
    return NO;
}

#pragma mark - ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue{
    NSLog(@"personViewController shouldPerformDefaultActionForPerson");
    return NO;
}

@end
