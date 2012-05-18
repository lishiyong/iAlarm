//
//  ContactsCell.m
//  TestShareApp
//
//  Created by li shiyong on 11-8-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSObject+YC.h"
#import "CheckPeopleCell.h"


@implementation CheckPeopleCell
@synthesize checked;
@synthesize identifier;


- (void)setChecked:(BOOL)b{
	//[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setChecked:) object:nil];
	checked = b;
	if (checked) {
		self.backgroundView.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:240.0/255.0 blue:250.0/255.0 alpha:255.0/255.0];
		self.accessoryViewImageView.image = [UIImage imageNamed:@"checked.png"];
	}else {
		self.backgroundView.backgroundColor = [UIColor whiteColor];
		self.accessoryViewImageView.image = [UIImage imageNamed:@"notchecked.png"];
	}
	self.accessoryView = self.accessoryViewImageView; 
	
	
}

- (id)accessoryViewImageView{
	if (accessoryViewImageView == nil) {
		accessoryViewImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notchecked.png"]];
	}
	return accessoryViewImageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		self.accessoryView = self.accessoryViewImageView;        //定义了accessoryView，accessoryView就会自动出现
		self.selectionStyle = UITableViewCellSelectionStyleNone; //选中时候无颜色变化
		self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
		self.textLabel.backgroundColor = [UIColor clearColor];
		
		UIImageView *picFrame = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"peoplePictureFrame.png"]] autorelease];
		picFrame.center = CGPointMake(35, 35); //因为row高 ＝70
		[self addSubview:picFrame];
    }
    return self;
}




- (void)dealloc {
	[accessoryViewImageView release];
	[identifier release];
    [super dealloc];
}


@end
