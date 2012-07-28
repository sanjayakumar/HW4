//
//  PictureDisplayViewController.m
//  Popphoto
//
//  Created by Sanjaya Kumar on 7/25/12.
//  Copyright (c) 2012 Sanjaya Kumar. All rights reserved.
//

#import "PictureDisplayViewController.h"

@interface PictureDisplayViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PictureDisplayViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize actualImage = _actualImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.scrollView.delegate = self;
    self.imageView.image = self.actualImage;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.navigationItem.title = self.imageTitle;
    [self.scrollView zoomToRect:self.imageView.frame animated:YES];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

@end
