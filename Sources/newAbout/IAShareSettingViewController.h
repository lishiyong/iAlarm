//
//  IAShareSettingViewController.h
//  iAlarm
//
//  Created by li shiyong on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCShareAppEngine;
@class TableViewCellDescription;
@interface IAShareSettingViewController : UITableViewController{
    YCShareAppEngine *shareAppEngine;

    NSArray *cellDescriptions;
    TableViewCellDescription *facebookCellDescription;                 //facebook
	TableViewCellDescription *twitterCellDescription;                  //twitter
    TableViewCellDescription *kxCellDescription;                       //开心网
}

@property(nonatomic,retain) NSArray *cellDescriptions;   
@property(nonatomic,retain) TableViewCellDescription *facebookCellDescription;
@property(nonatomic,retain) TableViewCellDescription *twitterCellDescription;
@property(nonatomic,retain) TableViewCellDescription *kxCellDescription;

- (id)initWithStyle:(UITableViewStyle)style shareAppEngine:(YCShareAppEngine *)theShareAppEngine;

@end
