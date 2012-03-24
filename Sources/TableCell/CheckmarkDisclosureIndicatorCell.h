//
//  CheckmarkDisclosureIndicatorCell.h
//  iArrived
//
//  Created by li shiyong on 10-10-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CheckmarkDisclosureIndicatorCell : UITableViewCell {
	
	UITableViewCell *subCheckmarkCell;
	UIImage *defaultImage;
	UIImage *checkedImage;

}

@property (nonatomic,retain,readonly) UITableViewCell *subCheckmarkCell;
@property (nonatomic,retain) UIImage *defaultImage;
@property (nonatomic,retain) UIImage *checkedImage;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier checkmark:(BOOL)isCheckmark;
-(void) setChechmark:(BOOL)isCheckmark;



@end
