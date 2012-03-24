//
//  AlarmLSoundViewController.h
//  iArrived
//
//  Created by li shiyong on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "AlarmModifyTableViewController.h"

//@class YCSoundPlayer;
@interface AlarmLSoundViewController : AlarmModifyTableViewController {
	
	NSIndexPath    * lastIndexPath;
	//YCSoundPlayer *soundPlayerCurrent;
	AVAudioPlayer *soundPlayerCurrent;
	NSDictionary *soundPlays;
	
}

@property (nonatomic, retain) NSIndexPath *lastIndexPath;
//@property (nonatomic, retain) YCSoundPlayer *soundPlayerCurrent;
@property (nonatomic, retain) AVAudioPlayer *soundPlayerCurrent;
@property (nonatomic, retain,readonly) NSDictionary *soundPlays;

//在整个tableView中indexPath的row在位置
-(NSInteger)gernarlRowInTableView:(UITableView *)tableView ForIndexPath:(NSIndexPath *)indexPath;

@end
