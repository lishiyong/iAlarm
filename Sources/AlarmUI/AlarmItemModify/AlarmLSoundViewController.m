//
//  AlarmLSoundViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IAParam.h"
#import "YCLib.h"
#import "YCSound.h"
#import "DicManager.h"
#import "AlarmLSoundViewController.h"
#import "IAAlarm.h"


@implementation AlarmLSoundViewController
@synthesize lastIndexPath;
@synthesize soundPlayerCurrent;

- (void)setSkinWithType:(IASkinType)type{
    YCBarButtonItemStyle buttonItemStyle = YCBarButtonItemStyleDefault;
    YCTableViewBackgroundStyle tableViewBgStyle = YCTableViewBackgroundStyleDefault;
    YCBarStyle barStyle = YCBarStyleDefault;
    if (IASkinTypeDefault == type) {
        buttonItemStyle = YCBarButtonItemStyleDefault;
        tableViewBgStyle = YCTableViewBackgroundStyleDefault;
        barStyle = YCBarStyleDefault;
    }else {
        buttonItemStyle = YCBarButtonItemStyleSilver;
        tableViewBgStyle = YCTableViewBackgroundStyleSilver;
        barStyle = YCBarStyleSilver;
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:buttonItemStyle];
    [self.tableView setYCBackgroundStyle:tableViewBgStyle];
    [self.tableView reloadData];
}

-(id)soundPlays{
	if (soundPlays == nil) {
		NSArray *sounds = [[DicManager soundDictionary] allValues];
		soundPlays = [[NSMutableDictionary alloc] initWithCapacity:sounds.count];
		for (int i=0; i<sounds.count;i++) {			
			YCSound *sound = [sounds objectAtIndex:i];
			id /*AVAudioPlayer*/ soundPlayer = nil;
			if (sound.soundFileURL ){
				soundPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:sound.soundFileURL error:NULL] autorelease];
				//((AVAudioPlayer*)soundPlayer).meteringEnabled = YES;
			}else 
				soundPlayer = [NSNull null];
			[(NSMutableDictionary*)soundPlays setObject:soundPlayer forKey:sound.soundId];
			
		}
	}
	return soundPlays;
}

//覆盖父类
- (void)saveData{	
	NSInteger soundSortId = 0;
    if (lastIndexPath) {
        if (lastIndexPath.section == 0) {
            soundSortId = lastIndexPath.row + 1;
        }else if (lastIndexPath.section == 1){ //无声音
            soundSortId = 0;
        }
    }
    
	YCSound *sound = [DicManager soundForSortId:soundSortId];
	self.alarm.sound = sound;	
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = KViewTitleSound;
	//修改视图背景等
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
	
    //skin Style
    [self setSkinWithType:[IAParam sharedParam].skinType];
}



- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (void)setPlayerCurrentVolume:(NSNumber*)volumeObj{
	self.soundPlayerCurrent.volume = [volumeObj floatValue];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	if (self.soundPlayerCurrent.playing){
		[self performSelector:@selector(setPlayerCurrentVolume:) withObject:[NSNumber numberWithFloat:0.8] afterDelay:0.0];
		[self performSelector:@selector(setPlayerCurrentVolume:) withObject:[NSNumber numberWithFloat:0.6] afterDelay:0.1];
		[self performSelector:@selector(setPlayerCurrentVolume:) withObject:[NSNumber numberWithFloat:0.4] afterDelay:0.2];
		[self performSelector:@selector(setPlayerCurrentVolume:) withObject:[NSNumber numberWithFloat:0.3] afterDelay:0.3];
		[self performSelector:@selector(setPlayerCurrentVolume:) withObject:[NSNumber numberWithFloat:0.2] afterDelay:0.4];
		[self performSelector:@selector(setPlayerCurrentVolume:) withObject:[NSNumber numberWithFloat:0.15] afterDelay:0.5];
		[self performSelector:@selector(setPlayerCurrentVolume:) withObject:[NSNumber numberWithFloat:0.10] afterDelay:0.6];
		[self performSelector:@selector(setPlayerCurrentVolume:) withObject:[NSNumber numberWithFloat:0.05] afterDelay:0.7];
		[self.soundPlayerCurrent performSelector:@selector(stop) withObject:nil afterDelay:0.8];
	}

}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
            return [DicManager soundDictionary].count - 1;
			break;
		case 1:
            return 1;  //无声音
			break;
		default:
			return 0;
			break;
	}

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // 
	NSInteger soundRow = 0;
	switch (indexPath.section) {
		case 0:
            soundRow = indexPath.row+1; //从无声音下的第一个开始
			break;
		case 1:
            soundRow = 0;  //无声音
			break;
		default:
			break;
	}
	
	YCSound *rep = [DicManager soundForSortId:soundRow];
	if (rep) {
		NSString *repeatString = rep.soundName;
		cell.textLabel.text = repeatString;
		
		if ([rep.soundId isEqualToString:self.alarm.sound.soundId]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			cell.textLabel.textColor = [UIColor tableCellBlueTextYCColor];
			self.lastIndexPath = indexPath;
		}else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.textColor = [UIColor darkTextColor];
		}
	}
	
	return cell;
	
}

#pragma mark -
#pragma mark Table view delegate

//在整个tableView中indexPath的row在位置
-(NSInteger)gernarlRowInTableView:(UITableView *)tableView ForIndexPath:(NSIndexPath *)indexPath {
	NSInteger retVal =0;
	NSInteger section =  indexPath.section;
	for (int i =0; i < section; i++) {
		retVal += [tableView numberOfRowsInSection:i];
	}
	retVal += indexPath.row;
	return retVal;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int newRow = [self gernarlRowInTableView:tableView ForIndexPath:indexPath];
	int oldRow = (lastIndexPath != nil) ? [self gernarlRowInTableView:tableView ForIndexPath:lastIndexPath] : -1;
    
    if (newRow != oldRow)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		newCell.textLabel.textColor = [UIColor tableCellBlueTextYCColor];
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:lastIndexPath]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
		oldCell.textLabel.textColor = [UIColor darkTextColor];
		self.lastIndexPath = indexPath;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//done按钮可用
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	//播放声音
	if (indexPath.section == 0) {
        
        NSInteger soundRow = indexPath.row+1; //从无声音下的第一个开始
		YCSound *sound = [DicManager soundForSortId:soundRow];
		//YCSoundPlayer *temp = [self.soundPlays objectForKey:sound.soundId];
		AVAudioPlayer *temp = [self.soundPlays objectForKey:sound.soundId];
		temp.volume = 1.0; //恢复成1.0,
		if (self.soundPlayerCurrent == temp) { //点的是同一行
			if (self.soundPlayerCurrent.playing) 
				[self.soundPlayerCurrent stop];
			else {
				[self.soundPlayerCurrent prepareToPlay];
				[self.soundPlayerCurrent play];
                AudioServicesPlaySystemSound (kSystemSoundID_Vibrate); //同时振动一次
			}
		}else {
			[self.soundPlayerCurrent stop];
			self.soundPlayerCurrent = [self.soundPlays objectForKey:sound.soundId];
			[self.soundPlayerCurrent prepareToPlay];
			[self.soundPlayerCurrent play];
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);//同时振动一次
		}
        
	}else {//无声音
        
		[self.soundPlayerCurrent stop]; //停止当前播放的声音
	}
	
}


#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    [super viewDidUnload];
	[soundPlays release];
	soundPlays = nil;
}


- (void)dealloc {
	[NSObject cancelPreviousPerformRequestsWithTarget:soundPlayerCurrent];
	
	[lastIndexPath release];
	[soundPlayerCurrent release];
	[soundPlays release];
    [super dealloc];
}




@end

