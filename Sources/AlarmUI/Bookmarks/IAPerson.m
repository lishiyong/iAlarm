//
//  IAPerson.m
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IAPerson.h"

@implementation IAPerson

- (ABRecordID)personId{
    return _personId;
}
- (NSString *)personName{
    return _personName;
}
- (NSDictionary *)addressDictionary{
    if (_addressDictionaries.count > 0) {
        return [_addressDictionaries objectAtIndex:0];
    }
    return nil;
}
- (NSArray *)addressDictionaries{
    return _addressDictionaries;
}

- (id)initWithPersonId:(ABRecordID)personId personName:(NSString*)personName addressDictionaries:(NSArray*)addressDictionaries{
    self = [super init];
    if (self) {
        _personId = personId;
        _personName = [personName copy];
        _addressDictionaries = [addressDictionaries retain];
    }
    return self;
}

- (id)initWithPersonId:(ABRecordID)personId personName:(NSString*)personName addressDictionary:(NSDictionary*)addressDictionary{
    
    NSArray *dics = nil;
    if (addressDictionary) 
        dics = [NSArray arrayWithObject:addressDictionary];
    
    return [self initWithPersonId:personId personName:personName addressDictionaries:dics];
}

- (id)initWithPerson:(ABRecordRef)thePerson{
    ABRecordID thePersonId = kABRecordInvalidID;
    NSString *thePersonName = nil;
    NSMutableArray *theDics = [NSMutableArray array];
    if (thePerson != NULL) {
        
        //id
        thePersonId = ABRecordGetRecordID(thePerson);
        
        //姓名
        thePersonName =  (__bridge_transfer NSString*)ABRecordCopyCompositeName(thePerson);
        [thePersonName autorelease];
        
        //地址
        ABMutableMultiValueRef multi = ABRecordCopyValue(thePerson, kABPersonAddressProperty);
        CFIndex count = ABMultiValueGetCount(multi);
        for (int i = 0 ; i < count ; i++) {
            NSDictionary *addressDic = nil;
            addressDic = (__bridge_transfer NSDictionary*)ABMultiValueCopyValueAtIndex(multi, i);
            [addressDic autorelease]; 
            [theDics addObject:addressDic];
        }
        CFRelease(multi);
    }
    
    return [self initWithPersonId:thePersonId personName:thePersonName addressDictionaries:(theDics.count > 0) ? theDics : nil];
}
- (id)initWithPersonId:(ABRecordID)personId{
    //先查询到联系人
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordRef thePerson = ABAddressBookGetPersonWithRecordID(addressBook,personId);
    return [self initWithPerson:thePerson];
}

- (void)dealloc{
    [_personName release];
    [_addressDictionaries release];
    [super dealloc];
}

#pragma mark - Override super

- (BOOL)isEqual:(id)object{
    if ([object isKindOfClass: [self class]]) {
        if ([(IAPerson*)object personId] == _personId ) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - NSCoding and NSCopying

#define kIAPersonId              @"kIAPersonId"
#define kIAPersonName            @"kIAPersonName"
#define kIAAddressDictionaries   @"kIAAddressDictionaries"

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInt32:_personId forKey:kIAPersonId];
    [encoder encodeObject:_personName forKey:kIAPersonName];
    [encoder encodeObject:_addressDictionaries forKey:kIAAddressDictionaries];
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self) {
        _personId = [decoder decodeInt32ForKey:kIAPersonId];
        _personName = [[decoder decodeObjectForKey:kIAPersonName] copy];
        _addressDictionaries = [[decoder decodeObjectForKey:kIAAddressDictionaries] retain];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    IAPerson *copy = [[[self class] allocWithZone: zone] initWithPersonId:self.personId personName:self.personName addressDictionaries:self.addressDictionaries];
    return copy;
}


@end
