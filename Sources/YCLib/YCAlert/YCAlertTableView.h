//
//  YCAlertViewWithTableView.h
//  TestAlertView
//
//  Created by li shiyong on 11-1-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YCShadowTableView;
@class YCAlertTableView;

@protocol YCAlertTableViewDelegete <UIAlertViewDelegate>

- (void)alertTableView:(YCAlertTableView *)alertTableView didSelectRow:(NSInteger)row;

@end


@interface YCAlertTableView : UIAlertView <UITableViewDelegate,UITableViewDataSource>{
	YCShadowTableView *tableView;
	NSArray *tableCellContents; 
}

@property(nonatomic,retain) YCShadowTableView *tableView;
@property(nonatomic,retain) NSArray *tableCellContents; 


- (id)  initWithTitle:(NSString *)title 
		     delegate:(id /*<YCSearchControllerDelegete>*/)delegate
	  tableCellContents:(NSArray*)theTableCellContents
    cancelButtonTitle:(NSString *)cancelButtonTitle;

@end
