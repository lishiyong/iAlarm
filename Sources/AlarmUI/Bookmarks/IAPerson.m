//
//  IAPerson.m
//  iAlarm
//
//  Created by li shiyong on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "LocalizedString.h"
#import "IAAlarm.h"
#import "IAPerson.h"

@implementation IAPerson

- (ABRecordID)personId{
    return _personId;
}

- (void)setPersonId:(ABRecordID)personId{
    _personId = personId;
}

- (NSString *)personName{
    return _personName;
}

- (NSString *)organization{
    //显示得时候把标识符号去掉
    NSString *temp = [_organization stringByReplacingOccurrencesOfString:@"✧" withString:@""];
    return temp;
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

- (NSString *)note{
    return _note;
}

- (UIImage *)image{
    return _image;
}

- (NSArray *)phones{
    return _phones;
}

- (ABRecordRef)ABPerson{
    //_ABperson,使用时候再创建。有别于其他属性
    if (!_ABperson) {
        
        _ABperson = ABPersonCreate();  
        
        //地址
        if (_addressDictionaries) {
            
            ABMutableMultiValueRef address = ABMultiValueCreateMutable(kABDictionaryPropertyType);
            bool didAdd = false;
            for (NSDictionary *anAddressDic in _addressDictionaries) {
                
                //把非字符串的对象过滤掉:Region,Location
                NSSet *keySet = [anAddressDic keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
                    if(![obj isKindOfClass:[NSString class]])
                        return YES;
                    return NO;
                }];
                NSMutableDictionary *newAddressDic = [NSMutableDictionary dictionaryWithDictionary:anAddressDic];
                if ([keySet allObjects].count > 0) 
                    [newAddressDic removeObjectsForKeys:[keySet allObjects]];
                
                
                
                
                bool didAdd1 = false;
                if (newAddressDic.count > 0) 
                    didAdd1 = ABMultiValueAddValueAndLabel(address,newAddressDic, NULL, NULL);
                
                
                //加成功一个就可以进行下面的 ABRecordSetValue 了
                if (!didAdd) 
                    didAdd = didAdd1;
            }
            
            if (didAdd) 
                ABRecordSetValue(_ABperson, kABPersonAddressProperty, address, NULL);
            
            CFRelease(address);
        }
        
        //备注
        if (_note) {
            ABRecordSetValue(_ABperson, kABPersonNoteProperty, (__bridge_transfer CFStringRef)_note, NULL);
        }
        
        /*
        //姓名
        if (_personName) {
            ABRecordSetValue(_ABperson, kABPersonOrganizationProperty, (__bridge_transfer CFStringRef)_personName, NULL);
        }
         */
        
        
        //图
        if (_image) {
            NSData *imageData = UIImagePNGRepresentation(_image);
            ABPersonSetImageData(_ABperson,(CFDataRef)imageData,NULL);
        }
        
        //phones
        if (_phones && _phones.count > 0) {
            
            ABMutableMultiValueRef phones = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            bool didAdd = false;
            for (YCPair *aPhonePair in _phones) {
                
                bool didAdd1 = ABMultiValueAddValueAndLabel(phones,aPhonePair.value, (__bridge_transfer CFStringRef)aPhonePair.key, NULL);;
                
                //加成功一个就可以进行下面的 ABRecordSetValue 了
                if (!didAdd) 
                    didAdd = didAdd1;
            }
            
            if (didAdd) 
                ABRecordSetValue(_ABperson, kABPersonPhoneProperty, phones, NULL);
            
            CFRelease(phones);
        }
        
        //organization
        if (_organization) {
            ABRecordSetValue(_ABperson, kABPersonOrganizationProperty, (__bridge_transfer CFStringRef)self.organization, NULL);
        }
        
    }
    
    return _ABperson;
    
}

- (id)initWithPersonId:(ABRecordID)personId personName:(NSString*)personName organization:(NSString*)organization addressDictionaries:(NSArray*)addressDictionaries note:(NSString*)note image:(UIImage*)image phones:(NSArray*)phones{
    self = [super init];
    if (self) {
        _personId = personId;
        _personName = [personName copy];
        _addressDictionaries = [addressDictionaries retain];
        _note = [note copy];
        _image = [image retain];
        _phones = [phones retain];
        
        NSString *temp = [NSString stringWithFormat:@"✧%@✧",organization]; 
        _organization = [temp retain];

    }
    return self;
}

- (id)initWithPersonId:(ABRecordID)personId organization:(NSString*)organization addressDictionary:(NSDictionary*)addressDictionary{
    
    NSArray *dics = nil;
    if (addressDictionary) 
        dics = [NSArray arrayWithObject:addressDictionary];
    
    return [self initWithPersonId:personId personName:nil organization:organization addressDictionaries:dics note:nil image:nil phones:nil];
}


- (id)initWithPersonId:(ABRecordID)personId{
    if (kABRecordInvalidID == personId) {
        return nil;
    }
    
    //先查询到联系人
    _addressBook = ABAddressBookCreate();
    ABRecordRef thePerson = ABAddressBookGetPersonWithRecordID(_addressBook,personId);
    self = [self initWithPerson:thePerson];
    if (self) {
        if (thePerson) {
            _ABperson = CFRetain(thePerson);
        }
    }
    return self;
}

- (id)initWithPerson:(ABRecordRef)thePerson{
    
    ABRecordID thePersonId = kABRecordInvalidID;
    NSString *thePersonName = nil;
    NSString *theOrganization = nil;
    NSMutableArray *theDics = [NSMutableArray array];
    NSString *theNote = nil;
    UIImage *theImage = nil;
    NSMutableArray *thePhones = [NSMutableArray array];
    
    if (thePerson != NULL) {
        
        //id
        thePersonId = ABRecordGetRecordID(thePerson);
        
        //姓名
        thePersonName =  (__bridge_transfer NSString*)ABRecordCopyCompositeName(thePerson);
        [thePersonName autorelease];
        
        //organization
        theOrganization =  (__bridge_transfer NSString*)ABRecordCopyValue(thePerson, kABPersonOrganizationProperty);
        [theOrganization autorelease];
        
        //地址
        ABMutableMultiValueRef multiAddress = ABRecordCopyValue(thePerson, kABPersonAddressProperty);
        if (multiAddress) {
            CFIndex count = ABMultiValueGetCount(multiAddress);
            for (int i = 0 ; i < count ; i++) {
                NSDictionary *addressDic = nil;
                addressDic = (__bridge_transfer NSDictionary*)ABMultiValueCopyValueAtIndex(multiAddress, i);
                [addressDic autorelease]; 
                [theDics addObject:addressDic];
            }
            CFRelease(multiAddress);
        }
        
        
        //备注
        theNote =  (__bridge_transfer NSString*)ABRecordCopyValue(thePerson, kABPersonNoteProperty);
        [theNote autorelease];
         
        
        //image
        CFDataRef dataRef = ABPersonCopyImageData(thePerson);
        if (dataRef) {
            theImage = [UIImage imageWithData:(NSData *)dataRef];
            CFRelease(dataRef);
        }
        
        //phones
        ABMutableMultiValueRef multiPhones = ABRecordCopyValue(thePerson, kABPersonPhoneProperty);
        if (multiPhones) {
            CFIndex count = ABMultiValueGetCount(multiPhones);
            for (int i = 0 ; i < count ; i++) {
                NSString *phoneNumber = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(multiPhones, i);
                NSString *phoneLabel = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(multiPhones, i);
                if (phoneNumber && phoneLabel) {
                    YCPair *anPhonePair = [[[YCPair alloc] initWithValue:phoneNumber forKey:phoneLabel] autorelease];
                    [thePhones addObject:anPhonePair];
                }
                [phoneNumber release];
                [phoneLabel release];
            }
            CFRelease(multiPhones);
        }
        
        return [self initWithPersonId:thePersonId personName:thePersonName organization:theOrganization addressDictionaries:(theDics.count > 0) ? theDics : nil note:theNote image:theImage phones:thePhones];
        
    }else{
        return nil;
    }
    
}

- (id)initWithAlarm:(IAAlarm*)theAlarm image:(UIImage*)image{
    
    //id
    ABRecordID thePersonId = kABRecordInvalidID;
    if (theAlarm.person) {
        thePersonId = theAlarm.person.personId;
    }
    
    //地址
    NSDictionary *theAddressDic = theAlarm.placemark.addressDictionary; 
    NSArray *theAddressArray = theAddressDic ? [NSArray arrayWithObject:theAddressDic] : nil;
    
    //备注
    NSString *coordinateString = nil;                                   
    CLLocationCoordinate2D coor = theAlarm.visualCoordinate;
    if (CLLocationCoordinate2DIsValid(coor)) {
        coordinateString = YCLocalizedStringFromCLLocationCoordinate2DUsingSeparater(coor,kCoordinateFrmStringNorthLatitudeSpace,kCoordinateFrmStringSouthLatitudeSpace,kCoordinateFrmStringEastLongitudeSpace,kCoordinateFrmStringWestLongitudeSpace,@"\n");
    }
    
    //organization
    NSString *organization = theAlarm.alarmName ? theAlarm.alarmName : theAlarm.positionTitle;
    
    
    self = [self initWithPersonId:thePersonId personName:nil organization:organization addressDictionaries:theAddressArray note:coordinateString image:image phones:nil];
    return self;
}

- (void)closeAddressBook{
    if (_addressBook) {
        CFRelease(_addressBook);
        _addressBook = nil;
    }
}

- (void)saveAddressBook{
    if (_addressBook) 
        ABAddressBookSave(_addressBook,NULL);
}

- (void)setOrganization:(NSString*)organization{
    
    if (_ABperson) {
        if (organization) {
            //前“✧”后“✧”做为标识
            
            BOOL hasPrefix = YES;
            BOOL hasSuffix = YES;
            if (_organization) {
                hasPrefix = [_organization hasPrefix:@"✧"]; // ([_organization rangeOfString:@"✧"].location != NSNotFound);
                hasSuffix = [_organization hasSuffix:@"✧"]; //([_organization rangeOfString:@"✧"].location != NSNotFound);
            }
            
            if (hasPrefix || hasSuffix) {
                NSString *temp = [_organization stringByReplacingOccurrencesOfString:@"✧" withString:@""]; //先去掉，
                temp = [NSString stringWithFormat:@"✧%@✧",organization]; //再添加一次
                ABRecordSetValue(_ABperson, kABPersonOrganizationProperty, (__bridge_transfer CFStringRef)temp, NULL);
            }
            
        }else{
            ABRecordRemoveValue(_ABperson, kABPersonOrganizationProperty, NULL);
        }
    }
    
    [organization retain];
    [_organization release];
    _organization = organization;
}

- (void)setOrganizationForDisplay:(NSString*)organization{
    
    if (_ABperson) {
        if (organization) {
            ABRecordSetValue(_ABperson, kABPersonOrganizationProperty, (__bridge_transfer CFStringRef)organization, NULL);
        }else{
            ABRecordRemoveValue(_ABperson, kABPersonOrganizationProperty, NULL);
        }
    }
    [organization retain];
    [_organization release];
    _organization = organization;
}



- (void)setAddressDictionaries:(NSArray*)theDics{
    [theDics retain];
    [_addressDictionaries release];
    _addressDictionaries = theDics;
    
    if (_ABperson) {
        //先删除
        ABRecordRemoveValue(_ABperson,kABPersonAddressProperty,NULL);
        //再添加
        if (_addressDictionaries && _addressDictionaries.count > 0) {
            
            ABMutableMultiValueRef address = ABMultiValueCreateMutable(kABDictionaryPropertyType);
            bool didAdd = false;
            for (NSDictionary *anAddressDic in _addressDictionaries) {
                
                //把非字符串的对象过滤掉:Region,Location
                NSSet *keySet = [anAddressDic keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
                    if(![obj isKindOfClass:[NSString class]])
                        return YES;
                    return NO;
                }];
                NSMutableDictionary *newAddressDic = [NSMutableDictionary dictionaryWithDictionary:anAddressDic];
                [newAddressDic removeObjectsForKeys:[keySet allObjects]];
                
                
                bool didAdd1 = false;
                if (newAddressDic.count > 0) 
                    didAdd1 = ABMultiValueAddValueAndLabel(address,newAddressDic, NULL, NULL);
                
                
                //加成功一个就可以进行下面的 ABRecordSetValue 了
                if (!didAdd) 
                    didAdd = didAdd1;
            }
            
            if (didAdd) 
                ABRecordSetValue(_ABperson, kABPersonAddressProperty, address, NULL);
            
            CFRelease(address);
        }
    }
}

- (void)replaceAddressDictionaryAtIndex:(NSUInteger)index withAddressDictionary:(NSDictionary*)dic{
    if (!dic || index >= _addressDictionaries.count) 
        return;
    
    //把非字符串的对象过滤掉:Region,Location
    NSSet *keySet = [dic keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        if(![obj isKindOfClass:[NSString class]])
            return YES;
        return NO;
    }];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([keySet allObjects].count > 0) 
        [newDic removeObjectsForKeys:[keySet allObjects]];
    
    //调用本类的setAddressDictionaries:
    if (newDic.count > 0) {
        NSMutableArray *newDics = [NSMutableArray arrayWithArray:_addressDictionaries];
        [newDics replaceObjectAtIndex:index withObject:newDic];
        [self setAddressDictionaries:newDics];
    }
}

- (void)addAddressDictionary:(NSDictionary*)dic{
    if (!dic) 
        return;
    
    //把非字符串的对象过滤掉:Region,Location
    NSSet *keySet = [dic keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        if(![obj isKindOfClass:[NSString class]])
            return YES;
        return NO;
    }];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([keySet allObjects].count > 0) 
        [newDic removeObjectsForKeys:[keySet allObjects]];
    
    //调用本类的setAddressDictionaries:
    if (newDic.count > 0) {
        NSMutableArray *newDics = nil;
        if (_addressDictionaries && _addressDictionaries.count > 0) 
            newDics = [NSMutableArray arrayWithArray:_addressDictionaries];
        else
            newDics = [NSMutableArray array];
        [newDics insertObject:dic atIndex:0];
        [self setAddressDictionaries:newDics];
    }
}

- (void)setImage:(UIImage*)theImage{
    [theImage retain];
    [_image release];
    _image = theImage;
    
    if (_ABperson) {
        if(ABPersonHasImageData(_ABperson)) 
        {
            ABPersonRemoveImageData(_ABperson, NULL);
        }
        if (_image) {
            NSData *imageData = UIImagePNGRepresentation(_image);
            ABPersonSetImageData(_ABperson,(CFDataRef)imageData,NULL);
        }
    }
}

- (void)setNote:(NSString*)note{
    [note retain];
    [_note release];
    _note = note;
    
    if (_ABperson) {
        if (_note) {
            ABRecordSetValue(_ABperson, kABPersonNoteProperty, (__bridge_transfer CFStringRef)_note, NULL);
        }else{
            ABRecordRemoveValue(_ABperson, kABPersonNoteProperty, NULL);
        }
    }
}

- (void)setNoteWithCoordinate:(CLLocationCoordinate2D)coordinate{
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        NSString *coordinateString = YCLocalizedStringFromCLLocationCoordinate2DUsingSeparater(coordinate,kCoordinateFrmStringNorthLatitudeSpace,kCoordinateFrmStringSouthLatitudeSpace,kCoordinateFrmStringEastLongitudeSpace,kCoordinateFrmStringWestLongitudeSpace,@"\n");
        [self setNote:coordinateString];
    }else{
        [self setNote:nil];
    }
}

- (void)prepareForDisplay:(IAAlarm*)alarm image:(UIImage*)image{
    //地址显示一个
    if (alarm.placemark.addressDictionary) {
        self.addressDictionaries = [NSArray arrayWithObject:alarm.placemark.addressDictionary];
    }else{
        self.addressDictionaries = nil;
    }
    
    //照片用抓的图
    [self setImage:image];
    
    //备注显示坐标
    [self setNoteWithCoordinate:alarm.visualCoordinate];
    
    //不显示标识
    [self setOrganizationForDisplay:self.organization];
    
    //防止没有标题
    if (!self.personName && !self.organization) {//如果都没有
        [self setOrganizationForDisplay:alarm.positionTitle];
    }
}

- (void)prepareForUnknownPersonDisplay:(IAAlarm*)alarm image:(UIImage*)image{
    [self ABPerson];//创建ABPreson
    
    //地址显示一个
    if (alarm.placemark.addressDictionary) {
        self.addressDictionaries = [NSArray arrayWithObject:alarm.placemark.addressDictionary];
    }else{
        self.addressDictionaries = nil;
    }
    
    //照片用抓的图
    [self setImage:image];
    
    //备注显示坐标
    [self setNoteWithCoordinate:alarm.visualCoordinate];
    
    [self setOrganization:alarm.placemark.name];
    if (!self.organization) {
        [self setOrganization:alarm.positionTitle];
    }
}

- (BOOL)isAlarmOrganization{
    BOOL hasPrefix = NO;
    BOOL hasSuffix = NO;
    if (_organization) {
        hasPrefix = [_organization hasPrefix:@"✧"]; // ([_organization rangeOfString:@"✧"].location != NSNotFound);
        hasSuffix = [_organization hasSuffix:@"✧"]; //([_organization rangeOfString:@"✧"].location != NSNotFound);
    }
    
    return (hasPrefix || hasSuffix);
}

#pragma mark - Override super

- (void)dealloc{
    [_personName release];
    [_organization release];
    [_addressDictionaries release];
    [_note release];
    [_image release];
    [_phones release];
    
    if (_ABperson) 
        CFRelease(_ABperson);
    if (_addressBook) 
        CFRelease(_addressBook);
    [super dealloc];
}

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
#define kIAOrganization          @"kIAOrganization"
#define kIAAddressDictionaries   @"kIAAddressDictionaries"
#define kIANote                  @"kIANote"
#define kIAImage                 @"kIAImage"
#define kIAPhones                @"kIAPhones"

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInt32:_personId forKey:kIAPersonId];
    [encoder encodeObject:_personName forKey:kIAPersonName];
    [encoder encodeObject:_organization forKey:kIAOrganization];
    [encoder encodeObject:_addressDictionaries forKey:kIAAddressDictionaries];
    [encoder encodeObject:_note forKey:kIANote];
    [encoder encodeObject:_image forKey:kIAImage];
    [encoder encodeObject:_phones forKey:kIAPhones];
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self) {
        _personId = [decoder decodeInt32ForKey:kIAPersonId];
        _personName = [[decoder decodeObjectForKey:kIAPersonName] copy];
        _organization = [[decoder decodeObjectForKey:kIAOrganization] copy];
        _addressDictionaries = [[decoder decodeObjectForKey:kIAAddressDictionaries] retain];
        _note = [[decoder decodeObjectForKey:kIANote] copy];
        _image = [[decoder decodeObjectForKey:kIAImage] retain];
        _phones = [[decoder decodeObjectForKey:kIAPhones] retain];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    IAPerson *copy = [[[self class] allocWithZone: zone] initWithPersonId:self.personId personName:self.personName organization:self.organization addressDictionaries:self.addressDictionaries note:self.note image:self.image phones:self.phones];    
    return copy;
}


@end
