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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *fetchActivityIndicator;

- (void) setImage: (UIImage *)image andTitle: (NSString *)title;

@end
#define FAVORITES_KEY @"popPhotoAppUserViewed.Favorites"
