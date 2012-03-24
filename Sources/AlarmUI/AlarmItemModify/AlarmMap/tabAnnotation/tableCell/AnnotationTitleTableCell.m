//
//  AlarmNameTableCell.m
//  iAlarm
//
//  Created by li shiyong on 10-12-6.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AnnotationTitleTableCell.h"


@implementation AnnotationTitleTableCell
@synthesize imageView;
//@synthesize image;
@synthesize textLabel;

-(void)setImage:(UIImage *)theImage
{
	self.imageView.image = theImage;
}

-(id)image
{
	return self.imageView.image;
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
	[self.imageView release];
	[self.textLabel release];
    [super dealloc];
}


+(id)tableCellWithXib
{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AnnotationTitleTableCell" owner:self options:nil];
	id cell =nil;
	for (id oneObject in nib){
		if ([oneObject isKindOfClass:[AnnotationTitleTableCell class]]){
			cell = (AnnotationTitleTableCell *)oneObject;
			((AnnotationTitleTableCell *)cell).selectionStyle = UITableViewCellSelectionStyleNone;
			((AnnotationTitleTableCell *)cell).textLabel.font = [UIFont boldSystemFontOfSize:18];
		}
	}
	return cell;
}


@end
