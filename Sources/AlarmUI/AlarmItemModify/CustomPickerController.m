
#import "YCParam.h"
#import "IAGlobal.h"
#import "IAAlarmRadiusType.h"
#import "DicManager.h"
#import "LocalizedString.h"
#import "CustomPickerController.h"

//闹钟的警示半径改变了--Done前
NSString *IAAlarmRadiusDidChangeNotification = @"IAAlarmRadiusDidChangeNotification";
//在custom picker上选中的不是Custom行
NSString *IAAlarmDidDeSelecteCustomRowNotification = @"IAAlarmDidDeSelecteCustomRowNotification";


@implementation CustomPickerController

//Custom的行号
#define kCustomRow 3

// Identifiers and widths for the various components
#define TYPENAME_COMPONENT 0
#define TYPENAME_COMPONENT_WIDTH 64
#define TYPENAME_COMPONENT_HIGHT 32

#define KM_COMPONENT 1
#define KM_COMPONENT_WIDTH 103
#define KM_COMPONENT_HIGHT 32
#define KM_LABEL_WIDTH 50

#define METERS_COMPONENT 2
#define METERS_COMPONENT_WIDTH 108
#define METERS_COMPONENT_HIGHT 32
#define METERS_LABEL_WIDTH 50


// Identifies for component views
#define VIEW_TAG 41
#define SUB_LABEL_TAG 42
#define SUB_IMAGE_TAG 43

#define LABEL_TAG 44   //km,meter 标签

@synthesize pickerView;
@synthesize alarmRadiusUnitKilometreLabel;
@synthesize alarmRadiusUnitMetreLabel;


-(void)updatePickerViewWithAlarmRadius:(double)alarmRadius{
	//int kmRow = (int)(alarmRadius/1000.0) -1;
	int kmRow = (int)(alarmRadius/1000.0);
	if (kmRow < 0 ) kmRow = 0;
	
	int meterRow = (((int)alarmRadius % 1000)/100);
	if (meterRow < 0 ) meterRow = 0;
	
	[self.pickerView selectRow:kmRow inComponent:1 animated:NO];
	[self.pickerView selectRow:meterRow inComponent:2 animated:NO];
	
	/*
	if (kmRow == 0) {
		self.alarmRadiusUnitKilometreLabel.text = kAlarmRadiusUnitKilometre; //单数
	}else {
		self.alarmRadiusUnitKilometreLabel.text = kAlarmRadiusUnitKilometres; //复数
	}
	 */
	
}

-(double)customAlarmRadiusValue{
	double d = 0.0;
	int kmRow = [self.pickerView selectedRowInComponent:1];
	int meterRow = [self.pickerView selectedRowInComponent:2];
	//d = (kmRow+1)*1000.0 + meterRow*100.0;
	d = kmRow*1000.0 + meterRow*100.0;
	
	return d;
}


#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	
	return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	
	CGFloat numberOfRowsInComponent = 0.0;
	switch (component) {
		case TYPENAME_COMPONENT:
			numberOfRowsInComponent = 4;//Near ~ Custom
			break;
		case KM_COMPONENT:
			numberOfRowsInComponent = 9000; //1千米 - 9000千米
			break;
		case METERS_COMPONENT:
			numberOfRowsInComponent = 10;//100米 ~ 900米
			break;
		default:
			break;
	}
	
	return numberOfRowsInComponent;
}


#pragma mark -
#pragma mark UIPickerViewDelegate

- (UIView *)imageAndLabelCellWidth:(CGFloat)width rightOffset:(CGFloat)offset {

	CGRect frame = CGRectMake(10, (TYPENAME_COMPONENT_HIGHT-16)/2,16, 16);  //左空出10
	UIImageView *subImageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
	subImageView.backgroundColor = [UIColor clearColor];
	subImageView.userInteractionEnabled = NO;
	subImageView.tag = SUB_IMAGE_TAG;
	
	CGFloat subLeftLabelWidth = 100.0;
	CGRect subLeftLabelFrame = CGRectMake(30, 0, subLeftLabelWidth, TYPENAME_COMPONENT_HIGHT); //左空出20（35-15）
	UILabel *subLeftLabel = [[[UILabel alloc] initWithFrame:subLeftLabelFrame] autorelease];
	subLeftLabel.textAlignment = UITextAlignmentLeft;
	subLeftLabel.backgroundColor = [UIColor clearColor];
	subLeftLabel.font = [UIFont boldSystemFontOfSize:18.0];
	subLeftLabel.shadowColor = [UIColor whiteColor];
	subLeftLabel.shadowOffset = CGSizeMake(0, 1);
	subLeftLabel.userInteractionEnabled = NO;
	subLeftLabel.tag = SUB_LABEL_TAG;
	
	CGRect viewFrame = CGRectMake(0.0, 0.0, width, TYPENAME_COMPONENT_HIGHT);
	UIView *view = [[[UIView alloc] initWithFrame:viewFrame] autorelease];
	[view addSubview:subImageView];
	[view addSubview:subLeftLabel];
	view.tag = VIEW_TAG;
	
	
	return view;
}

- (UIView *)imageCellWidth:(CGFloat)width rightOffset:(CGFloat)offset {
	
	CGRect frame = CGRectMake((width-16.0)/2, (TYPENAME_COMPONENT_HIGHT-16)/2,16, 16);  //居中
	UIImageView *subImageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
	subImageView.backgroundColor = [UIColor clearColor];
	subImageView.userInteractionEnabled = NO;
	subImageView.tag = SUB_IMAGE_TAG;
	
	CGRect viewFrame = CGRectMake(0.0, 0.0, width, TYPENAME_COMPONENT_HIGHT);
	UIView *view = [[[UIView alloc] initWithFrame:viewFrame] autorelease];
	[view addSubview:subImageView];
	view.tag = VIEW_TAG;
	
	
	return view;
}

- (UIView *)labelCellWithWidth:(CGFloat)width rightOffset:(CGFloat)offset {
	
	// Create a new view that contains a label offset from the right.
	CGRect frame = CGRectMake(0.0, 0.0, width, 32.0);
	UIView *view = [[[UIView alloc] initWithFrame:frame] autorelease];
	view.tag = VIEW_TAG;
	
	frame.size.width = width - offset;
	UILabel *subLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
	subLabel.textAlignment = UITextAlignmentRight;
	subLabel.backgroundColor = [UIColor clearColor];
	subLabel.font = [UIFont boldSystemFontOfSize:18.0];
	subLabel.shadowColor = [UIColor whiteColor];
	subLabel.shadowOffset = CGSizeMake(0, 1);
	subLabel.userInteractionEnabled = NO;
	
	subLabel.tag = SUB_LABEL_TAG;
	
	[view addSubview:subLabel];
	return view;
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	
	UIView *returnView = nil;
	
	// Reuse the label if possible, otherwise create and configure a new one.
	if (view.tag == VIEW_TAG) {
		returnView = view;
	}
	else {
		switch (component) {
			case TYPENAME_COMPONENT:
				//returnView = [self imageAndLabelCellWidth:TYPENAME_COMPONENT_WIDTH rightOffset:0];
				returnView = [self imageCellWidth:TYPENAME_COMPONENT_WIDTH rightOffset:0];
				break;
			case KM_COMPONENT:
				returnView = [self labelCellWithWidth:KM_COMPONENT_WIDTH rightOffset:KM_LABEL_WIDTH];
				break;
			case METERS_COMPONENT:
				returnView = [self labelCellWithWidth:METERS_COMPONENT_WIDTH rightOffset:METERS_LABEL_WIDTH];
				break;
			default:
				break;
		}
	}
	
	// The text shown in the component is just the number of the component.
	NSArray *array = [DicManager alarmRadiusTypeArray];
	
	NSString *text = nil;
	NSString *imageName = nil;
	UIImageView *theImageView = nil;
	switch (component) {
		case TYPENAME_COMPONENT:
			imageName = [(IAAlarmRadiusType*)[array objectAtIndex:row] alarmRadiusTypeImageName];	
			theImageView = (UIImageView*)[returnView viewWithTag:SUB_IMAGE_TAG];
			theImageView.image = [UIImage imageNamed:imageName];
			//text = [(IAAlarmRadiusType*)[array objectAtIndex:row] alarmRadiusName];
			//text = @"...";
			break;
		case KM_COMPONENT:
			//text = [NSString stringWithFormat:@"%d", row+1];
			text = [NSString stringWithFormat:@"%d", row];
			break;
		case METERS_COMPONENT:
			text = [NSString stringWithFormat:@"%d", (row)*100];
			break;
		default:
			break;
	}
	
	UILabel *theLabel = (UILabel *)[returnView viewWithTag:SUB_LABEL_TAG];
	theLabel.text = text;
	
	return returnView;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	
	CGFloat widthForComponent = 0.0;
	switch (component) {
		case TYPENAME_COMPONENT:
			widthForComponent = TYPENAME_COMPONENT_WIDTH;
			break;
		case KM_COMPONENT:
			widthForComponent = KM_COMPONENT_WIDTH;
			break;
		case METERS_COMPONENT:
			widthForComponent = METERS_COMPONENT_WIDTH;
			break;
		default:
			break;
	}
	
	return widthForComponent;
	
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
	
	return 32.0;
}


//解决轮子滚动后上不上，下不下的问题
-(void)delaySelectRowAtPickerView:(UIPickerView *)thePickerView{
	NSInteger row = [thePickerView selectedRowInComponent:0];
	[thePickerView selectRow:row inComponent:0 animated:YES];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	[self performSelector:@selector(delaySelectRowAtPickerView:) withObject:thePickerView afterDelay:0.5];//解决轮子滚动后上不上，下不下的问题

	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	if (component == 0){
		if (row != kCustomRow) { //选择的不是Custom行
			NSNotification *bNotification = [NSNotification notificationWithName:IAAlarmDidDeSelecteCustomRowNotification object:self];
			//[notificationCenter performSelector:@selector(postNotification:) withObject:bNotification afterDelay:0.0];
			[notificationCenter postNotification:bNotification];
		}
	}else {
		NSTimeInterval delay = 0.0;
        if (self.customAlarmRadiusValue < kMixAlarmRadius-1.0) //499.0(500.0) 浮点比较
        {
            if ([YCParam paramSingleInstance].leaveAlarmEnabled) { //iphone 4
                [thePickerView selectRow:1 inComponent:2 animated:YES];//最小选100米
            }else{
                [thePickerView selectRow:5 inComponent:2 animated:YES]; //最小选500米
            }
            delay = 1.0;
        }
        
		
		NSNotification *aNotification = [NSNotification notificationWithName:IAAlarmRadiusDidChangeNotification object:self];
		[notificationCenter performSelector:@selector(postNotification:) withObject:aNotification afterDelay:delay];	
	}
	
	/*
	if (component == 1){
		if (row == 0) {
			self.alarmRadiusUnitKilometreLabel.text = kAlarmRadiusUnitKilometre; //单数
		}else {
			self.alarmRadiusUnitKilometreLabel.text = kAlarmRadiusUnitKilometres; //复数
		}
	}else if (component == 2){
		if (row == 0) {
			self.alarmRadiusUnitMetreLabel.text = kAlarmRadiusUnitMeter; //单数
		}else {
			self.alarmRadiusUnitMetreLabel.text = kAlarmRadiusUnitMeters; //复数
		}
	}
	 */


}



#pragma mark -
#pragma mark lifecycle

-(void)awakeFromNib{
	[super awakeFromNib];
	self.alarmRadiusUnitKilometreLabel.text = kUnitKilometre;
	self.alarmRadiusUnitMetreLabel.text = kUnitMeters;
	
	[self.pickerView selectRow:kCustomRow inComponent:0 animated:NO];
	
	//self.pickerView.frame = CGRectMake(0, 0, 320, 45);
}

#pragma mark -
#pragma mark Memory management

/*
- (void)viewDidUnload {
    [super viewDidUnload];
	
	self.pickerView = nil;
	self.alarmRadiusUnitKilometreLabel = nil;
	self.alarmRadiusUnitMetreLabel = nil;
}
 */

- (void)dealloc {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];  //取消所有约定执行
	[NSObject cancelPreviousPerformRequestsWithTarget:pickerView];  //取消所有约定执行
	
	[pickerView release];
	[alarmRadiusUnitKilometreLabel release];
	[alarmRadiusUnitMetreLabel release];
	[super dealloc];
}
	
	
@end
