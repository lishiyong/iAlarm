//
//  IAPerson.h
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <Foundation/Foundation.h>

@class IAAlarm;
@interface IAPerson : NSObject<NSCoding, NSCopying>{
    
    ABRecordID _personId;
    NSString *_personName;
    NSString *_organization;
    NSArray *_addressDictionaries;
    NSString *_note;
    UIImage *_image;
    NSArray *_phones; //YCPair value：电话号码。key：label
    
    ABAddressBookRef _addressBook;
    ABRecordRef _ABperson;
}

- (ABRecordID)personId;
- (void)setPersonId:(ABRecordID)personId;
- (NSString *)personName;
- (NSString *)organization;
- (NSDictionary *)addressDictionary;
- (NSArray *)addressDictionaries;

- (NSString *)note;
- (void)setNote:(NSString*)note;
- (void)setNoteWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (UIImage *)image;
- (NSArray *)phones;
- (ABRecordRef)ABPerson;




//不从库里搜索
- (id)initWithPersonId:(ABRecordID)personId personName:(NSString*)personName organization:(NSString*)organization addressDictionaries:(NSArray*)addressDictionaries note:(NSString*)note image:(UIImage*)image phones:(NSArray*)phones;
- (id)initWithPersonId:(ABRecordID)personId organization:(NSString*)organization addressDictionary:(NSDictionary*)addressDictionary;
- (id)initWithAlarm:(IAAlarm*)theAlarm image:(UIImage*)image;

//不从库里搜索，而且不retain ABRecordRef
- (id)initWithPerson:(ABRecordRef)person; 


//从库里搜索，保存搜索到的ABRecordRef
- (id)initWithPersonId:(ABRecordID)personId;
- (void)closeAddressBook;

//仅仅能保存从 initWithPersonId: 创建的
- (void)saveAddressBook;

//同时修改ABPreson
- (void)setOrganization:(NSString*)organization;
- (void)setOrganizationWithAlarmIdentifier:(NSString*)organization; //带前后标识
- (void)addAddressDictionary:(NSDictionary*)dic;//添加一个地址
- (void)setAddressDictionaries:(NSArray*)theDics;
- (void)replaceAddressDictionaryAtIndex:(NSUInteger)index withAddressDictionary:(NSDictionary*)dic;
- (void)setImage:(UIImage*)theImage;

//修改ABPreson，为显示做准备。如果没有ABPreson，创建一个
- (void)prepareForDisplay:(IAAlarm*)alarm image:(UIImage*)image;
- (void)prepareForUnknownPersonDisplay:(IAAlarm*)alarm image:(UIImage*)image;

//公司名称是否通过alarm添加的
- (BOOL)hasAlarmIdentifierInOrganization;

//指定的地址在地址组中的索引位置。没找到返回 NSNotfound
- (NSUInteger)indexOfAddressDictionary:(NSDictionary*)theAddressDictionary;



@end
