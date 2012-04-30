//
//  IADestinationCell.m
//  iAlarm
//
//  Created by li shiyong on 11-9-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IADestinationCell.h"

//详细文本的蓝色
//0.22 0.33 0.53 1
//56,84,135

@implementation IADestinationCell
@synthesize pinImageView;
@synthesize locatingImageView;
@synthesize titleLabel;
@synthesize locatingLabel;
@synthesize addressLabel;
@synthesize distanceLabel;
@synthesize distanceActivityIndicatorView;

@synthesize moveArrowImageView;

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	
	if ( [keyPath isEqualToString:@"text"]) {
		//NSString* newText = (NSString*)[change valueForKey:NSKeyValueChangeNewKey];
		if (object == self.titleLabel) {
			CGRect newTitleFrame = [self.titleLabel textRectForBounds:self.titleLabel.frame limitedToNumberOfLines:1];
			
			//计算address的frame
			CGFloat addressLabelX = newTitleFrame.origin.x + newTitleFrame.size.width + 6.0; //两个label间隔xx.0
			CGFloat addressLabelW = 260.0 - addressLabelX; //addressLabel在260处结束
			CGFloat addressLabelY = self.addressLabel.frame.origin.y;
			CGFloat addressLabelH = self.addressLabel.frame.size.height;
			
			self.addressLabel.frame = CGRectMake(addressLabelX, addressLabelY, addressLabelW, addressLabelH);
			
			
			//计算distance的frame
			CGFloat distanceLabelX = newTitleFrame.origin.x + newTitleFrame.size.width + 3.0; //两个label间隔xx.0
			CGFloat distanceLabelW = 260.0 - distanceLabelX; //addressLabel在260处结束
			CGFloat distanceLabelY = self.distanceLabel.frame.origin.y;
			CGFloat distanceLabelH = self.distanceLabel.frame.size.height;
			
			self.distanceLabel.frame = CGRectMake(distanceLabelX, distanceLabelY, distanceLabelW, distanceLabelH);
		}
	}

	
}

+(id)viewWithXib 
{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IADestinationCell" owner:self options:nil];
	IADestinationCell *cell =nil;
	for (id oneObject in nib){
		if ([oneObject isKindOfClass:[IADestinationCell class]]){
			cell = (IADestinationCell *)oneObject;
		}
	}
	cell.titleLabel.text = nil;
	cell.addressLabel.text = nil;
	cell.distanceLabel.text = nil;
	cell.locatingLabel.text = nil;
    
    cell.moveArrowImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"IAMoveArrow0.png"], [UIImage imageNamed:@"IAMoveArrow1.png"],[UIImage imageNamed:@"IAMoveArrow2.png"],[UIImage imageNamed:@"IAMoveArrow3.png"],[UIImage imageNamed:@"IAMoveArrow4.png"],[UIImage imageNamed:@"IAMoveArrow5.png"],nil];
    cell.moveArrowImageView.animationDuration = 0.4;
    cell.moveArrowImageView.animationRepeatCount = 2;
    
	
	[cell.titleLabel addObserver:cell forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];

	
	return cell; 
}

- (void)setUserInteractionEnabled:(BOOL)enabled{
	[super setUserInteractionEnabled:enabled];
	
	self.titleLabel.enabled                    = enabled;
	self.locatingLabel.enabled                 = enabled;
	self.addressLabel.enabled                  = enabled;
	self.distanceLabel.enabled                 = enabled;
	
	if (enabled) {
		self.pinImageView.image = [UIImage imageNamed:@"IAPinPurple.png"];
	}else {
		self.pinImageView.image = [UIImage imageNamed:@"IAPinGray.png"];
	}
}


- (void)setWaiting:(BOOL)waiting andWaitText:(NSString*)waitText{
	self.pinImageView.hidden                  = waiting;
	self.locatingImageView.hidden             =!waiting;
	self.titleLabel.hidden                    = waiting;
	self.locatingLabel.hidden                 =!waiting;
	self.addressLabel.hidden                  = waiting;
	self.distanceLabel.hidden                 = waiting;
	self.distanceActivityIndicatorView.hidden = waiting;

	self.locatingLabel.text = waitText;
	
	if (waiting) {
		UIActivityIndicatorView *acView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
		[acView startAnimating];
		self.accessoryView = acView;
	}else {
		self.accessoryView = nil;
	}
    
}

- (void)setDistanceWaiting:(BOOL)waiting andDistanceText:(NSString*)distanceTextText{
	
	self.distanceLabel.hidden                 = waiting;
	self.distanceActivityIndicatorView.hidden = !waiting;
	
	self.distanceLabel.text = distanceTextText;
	if(waiting) 
		[self setAddressLabelWithLarge:NO];
}


- (void)setAddressLabelWithLarge:(BOOL)large{
	CGFloat addressLabelX = self.addressLabel.frame.origin.x;
	CGFloat addressLabelW = self.addressLabel.frame.size.width;
	
	CGRect smallFrame = CGRectMake(addressLabelX, 3, addressLabelW, 21);
	CGRect largeFrame = CGRectMake(addressLabelX, 0, addressLabelW, 44);
	
	if (large) {
		self.distanceLabel.hidden                 = YES;
		self.distanceActivityIndicatorView.hidden = YES;
		
		self.addressLabel.frame = largeFrame;
		self.addressLabel.font = [UIFont systemFontOfSize:17.0];
		self.addressLabel.adjustsFontSizeToFitWidth = YES;
		self.addressLabel.minimumFontSize = 12.0;
	}else {
		self.addressLabel.frame = smallFrame;
		self.addressLabel.font = [UIFont systemFontOfSize:15.0];
		self.addressLabel.adjustsFontSizeToFitWidth = YES;
		self.addressLabel.minimumFontSize = 12.0;
	}

}

- (void)startMoveArrowAnimating{
    [self.moveArrowImageView stopAnimating];
    [self.moveArrowImageView startAnimating];
    if (moving) {
        [self performSelector:@selector(startMoveArrowAnimating) withObject:nil afterDelay:4.0];
    }
}

- (void)setMoveArrow:(BOOL)theMoving{
    moving = theMoving; 
    if (moving) {
        [self performSelector:@selector(startMoveArrowAnimating) withObject:nil afterDelay:2.0];
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startMoveArrowAnimating) object:nil];
    }
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self.titleLabel removeObserver:self forKeyPath:@"text"];

	[pinImageView release];
	[locatingImageView release];
	[titleLabel release];
	[locatingLabel release];
	[addressLabel release];
	[distanceLabel release];
	[distanceActivityIndicatorView release];
    
    [moveArrowImageView release];	
    [super dealloc];
}


@end
