//
//  PhotosListViewController.h
//  Popphoto
//
//  Created by Sanjaya Kumar on 7/26/12.
//  Copyright (c) 2012 Sanjaya Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosListViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray * photoList;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *listFetcherActivityIndicator;

@end
