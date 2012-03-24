//
//  ContactsCell.h
//  TestShareApp
//
//  Created by li shiyong on 11-8-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CheckPeopleCell : UITableViewCell {
	UIImageView *accessoryViewImageView;
	BOOL checked;
	NSString *identifier;
}

@property(nonatomic, retain, readonly) UIImageView *accessoryViewImageView;
@property(nonatomic, assign) BOOL checked;
@property(copy) NSString *identifier;

@end
