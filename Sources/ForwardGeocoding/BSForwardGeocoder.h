//
//  Created by Björn Sållarp on 2010-03-13.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "BSGoogleV2KmlParser.h"
#import "BSGoogleV3KmlParser.h"

@class BSForwardGeocoder;

// Enum for geocoding status responses
enum {
	G_GEO_SUCCESS = 200,
	G_GEO_BAD_REQUEST = 400,
	G_GEO_SERVER_ERROR = 500,
	G_GEO_MISSING_QUERY = 601,
	G_GEO_UNKNOWN_ADDRESS = 602,
	G_GEO_UNAVAILABLE_ADDRESS = 603,
	G_GEO_UNKNOWN_DIRECTIONS = 604,
	G_GEO_BAD_KEY = 610,
	G_GEO_TOO_MANY_QUERIES = 620	
};

@protocol BSForwardGeocoderDelegate<NSObject>

@required
-(void)forwardGeocoderFoundLocation;
@optional
-(void)forwardGeocoderError:(NSString *)errorMessage;
 
/*
@required
-(void)forwardGeocoder:(BSForwardGeocoder*)forwardGeocoder searchString:(NSString*)searchString results:(NSArray*)results;

@optional
-(void)forwardGeocoder:(BSForwardGeocoder*)forwardGeocoder error:(NSString *)error;
*/
@end



@interface BSForwardGeocoder : NSObject {
	NSString *searchQuery;
	NSString *googleAPiKey;
	int status;
	NSArray *results;
	id delegate;
    
    //MKCoordinateRegion coordinateRegion;
    MKMapRect mapRect;
}
-(id) initWithDelegate:(id<BSForwardGeocoderDelegate, NSObject>)del;
-(void) findLocation:(NSString *)searchString;
-(void) cancel;  //取消，2011-01-04 lishiyong 添加

//- (void)findLocation:(NSString *)searchString  andCoordinateRegion:(MKCoordinateRegion)coordinateRegion; //指定范围查找 2011-11-19 lishiyong 添加
- (void)findLocation:(NSString *)searchString  andMapRect:(MKMapRect)theMapRect; //指定范围查找 2011-11-19 lishiyong 添加

@property (assign) id delegate;
@property (nonatomic, retain) NSString *searchQuery;
@property (nonatomic/*, readonly*/) int status;//取消，2011-01-21 lishiyong 修改
@property (nonatomic, retain) NSArray *results;

@end
