//
//  IADestinationCell.m
//  iAlarm
//
//  Created by li shiyong on 11-9-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IANotifications.h"
#import "YCLib.h"
#import "YCPlacemark.h"
#import "IAAlarm.h"
#import "YCSystemStatus.h"
#import "LocalizedString.h"
#import "IADestinationCell.h"

@interface IADestinationCell (private) 

- (void)startMoveArrowAnimating;
- (void)setMoveArrow:(BOOL)theMoving;
- (void)setAddressLabelWithLarge:(BOOL)large;
- (void)handleStandardLocationDidFinish: (NSNotification*) notification;
- (void)registerNotifications;
- (void)unRegisterNotifications;
- (void)setWidthOfAddressLabelAndDistanceLabel;//设置地址label距离label的宽度，根据不同语言“title”的长度

@end

@implementation IADestinationCell

@synthesize titleLabel, addressLabel, distanceLabel, distanceActivityIndicatorView;
@synthesize locatingImageView, locatingLabel;
@synthesize moveArrowImageView;
@synthesize alarm = _alarm, cellStatus = _cellStatus;

- (void)setWidthOfAddressLabelAndDistanceLabel{
    
    //修正titleLabel
    [self.titleLabel sizeToFit];
    CGPoint titleLabelCenter = (CGPoint){self.titleLabel.center.x,self.contentView.bounds.size.height/2};
    self.titleLabel.center = titleLabelCenter;
    
    CGFloat titleLabelR = self.titleLabel.frame.size.width + self.titleLabel.frame.origin.x;
    CGFloat newAddressLabelL = titleLabelR + 6.0; //与TitleLable间隔xx.0
    CGFloat newDistanceLabelL = titleLabelR + 3.0;//与TitleLable间隔xx.0
    CGFloat oldAddressLabelL = self.addressLabel.frame.origin.x;
    CGFloat oldDistanceLabelL = self.distanceLabel.frame.origin.x;

    
    CGRect addressLabelFrame = self.addressLabel.frame;
    addressLabelFrame.origin.x = newAddressLabelL;
    addressLabelFrame.size.width = (oldAddressLabelL - newAddressLabelL) + self.addressLabel.frame.size.width;
    self.addressLabel.frame = addressLabelFrame;
    
    CGRect distanceLabelFrame = self.distanceLabel.frame;
    distanceLabelFrame.origin.x = newDistanceLabelL;
    distanceLabelFrame.size.width = (oldDistanceLabelL - newDistanceLabelL) + self.distanceLabel.frame.size.width;
    self.distanceLabel.frame = distanceLabelFrame;
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

- (void)setAddressLabelWithLarge:(BOOL)large{
	CGFloat addressLabelX = self.addressLabel.frame.origin.x;
	CGFloat addressLabelW = self.addressLabel.frame.size.width;
    CGFloat addressLabelH = self.addressLabel.frame.size.height;
	
	CGRect smallFrame = CGRectMake(addressLabelX, 2, addressLabelW, addressLabelH);
	//CGRect largeFrame = CGRectMake(addressLabelX, 0, addressLabelW, addressLabelH);
	
	if (large) {
        CGPoint addressLabelCenter = (CGPoint){self.addressLabel.center.x,self.contentView.bounds.size.height/2};
        self.addressLabel.center = addressLabelCenter;
		//self.addressLabel.frame = largeFrame;
        
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


- (void)setCellStatus:(IADestinationCellStatus)cellStatus{
    _cellStatus = cellStatus;
    
    //停了再说
    [self setMoveArrow:NO];
    
[UIView transitionWithView:self.contentView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
    NSString *placemarkName = self.alarm.placemark.name ? self.alarm.placemark.name : @"";
    NSString *shortAddress = self.alarm.positionShort ? self.alarm.positionShort : @"";
    
    //空格个逗号都替掉,再比对
    NSString *placemarkNameTemp = [placemarkName stringByReplacingOccurrencesOfString:@" " withString:@""]; 
    placemarkNameTemp = [placemarkNameTemp stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSString *shortAddressTemp = [shortAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    shortAddressTemp = [shortAddressTemp stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    //如果名字已经在地址中
    if ([shortAddressTemp rangeOfString:placemarkNameTemp].location != NSNotFound) 
        placemarkName = @"";
    
    NSString *addressLabelText = [NSString stringWithFormat:@"%@ %@",placemarkName,shortAddress]; 
    addressLabelText = [addressLabelText stringByTrim];
    
	self.addressLabel.text = addressLabelText; //地址
    
    CLLocationCoordinate2D realCoordinate = self.alarm.realCoordinate;
	if (CLLocationCoordinate2DIsValid(realCoordinate) && [YCSystemStatus sharedSystemStatus].lastLocation) {
        CLLocation *currentLocation = [YCSystemStatus sharedSystemStatus].lastLocation;
		NSString *distanceString = [currentLocation distanceStringFromCoordinate:realCoordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextPromptCurrentLocation];
		self.distanceLabel.text = distanceString; //距离
	}else {
		self.distanceLabel.text = nil;
	}
    
    
    switch (_cellStatus) {
        case IADestinationCellStatusNone:
        {
            self.titleLabel.hidden = NO;
            self.addressLabel.hidden = YES;
            self.distanceLabel.hidden = YES;            
            self.distanceActivityIndicatorView.hidden = YES;
            self.locatingImageView.hidden = YES;
            self.locatingLabel.hidden = YES;
            self.moveArrowImageView.hidden = YES;
            
            self.accessoryView = nil;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case IADestinationCellStatusNormal:
        {
            if (self.distanceLabel.text != nil) {
                [self setAddressLabelWithLarge:NO]; //地址要缩小
                self.distanceLabel.hidden = NO;             
            }else {
                [self setAddressLabelWithLarge:YES]; //地址要大
                self.distanceLabel.hidden = YES; 
            }
            
            self.titleLabel.hidden = NO;
            self.addressLabel.hidden = NO;
            //self.distanceLabel.hidden = NO;            
            self.distanceActivityIndicatorView.hidden = YES;
            self.locatingImageView.hidden = YES;
            self.locatingLabel.hidden = YES;
            self.moveArrowImageView.hidden = YES;
            
            self.accessoryView = nil;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }   
        case IADestinationCellStatusNormalWithoutDistance:
        {
            [self setAddressLabelWithLarge:YES]; //地址要大

            self.titleLabel.hidden = NO;
            self.addressLabel.hidden = NO;
            self.distanceLabel.hidden = YES;            
            self.distanceActivityIndicatorView.hidden = YES;
            self.locatingImageView.hidden = YES;
            self.locatingLabel.hidden = YES;
            self.moveArrowImageView.hidden = YES;
            
            
            self.accessoryView = nil;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }   
        case IADestinationCellStatusNormalWithoutDistanceAndAddress:
        {
            self.titleLabel.hidden = NO;
            self.addressLabel.hidden = YES;
            self.distanceLabel.hidden = YES;            
            self.distanceActivityIndicatorView.hidden = YES;
            self.locatingImageView.hidden = YES;
            self.locatingLabel.hidden = YES;
            self.moveArrowImageView.hidden = NO;
            
            [self setMoveArrow:YES];//开始播放箭头
            
            self.accessoryView = nil;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }   
        case IADestinationCellStatusNormalMeasuringDistance:
        {
            [self setAddressLabelWithLarge:NO]; //地址要缩小

            self.titleLabel.hidden = NO;
            self.addressLabel.hidden = NO;
            self.distanceLabel.hidden = YES;            
            self.distanceActivityIndicatorView.hidden = NO;
            self.locatingImageView.hidden = YES;
            self.locatingLabel.hidden = YES;
            self.moveArrowImageView.hidden = YES;
            
            [self.distanceActivityIndicatorView startAnimating]; //测量地址等待
            
            self.accessoryView = nil;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case IADestinationCellStatusLocating:
        case IADestinationCellStatusReversing:
        {
            self.titleLabel.hidden = YES;
            self.addressLabel.hidden = YES;
            self.distanceLabel.hidden = YES;            
            self.distanceActivityIndicatorView.hidden = YES;
            self.locatingImageView.hidden = NO;
            self.locatingLabel.hidden = NO;
            self.moveArrowImageView.hidden = YES;
            
            UIActivityIndicatorView *acView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            [acView startAnimating];
            self.accessoryView = acView;
            
            if (IADestinationCellStatusLocating == _cellStatus) {
                self.locatingLabel.text = KTextPromptWhenLocating;
            }else if (IADestinationCellStatusReversing == _cellStatus){
                self.locatingLabel.text = KTextPromptWhenReversing;
            }
            
            break;
        }
        default:
            break;
    }
    

} completion:NULL];
    
}

/*
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	
	if ( [keyPath isEqualToString:@"text"]) {
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
 */

- (void)handleStandardLocationDidFinish: (NSNotification*) notification{
    
    CLLocation *curLocation = [[notification userInfo] objectForKey:IAStandardLocationKey];
    BOOL curLocationAndRealCoordinateIsValid = (curLocation && CLLocationCoordinate2DIsValid(self.alarm.realCoordinate));
    
    //设置与当前位置的距离值
    if (curLocationAndRealCoordinateIsValid) {        
        
        NSString *distanceString = [curLocation distanceStringFromCoordinate:self.alarm.realCoordinate withFormat1:KTextPromptDistanceCurrentLocation withFormat2:KTextPromptCurrentLocation];  
        
        if (![self.distanceLabel.text isEqualToString:distanceString]) {
            self.distanceLabel.text = distanceString;
            
            if (_cellStatus == IADestinationCellStatusNormal 
             || _cellStatus == IADestinationCellStatusNormalWithoutDistance
                ) { //正常状态才显示距离文本
                
                self.cellStatus = IADestinationCellStatusNormalMeasuringDistance;
                
                [self performBlock:^{ //让用户看2秒等待圈
                    self.cellStatus = IADestinationCellStatusNormal;
                } afterDelay:2.0];
                
            }
            
        }
        
        
    }else{
        if (_cellStatus != IADestinationCellStatusLocating 
            || _cellStatus != IADestinationCellStatusReversing) {
            
            self.cellStatus = IADestinationCellStatusNormalWithoutDistance; 
            self.distanceLabel.text = nil;
        }
    }
    
}

- (void)registerNotifications {
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
						   selector: @selector (handleStandardLocationDidFinish:)
							   name: IAStandardLocationDidFinishNotification
							 object: nil];
}

- (void)unRegisterNotifications{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self	name: IAStandardLocationDidFinishNotification object: nil];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {        
        [self registerNotifications];
    }
    return self;
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
	cell.titleLabel.text = KLabelAlarmPostion;
	cell.addressLabel.text = nil;
	cell.distanceLabel.text = nil;
	cell.locatingLabel.text = nil;
    
    [cell setWidthOfAddressLabelAndDistanceLabel];
    
    cell.moveArrowImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"IAMoveArrow0.png"], [UIImage imageNamed:@"IAMoveArrow1.png"],[UIImage imageNamed:@"IAMoveArrow2.png"],[UIImage imageNamed:@"IAMoveArrow3.png"],[UIImage imageNamed:@"IAMoveArrow4.png"],[UIImage imageNamed:@"IAMoveArrow5.png"],nil];
    cell.moveArrowImageView.animationDuration = 0.4;
    cell.moveArrowImageView.animationRepeatCount = 2;
    
    	
    [cell registerNotifications];
    
	return cell; 
}



- (void)dealloc {
    [self unRegisterNotifications];

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
