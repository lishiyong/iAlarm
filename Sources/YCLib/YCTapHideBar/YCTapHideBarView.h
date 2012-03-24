//
//  YCMapView.h
//  TestSearchBar
//
//  Created by li shiyong on 10-12-2.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKMapView;
@interface YCTapHideBarView :UIView <UIGestureRecognizerDelegate>
{
	IBOutlet MKMapView *mapView;
	
	IBOutlet UIToolbar *toolbar;
	IBOutlet UISearchBar *searchBar;
	
	BOOL canHideToolBar;
	BOOL canHideSearchBar;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL canHideToolBar;
@property (nonatomic, assign) BOOL canHideSearchBar;

//开始隐藏倒计时 - toolbar
-(void)startHideToolbarAfterTimeInterval:(NSTimeInterval)TimeInterval;
//重置隐藏倒计时 - toolbar
-(void)resetTimeIntervalForHideToolbar:(NSTimeInterval)TimeInterval;
//停止隐藏 - toolbar
-(void)stopHideToolbar;


//开始隐藏倒计时 - SearchBar
-(void)startHideSearchBarAfterTimeInterval:(NSTimeInterval)TimeInterval;
//重置隐藏倒计时 - SearchBar
-(void)resetTimeIntervalForHideSearchBar:(NSTimeInterval)TimeInterval;

//停止隐藏 - SearchBar
-(void)stopHideSearchBar;
 



@end

