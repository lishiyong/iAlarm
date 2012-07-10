//
//  AlarmLRepeatTypeViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCLib.h"
#import "AlarmLRepeatTypeViewController.h"
#import "DicManager.h"
#import "YCRepeatType.h"
#import "IAAlarm.h"


@implementation AlarmLRepeatTypeViewController

@synthesize lastIndexPath = _lastIndexPath;
@synthesize switchCell = _switchCell, beginEndCell = _beginEndCell, switchControl = _switchControl;

//覆盖父类
- (void)saveData{	    
	YCRepeatType *rep = [DicManager repeatTypeForSortId:self.lastIndexPath.row];
	self.alarm.repeatType = rep;
}
 

- (IBAction)switchControlValueDidChange:(id)sender{
    if (self.switchControl.on) {
        if (NSNotFound == [_sections indexOfObject:_beginEndSection]) 
            [_sections addObject:_beginEndSection];
    }else{
        [_sections removeObject:_beginEndSection];
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad{
    
    [super viewDidLoad];
	self.title = KViewTitleRepeat;
    
    //重复类型cells
    NSUInteger numberOfRepeatTypeSection = [DicManager repeatTypeDictionary].count;
    NSMutableArray *repeatTypeSection = [NSMutableArray arrayWithCapacity:numberOfRepeatTypeSection];
    
    for (NSUInteger i = 0; i < numberOfRepeatTypeSection; i++) {
        YCRepeatType *rep = [DicManager repeatTypeForSortId:i];
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
        
        NSString *repeatString = rep.repeatTypeName;
		cell.textLabel.text = repeatString;
		
		if ([rep.repeatTypeId isEqualToString:self.alarm.repeatType.repeatTypeId]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark ;
			cell.textLabel.textColor = [UIColor tableCellBlueTextYCColor];
			self.lastIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
		}else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.textColor = [UIColor tableCellBlueTextYCColor];
		}
        
        [repeatTypeSection addObject:cell];
    }
    
    //启用开关cell
    NSArray *switchSection = [NSArray arrayWithObjects:self.switchCell, nil];
    self.switchCell.textLabel.text = @"启用定时提醒";
    self.switchCell.accessoryView = self.switchControl;
    
    _sections = [[NSMutableArray arrayWithObjects:repeatTypeSection, switchSection, nil] retain];
    
    
    //开始结束cell，
    _beginEndSection = [[NSArray arrayWithObjects:self.beginEndCell, nil] retain];
    self.beginEndCell.textLabel.text = @"开始\r\n结束";
    self.beginEndCell.detailTextLabel.text = @"2:00 AM\r\n4:00 PM";
    self.beginEndCell.textLabel.numberOfLines = 2;
    self.beginEndCell.detailTextLabel.numberOfLines = 2;
    
    
    if (self.switchControl.on) {
        [_sections addObject:_beginEndSection];
    }

}
 

- (void)viewWillAppear:(BOOL)animated{
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0://重复类型
        {
            int newRow = [indexPath row];
            int oldRow = (_lastIndexPath != nil) ? [_lastIndexPath row] : -1;
            
            if (newRow != oldRow)
            {
                UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
                newCell.accessoryType = UITableViewCellAccessoryCheckmark;
                newCell.textLabel.textColor = [UIColor tableCellBlueTextYCColor];
                
                UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastIndexPath]; 
                oldCell.accessoryType = UITableViewCellAccessoryNone;
                oldCell.textLabel.textColor = [UIColor tableCellBlueTextYCColor];
                self.lastIndexPath = indexPath;
            }
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            break;
        }
        case 2://开始结束
        {
            break;
        }
            
        default:
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    UITableViewCell *cell = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell.bounds.size.height-1;
     */
    if (indexPath.section == 2) {
        return 64;
    }else{
        return 44;
    }
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_lastIndexPath release];
    [super dealloc];
}


@end

