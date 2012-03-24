//
//  YCAlertViewWithTableView.m
//  TestAlertView
//
//  Created by li shiyong on 11-1-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YCShadowTableView.h"
#import "YCAlertTableView.h"


@implementation YCAlertTableView

@synthesize tableView;
@synthesize tableCellContents;


//AlertView的行最多数量，用来扩充AlertView的大小的
#define kMaxDisplayRow             12
//AlertTableView的最大高度
#define kMaxTableViewHeight        240
//一行文本的cell高度
#define kHeightCellForOneLineText  45
//两行文本的cell高度
#define kHeightCellForOneTwoText   60


//取得指定文本的行数
-(NSUInteger)textLineCountOfCellLabelText:(NSString*)cellLabelText{
	/*
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	cell.frame = CGRectMake(12.0, 55.0, 260.0, 40);
	cell.textLabel.numberOfLines = 1 ;
	cell.textLabel.font =  [UIFont boldSystemFontOfSize:14];
	cell.textLabel.text = @"this is text for test cell's textLabel's width, and lenght of text must long.";
	CGFloat labelWidth  = cell.textLabel.frame.size.width;  //用cell.textLabel的宽度,来确定label的宽度。
	*/
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 254, kHeightCellForOneLineText)] autorelease];
	label.font =  [UIFont boldSystemFontOfSize:14];
	label.numberOfLines = 2;
	
	label.text = cellLabelText;
	CGRect labelTextRect = [label textRectForBounds:label.frame limitedToNumberOfLines:2];
	
	if (labelTextRect.size.height <= 25) { //14号boldSystemFont,一行高度应该是18 
		return 1;
	}else {
		return 2;
	}
	
}

//所有cell的总高度
-(CGFloat)totalHeightAllCells{
	CGFloat totalHeight = 0.0;
	
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 254, kHeightCellForOneLineText)] autorelease];
	label.font =  [UIFont boldSystemFontOfSize:14];
	label.numberOfLines = 2;
	
	for (id oneObject in self.tableCellContents) {
		NSString *string = oneObject;
		label.text = string;
	
		NSUInteger textLineCount = [self textLineCountOfCellLabelText:string];
		if (textLineCount == 1) { 
			totalHeight += kHeightCellForOneLineText;
		}else {
			totalHeight += kHeightCellForOneTwoText;
		}
	}
	return totalHeight;
}

- (id)  initWithTitle:(NSString *)title 
		     delegate:(id /*<UIAlertViewDelegate>*/)delegate
	tableCellContents:(NSArray*)theTableCellContents
    cancelButtonTitle:(NSString *)cancelButtonTitle
{
	self.tableCellContents = theTableCellContents;
	
	//取得cell的总高度
	NSInteger totalHeight = (NSInteger)[self totalHeightAllCells];
	
	//AlertView的高度
	NSUInteger messageLineCount = (totalHeight/20);//一行文本＝20。
	if (totalHeight % 20 > 0) messageLineCount ++; //有余数
	
	if (kMaxDisplayRow < messageLineCount) { //不得大于最大值
		messageLineCount = kMaxDisplayRow;
	}
	totalHeight = messageLineCount * 20;//行数取整后的高度
	
	NSMutableString *message = [NSMutableString stringWithCapacity:messageLineCount];
	for (int i = 0; i < messageLineCount; i++) {
		[message appendString:@"\n"];
	}
	
	if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil]) {
		
		CGRect tableViewFrame = CGRectMake(12.0, 53.0, 260.0, totalHeight);
		self.tableView =   [[[YCShadowTableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain] autorelease];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.alpha = 0.77;
		self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
	}
	
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return self.tableCellContents.count;
}

- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

	NSString *string = [self.tableCellContents objectAtIndex:indexPath.row];
	
	NSUInteger textLineCount = [self textLineCountOfCellLabelText:string];
	if (textLineCount == 1) { 
		return kHeightCellForOneLineText;
	}else {
		return kHeightCellForOneTwoText;
	}

}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
		cell.textLabel.numberOfLines = 2;
	}    
	
	NSString *backgroundImageName = @"YCAlertTableViewCellRowNormal";
	if (indexPath.row == 0) backgroundImageName = @"YCAlertTableViewCellRowFirst";
	if (indexPath.row == self.tableCellContents.count -1) backgroundImageName = @"YCAlertTableViewCellRowLast";
	NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:backgroundImageName ofType:@"png"];
	UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:3.0 topCapHeight:2.0];
	//UIImage *backgroundImage = [UIImage imageWithContentsOfFile:backgroundImagePath];
	cell.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
	cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	cell.backgroundView.frame = cell.bounds;

	
    cell.textLabel.text = [self.tableCellContents objectAtIndex:indexPath.row];

	
	
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self dismissWithClickedButtonIndex:0 animated:YES]; //关
	
	if ([self.delegate respondsToSelector:@selector(alertTableView:didSelectRow:)]) {
		[self.delegate alertTableView:self didSelectRow:indexPath.row];
	}
}


-(void)show{
	[super show];
	[self addSubview:self.tableView];
}

- (void)dealloc {
	[tableView release];
	[tableCellContents release];
    [super dealloc];
}


@end
