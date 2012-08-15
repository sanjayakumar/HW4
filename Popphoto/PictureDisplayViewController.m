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

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *toolbarTitle;
@property (nonatomic, strong)UIImage *actualImage;
@property (nonatomic, strong)NSString *imageTitle;
@end

@implementation PictureDisplayViewController
@synthesize fetchActivityIndicator = _fetchActivityIndicator;
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

- (void) debugLogs: (NSString *) msg
{
    NSLog(@"%@", msg);
    NSLog(@"Content Size %f %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    NSLog(@"ContentSize Aspect Ratio %f", self.scrollView.contentSize.width/self.scrollView.contentSize.height);
    NSLog(@"Screen Size Bounds %f %f", self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    NSLog(@"Photo size %f %f", self.imageView.image.size.width, self.imageView.image.size.height);
    NSLog(@"Screen Aspect Ratio %f", self.scrollView.bounds.size.width/self.scrollView.bounds.size.height);
    NSLog(@"Photo Aspect Ratio %f", self.imageView.image.size.width/self.imageView.image.size.height);
    NSLog(@"ZoomScale %f", self.scrollView.zoomScale);
   

}

- (void) displayImageWithZoomAndTitle
{
    CGRect scrollRect;
    self.scrollView.delegate = self;
    self.imageView.image = self.actualImage;
    self.scrollView.contentSize = self.imageView.image.size;
    self.scrollView.zoomScale = 1.0;
    
    //[self debugLogs:@"1"];
    float viewBoundsAspectRatio = self.scrollView.bounds.size.width/self.scrollView.bounds.size.height;
    float photoAspectRatio = self.imageView.image.size.width/self.imageView.image.size.height;
    
    if (photoAspectRatio < viewBoundsAspectRatio){
        scrollRect = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.width/viewBoundsAspectRatio);
    } else {
        scrollRect = CGRectMake(0, 0, self.imageView.image.size.height*viewBoundsAspectRatio, self.imageView.image.size.height);
    }
    
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    if (self.toolbar) {
        self.toolbarTitle.text = self.imageTitle;
    } else {
        self.navigationItem.title = self.imageTitle;
    }
    [self.scrollView zoomToRect:scrollRect animated:YES];
    
    //[self debugLogs:@"2"];
    
}

- (void) setImage:(UIImage *)image andTitle:(NSString *)title
{
    self.actualImage = image;
    self.imageTitle = title;
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
    [self setFetchActivityIndicator:nil];
    [super viewDidUnload];
}

@end
