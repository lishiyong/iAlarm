//
//  CellHearderView.h
//  iAlarm
//
//  Created by li shiyong on 10-12-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CellHeaderView : UIView {
	
	IBOutlet UILabel *textLabel;

}

@property(nonatomic,retain) IBOutlet UILabel *textLabel;

+(id)viewWithXib;

@end
