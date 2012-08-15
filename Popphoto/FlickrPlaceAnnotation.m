//
//  FlickrPlaceAnnotation.m
//  Popphoto
//
//  Created by Sanjaya Kumar on 8/15/12.
//  Copyright (c) 2012 Sanjaya Kumar. All rights reserved.
//

#import "FlickrFetcher.h"
#import "FlickrPlaceAnnotation.h"

@implementation FlickrPlaceAnnotation

@synthesize place = _place;

+ (FlickrPlaceAnnotation *) annotationForPlace:(NSDictionary *)place
{
    FlickrPlaceAnnotation *annotation = [[FlickrPlaceAnnotation alloc]init];
    annotation.place = place;
    return annotation;
}

#pragma mark - MKAnnotation

- (NSString *)title
{
    return [[[self.place objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
}

- (NSString *)subtitle
{
    return [[[self.place objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] objectAtIndex:0];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.place objectForKey:FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [[self.place objectForKey:FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}


@end
