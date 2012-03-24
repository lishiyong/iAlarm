//
//  NSString.h
//  iAlarm
//
//  Created by li shiyong on 11-2-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (YC)

-(NSString*)trim;
//-(NSString*)ltrim;
//-(NSString*)rtrim;



//拆分文件名
-(NSString*)nameInFullFileName;
-(NSString*)typeInFullFileName;

@end
