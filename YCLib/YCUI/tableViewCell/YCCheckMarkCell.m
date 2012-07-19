//
//  YCCheckMarkCell.m
//  iAlarm
//
//  Created by li shiyong on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+YC.h"
#import "YCCheckMarkCell.h"

@implementation YCCheckMarkCell
@synthesize checkmark = _checkmark, changeWhenSelected = _changeWhenSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier checkMarkType:(YCCheckMarkType)checkMarkType;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _changeWhenSelected = YES;
        _checkMarkType = checkMarkType;
        
        if (_checkMarkType == YCCheckMarkTypeLeft) {
            UIImage *blueCheck = [UIImage imageNamed:@"YCPreferencesBlueCheck.png"];
            UIImage *whiteCheck = [UIImage imageNamed:@"YCPreferencesWhiteCheck.png"];
            self.imageView.image = blueCheck;
            self.imageView.highlightedImage = whiteCheck;
            self.imageView.alpha = 0.0; //缺省不选中
            self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            [self addObserver:self forKeyPath:@"textLabel.frame" options:0 context:nil];
            [self addObserver:self forKeyPath:@"detailTextLabel.frame" options:0 context:nil];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected && _changeWhenSelected) 
        self.checkmark = !self.checkmark;
}

- (void)setCheckmark:(BOOL)checkmark{
    _checkmark = checkmark;
    if (_checkmark) {
        if (_checkMarkType == YCCheckMarkTypeRight) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            self.imageView.alpha = 1.0;
            self.detailTextLabel.textColor = [UIColor tableCellBlueTextYCColor];//选中，详细文本蓝色
        }
    }else {
        if (_checkMarkType == YCCheckMarkTypeRight) {
            self.accessoryType = UITableViewCellAccessoryNone;
        }else {
            self.imageView.alpha = 0.0;
            self.detailTextLabel.textColor = [UIColor tableCellGrayTextYCColor];//不选中，详细文本灰色
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    //解决textLabel,detailTextLabel离对号过远的问题
    if ([keyPath isEqualToString:@"textLabel.frame"] && self.textLabel.frame.origin.x > 9) {
        self.textLabel.center = (CGPoint){self.textLabel.center.x - 5, self.textLabel.center.y};
    }
    if ([keyPath isEqualToString:@"detailTextLabel.frame"] && self.detailTextLabel.frame.origin.x > 9) {
        self.detailTextLabel.center = (CGPoint){self.detailTextLabel.center.x - 5, self.detailTextLabel.center.y};
    }
}


- (void)dealloc{
    if (_checkMarkType == YCCheckMarkTypeLeft) {
        [self removeObserver:self forKeyPath:@"textLabel.frame"];
        [self removeObserver:self forKeyPath:@"detailTextLabel.frame"];
    }
    [super dealloc];
}


@end
