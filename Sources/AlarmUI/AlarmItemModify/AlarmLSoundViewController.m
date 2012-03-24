//
//  AlarmLSoundViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YCSoundPlayer.h"
#import "UIUtility.h"
#import "YCSound.h"
#import "DicManager.h"
#import "AlarmLSoundViewController.h"
#import "IAAlarm.h"


@implementation AlarmLSoundViewController
@synthesize lastIndexPath;
@synthesize soundPlayerCurrent;

/*
-(id)soundPlays{
	if (soundPlays == nil) {
		NSArray *sounds = [[DicManager soundDictionary] allValues];
		soundPlays = [[NSMutableDictionary alloc] initWithCapacity:sounds.count];
		
		for (int i=0; i<sounds.count;i++) {
			YCSound *sound = [sounds objectAtIndex:i];
			YCSoundPlayer *soundPlayer= [YCSoundPlayer soundPlayerWithSoundFileName:sound.soundFileName];
			[(NSMutableDictionary*)soundPlays setObject:soundPlayer forKey:sound.soundId];
		}
	}
	return soundPlays;
}
 */

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
-(IBAction)doneButtonPressed:(id)sender
{	
	//YCSound *sound = [DicManager soundForSortId:lastIndexPath.row];
	NSInteger soundSortId = [self gernarlRowInTableView:self.tableView ForIndexPath:lastIndexPath];
	YCSound *sound = [DicManager soundForSortId:soundSortId];
	self.alarm.sound = sound;
	[self.navigationController popViewControllerAnimated:YES];
	
	[super doneButtonPressed:sender];
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = KViewTitleSound;
	//修改视图背景等
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
	
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
			return 1;  //无声音
			break;
		case 1:
			return [DicManager soundDictionary].count - 1;
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
			soundRow = 0;  //无声音
			break;
		case 1:
			soundRow = indexPath.row+1; //从无声音下的第一个开始
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
			cell.textLabel.textColor = [UIUtility checkedCellTextColor];
			self.lastIndexPath = indexPath;
		}else {
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.textLabel.textColor = [UIUtility defaultCellTextColor];
		}
	}
	
	return cell;
	
}

#pragma mark -
#pragma mark Table view delegate

//row总数 --目前无用
-(NSInteger)totalRowForTableView:(UITableView *)tableView{
	NSInteger retVal =0;
	NSInteger sectionNumber =  [tableView numberOfSections];
	for (int i =0; i < sectionNumber; i++) {
		retVal += [tableView numberOfRowsInSection:i];
	}
	return retVal;
}

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
    //int newRow = [indexPath row];
    //int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
	int newRow = [self gernarlRowInTableView:tableView ForIndexPath:indexPath];
	int oldRow = (lastIndexPath != nil) ? [self gernarlRowInTableView:tableView ForIndexPath:lastIndexPath] : -1;
    
    if (newRow != oldRow)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		newCell.textLabel.textColor = [UIUtility checkedCellTextColor];
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:lastIndexPath]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
		oldCell.textLabel.textColor = [UIUtility defaultCellTextColor];
		self.lastIndexPath = indexPath;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//done按钮可用
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	//播放声音
	if (indexPath.section == 0) {//无声音
		[self.soundPlayerCurrent stop]; //停止当前播放的声音
		return; 
	}else {
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
	}
	
	
}


#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
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

