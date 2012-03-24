//
//  YCTableView.h
//  TestAlertView
//
//  Created by li shiyong on 11-1-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface YCShadowTableView : UITableView {
	UIImageView *topShadowView;
	UIImageView *bottomShadowView;
	UIImageView *leftShadowView;
	UIImageView *rightShadowView;
}

@property(nonatomic,retain) UIImageView *topShadowView;
@property(nonatomic,retain) UIImageView *bottomShadowView;
@property(nonatomic,retain) UIImageView *leftShadowView;
@property(nonatomic,retain) UIImageView *rightShadowView;

@end
