//
//  TableViewCellDescription.h
//  iAlarm
//
//  Created by li shiyong on 10-12-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableViewCellDescription : NSObject {
	
	UITableViewCell *tableViewCell;
	
	SEL didSelectCellSelector;             //选中cell所在行，执行的函数
	NSObject *didSelectCellObject;         //选中cell所在行，执行的函数的参数，一般是viewController
	
	SEL accessoryButtonTappedSelector;     //tap cell的按钮，执行的函数
	NSObject *accessoryButtonTappedObject; //tap cell的按钮，执行的函数的参数，一般是viewController
	

}

@property(nonatomic,retain) UITableViewCell *tableViewCell;  
@property(nonatomic,assign) SEL didSelectCellSelector;
@property(nonatomic,retain) NSObject *didSelectCellObject;
@property(nonatomic,assign) SEL accessoryButtonTappedSelector;
@property(nonatomic,retain) NSObject *accessoryButtonTappedObject;

@end
