//
//  IABookmarkManager.m
//  iAlarm
//
//  Created by li shiyong on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IAParam.h"
#import "LocalizedString.h"
#import "YCLib.h"
#import "IAPerson.h"
#import "YCSearchDisplayController.h"
#import "searchDisplayManager.h"
#import "IARecentAddressViewController.h"
#import "IABookmarkManager.h"

@interface IABookmarkManager (private)

//把状态栏改程序需要的
- (void)modifyStatusBar;

@end

@implementation IABookmarkManager

- (void)modifyStatusBar{
    UIStatusBarStyle style = (IASkinTypeDefault == [IAParam sharedParam].skinType) ? UIStatusBarStyleDefault : UIStatusBarStyleBlackOpaque;
    if (style != [UIApplication sharedApplication].statusBarStyle)
        [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
}

@synthesize currentViewController = _currentViewController, searchDisplayManager = _searchDisplayManager;

- (void)cancelButtonItemPressed:(id)sender{
    //ABPersonViewController 控制器的取消按钮。点击后，回到地图界面。
    if ([_currentViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [_currentViewController dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [_currentViewController dismissModalViewControllerAnimated:YES];
    }
    
    //把状态栏改程序需要的
    [self modifyStatusBar];
}


- (void)presentBookmarViewController{
    
    //设置ABPeoplePickerNavigationController
    if (!_peoplePicker) {
        _peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        _peoplePicker.peoplePickerDelegate = self;	
        NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonAddressProperty], 
                                   nil];
        _peoplePicker.displayedProperties = displayedItems;
        _peoplePicker.title = KBMTitleContacts;
        _peoplePicker.delegate = self;
    }
    
    //设置最近“搜索控制器”
    if (!_recentAddressNav) {
        IARecentAddressViewController *recentAddressVC = [[[IARecentAddressViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        recentAddressVC.delegate = self;
        recentAddressVC.navigationItem.prompt = KBMTitlePromptRecents;
        _recentAddressNav = [[UINavigationController alloc] initWithRootViewController:recentAddressVC];
        _recentAddressNav.title = KBMTitleBMRecents;
        
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
    
    //把状态栏改成银色的
    if (UIStatusBarStyleDefault != [UIApplication sharedApplication].statusBarStyle)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)_searchWithAddressDictionary:(NSDictionary *)addressDictionary personName:(NSString *)personName personId:(ABRecordID)personId{
    
    //做搜索状
    NSString *searchString = ABCreateStringWithAddressDictionary(addressDictionary,NO);
    self.searchDisplayManager.searchDisplayController.searchBar.text = searchString;
    [self.searchDisplayManager.searchDisplayController setActive:YES animated:NO];
    [self.searchDisplayManager.searchDisplayController.searchBar setShowsSearchingView:YES];
    
    
    //关闭本视图控制器
    if ([self.currentViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.currentViewController dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [self.currentViewController dismissModalViewControllerAnimated:YES];
    }
    
    [self performBlock:^{
        
        if ([self.searchDisplayManager.delegate respondsToSelector:@selector(searchWithaddressDictionary:personName:personId:)]) {
            [self.searchDisplayManager.searchDisplayController hidesSearchResultsTableViewWithAnimated:YES]; //搜索时候，把tableView去掉
            [self.searchDisplayManager.delegate searchWithaddressDictionary:addressDictionary personName:personName personId:personId];
        }
        
    } afterDelay:0.1];
    
}

- (void)_searchWithSearchString:(NSString*)searchString{
    
    //做搜索状
    self.searchDisplayManager.searchDisplayController.searchBar.text = searchString;
    [self.searchDisplayManager.searchDisplayController setActive:YES animated:NO];
    [self.searchDisplayManager.searchDisplayController.searchBar setShowsSearchingView:YES];
    
    //关闭本视图控制器
    if ([self.currentViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self.currentViewController dismissViewControllerAnimated:YES completion:NULL];
    }else{
        [self.currentViewController dismissModalViewControllerAnimated:YES];
    }
    
    [self performBlock:^{
        if ([self.searchDisplayManager.delegate respondsToSelector:@selector(searchWithString:)]) {
            [self.searchDisplayManager.searchDisplayController hidesSearchResultsTableViewWithAnimated:YES]; //搜索时候，把tableView去掉
            [self.searchDisplayManager.delegate searchWithString:searchString];
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
        ABPersonViewController *personVC = [[[ABPersonViewController alloc] init] autorelease];
        personVC.personViewDelegate = self;
        personVC.displayedPerson = person;
        personVC.allowsEditing = NO; //允许编辑会把“取消”按钮冲掉
        //personVC.navigationItem.prompt = @"选取联系人显示在地图上";
        NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonAddressProperty], 
                                   nil];
        personVC.displayedProperties = displayedItems;
        
        [peoplePicker pushViewController:personVC animated:YES]; 
        /*
        UIBarButtonItem *cancelButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonItemPressed:)] autorelease];
        personVC.navigationItem.rightBarButtonItem = cancelButtonItem; //必须在push后设置才有效
         */
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
    //把状态栏改程序需要的
    [self modifyStatusBar];
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
    //把状态栏改程序需要的
    [self modifyStatusBar];
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
    
    NSString *key = (NSString*)anRecentAddressData.key; //查询串或人名
    id value = anRecentAddressData.value;    //查询结果，字符串或IAPerson
    
    if ([value isKindOfClass: [NSString class]]) {
        
        [self _searchWithSearchString:key];
        
    }else if ([value isKindOfClass:[IAPerson class]]){
        
        IAPerson *aPerson = (IAPerson*)value;
        [self _searchWithAddressDictionary:aPerson.addressDictionary personName:aPerson.personName personId:aPerson.personId];
        
    }
    
    return NO;
}

#pragma mark -  UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //ABPeoplePickerNavigationController是个nav控制器，把它包含的子视图都设置上
    if (navigationController == _peoplePicker) {
        viewController.navigationItem.prompt = KBMTitlePromptContacts;
        
        UIBarButtonItem *cancelButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonItemPressed:)] autorelease];
        viewController.navigationItem.rightBarButtonItem = cancelButtonItem;
        
        //把状态栏改成银色的
        if (UIStatusBarStyleDefault != [UIApplication sharedApplication].statusBarStyle)
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }else {
        //把状态栏改回去
        UIStatusBarStyle style = (IASkinTypeDefault == [IAParam sharedParam].skinType) ? UIStatusBarStyleDefault : UIStatusBarStyleBlackOpaque;
        if (style != [UIApplication sharedApplication].statusBarStyle)
            [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
    }
}

@end
