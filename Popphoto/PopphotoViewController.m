//
//  PopphotoViewController.m
//  Popphoto
//
//  Created by Sanjaya Kumar on 7/25/12.
//  Copyright (c) 2012 Sanjaya Kumar. All rights reserved.
//

#import "PopphotoViewController.h"
#import "FlickrFetcher.h"
#import "PictureDisplayViewController.h"

@interface PopphotoViewController ()
@end

@implementation PopphotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSArray *topPlacesList= [FlickrFetcher topPlaces];
    NSLog(@"%@", topPlacesList);
    
    NSArray *topPhotosInPlaceList = [FlickrFetcher photosInPlace:[topPlacesList objectAtIndex:0] maxResults:5];
    
    NSDictionary *singlePhoto = [topPhotosInPlaceList objectAtIndex:0];
    
    NSLog(@"%@", singlePhoto);
    // Log the description field of this photo
    NSLog(@"%@", [singlePhoto valueForKeyPath:@"description._content"]);
    
    NSURL *photoURL = [FlickrFetcher urlForPhoto:singlePhoto format:FlickrPhotoFormatLarge];
    NSLog(@"%@", photoURL);
    
    NSData *imageData = [NSData dataWithContentsOfURL:photoURL];

    [segue.destinationViewController setActualImage:[UIImage imageWithData:imageData]];
}

@end
