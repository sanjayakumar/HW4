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
@property (nonatomic, strong) NSMutableArray *countryList;
@end

#define MAX_PHOTOS_FROM_PLACE 50 // set by Assignment 4 instructions

@implementation PopularPlacesTableViewController

- (NSMutableArray *)countryList
{
    // We get the topPlaces from Flikr and organize them by country (Extra Credit)
    if (!_countryList){
        _countryList = [[NSMutableArray alloc]init];
        NSDictionary * topPlace;
        NSMutableOrderedSet * countryNames = [[NSMutableOrderedSet alloc]init]; // used only temporarily in this function
        NSUInteger countryIndex;
        
        for (topPlace in [FlickrFetcher topPlaces]){
            NSString *placeCountry = [[[topPlace objectForKey:@"_content"] componentsSeparatedByString:@", "] lastObject];
            countryIndex = [countryNames indexOfObject:placeCountry];
            if (countryIndex == NSNotFound){
                // If this is the first time we see this country, add it to the list of countries
                // Note: distinction between countryName and countryList -- countryName is a set of country names; countryList is an array of arrays.
                [countryNames addObject:placeCountry];
                countryIndex = [countryNames indexOfObject:placeCountry];
                NSMutableArray * countryPlaceList = [[NSMutableArray alloc]init];
                [_countryList insertObject:countryPlaceList atIndex: countryIndex];
            }
            [[_countryList objectAtIndex:countryIndex]addObject: topPlace];
        }
    }
    return _countryList;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.countryList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.countryList objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *topPlace = [[self.countryList objectAtIndex:section] objectAtIndex:0];
    return [[[topPlace objectForKey:@"_content"] componentsSeparatedByString:@", "] lastObject];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Place Title";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *topPlace = [[self.countryList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSString *placeName = [topPlace objectForKey:@"_content"];
    NSArray *placeNameItems = [placeName componentsSeparatedByString:@", "];
    cell.textLabel.text = [placeNameItems objectAtIndex:0];
    NSRange secondToEnd;
    secondToEnd.location = 1;
    secondToEnd.length = [placeNameItems count] - 2; // Don't show country in cell since it is the section header
    cell.detailTextLabel.text = [[placeNameItems subarrayWithRange:secondToEnd] componentsJoinedByString:@", "];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *topPlace = [[self.countryList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSArray *PhotoList = [FlickrFetcher photosInPlace:topPlace maxResults:MAX_PHOTOS_FROM_PLACE];
    [segue.destinationViewController setPhotoList:[PhotoList mutableCopy]];
}

@end
