//
//  AlarmNameViewController.m
//  iArrived
//
//  Created by li shiyong on 10-10-19.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AnnotationInfoViewController.h"
#import "UIUtility.h"
#import "AnnotationTitleTableCell.h"
#import "AnnotationSubtitleTableCell.h"
#import "IAAnnotation.h"
#import <MapKit/MapKit.h>


@implementation AnnotationInfoViewController
@synthesize annotation;
@synthesize annotationTitle;
@synthesize annotationSubtitle;

-(void)backBarButtonItemPressed:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = KViewTitleInformation;
	//self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat cellHeight = 44;
	switch (indexPath.section) {
		case 0:
			cellHeight = kAnnotationTitleTableCellHeight;
			break;
		case 1:
			cellHeight = kAnnotationSubtitleTableCellHeight;
			break;
		default:
			break;
	}
    return cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1; //每个组都是一个
}


- (UIImage *)titleImageForAnnotation:(id<MKAnnotation>)theAnnotation{

	UIImage *image = nil;
	if ([theAnnotation isKindOfClass:[MKUserLocation class]]) 
	{
		//当前位置
		image = [UIImage imageNamed:@"mapInfoCurrent.png"];
		
	}else if ([theAnnotation isKindOfClass:[IAAnnotation class]]){
		
		switch (((IAAnnotation*)theAnnotation).annotationType) {
			case IAMapAnnotationTypeStandard:            //已经定位的普通类型
				image = [UIImage imageNamed:@"mapInfoRed.png"];
				break;
			case IAMapAnnotationTypeStandardEnabledDrag: //已经定位的普通类型，但可以拖动
				image = [UIImage imageNamed:@"mapInfoPurple.png"];
				break;
			case IAMapAnnotationTypeLocating:            //正在定位的
				image = [UIImage imageNamed:@"mapInfoPurple.png"];
				break;
			case IAMapAnnotationTypeMovingToTarget:      //接近的目标位置
				image = [UIImage imageNamed:@"mapInfoGreen.png"];
				break;
			case IAMapAnnotationTypeSearch:               //搜索的类型
				image = [UIImage imageNamed:@"mapInfoRed.png"];
				break;
			default:
				image = [UIImage imageNamed:@"mapInfoRed.png"];
				break;
		}
	}else {
		image = [UIImage imageNamed:@"mapInfoRed.png"];
	}

	
	return image;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = nil;
	UITableViewCell *cell = nil;
	switch (indexPath.section) {
		case 0:
			CellIdentifier = @"AnnotationTitleTableCell";
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [AnnotationTitleTableCell tableCellWithXib];
			}
			((AnnotationTitleTableCell*)cell).textLabel.text = self.annotationTitle;
			((AnnotationTitleTableCell*)cell).image = [self titleImageForAnnotation:self.annotation];
			break;
		case 1:
			CellIdentifier = @"AnnotationSubtitleTableCell";
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [AnnotationSubtitleTableCell tableCellWithXib];
			}
			((AnnotationSubtitleTableCell*)cell).textView.text = self.annotationSubtitle;
			break;
		default:
			return nil;
			break;
	}

    return cell;
	
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) 
	{
		case 0:
			cell.backgroundView.alpha = 0.0;  //第一个cell没有背景
			break;
		default:
			break;
	}
}




- (void)dealloc {

	[self.annotationTitle release];
	[self.annotationSubtitle release];
    [super dealloc];
}


@end
