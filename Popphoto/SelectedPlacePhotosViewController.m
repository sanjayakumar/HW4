//
//  SelectedPlacePhotosViewController.m
//  Popphoto
//
//  Created by Sanjaya Kumar on 7/26/12.
//  Copyright (c) 2012 Sanjaya Kumar. All rights reserved.
//

#import "SelectedPlacePhotosViewController.h"
#import "FlickrFetcher.h"
#import "PictureDisplayViewController.h"

@interface SelectedPlacePhotosViewController ()
@property (nonatomic, strong) NSArray * selectedPlacePhotoList;
@end

@implementation SelectedPlacePhotosViewController

#define MAX_PHOTOS_FROM_PLACE 50 // set by Assignment 4 instructions

- (NSArray *)selectedPlacePhotoList
{
    if (!_selectedPlacePhotoList){
        _selectedPlacePhotoList = [FlickrFetcher photosInPlace:self.selectedPlace maxResults:MAX_PHOTOS_FROM_PLACE];
    }
    return _selectedPlacePhotoList;
}

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
 
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return self.selectedPlacePhotoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.selectedPlacePhotoList objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Need to revisit this when implementing iPad version since the storyboard will be different
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    PictureDisplayViewController *detailViewController = [storyBoard instantiateViewControllerWithIdentifier:@"Photo Viewer"];
    
    NSDictionary * photoInfo = [self.selectedPlacePhotoList objectAtIndex:indexPath.row];
    
    [self addToFavorites:photoInfo];
    
    NSURL * photoURL = [FlickrFetcher urlForPhoto:photoInfo format:FlickrPhotoFormatLarge];
    NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    
    detailViewController.actualImage = [UIImage imageWithData:photoData];
    [self.navigationController pushViewController:detailViewController animated:YES];

}

@end
