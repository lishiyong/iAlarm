//
//  YCPlacemarkUS.h
//  iAlarm
//
//  Created by li shiyong on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YCPlacemark.h"

@interface YCPlacemarkUSCA : YCPlacemark{
    NSMutableArray *_addressArray; //从街道->国名，有效的地址。除了门牌、邮编
}

@end
