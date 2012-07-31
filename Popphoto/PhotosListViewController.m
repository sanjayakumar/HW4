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

@interface PhotosListViewController ()
@end

@implementation PhotosListViewController


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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *photoInfo = [self.photoList objectAtIndex:indexPath.row];
    NSString *photoTitle = [photoInfo objectForKey:FLICKR_PHOTO_TITLE];
    NSString *photoDescription = [photoInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    if ([photoTitle isEqualToString:@""]){
        photoTitle = photoDescription;
        photoDescription = @"";
    }
    if ([photoTitle isEqualToString:@""]){
        photoTitle = @"Unknown";
    }
    
    cell.textLabel.text = photoTitle;
    cell.detailTextLabel.text = photoDescription;
    
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

// Note: prepareForSegue not called if the device is an iPad
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary * photoInfo = [self.photoList objectAtIndex:indexPath.row];
    
    [self addToFavorites:photoInfo];
    
    NSURL * photoURL = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge];
    NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    
    [segue.destinationViewController setActualImage: [UIImage imageWithData:photoData]];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [segue.destinationViewController setImageTitle : cell.textLabel.text];
}

// This function is called when the device is an iPad and the user selects a picture to display; not called for iPhone
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * photoInfo = [self.photoList objectAtIndex:indexPath.row];
    
    [self addToFavorites:photoInfo];
    
    NSURL * photoURL = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge];
    NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    
    id detailViewController = [[self.splitViewController viewControllers] lastObject];
   
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [detailViewController setImageTitle : cell.textLabel.text];

    [detailViewController setActualImage: [UIImage imageWithData:photoData]];
}

@end
