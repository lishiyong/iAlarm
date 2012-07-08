//
//  IADestinationCell.h
//  iAlarm
//
//  Created by li shiyong on 11-9-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    IADestinationCellStatusNone = 0,
    IADestinationCellStatusNormal,                           //正常状态     
    IADestinationCellStatusNormalWithoutDistance,            //正常状态,但没有距离
    IADestinationCellStatusNormalWithoutDistanceAndAddress,  //正常状态,但没有距离和地址
	IADestinationCellStatusNormalMeasuringDistance,          //正常状态,正在测量与当前位置的距离   
    IADestinationCellStatusLocating,                         //正在定位状态
    IADestinationCellStatusReversing                         //正在反转地址状态  
};

typedef NSUInteger IADestinationCellStatus;

@class IAAlarm;
@interface IADestinationCell : UITableViewCell {
	UIImageView *locatingImageView;
	UILabel *titleLabel;
	UILabel *locatingLabel;
	UILabel *addressLabel;
	UILabel *distanceLabel;
	UIActivityIndicatorView *distanceActivityIndicatorView;
    
    UIImageView *moveArrowImageView;
    BOOL moving;
    
    
}

@property (nonatomic, retain) IBOutlet UIImageView *locatingImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *locatingLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *distanceActivityIndicatorView;
@property (nonatomic, retain) IBOutlet UIImageView *moveArrowImageView;



+(id)viewWithXib;

@property (nonatomic, retain) IAAlarm *alarm;
@property (nonatomic) IADestinationCellStatus cellStatus;


@end
