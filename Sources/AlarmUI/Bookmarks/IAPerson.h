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
- (void)setPersonName:(NSString*)personName;
- (NSDictionary *)addressDictionary;
- (NSArray *)addressDictionaries;
- (void)setAddressDictionaries:(NSArray*)theDics;
- (NSString *)note;
- (void)setNote:(NSString*)note;
- (UIImage *)image;
- (void)setImage:(UIImage*)theImage;
- (NSArray *)phones;
- (ABRecordRef)ABPerson;

//添加一个地址
- (void)addAddressDictionary:(NSDictionary*)dic;
//替换
- (void)replaceAddressDictionaryAtIndex:(NSUInteger)index withAddressDictionary:(NSDictionary*)dic;

//不从库里搜索
- (id)initWithPersonId:(ABRecordID)personId personName:(NSString*)personName addressDictionaries:(NSArray*)addressDictionaries note:(NSString*)note image:(UIImage*)image phones:(NSArray*)phones;
- (id)initWithPersonId:(ABRecordID)personId personName:(NSString*)personName addressDictionary:(NSDictionary*)addressDictionary;
- (id)initWithAlarm:(IAAlarm*)theAlarm image:(UIImage*)image;

//不从库里搜索，而且不保存ABRecordRef
- (id)initWithPerson:(ABRecordRef)person; 


//从库里搜索，保存搜索到的ABRecordRef
- (id)initWithPersonId:(ABRecordID)personId;
//仅仅能保存从 initWithPersonId: 创建的
- (void)addressBookSave;



@end
