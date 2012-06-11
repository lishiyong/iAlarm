//
//  IAContactManager.m
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "YCLib.h"
#import "IAPerson.h"
#import "IAAlarm.h"
#import "LocalizedString.h"
#import "IAContactManager.h"

@implementation IAContactManager
@synthesize currentViewController = _currentViewController; 

- (void)presentContactViewControllerWithAlarm:(IAAlarm*)theAlarm{

    IAPerson *thePerson = nil;
    ABRecordID thePersonId = theAlarm.personId;
    if (kABRecordInvalidID != thePersonId )
        thePerson = [[[IAPerson alloc] initWithPersonId:thePersonId] autorelease];
    
    NSDictionary *theAddressDic = theAlarm.placemark.addressDictionary;
    
    NSUInteger idxAlarmDic = NSNotFound;
    if (theAddressDic) {
        idxAlarmDic = [thePerson.addressDictionaries indexOfObjectPassingTest:^BOOL(NSDictionary *aDic, NSUInteger idx, BOOL *stop) {
            if ([aDic isEqualToDictionary:theAddressDic]){
                *stop = YES;
                return YES;
            }
            return NO;
        }];
    }
    
    //还未关联联系人
    if (!thePerson || kABRecordInvalidID == thePerson.personId || idxAlarmDic == NSNotFound) {
        
        CFErrorRef anError0 = NULL;
        CFErrorRef anError1 = NULL;
        
        ABRecordRef aContact = ABPersonCreate();
        ABMutableMultiValueRef address = ABMultiValueCreateMutable(kABDictionaryPropertyType);
        
        bool didAdd = true;
        if (theAddressDic) 
            didAdd = ABMultiValueAddValueAndLabel(address,theAddressDic, NULL, NULL);
        
        if (didAdd) 
            ABRecordSetValue(aContact, kABPersonAddressProperty, address, &anError0);
        
        
        
        NSString *coordinateString = YCLocalizedStringFromCLLocationCoordinate2DUsingSeparater(theAlarm.visualCoordinate,kCoordinateFrmStringNorthLatitudeSpace,kCoordinateFrmStringSouthLatitudeSpace,kCoordinateFrmStringEastLongitudeSpace,kCoordinateFrmStringWestLongitudeSpace,@"\n");
        
        
        CFStringRef cfsCoordinateString = CFStringCreateWithCString(NULL,[coordinateString UTF8String],kCFStringEncodingUTF8);
        ABRecordSetValue(aContact, kABPersonNoteProperty, cfsCoordinateString, &anError1);
        
        
        if (anError0 == NULL && anError1 == NULL)
        {
            ABUnknownPersonViewController *picker = [[[ABUnknownPersonViewController alloc] init] autorelease];
            picker.unknownPersonViewDelegate = self;
            picker.displayedPerson = aContact;
            picker.allowsAddingToAddressBook = YES;
            picker.allowsActions = NO;
            picker.alternateName = theAlarm.positionTitle;
            picker.title = @"简介";
            //picker.message = @"distance from curreent location:1800 km";
            
            
            UINavigationController *navc = [[[UINavigationController alloc] initWithRootViewController:picker] autorelease];
            
            if ([_currentViewController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
                [_currentViewController presentViewController:navc animated:YES completion:NULL];
            }else{
                [_currentViewController presentModalViewController:navc animated:YES];
            }
        }
        
        
        CFRelease(cfsCoordinateString);
        CFRelease(address);
        CFRelease(aContact);
    }
}

@end
