//
//  PopularPlacesTableViewController.m
//  Popphoto
//
//  Created by Sanjaya Kumar on 7/26/12.
//  Copyright (c) 2012 Sanjaya Kumar. All rights reserved.
//

#import "PopularPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotosListViewController.h"


@interface PopularPlacesTableViewController ()
@property (nonatomic, strong)  NSArray * topPlacesList;
@end

#define MAX_PHOTOS_FROM_PLACE 50 // set by Assignment 4 instructions

@implementation PopularPlacesTableViewController

- (NSArray *)topPlacesList
{
    if (!_topPlacesList){
        _topPlacesList = [FlickrFetcher topPlaces];
    }
    return _topPlacesList;
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
// Comment out this method for now because only one section. May need this later if grouping by countries
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topPlacesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Place Title";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *placeName = [[self.topPlacesList objectAtIndex:indexPath.row] objectForKey:@"_content"];
    NSArray *placeNameItems = [placeName componentsSeparatedByString:@", "];
    cell.textLabel.text = [placeNameItems objectAtIndex:0];
    NSRange secondToEnd;
    secondToEnd.location = 1;
    secondToEnd.length = [placeNameItems count] - 1;
    cell.detailTextLabel.text = [[placeNameItems subarrayWithRange:secondToEnd] componentsJoinedByString:@", "];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [segue.destinationViewController setPhotoList: [FlickrFetcher photosInPlace:[self.topPlacesList objectAtIndex:indexPath.row] maxResults:MAX_PHOTOS_FROM_PLACE] ];
}

@end
