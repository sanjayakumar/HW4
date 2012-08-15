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
#import "MapViewController.h"
#import "FlickrPlaceAnnotation.h"


@interface PopularPlacesTableViewController () <MapViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *countryList;
@end

#define MAX_PHOTOS_FROM_PLACE 50 // set by Assignment 4 instructions

@implementation PopularPlacesTableViewController
- (IBAction)refresh:(UIBarButtonItem *)sender {
{
        // might want to use introspection to be sure sender is UIBarButtonItem
        // (if not, it can skip the spinner)
        // that way this method can be a little more generic
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSArray *topPlaces = [FlickrFetcher topPlaces];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.leftBarButtonItem = sender;
                self.topPlaces = topPlaces;
            });
        });
        dispatch_release(downloadQueue);
    }

}

- (void) setTopPlaces:(NSArray *)topPlaces
{
    if (_topPlaces != topPlaces){
        _topPlaces = topPlaces;
        // update country list since topPlace list has changed
        self.countryList = nil;
        [self countryList];
        // Model changed, so update our View (the table)
        if (self.tableView.window) [self.tableView reloadData];
    }
}

- (NSMutableArray *)countryList
{
    // We organize Top Places by country (Extra Credit)
    if (!_countryList){
        _countryList = [[NSMutableArray alloc]init];
        NSDictionary * topPlace;
        NSMutableOrderedSet * countryNames = [[NSMutableOrderedSet alloc]init]; // used only temporarily in this function
        NSUInteger countryIndex;
        
        for (topPlace in self.topPlaces){
            NSString *placeCountry = [[[topPlace objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
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
    return [[[topPlace objectForKey:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Place Title";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *topPlace = [[self.countryList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSString *placeName = [topPlace objectForKey:FLICKR_PLACE_NAME];
    NSArray *placeNameItems = [placeName componentsSeparatedByString:@", "];
    cell.textLabel.text = [placeNameItems objectAtIndex:0];
    NSRange secondToEnd;
    secondToEnd.location = 1;
    secondToEnd.length = [placeNameItems count] - 2; // Don't show country in cell since it is the section header
    cell.detailTextLabel.text = [[placeNameItems subarrayWithRange:secondToEnd] componentsJoinedByString:@", "];
    
    return cell;
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc]init];
    NSDictionary * topPlace;
    
    for (topPlace in [FlickrFetcher topPlaces]){
        [annotations addObject:[FlickrPlaceAnnotation annotationForPlace:topPlace]];
    }
    return annotations;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // segue to map
    if ([segue.destinationViewController isKindOfClass:[MapViewController class]]){
        MapViewController *mapVC = segue.destinationViewController;
        mapVC.annotations = [self mapAnnotations];
        mapVC.delegate = self;
        NSLog(@"Map button pressed");
        return;
    }
    
    NSDictionary * topPlace;
    
    // segue to place specific table view
    if ([sender isKindOfClass: [FlickrPlaceAnnotation class]])
    {
        // segueing because user touched call out on place map
        FlickrPlaceAnnotation * placeAnnotation = sender;
        topPlace = placeAnnotation.place;
    } else {
        // segueing because user selected row in table
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        topPlace = [[self.countryList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    NSArray *PhotoList = [FlickrFetcher photosInPlace:topPlace maxResults:MAX_PHOTOS_FROM_PLACE];
    [segue.destinationViewController setPhotoList:[PhotoList mutableCopy]];
}

#pragma mark - MapViewControllerDelegate

- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    return nil; // no thumbnail image for Top Photo Place
}

- (void) annotationCallOutAction:(id<MKAnnotation>)annotation
{
    [self performSegueWithIdentifier:@"Place Photo List Segue" sender:annotation];
}



@end
