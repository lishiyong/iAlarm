//
//  WaitingCell.m
//  iAlarm
//
//  Created by li shiyong on 10-12-21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIUtility.h"
#import "WaitingCell.h"


@implementation WaitingCell
@synthesize waiting;

@synthesize accessoryImageView0Disabled;
@synthesize accessoryImageView0TempImage;

//@synthesize accessoryImageView1;
@synthesize accessoryImageView1Disabled;
@synthesize accessoryImageView1TempImage;

//@synthesize accessoryImageView2;
@synthesize accessoryImageView2Disabled;
@synthesize accessoryImageView2TempImage;

@synthesize accessoryButton;
@synthesize accessoryViewEnabled;

@synthesize accessoryType;


-(id) activityIndicator{
	if (!activityIndicator ) {
		activityIndicator = [[UIActivityIndicatorView alloc] 
							 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator.frame = CGRectMake(270.0,12.0,20.0,20.0);
		activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin 
											|UIViewAutoresizingFlexibleBottomMargin;
	}
	return activityIndicator;
}

-(id) activityLabel{
	if (!activityLabel ) {
		activityLabel = [[UILabel alloc] init];
		activityLabel.backgroundColor = [UIColor clearColor];    //背景色
		activityLabel.textColor = [UIColor grayColor];           //文本颜色
		activityLabel.font = [UIFont boldSystemFontOfSize:16.0]; //字体：加粗
		activityLabel.textAlignment = UITextAlignmentLeft;       //文本左对齐
		activityLabel.adjustsFontSizeToFitWidth = YES;           //字号自适应
		activityLabel.minimumFontSize = 12.0;
		//activityLabel.frame = CGRectMake(0.0,12.0,125.0,20.0);
		activityLabel.frame = CGRectMake(30.0,12.0,200.0,20.0);
		activityLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin 
										|UIViewAutoresizingFlexibleBottomMargin;
	}
	return activityLabel;
}

-(id) activityImageView{
	if (!activityImageView ) {
		activityImageView = [[UIImageView alloc] init];
		activityImageView.backgroundColor = [UIColor clearColor];    //背景色
		activityImageView.frame = CGRectMake(12,15,13,13);   //13*13
		activityImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin 
										|UIViewAutoresizingFlexibleBottomMargin;
	}
	return activityImageView;
}

-(id) activityView{
	if (!activityView ) {
		activityView = [[UILabel alloc] init];
		activityView.backgroundColor = [UIColor clearColor];
		//activityView.frame = CGRectMake(130.0,0.0,190.0,44.0);
		activityView.frame = CGRectMake(0.0,0.0,300,44.0);
		activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin 
									   |UIViewAutoresizingFlexibleRightMargin
									   |UIViewAutoresizingFlexibleBottomMargin;
		
		[activityView addSubview:self.activityIndicator];
		[activityView addSubview:self.activityLabel];
		[activityView addSubview:self.activityImageView];
		
		activityView.hidden = YES;
		
	}
	return activityView;
}



////////////////////////////////////////////////////////////////////////////



-(id) accessoryImageView0{
	if (!accessoryImageView0 ) {
		accessoryImageView0 = [[UIImageView alloc] init];
		accessoryImageView0.backgroundColor = [UIColor clearColor];    //背景色
	}
	accessoryImageView0.highlighted = NO;//
	return accessoryImageView0;
}

-(id) accessoryImageView1{
	if (!accessoryImageView1 ) {
		accessoryImageView1 = [[UIImageView alloc] init];
		accessoryImageView1.backgroundColor = [UIColor clearColor];    //背景色
	}
	accessoryImageView1.highlighted = NO;//
	return accessoryImageView1;
}

-(id) accessoryImageView2{
	if (!accessoryImageView2 ) {
		accessoryImageView2 = [[UIImageView alloc] init];
		accessoryImageView2.backgroundColor = [UIColor clearColor];    //背景色
	}
	accessoryImageView2.highlighted = NO;//
	return accessoryImageView2;
}
 

//////////////////////////////////////////////////
//设置accessoryView上图片是否高亮
-(void)accessoryViewDidTouchDown:(id)sender{
	/*
	UIView *accessoryView =  (UIView *)sender;
	NSArray *subViews = accessoryView.subviews;
	for(id oneObject in subViews){
		BOOL b = [oneObject isKindOfClass:[UIImageView class]];
		if (b){
			[(UIImageView*)oneObject setHighlighted:YES];
		}
	}
	 */
	self.accessoryImageView1.highlightedImage = self.accessoryImageView1TempImage;
	self.accessoryImageView1.highlighted = YES;
	self.accessoryImageView2.highlightedImage = self.accessoryImageView2TempImage;
	self.accessoryImageView2.highlighted = YES;
	
}

-(void)accessoryViewDidTouchUp:(id)sender{
	/*
	UIView *accessoryView =  (UIView *)sender;
	NSArray *subViews = accessoryView.subviews;
	for(id oneObject in subViews){
		BOOL b = [oneObject isKindOfClass:[UIImageView class]];
		if (b){
			[(UIImageView*)oneObject setHighlighted:NO];
		}
	}
	 */
	self.accessoryImageView1.highlightedImage = nil;
	self.accessoryImageView1.highlighted = NO;
	self.accessoryImageView2.highlightedImage = nil;
	self.accessoryImageView2.highlighted = NO;
}

-(void)accessoryViewDidTouchUpOutside:(id)sender{
	[self accessoryViewDidTouchUp:sender];
}
-(void)accessoryViewDidTouchUpOutInside:(id)sender{
	[self accessoryViewDidTouchUp:sender];
}



//////////////////////////////////////////////////

-(void)setAccessoryType:(UITableViewCellAccessoryType)type{
	
	if (UITableViewCellAccessoryNone==type) {
		self.accessoryView = nil;
		super.accessoryType = UITableViewCellAccessoryNone;
	}else {  //
		
		accessoryType = type;
		
		
		UIView *myAccessoryView = [[[UIView alloc] init] autorelease];
		CGFloat viewWidth = 0; //总宽度
		
		//第0个图
		CGFloat view0Width = 0;
		if (accessoryImageView0 !=nil) {
			view0Width = 16+5;  //0图与1图 要有 间隔
			self.accessoryImageView0.frame = CGRectMake(0,14,view0Width-5,16); //16*16;
		}

		
		//大头针 
		CGFloat view1Width = 0;
		if (accessoryImageView1 !=nil) {
			view1Width = 14;
			self.accessoryImageView1.frame = CGRectMake(view0Width,12,view1Width,19); //14*19;
		}


		//展示按钮
		CGFloat view2Width = 0;
		
		if (UITableViewCellAccessoryDisclosureIndicator == type) {  // >，是这个
			view2Width = 10;
			viewWidth = view0Width + view1Width + view2Width +10;
			self.accessoryImageView2.frame = CGRectMake(view0Width+view1Width,15,view2Width,13);//10*13
			self.accessoryImageView2.image = [UIImage imageNamed:@"UITableNext.png"];
			self.accessoryImageView2.highlightedImage = [UIImage imageNamed:@"UITableNextSelected.png"];
		
		}else if (UITableViewCellAccessoryCheckmark == type) {    // √，是这个
			view2Width = 14;
			viewWidth = view0Width + view1Width + view2Width + 8;
			self.accessoryImageView2.frame = CGRectMake(view0Width+view1Width,15,view2Width,14);  //14*14
			self.accessoryImageView2.image = [UIImage imageNamed:@"UIPickerTableCellChecked.png"];
			self.accessoryImageView2.highlightedImage = [UIImage imageNamed:@"UIPickerTableCellCheckedSelected.png"];
		
		}else if (UITableViewCellAccessoryDetailDisclosureButton == type) { //是个按钮
			myAccessoryView = [[[UIControl alloc] init] autorelease];
			self.accessoryButton = (UIControl*)myAccessoryView;
			[(UIControl*)myAccessoryView addTarget:self action:@selector(accessoryViewDidTouchDown:) forControlEvents:UIControlEventTouchDown];
			[(UIControl*)myAccessoryView addTarget:self action:@selector(accessoryViewDidTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
			[(UIControl*)myAccessoryView addTarget:self action:@selector(accessoryViewDidTouchUpOutInside:) forControlEvents:UIControlEventTouchUpInside];

			view2Width = 29;
			viewWidth = view0Width + view1Width + view2Width + 8;
			self.accessoryImageView2.frame = CGRectMake(view0Width+view1Width,6,view2Width,31);//29*31
			self.accessoryImageView2.image = [UIImage imageNamed:@"UITableNextButton.png"];

			//////////////////////
			//按钮行选中时候，按钮不高亮
			self.accessoryImageView2TempImage = [UIImage imageNamed:@"UITableNextButtonPressed.png"];
			self.accessoryImageView2.highlightedImage = nil;
			
			if (self.accessoryImageView1.highlightedImage) {
				self.accessoryImageView1TempImage = self.accessoryImageView1.highlightedImage;
				self.accessoryImageView1.highlightedImage = nil;
			}
			//////////////////////
		}
		
		myAccessoryView.backgroundColor = [UIColor clearColor];
		myAccessoryView.frame = CGRectMake(0,0,viewWidth,44);
		
		if (accessoryImageView0)
			[myAccessoryView addSubview:self.accessoryImageView0];
		if (accessoryImageView1)
			[myAccessoryView addSubview:self.accessoryImageView1];
		[myAccessoryView addSubview:self.accessoryImageView2];
		
		self.accessoryView = myAccessoryView;
	}
	
	
	
}

//设置AccessoryButton的响应函数
- (void)setAccessoryButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
	[self.accessoryButton addTarget:target action:action forControlEvents:controlEvents];
}


-(void) setWaiting:(BOOL)theWaiting{
	if (waiting == theWaiting) return;
	
	if (theWaiting){
		self->accessoryTypeTemp = self.accessoryType;
		self.accessoryType = UITableViewCellAccessoryNone; //显示等待就隐藏accessoryView
		self.detailTextLabel.hidden = YES;
		
		self.activityView.hidden = NO;
		self.activityIndicator.hidden = NO;
		self.activityLabel.hidden = NO;
		//self.detailTextLabel.text = nil;
		self.detailTextLabel.hidden = YES;
		self.textLabel.hidden = YES;
		[self.activityIndicator startAnimating];
	}else {
		self.accessoryType = self->accessoryTypeTemp; 
		self.detailTextLabel.hidden = NO;
		self.textLabel.hidden = NO;
		
		self.activityView.hidden = YES;
		self.activityIndicator.hidden = YES;
		self.activityLabel.hidden = YES;
		[self.activityIndicator stopAnimating];
	}
	
	waiting = theWaiting;
}

//设置AccessoryView Disable
- (void)setAccessoryViewEnabled:(BOOL)enabled{
	if (accessoryViewEnabled == enabled) return;
	
	accessoryViewEnabled = enabled;
	if (enabled) {
		if (self.accessoryImageView0TempImage != nil)
			self.accessoryImageView0.image = self.accessoryImageView0TempImage;
		
		if (self.accessoryImageView1TempImage != nil)
			self.accessoryImageView1.image = self.accessoryImageView1TempImage;
		
		if (self.accessoryImageView2TempImage != nil)
			self.accessoryImageView2.image = self.accessoryImageView2TempImage;
	}else{
		if (self.accessoryImageView0Disabled !=nil){
			self.accessoryImageView0TempImage = self.accessoryImageView0.image;
			self.accessoryImageView0.image = self.accessoryImageView0Disabled;
		}
		
		if (self.accessoryImageView1Disabled !=nil){
			self.accessoryImageView1TempImage = self.accessoryImageView1.image;
			self.accessoryImageView1.image = self.accessoryImageView1Disabled; 
		}
		
		if (self.accessoryImageView2Disabled !=nil){
			self.accessoryImageView2TempImage = self.accessoryImageView2.image;
			self.accessoryImageView2.image = self.accessoryImageView2Disabled; 
		}
	}
	
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        accessoryViewEnabled = YES;
		[self.contentView addSubview: self.activityView];
    }
    return self;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
	return [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

- (void)dealloc {
	[activityIndicator release];
	[activityLabel release];
	[activityImageView release];
	[activityView release];
	
	[accessoryImageView0 release];
	[accessoryImageView0Disabled release];
	[accessoryImageView0TempImage release];
	
	[accessoryImageView1 release];
	[accessoryImageView1Disabled release];
	[accessoryImageView1TempImage release];
	
	[accessoryImageView2 release];
	[accessoryImageView2Disabled release];
	[accessoryImageView2TempImage release];
	
	[accessoryButton release];
	
    [super dealloc];
}


@end
