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
@end

@implementation RecentlyViewedPhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// When under the Tab-button controller, controllers started by tab button stay in memory, so if we want to update
// the NSUserdefaults for Recently Viewed Photos, we must update the photo list each time the view is going to appear on the screen

- (void)viewWillAppear:(BOOL)animated
{
    self.photoList = [[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY] mutableCopy];
    [self.tableView reloadData];
}


 - (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove item from list
        [self.photoList removeObjectAtIndex:indexPath.row];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //write to user defaults
        [defaults setObject:self.photoList forKey:FAVORITES_KEY];
        [defaults synchronize];
        
        // Delete the row from the data source (i.e. table)
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}
@end
