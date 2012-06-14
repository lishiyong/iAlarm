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
- (NSString *)note{
    return _note;
}
- (UIImage *)image{
    return _image;
}

- (id)initWithPersonId:(ABRecordID)personId personName:(NSString*)personName addressDictionaries:(NSArray*)addressDictionaries note:(NSString*)note image:(UIImage*)image{
    self = [super init];
    if (self) {
        _personId = personId;
        _personName = [personName copy];
        _addressDictionaries = [addressDictionaries retain];
        _note = [note copy];
        _image = [image retain];
    }
    return self;
}

- (id)initWithPersonId:(ABRecordID)personId personName:(NSString*)personName addressDictionary:(NSDictionary*)addressDictionary{
    
    NSArray *dics = nil;
    if (addressDictionary) 
        dics = [NSArray arrayWithObject:addressDictionary];
    
    return [self initWithPersonId:personId personName:personName addressDictionaries:dics note:nil image:nil];
}


- (id)initWithPersonId:(ABRecordID)personId{
    if (kABRecordInvalidID == personId) {
        return nil;
    }
    
    //先查询到联系人
    _addressBook = ABAddressBookCreate();
    ABRecordRef thePerson = ABAddressBookGetPersonWithRecordID(_addressBook,personId);
    self = [self initWithPerson:thePerson];
    return self;
}

- (id)initWithPerson:(ABRecordRef)thePerson{
    
    ABRecordID thePersonId = kABRecordInvalidID;
    NSString *thePersonName = nil;
    NSMutableArray *theDics = [NSMutableArray array];
    NSString *theNote = nil;
    UIImage *theImage = nil;
    if (thePerson != NULL) {
        
        _ABperson = CFRetain(thePerson);
        
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
        
        
        //备注
        theNote =  (__bridge_transfer NSString*)ABRecordCopyValue(thePerson, kABPersonNoteProperty);
        [theNote autorelease];
        
        //image
        CFDataRef dataRef = ABPersonCopyImageData(thePerson);
        if (dataRef) {
            theImage = [UIImage imageWithData:(NSData *)dataRef];
            CFRelease(dataRef);
        }
        
        return [self initWithPersonId:thePersonId personName:thePersonName addressDictionaries:(theDics.count > 0) ? theDics : nil note:theNote image:theImage];
        
        
    }else{
        return nil;
    }
    
}

- (id)initWithAlarm:(IAAlarm*)theAlarm image:(UIImage*)image{
    
    //id
    ABRecordID thePersonId = theAlarm.personId;
    
    //地址
    NSDictionary *theAddressDic = theAlarm.placemark.addressDictionary; 
    NSArray *theAddressArray = theAddressDic ? [NSArray arrayWithObject:theAddressDic] : nil;
    
    //备注
    NSString *coordinateString = nil;                                   
    CLLocationCoordinate2D coor = theAlarm.visualCoordinate;
    if (CLLocationCoordinate2DIsValid(coor)) {
        coordinateString = YCLocalizedStringFromCLLocationCoordinate2DUsingSeparater(coor,kCoordinateFrmStringNorthLatitudeSpace,kCoordinateFrmStringSouthLatitudeSpace,kCoordinateFrmStringEastLongitudeSpace,kCoordinateFrmStringWestLongitudeSpace,@"\n");
    }
    //姓名
    NSString *name = theAlarm.alarmName ? theAlarm.alarmName : theAlarm.positionTitle;
    
    
    self = [self initWithPersonId:thePersonId personName:name addressDictionaries:theAddressArray note:coordinateString image:image];
    return self;
}

- (ABRecordRef)ABPerson{
    
    //通过personId创建的
    if (_ABperson) 
        return _ABperson;
    
    //通过alarm创建的

    ABRecordRef aContact = ABPersonCreate();
    [(NSObject*)aContact autorelease];
    
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
            [newAddressDic removeObjectsForKeys:[keySet allObjects]];
            
            
            bool didAdd1 = false;
            if (newAddressDic.count > 0) 
                didAdd1 = ABMultiValueAddValueAndLabel(address,newAddressDic, NULL, NULL);
            
             
            //加成功一个就可以进行下面的 ABRecordSetValue 了
            if (!didAdd) 
                didAdd = didAdd1;
        }
        
        if (didAdd) 
            ABRecordSetValue(aContact, kABPersonAddressProperty, address, NULL);
        
        CFRelease(address);
    }
     
    //备注
    if (_note) {
        ABRecordSetValue(aContact, kABPersonNoteProperty, (__bridge_transfer CFStringRef)_note, NULL);
    }
    
    //姓名
    if (_personName) {
        /*
        ABPropertyID nameProperty;
        if (ABPersonGetCompositeNameFormat() == kABPersonCompositeNameFormatFirstNameFirst)
            nameProperty = kABPersonFirstNameProperty;
        else
            nameProperty = kABPersonLastNameProperty;
            
        ABRecordSetValue(aContact, nameProperty, (__bridge_transfer CFStringRef)_personName, NULL);
         */
        ABRecordSetValue(aContact, kABPersonOrganizationProperty, (__bridge_transfer CFStringRef)_personName, NULL);
    }
    
    //图
    if (_image) {
        NSData *imageData = UIImagePNGRepresentation(_image);
        ABPersonSetImageData(aContact,(CFDataRef)imageData,NULL);
    }
    
    return aContact;
}

- (void)dealloc{
    [_personName release];
    [_addressDictionaries release];
    [_note release];
    [_image release];
    
    if (_ABperson) 
        CFRelease(_ABperson);
    if (_addressBook) 
        CFRelease(_addressBook);
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
#define kIANote                  @"kIANote"
#define kIAImage                 @"kIAImage"

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeInt32:_personId forKey:kIAPersonId];
    [encoder encodeObject:_personName forKey:kIAPersonName];
    [encoder encodeObject:_addressDictionaries forKey:kIAAddressDictionaries];
    [encoder encodeObject:_note forKey:kIANote];
    [encoder encodeObject:_image forKey:kIAImage];
}

- (id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if (self) {
        _personId = [decoder decodeInt32ForKey:kIAPersonId];
        _personName = [[decoder decodeObjectForKey:kIAPersonName] copy];
        _addressDictionaries = [[decoder decodeObjectForKey:kIAAddressDictionaries] retain];
        _note = [[decoder decodeObjectForKey:kIANote] copy];
        _image = [[decoder decodeObjectForKey:kIAImage] retain];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    IAPerson *copy = [[[self class] allocWithZone: zone] initWithPersonId:self.personId personName:self.personName addressDictionaries:self.addressDictionaries note:self.note image:self.image];    
    return copy;
}


@end
