//
//  IABookmarkManager.m
//  iAlarm
//
//  Created by li shiyong on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "YCSearchBar.h"
#import "YCSearchDisplayController.h"
#import "YCSearchController.h"
#import "YCTabToolbarController.h"
#import "IARecentAddressViewController.h"
#import "IABookmarkManager.h"

@implementation IABookmarkManager

@synthesize currentViewController = _currentViewController, searchController = _searchController;

/*
- (id)initWithCurrentViewController:(UIViewController*)currentViewController{
    self = [super init];
    if (self) {
        _currentViewController = [currentViewController retain];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}
 */

- (void)presentBookmarViewController{
    
    if (!_peoplePicker) {
        _peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        _peoplePicker.peoplePickerDelegate = self;	
        NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonAddressProperty], 
                                   nil];
        _peoplePicker.displayedProperties = displayedItems;
        _peoplePicker.title = @"联系人";
    }
    
    [_peoplePicker.viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop){
        obj.navigationItem.prompt = @"选择联系人显示在地图上";
    }];
    
    if (!_recentAddressNav) {
        IARecentAddressViewController *recentAddressVC = [[[IARecentAddressViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        recentAddressVC.delegate = self;
        recentAddressVC.navigationItem.prompt = @"选择最近搜索";
        _recentAddressNav = [[UINavigationController alloc] initWithRootViewController:recentAddressVC];
        _recentAddressNav.title = @"最近搜索";
        
    }
    
    
    if (!_tabToolbarController) {
        _tabToolbarController = [[YCTabToolbarController alloc] initWithNibName:nil bundle:nil];
        _tabToolbarController.viewControllers = [NSArray arrayWithObjects:_peoplePicker,_recentAddressNav, nil];
    }
    
    
    if ([self.currentViewController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [self.currentViewController presentViewController:_tabToolbarController animated:YES completion:NULL];
    }else{
        [self.currentViewController presentModalViewController:_tabToolbarController animated:YES];
    }
    
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    //联系人的姓名    
    NSString *personName = nil;
    personName =  (__bridge_transfer NSString*)ABRecordCopyCompositeName(person);
    [personName autorelease];
    personName = [personName stringByTrim];
    personName = (personName != nil) ? personName : @"";
    
    //联系人的地址
    NSDictionary *addressDic = nil;
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonAddressProperty);
    CFIndex count = ABMultiValueGetCount(multi);
    if (count > 0) {
        addressDic = (__bridge_transfer NSDictionary*)ABMultiValueCopyValueAtIndex(multi, 0);
        [addressDic autorelease];        
    }
    CFRelease(multi);
    
    if (addressDic) {
        
        //做搜索状
        NSString *searchString = ABCreateStringWithAddressDictionary(addressDic,NO);
        self.searchController.searchDisplayController.searchBar.text = searchString;
        
        [self.searchController setActive:YES animated:NO];
        [self.searchController setSearchWaiting:YES];
                    
        
        //关闭本视图控制器
        if ([self.currentViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
            [self.currentViewController dismissViewControllerAnimated:YES completion:NULL];
        }else{
            [self.currentViewController dismissModalViewControllerAnimated:YES];
        }
        
        [self performBlock:^{
            if ([self.searchController.delegate respondsToSelector:@selector(searchController:addressDictionary:addressTitle:)]) {
                [self.searchController.delegate searchController:self.searchController addressDictionary:addressDic addressTitle:personName];
            }
        } afterDelay:0.1];
        
         
        
    }else{
        //打开联系人编辑
        ABPersonViewController *picker = [[[ABPersonViewController alloc] init] autorelease];
        picker.personViewDelegate = self;
        picker.displayedPerson = person;
        // Allow users to edit the person’s information
        picker.allowsEditing = YES;
        picker.navigationItem.prompt = @"选择联系人显示在地图上";
        NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonAddressProperty], 
                                   nil];
        picker.displayedProperties = displayedItems;
        [peoplePicker pushViewController:picker animated:YES]; 
    }
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    if ([self.currentViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.currentViewController dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [self.currentViewController dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue{
    return YES;
}

#pragma mark - IARecentAddressViewControllerDelegate

- (void)recentAddressPickerNavigationControllerDidCancel:(IARecentAddressViewController *)recentAddressPicker{
    if ([self.currentViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.currentViewController dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [self.currentViewController dismissModalViewControllerAnimated:YES];
    }
}

- (BOOL)recentAddressPickerNavigationController:(IARecentAddressViewController *)recentAddressPicker shouldContinueAfterSelectingPerson:(YCPlacemark*)placemark{
    
    if ([self.currentViewController respondsToSelector:@selector(resetAnnotationWithPlacemark:)]) {
        [self.currentViewController performSelector:@selector(resetAnnotationWithPlacemark:) withObject:placemark];
    }
    
    if ([self.currentViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.currentViewController dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [self.currentViewController dismissModalViewControllerAnimated:YES];
    }
    
    return NO;
}

- (BOOL)recentAddressPickerNavigationController:(IARecentAddressViewController *)recentAddressPicker shouldContinueAfterSelectingRecentAddressData:(NSDictionary*)anRecentAddressData{
    
    NSString *key = [[anRecentAddressData allKeys] objectAtIndex:0]; //查询串或人名
    id value = [[anRecentAddressData allValues] objectAtIndex:0]; //查询结果，字符串或dic
    
    //做搜索状
    NSString *searchString = nil;
    if ([value isKindOfClass: [NSString class]]) 
        searchString = key;
    else
        searchString = ABCreateStringWithAddressDictionary(value,NO);
    self.searchController.searchDisplayController.searchBar.text = searchString;
    [self.searchController setActive:YES animated:NO];
    [self.searchController setSearchWaiting:YES];
    
    //关闭本视图控制器
    if ([self.currentViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.currentViewController dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [self.currentViewController dismissModalViewControllerAnimated:YES];
    }
    
    if ([value isKindOfClass: [NSString class]]) {
        
        [self performBlock:^{
            if ([self.searchController.delegate respondsToSelector:@selector(searchController:searchString:)]) {
                [self.searchController.delegate searchController:self.searchController searchString:key];
            }
        } afterDelay:0.1];
        
    }else{
        [self performBlock:^{
            if ([self.searchController.delegate respondsToSelector:@selector(searchController:addressDictionary:addressTitle:)]) {
                [self.searchController.delegate searchController:self.searchController addressDictionary:value addressTitle:key];
            }
        } afterDelay:0.1];
    }
    
    return NO;
}

@end
