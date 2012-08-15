//
//  PhotosListViewController.m
//  Popphoto
//
//  Created by Sanjaya Kumar on 7/26/12.
//  Copyright (c) 2012 Sanjaya Kumar. All rights reserved.
//

#import "PhotosListViewController.h"
#import "FlickrFetcher.h"
#import "PictureDisplayViewController.h"
#import "MapViewController.h"
#import "FlickrPhotoAnnotation.h"

@interface PhotosListViewController () <MapViewControllerDelegate>
@end

@implementation PhotosListViewController
@synthesize listFetcherActivityIndicator;

- (void)setPhotoList:(NSMutableArray *)photoList
{
    _photoList = photoList;
    if (self.tableView.window)[self.tableView reloadData];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoList.count;
}

- (NSString *)getPhotoTitle: (NSDictionary *) photoInfo
{
    NSString *photoTitle = [photoInfo objectForKey:FLICKR_PHOTO_TITLE];
    
    if ([photoTitle isEqualToString:@""]){
        photoTitle = [photoInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    }
    if ([photoTitle isEqualToString:@""]){
        photoTitle = @"Unknown";
    }
    return photoTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *photoInfo = [self.photoList objectAtIndex:indexPath.row];
    cell.textLabel.text = [self getPhotoTitle:photoInfo];
    cell.detailTextLabel.text = [photoInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([cell.textLabel.text isEqualToString:cell.detailTextLabel.text]) cell.detailTextLabel.text = @"";
    
    return cell;
}

- (void)addToFavorites: (NSDictionary *)photoInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorites = [[defaults objectForKey:FAVORITES_KEY] mutableCopy];
    
    // If photo already in favorites, don't add a duplicate copy 
    NSString * newPhotoId = [photoInfo objectForKey:FLICKR_PHOTO_ID];
    for (NSDictionary *currentPhoto in favorites)
    {
        if ([newPhotoId isEqualToString:[currentPhoto objectForKey:FLICKR_PHOTO_ID]]){
            return;
        }
    }
    if (!favorites) favorites = [NSMutableArray array];
    [favorites addObject:photoInfo];
    [defaults setObject:favorites forKey:FAVORITES_KEY];
    [defaults synchronize];
}


- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photoList count]];
    for (NSDictionary *photo in self.photoList) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[MapViewController class]]){
        // Segueing to Map view in splitView Master
        MapViewController *mapVC = segue.destinationViewController;
        mapVC.annotations = [self mapAnnotations];
        mapVC.delegate = self;
    } else {
 /*       // iphone only -- segueing to Photo view
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary * photoInfo = [self.photoList objectAtIndex:indexPath.row];
    
        [self addToFavorites:photoInfo];
    
        NSURL * photoURL = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge];
        NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    
    //[segue.destinationViewController setActualImage: [UIImage imageWithData:photoData]];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
     //   [segue.destinationViewController setImageTitle : cell.textLabel.text];*/
    }
}

// This function is called when the device is an iPad and the user selects a picture to display from a Table Entry; not called for iPhone
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * photoInfo = [self.photoList objectAtIndex:indexPath.row];
    
    [self displayPhoto:photoInfo onController: [[self.splitViewController viewControllers] lastObject]];
}

- (void) displayPhoto: (NSDictionary *)photoInfo onController: (PictureDisplayViewController *)viewController
{
    [self addToFavorites:photoInfo];
    
    [viewController.scrollView bringSubviewToFront:viewController.fetchActivityIndicator];
    [viewController.fetchActivityIndicator startAnimating];

    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
 
        NSURL * photoURL = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge];
        //DEBUGGING!
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController.fetchActivityIndicator stopAnimating];
            [viewController setImage: [UIImage imageWithData:photoData] andTitle:[self getPhotoTitle:photoInfo]];
        });
    });
    dispatch_release(downloadQueue);
    
}

#pragma mark - MapViewControllerDelegate

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data ? [UIImage imageWithData:data] : nil;
}

- (void) annotationCallOutAction:(id<MKAnnotation>)annotation
{
    FlickrPhotoAnnotation * flikrAnnotation = annotation;
    NSDictionary * photoInfo = flikrAnnotation.photo;
    [self displayPhoto:photoInfo onController: [[self.splitViewController viewControllers] lastObject]];
}

- (void)viewDidUnload {
    [self setListFetcherActivityIndicator:nil];
    [super viewDidUnload];
}
@end
