//
//  BoolCell.h
//  iAlarm
//
//  Created by li shiyong on 10-12-21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BoolCell : UITableViewCell {
	UISwitch *switchCtl;
}

@property(nonatomic,retain,readonly) UISwitch *switchCtl;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
