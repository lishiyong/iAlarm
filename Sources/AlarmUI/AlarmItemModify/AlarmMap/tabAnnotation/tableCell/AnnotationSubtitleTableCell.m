//
//  AlarmPostionTableCell.m
//  iAlarm
//
//  Created by li shiyong on 10-12-6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AnnotationSubtitleTableCell.h"
#import "LocalizedString.h"
#import "UIUtility.h"


@implementation AnnotationSubtitleTableCell

@synthesize label;
@synthesize textLabel;
@synthesize textView;

- (id)init{
	if ((self = [super init])) {
        // Initialization code
		self.label.text = KLabelAlarmPostion;
    }
	return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[self.label release];
	[self.textLabel release];
    [super dealloc];
}

+(id)tableCellWithXib
{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AnnotationSubtitleTableCell" owner:self options:nil];
	id cell =nil;
	for (id oneObject in nib){
		if ([oneObject isKindOfClass:[AnnotationSubtitleTableCell class]]){
			cell = (AnnotationSubtitleTableCell *)oneObject;
			((AnnotationSubtitleTableCell *)cell).selectionStyle = UITableViewCellSelectionStyleNone;
			((AnnotationSubtitleTableCell *)cell).label.text = KLabelAlarmMapInfo;  //address
			((AnnotationSubtitleTableCell *)cell).label.font = [UIFont systemFontOfSize:14];
			((AnnotationSubtitleTableCell *)cell).label.textColor = [UIUtility defaultCellDetailTextColor];
			((AnnotationSubtitleTableCell *)cell).textLabel.font = [UIFont boldSystemFontOfSize:15];
			((AnnotationSubtitleTableCell *)cell).textView.font = [UIFont boldSystemFontOfSize:15];
		}
			
			
	}
	return cell;
}



@end
