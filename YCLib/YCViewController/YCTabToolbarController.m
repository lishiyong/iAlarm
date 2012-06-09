//
//  IABookmarkController.m
//  TestABController
//
//  Created by li shiyong on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSObject+YC.h"
#import "YCDouble.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "IARecentAddressViewController.h"
#import "YCTabToolbarController.h"

@interface YCTabToolbarController (private)
@end

@implementation YCTabToolbarController

@synthesize viewControllers = _viewControllers;
@synthesize segmentedControl = _segmentedControl, toolbar = _toolbar, containerView = _containerView;

- (void)_changeViewForIndex:(NSUInteger)index{
    UIViewController *vcSelected = (UIViewController*)[self.viewControllers objectAtIndex:index];
    UIView *viewSelected = vcSelected.view;
    
    CGRect oldFrame = viewSelected.frame;
    viewSelected.frame = (CGRect){{0.0, 0.0},{oldFrame.size.width,self.view.frame.size.height - 44.0}};//减掉toolbar的高度
    
    [_currentView removeFromSuperview];
    [_currentView release];
    [self.containerView addSubview:viewSelected];
    _currentView = [viewSelected retain]; 
    
    //防止不同sdk的版本的不同。5.0不用下面代码其实也可以
    [self performBlock:^{
        
        if ([vcSelected isKindOfClass:[UINavigationController class]]) 
        {
            CGFloat viewSelectedY = [(UINavigationController*)vcSelected navigationBar].frame.origin.y;
            //navigationBar y轴不是在0开始的
            if (YCCompareDouble(viewSelectedY, 0.0) == NSOrderedDescending) {
                CGRect oldFrame1 = viewSelected.frame;
                viewSelected.frame = (CGRect){{0.0, -viewSelectedY},oldFrame1.size};
            }
        }
        
    } afterDelay:0.0];
    
      
    
    
    
    /*
    NSLog(@"view0 = %@ %@",NSStringFromClass([viewSelected class]),viewSelected);
    [viewSelected.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"UILayoutContainerView's subview = %@ %@",NSStringFromClass([obj class]),obj);
    }];
    
    UIView *transitionView = [viewSelected.subviews objectAtIndex:0];
    [[transitionView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"UINavigationTransitionView's subview = %@ %@",NSStringFromClass([obj class]),obj);
    }];
    
    if (transitionView.subviews.count > 0) {
        UIView *controllerWrapperView = [[transitionView subviews] objectAtIndex:0];
        [[controllerWrapperView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"UIViewControllerWrapperView's subview = %@ %@",NSStringFromClass([obj class]),obj);
        }];
    }
     */
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *segmentedItem = [[[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl] autorelease];
    UIBarButtonItem *spaceItemLeft = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease];
    UIBarButtonItem *spaceItemRight = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease];
    self.toolbar.items = [NSArray arrayWithObjects:spaceItemLeft,segmentedItem,spaceItemRight,nil];
    
    [self _changeViewForIndex:0];
    
    for (NSUInteger i = 0; i < self.viewControllers.count;i++) {
        UIViewController *vc = [self.viewControllers objectAtIndex:i];
        [self.segmentedControl setTitle:vc.title forSegmentAtIndex:i];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.toolbar = nil;
    self.segmentedControl = nil;
    self.containerView = nil;
    [_currentView release]; _currentView = nil;
}


- (IBAction)segmentAction:(id)sender
{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;    
    [self _changeViewForIndex:segmentedControl.selectedSegmentIndex];
}


@end
