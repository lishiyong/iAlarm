//
//  IADestinationCell.h
//  iAlarm
//
//  Created by li shiyong on 11-9-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IADestinationCell : UITableViewCell {
	UIImageView *pinImageView;
	UIImageView *locatingImageView;
	UILabel *titleLabel;
	UILabel *locatingLabel;
	UILabel *addressLabel;
	UILabel *distanceLabel;
	UIActivityIndicatorView *distanceActivityIndicatorView;
    
    UIImageView *moveArrowImageView;
    BOOL moving;
}

@property (nonatomic, retain) IBOutlet UIImageView *pinImageView;
@property (nonatomic, retain) IBOutlet UIImageView *locatingImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *locatingLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *distanceActivityIndicatorView;

@property (nonatomic, retain) IBOutlet UIImageView *moveArrowImageView;


- (void)setWaiting:(BOOL)waiting andWaitText:(NSString*)waitText;
- (void)setDistanceWaiting:(BOOL)waiting andDistanceText:(NSString*)distanceTextText;
- (void)setAddressLabelWithLarge:(BOOL)large;
- (void)setMoveArrow:(BOOL)moving;

+(id)viewWithXib;


@end
