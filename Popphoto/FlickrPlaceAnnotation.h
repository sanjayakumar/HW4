//
//  FlickrPlaceAnnotation.h
//  Popphoto
//
//  Created by Sanjaya Kumar on 8/15/12.
//  Copyright (c) 2012 Sanjaya Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface FlickrPlaceAnnotation : NSObject <MKAnnotation>

+ (FlickrPlaceAnnotation *) annotationForPlace:(NSDictionary *)place; 

@property (nonatomic, strong)NSDictionary *place;
@end
