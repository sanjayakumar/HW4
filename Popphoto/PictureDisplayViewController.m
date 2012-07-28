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
    self.scrollView.delegate = self;
    self.imageView.image = self.actualImage;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.navigationItem.title = self.imageTitle;

    // testing
    
    NSLog(@"%@", self.imageTitle);
    
    NSLog(@"scrollview content size %f %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    NSLog(@"scrollview bounds size %f %f", self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    
    NSLog(@"imageview frame size %f %f", self.imageView.frame.size.width, self.imageView.frame.size.height);
    NSLog(@"imageview bounds size %f %f", self.imageView.bounds.size.width, self.imageView.bounds.size.height);
    
    CGRect visibleRect = [self.imageView convertRect:self.imageView.bounds toView:self.scrollView];
    NSLog(@"imageview frame in scrollview coordinates  %f %f", visibleRect.size.width, visibleRect.size.height);
    
    visibleRect = [self.imageView convertRect:self.imageView.frame toView:self.scrollView];
    NSLog(@"imageview bounds in scrollview coordinates  %f %f", visibleRect.size.width, visibleRect.size.height);
    
    [self.scrollView zoomToRect:self.imageView.frame animated:YES];
    
    NSLog(@" After zoom to rect");
    NSLog(@"scrollview content size %f %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    NSLog(@"scrollview bounds size %f %f", self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    
    NSLog(@"imageview frame size %f %f", self.imageView.frame.size.width, self.imageView.frame.size.height);
    NSLog(@"imageview bounds size %f %f", self.imageView.bounds.size.width, self.imageView.bounds.size.height);
    
    visibleRect = [self.imageView convertRect:self.imageView.bounds toView:self.scrollView];
    NSLog(@"imageview frame in scrollview coordinates  %f %f", visibleRect.size.width, visibleRect.size.height);
    
    visibleRect = [self.imageView convertRect:self.imageView.frame toView:self.scrollView];
    NSLog(@"imageview bounds in scrollview coordinates  %f %f", visibleRect.size.width, visibleRect.size.height);

    NSLog(@" ");
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
