
//闹钟的警示半径改变了--Done前
extern NSString *IAAlarmRadiusDidChangeNotification;
//在custom picker上选中的不是Custom行
extern NSString *IAAlarmDidDeSelecteCustomRowNotification;


@interface CustomPickerController : NSObject <UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UIPickerView *pickerView;
	IBOutlet UILabel *alarmRadiusUnitKilometreLabel;
	IBOutlet UILabel *alarmRadiusUnitMetreLabel;
	
}

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UILabel *alarmRadiusUnitKilometreLabel;
@property (nonatomic, retain) IBOutlet UILabel *alarmRadiusUnitMetreLabel;

@property (nonatomic, readonly) double customAlarmRadiusValue;

-(void)updatePickerViewWithAlarmRadius:(double)alarmRadius;

@end
