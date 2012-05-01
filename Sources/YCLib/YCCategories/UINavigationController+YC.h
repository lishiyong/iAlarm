//
//  UINavigationController+YC.h
//  iAlarm
//
//  Created by li shiyong on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (YC)

/**
 把SearchBar加到UINavigationController.view中，随着NavigationBar的隐藏或显示，来升降SearchBar。动画运行结束后会把searchBar加回到原来的View上。
 这个函数是为了提升searchBar在View树中的级别。
 **/
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated searchBar:(UISearchBar*)theSearchBar fromSuperView:(UIView*)fromSuperView;

@end
