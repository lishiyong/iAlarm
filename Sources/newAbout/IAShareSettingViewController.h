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
    
    NSMutableArray *_sections;
    UITableViewCell *_facebookCell;  //facebook
    UITableViewCell *_twitterCell;   //twitter
    UITableViewCell *_kxCell;        //开心网
    
    UITableViewCell *_defaultSkinCell;
    UITableViewCell *_silverSkinCell;
    
}

- (id)initWithStyle:(UITableViewStyle)style shareAppEngine:(YCShareAppEngine *)theShareAppEngine;

@end
