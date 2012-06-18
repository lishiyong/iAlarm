//
//  IAPerson.h
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <Foundation/Foundation.h>

@class IAAlarm;
@interface IAPerson : NSObject<NSCoding, NSCopying>{
    
    ABRecordID _personId;
    NSString *_personName;
    NSArray *_addressDictionaries;
    NSString *_note;
    UIImage *_image;
    NSArray *_phones; //YCPair value：电话号码。key：label
    
    ABAddressBookRef _addressBook;
    ABRecordRef _ABperson;
}

- (ABRecordID)personId;
- (NSString *)personName;
- (NSDictionary *)addressDictionary;
- (NSArray *)addressDictionaries;
- (NSString *)note;
- (UIImage *)image;
- (void)setImage:(UIImage*)theImage;
- (NSArray *)phones;

- (ABRecordRef)ABPerson;

//不从库里搜索
- (id)initWithPersonId:(ABRecordID)personId personName:(NSString*)personName addressDictionaries:(NSArray*)addressDictionaries note:(NSString*)note image:(UIImage*)image phones:(NSArray*)phones;
- (id)initWithPersonId:(ABRecordID)personId personName:(NSString*)personName addressDictionary:(NSDictionary*)addressDictionary;
- (id)initWithPerson:(ABRecordRef)person;
- (id)initWithAlarm:(IAAlarm*)theAlarm image:(UIImage*)image;

//从库里搜索
- (id)initWithPersonId:(ABRecordID)personId;



@end
