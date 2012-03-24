//
//  CheckmarkDisclosureIndicatorCell.m
//  iArrived
//
//  Created by li shiyong on 10-10-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIUtility.h"
#import "CheckmarkDisclosureIndicatorCell.h"


@implementation CheckmarkDisclosureIndicatorCell

@synthesize defaultImage;
@synthesize checkedImage;

-(id)subCheckmarkCell
{
	if(subCheckmarkCell == nil)
	{
		subCheckmarkCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		subCheckmarkCell.frame = CGRectMake(0.0, 0.0, 290, 44);
		//subCheckmarkCell.accessoryType = UITableViewCellAccessoryCheckmark;
		//subCheckmarkCell.backgroundColor = [UIColor brownColor];
	}
	
	return subCheckmarkCell;
}




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// >
		super.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[self insertSubview:self.subCheckmarkCell belowSubview:self.contentView];
    }
    return self;
}


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier checkmark:(BOOL)isCheckmark{
	
	if ((self = [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier])) {
		// √
		if (isCheckmark) {
			self.subCheckmarkCell.accessoryType = UITableViewCellAccessoryCheckmark;	
		}
    }
    return self;	
}


-(void) setAccessoryType:(UITableViewCellAccessoryType)accType
{
	if (UITableViewCellAccessoryCheckmark == accType) {
		self.textLabel.textColor = [UIUtility checkedCellTextColor];
		self.imageView.image = self.checkedImage;
	}
	else {
		self.textLabel.textColor = [UIUtility defaultCellTextColor];
		self.imageView.image = self.defaultImage;
	}

	
	self.subCheckmarkCell.accessoryType = accType;
}
 

-(void) setChechmark:(BOOL)isCheckmark
{
	/*
	if (isCheckmark) 
		[self insertSubview:self.subCheckmarkCell belowSubview:self.contentView];	
	else 
		[self.subCheckmarkCell removeFromSuperview];
	 */
	
	if (isCheckmark) 
		[self setAccessoryType:UITableViewCellAccessoryCheckmark];
	else 
		[self setAccessoryType:UITableViewCellAccessoryNone];
}

- (void)dealloc {
	[subCheckmarkCell release];
    [super dealloc];
}



@end
