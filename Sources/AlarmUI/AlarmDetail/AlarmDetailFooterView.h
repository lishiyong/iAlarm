//
//  AlarmDetailFootView.h
//  iAlarm
//
//  Created by li shiyong on 11-4-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlarmDetailFooterView : UIView {
    UIActivityIndicatorView *waitingAIView;
    UILabel *distanceLabel;
    UILabel *promptLabel;
}

@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *waitingAIView;
@property(nonatomic,retain) IBOutlet UILabel *distanceLabel;
@property(nonatomic,retain) IBOutlet UILabel *promptLabel;

+(id)viewWithXib;

@end
