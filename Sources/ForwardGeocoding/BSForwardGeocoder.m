//
//  Created by Björn Sållarp on 2010-03-13.
//  NO Copyright 2010 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import "BSForwardGeocoder.h"


@implementation BSForwardGeocoder

@synthesize searchQuery, status, results, delegate;

-(id) initWithDelegate:(id<BSForwardGeocoderDelegate>)del
{
	self = [super init];
	
	if (self != nil) {
		delegate = del;
	}
	return self;
}

-(void) findLocation:(NSString *)searchString
{
	// store the query
	self.searchQuery = searchString;
	
	[self performSelectorInBackground:@selector(startGeocoding) withObject:nil];
}

-(void) cancel{  //取消，2011-01-04 lishiyong 添加
	[NSObject cancelPreviousPerformRequestsWithTarget:self.delegate];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	self.delegate = nil;
}

-(void)startGeocoding
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int version = 3;
	
	NSError *parseError = nil;
	
	if(version == 2)
	{
		// Create the url to Googles geocoding API, we want the response to be in XML
		
		NSString* mapsUrl = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps/geo?q=%@&gl=se&output=xml&oe=utf8&sensor=false", 
							 searchQuery];
		
		// Create the url object for our request. It's important to escape the 
		// search string to support spaces and international characters
		NSURL *url = [[NSURL alloc] initWithString:[mapsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		// Run the KML parser
		BSGoogleV2KmlParser *parser = [[BSGoogleV2KmlParser alloc] init];
		
		[parser parseXMLFileAtURL:url parseError:&parseError];
		
		[url release];
		[mapsUrl release];
		
		status = parser.statusCode;
		
		// If the query was successfull we store the array with results
		if(parser.statusCode == G_GEO_SUCCESS)
		{
			self.results = parser.placemarks;
		}
		
		[parser release];
		
	}
	else if(version == 3)
	{
		// Create the url to Googles geocoding API, we want the response to be in XML
		NSString* mapsUrl = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps/api/geocode/xml?address=%@&sensor=false", 
							 searchQuery];
		
		// Create the url object for our request. It's important to escape the 
		// search string to support spaces and international characters
		NSURL *url = [[NSURL alloc] initWithString:[mapsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		// Run the KML parser
		BSGoogleV3KmlParser *parser = [[BSGoogleV3KmlParser alloc] init];
		
		[parser parseXMLFileAtURL:url parseError:&parseError ignoreAddressComponents:NO];
		
		[url release];
		[mapsUrl release];
		
		status = parser.statusCode;
		
		// If the query was successfull we store the array with results
		if(parser.statusCode == G_GEO_SUCCESS)
		{
			self.results = parser.results;
		}
		
		[parser release];
	}
	
	
	
	if(parseError != nil)
	{
		
		if([delegate respondsToSelector:@selector(forwardGeocoderError:)])
		{
			[delegate performSelectorOnMainThread:@selector(forwardGeocoderError:) withObject:[parseError localizedDescription] waitUntilDone:NO];
		}
		 
		/*
		if([delegate respondsToSelector:@selector(forwardGeocoder:error:)])
		{
			[delegate forwardGeocoder:self error:[parseError localizedDescription]];
		}*/
	}
	else {
		
		
		if([delegate respondsToSelector:@selector(forwardGeocoderFoundLocation)])
		{
			[delegate performSelectorOnMainThread:@selector(forwardGeocoderFoundLocation) withObject:nil waitUntilDone:NO];
		}
		/* 
		if([delegate respondsToSelector:@selector(forwardGeocoder:searchString:results:)])
		{
			[delegate forwardGeocoder:self searchString:self.searchQuery results:self.results];
		}*/
	}
	
	
	[pool release];
	
	
}

- (void)findLocation:(NSString *)searchString  andMapRect:(MKMapRect)theMapRect{
    // store the query
	self.searchQuery = searchString;
	self->mapRect = theMapRect;
	[self performSelectorInBackground:@selector(startGeocodingForMapRect) withObject:nil];

}

-(void)startGeocodingForMapRect
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    //换成坐标边距
    MKMapPoint pointSouth_west = MKMapPointMake(MKMapRectGetMinX(self->mapRect), MKMapRectGetMaxY(self->mapRect)); //西南
    CLLocationCoordinate2D coordinateSouth_west = MKCoordinateForMapPoint(pointSouth_west);
    
    MKMapPoint pointNorth_east = MKMapPointMake(MKMapRectGetMaxX(self->mapRect), MKMapRectGetMinY(self->mapRect)); //东北
    CLLocationCoordinate2D coordinateNorth_east = MKCoordinateForMapPoint(pointNorth_east);
    
    
    // Create the url to Googles geocoding API, we want the response to be in XML
    NSString* mapsUrl = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps/api/geocode/xml?address=%@&bounds=%.6f,%.6f|%.6f,%.6f&sensor=false",searchQuery,coordinateSouth_west.latitude,coordinateSouth_west.longitude,coordinateNorth_east.latitude,coordinateNorth_east.longitude];
    
    //NSLog(@"%@",mapsUrl);
    
    
    
    // Create the url object for our request. It's important to escape the 
    // search string to support spaces and international characters
    NSURL *url = [[NSURL alloc] initWithString:[mapsUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // Run the KML parser
    BSGoogleV3KmlParser *parser = [[BSGoogleV3KmlParser alloc] init];
    
    NSError *parseError = nil;
    [parser parseXMLFileAtURL:url parseError:&parseError ignoreAddressComponents:NO];
    
    [url release];
    [mapsUrl release];
    
    status = parser.statusCode;
    
    // If the query was successfull we store the array with results
    if(parser.statusCode == G_GEO_SUCCESS)
    {
        self.results = parser.results;
    }
    
    [parser release];
	
	
	
	
	if(parseError != nil)
	{
		
		if([delegate respondsToSelector:@selector(forwardGeocoderError:)])
		{
			[delegate performSelectorOnMainThread:@selector(forwardGeocoderError:) withObject:[parseError localizedDescription] waitUntilDone:NO];
		}
        
		/*
         if([delegate respondsToSelector:@selector(forwardGeocoder:error:)])
         {
         [delegate forwardGeocoder:self error:[parseError localizedDescription]];
         }*/
	}
	else {
		
		
		if([delegate respondsToSelector:@selector(forwardGeocoderFoundLocation)])
		{
			[delegate performSelectorOnMainThread:@selector(forwardGeocoderFoundLocation) withObject:nil waitUntilDone:NO];
		}
		/* 
         if([delegate respondsToSelector:@selector(forwardGeocoder:searchString:results:)])
         {
         [delegate forwardGeocoder:self searchString:self.searchQuery results:self.results];
         }*/
	}
	
	
	[pool release];
	
	
}


-(void)dealloc
{
	
	if(results != nil) {
		[results release];
	}
	
	[searchQuery release];
	[googleAPiKey release];
	
	[super dealloc];
}


@end
