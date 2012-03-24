//
//  AlarmsListCell.h
//  iAlarm
//
//  Created by li shiyong on 11-1-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>


@interface PeoplesLabelCell : UITableViewCell {
	
    IBOutlet UILabel *sendToLabel;
	IBOutlet UILabel *moreLabel;
	
	IBOutlet UIView *view0;
	IBOutlet UIImageView *imageView0;
	IBOutlet UILabel *label0;
	
	IBOutlet UIView *view1;
	IBOutlet UIImageView *imageView1;
	IBOutlet UILabel *label1;
	
	IBOutlet UIView *view2;
	IBOutlet UIImageView *imageView2;
	IBOutlet UILabel *label2;
	
	
 
}

@property(nonatomic,retain) IBOutlet UILabel *sendToLabel;
@property(nonatomic,retain) IBOutlet UILabel *moreLabel;

@property(nonatomic,retain) IBOutlet UIView *view0;
@property(nonatomic,retain) IBOutlet UIImageView *imageView0;
@property(nonatomic,retain) IBOutlet UILabel *label0;

@property(nonatomic,retain) IBOutlet UIView *view1;
@property(nonatomic,retain) IBOutlet UIImageView *imageView1;
@property(nonatomic,retain) IBOutlet UILabel *label1;

@property(nonatomic,retain) IBOutlet UIView *view2;
@property(nonatomic,retain) IBOutlet UIImageView *imageView2;
@property(nonatomic,retain) IBOutlet UILabel *label2;




+(id)viewWithXib;

@end
