//
//  PictureDisplayViewController.m
//  Popphoto
//
//  Created by Sanjaya Kumar on 7/25/12.
//  Copyright (c) 2012 Sanjaya Kumar. All rights reserved.
//

#import "PictureDisplayViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface PictureDisplayViewController () <UIScrollViewDelegate, SplitViewBarButtonItemPresenter>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *toolbarTitle;
@end

@implementation PictureDisplayViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize toolbar = _toolbar;
@synthesize toolbarTitle = _toolbarTitle;
@synthesize actualImage = _actualImage;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) displayImageWithZoomAndTitle
{
    self.scrollView.delegate = self;
    self.imageView.image = self.actualImage;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    if (self.toolbar) {
        self.toolbarTitle.text = self.imageTitle;
    } else {
        self.navigationItem.title = self.imageTitle;
    }
    [self.scrollView zoomToRect:self.imageView.frame animated:YES];
}

- (void) setActualImage:(UIImage *)actualImage
{
    _actualImage = actualImage;
    [self displayImageWithZoomAndTitle];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self displayImageWithZoomAndTitle];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem){
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [self setToolbar:nil];
    [self setToolbarTitle:nil];
    [super viewDidUnload];
}

@end
