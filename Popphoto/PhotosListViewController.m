//
//  SelectedPlacePhotosViewController.m
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
    NSString *photoTitle = [photoInfo objectForKey:@"title"];
    NSString *photoDescription = [photoInfo valueForKeyPath:@"description._content"];
    
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
    NSString * newPhotoId = [photoInfo objectForKey:@"id"];
    for (NSDictionary *currentPhoto in favorites)
    {
        if ([newPhotoId isEqualToString:[currentPhoto objectForKey:@"id"]]){
            return;
        }
    }
    if (!favorites) favorites = [NSMutableArray array];
    [favorites addObject:photoInfo];
    [defaults setObject:favorites forKey:FAVORITES_KEY];
    [defaults synchronize];
}

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

@end
