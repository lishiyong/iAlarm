//
//  MessageBody.m
//  TestShareApp
//
//  Created by li shiyong on 11-8-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageBodyCell.h"


@implementation MessageBodyCell
@synthesize textView;
@synthesize imageView;

+ (id)viewWithXib 
{
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageBodyCell" owner:self options:nil];
	MessageBodyCell *cell =nil;
	for (id oneObject in nib){
		if ([oneObject isKindOfClass:[MessageBodyCell class]]){
			cell = (MessageBodyCell *)oneObject;
			//cell.textView.delegate = self;
			cell.textView.font = [UIFont systemFontOfSize:17.0];
		}
	}
	
	
	return cell; 
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	//NSLog(@"scrollViewDidScroll");
	//CGFloat w = self.textView.contentSize.width;
	//CGFloat h = self.textView.contentSize.height;
}
 

/*
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
	NSLog(@"scrollViewShouldScrollToTop");
	return YES;

}
*/
/*
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	NSLog(@"viewForZoomingInScrollView");
	return nil;
}
*/
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
	//NSLog(@"scrollViewWillBeginZooming");

}

- (void)dealloc {
    [super dealloc];
}


@end
