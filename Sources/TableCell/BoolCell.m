//
//  BoolCell.m
//  iAlarm
//
//  Created by li shiyong on 10-12-21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BoolCell.h"


@implementation BoolCell



- (id) switchCtl{
	
	if (!self->switchCtl) {
	
        /*
		/////////////////////
		////switch控件位置
		CGPoint cellP = self.frame.origin;  //cell原点坐标
		CGSize  cellS = self.frame.size;    //cell的尺寸
		
		UISwitch *switchCtlTmp = [[UISwitch alloc] init];
		CGSize  ctlS = switchCtlTmp.frame.size;      //控件的的尺寸
		[switchCtlTmp release];
		
		CGFloat ctlY= (cellP.y + cellS.height/2 - ctlS.height/2);  //控件的原点的Y
		CGRect switchCtlRect = CGRectMake(cellP.x+198, ctlY, ctlS.width, ctlS.height);
		//CGRect switchCtlRect = CGRectMake(195.0, 12.0, 94.0, 27.0);
		/////////////////////
		        
		self->switchCtl = [[UISwitch alloc] initWithFrame:switchCtlRect];
         */
        
        self->switchCtl = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		self->switchCtl.backgroundColor = [UIColor clearColor];
		self->switchCtl.opaque = NO;
	}

	
	return self->switchCtl;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;    //被选择后，无变化
		//[self.contentView addSubview: self.switchCtl];
        self.accessoryView = self.switchCtl;
    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
	return [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}


- (void)dealloc {
	[switchCtl release];
    [super dealloc];
}


@end
