//
//  IABookmarkManager.m
//  iAlarm
//
//  Created by li shiyong on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "IAPerson.h"
#import "YCSearchBar.h"
#import "YCSearchDisplayController.h"
#import "YCSearchController.h"
#import "YCTabToolbarController.h"
#import "IARecentAddressViewController.h"
#import "IABookmarkManager.h"

@implementation IABookmarkManager

@synthesize currentViewController = _currentViewController, searchController = _searchController;


- (void)presentBookmarViewController{
    
    if (!_peoplePicker) {
        _peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        _peoplePicker.peoplePickerDelegate = self;	
        NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonAddressProperty], 
                                   nil];
        _peoplePicker.displayedProperties = displayedItems;
        _peoplePicker.title = @"通讯录";
    }
    
    [_peoplePicker.viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop){
        obj.navigationItem.prompt = @"选取联系人显示在地图上";
    }];
    
    if (!_recentAddressNav) {
        IARecentAddressViewController *recentAddressVC = [[[IARecentAddressViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        recentAddressVC.delegate = self;
        recentAddressVC.navigationItem.prompt = @"选取最近的搜索";
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

- (void)_searchWithAddressDictionary:(NSDictionary *)addressDictionary personName:(NSString *)personName personId:(ABRecordID)personId{
    
    //做搜索状
    NSString *searchString = ABCreateStringWithAddressDictionary(addressDictionary,NO);
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
        
        if ([self.searchController.delegate respondsToSelector:@selector(searchController:addressDictionary:personName:personId:)]) {
            
            [self.searchController.delegate searchController:self.searchController addressDictionary:addressDictionary personName:personName personId:personId];
            
        }
        
    } afterDelay:0.1];
    
}

- (void)_searchWithSearchString:(NSString*)searchString{
    
    //做搜索状
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
        if ([self.searchController.delegate respondsToSelector:@selector(searchController:searchString:)]) {
            [self.searchController.delegate searchController:self.searchController searchString:searchString];
        }
    } afterDelay:0.1];
    
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    IAPerson *theIAPerson = [[[IAPerson alloc] initWithPerson:person] autorelease];
    if (theIAPerson.addressDictionaries.count == 1) {
        
        //联系人的姓名
        NSString *personName =  theIAPerson.personName;
        personName = [personName stringByTrim];
        personName = (personName != nil) ? personName : @"";
        
        //联系人的地址
        NSDictionary *addressDic = [theIAPerson.addressDictionaries objectAtIndex:0];
        [self _searchWithAddressDictionary:addressDic personName:personName personId:theIAPerson.personId];
        
        
    }else { //count == 0 或 count > 1
        
        //打开联系人编辑
        ABPersonViewController *picker = [[[ABPersonViewController alloc] init] autorelease];
        picker.personViewDelegate = self;
        picker.displayedPerson = person;
        // Allow users to edit the person’s information
        picker.allowsEditing = YES;
        picker.navigationItem.prompt = @"选取联系人显示在地图上";
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
    
    if (kABPersonAddressProperty == property && kABMultiValueInvalidIdentifier != identifierForValue){
        
        IAPerson *theIAPerson = [[[IAPerson alloc] initWithPerson:person] autorelease];
        if (theIAPerson.addressDictionaries.count > identifierForValue) {
            //联系人的姓名
            NSString *personName =  theIAPerson.personName;
            personName = [personName stringByTrim];
            personName = (personName != nil) ? personName : @"";
            
            //联系人的地址
            NSDictionary *addressDic = [theIAPerson.addressDictionaries objectAtIndex:identifierForValue];
            [self _searchWithAddressDictionary:addressDic personName:personName personId:theIAPerson.personId];
        }
    }
    
    return NO;
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

- (BOOL)recentAddressPickerNavigationController:(IARecentAddressViewController *)recentAddressPicker shouldContinueAfterSelectingRecentAddressData:(YCPair*)anRecentAddressData{
    
    NSString *key = anRecentAddressData.key; //查询串或人名
    id value = anRecentAddressData.value;    //查询结果，字符串或IAPerson
    
    if ([value isKindOfClass: [NSString class]]) {
        
        [self _searchWithSearchString:key];
        
    }else if ([value isKindOfClass:[IAPerson class]]){
        
        IAPerson *aPerson = (IAPerson*)value;
        [self _searchWithAddressDictionary:aPerson.addressDictionary personName:aPerson.personName personId:aPerson.personId];
        
    }
    
    return NO;
}

@end
