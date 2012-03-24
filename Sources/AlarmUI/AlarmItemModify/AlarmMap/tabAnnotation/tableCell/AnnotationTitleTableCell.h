//
//  AlarmNameTableCell.h
//  iAlarm
//
//  Created by li shiyong on 10-12-6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAnnotationTitleTableCellHeight 66;
@interface AnnotationTitleTableCell : UITableViewCell {
	
	IBOutlet UIImageView *imageView;
	//UIImage *image;
	IBOutlet UILabel *textLabel;
	

}

@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,retain) IBOutlet UILabel *textLabel;




+(id)tableCellWithXib;

@end
