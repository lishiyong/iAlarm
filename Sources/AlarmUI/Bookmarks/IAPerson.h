//
//  IAPerson.h
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <Foundation/Foundation.h>

@interface IAPerson : NSObject<NSCoding, NSCopying>{
    ABRecordID _personId;
    NSString *_personName;
    NSArray *_addressDictionaries;
}


- (ABRecordID)personId;
- (NSString *)personName;
- (NSDictionary *)addressDictionary;
- (NSArray *)addressDictionaries;

- (id)initWithPersonId:(ABRecordID)personId personName:(NSString*)personName addressDictionaries:(NSArray*)addressDictionaries;
- (id)initWithPersonId:(ABRecordID)personId personName:(NSString*)personName addressDictionary:(NSDictionary*)addressDictionary;
- (id)initWithPersonId:(ABRecordID)personId;
- (id)initWithPerson:(ABRecordRef)person;

@end
