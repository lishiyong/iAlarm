//
//  AlarmPostionTableCell.h
//  iAlarm
//
//  Created by li shiyong on 10-12-6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAnnotationSubtitleTableCellHeight 80;
@interface AnnotationSubtitleTableCell : UITableViewCell 
{
	IBOutlet UILabel *label;
	IBOutlet UILabel *textLabel;
	IBOutlet UITextView *textView;
}

@property (nonatomic,retain) IBOutlet UILabel *label;
@property (nonatomic,retain) IBOutlet UILabel *textLabel;
@property (nonatomic,retain) IBOutlet UITextView *textView;

+(id)tableCellWithXib;

@end
