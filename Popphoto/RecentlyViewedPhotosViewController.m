//
//  RecentlyViewedPhotosViewController.m
//  Popphoto
//
//  Created by Sanjaya Kumar on 7/27/12.
//  Copyright (c) 2012 Sanjaya Kumar. All rights reserved.
//

#import "RecentlyViewedPhotosViewController.h"
#import "FlickrFetcher.h"
#import "PictureDisplayViewController.h"


@interface RecentlyViewedPhotosViewController ()
@property (nonatomic, strong)NSMutableArray *favoritesPhotoList;
@end

@implementation RecentlyViewedPhotosViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// When under the Tab-button controller, controllers started by tab button stay in memory, so if we want to update
// the NSUserdefaults for Recently Viewed Photos, we must update the photo list each time the view is going to appear on the screen

- (void)viewWillAppear:(BOOL)animated
{
    self.favoritesPhotoList = [[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY] mutableCopy];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source
/*
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 #warning Potentially incomplete method implementation.
 // Return the number of sections.
 return 0;
 } */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.favoritesPhotoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Favorite Photos List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *photoInfo = [self.favoritesPhotoList objectAtIndex:indexPath.row];
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

    
    return cell;
}

 - (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove item from list
        [self.favoritesPhotoList removeObjectAtIndex:indexPath.row];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //write to user defaults
        [defaults setObject:self.favoritesPhotoList forKey:FAVORITES_KEY];
        [defaults synchronize];
        
        // Delete the row from the data source (i.e. table)
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary * photoInfo = [self.favoritesPhotoList objectAtIndex:indexPath.row];
    
    NSURL * photoURL = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge];
    NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    
    [segue.destinationViewController setActualImage: [UIImage imageWithData:photoData]];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [segue.destinationViewController setImageTitle : cell.textLabel.text];
}

@end
