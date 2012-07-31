//
//  PictureDisplayViewController.h
//  Popphoto
//
//  Created by Sanjaya Kumar on 7/25/12.
//  Copyright (c) 2012 Sanjaya Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatableViewController.h"

@interface PictureDisplayViewController : RotatableViewController;
@property (nonatomic, strong)UIImage *actualImage;
@property (nonatomic, strong)NSString *imageTitle;

@end
#define FAVORITES_KEY @"popPhotoAppUserViewed.Favorites"
