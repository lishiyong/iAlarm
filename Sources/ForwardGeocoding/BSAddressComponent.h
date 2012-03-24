//
//  BSAddressComponent.h
//  Forward-Geocoding
//
//  Created by Björn Sållarp on 3/14/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BSAddressComponent : NSObject {
	NSString *longName;
	NSString *shortName;
	NSArray *types;
}

@property (nonatomic, retain) NSString *longName;
@property (nonatomic, retain) NSString *shortName;
@property (nonatomic, retain) NSArray *types;

@end
