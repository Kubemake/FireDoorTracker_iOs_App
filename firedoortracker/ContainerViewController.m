//
//  ContainerViewController.m
//  firedoortracker
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 chikipiki. All rights reserved.
//

#import "ContainerViewController.h"
#import "NiceTabBarView.h"

static NSString *const homeViewControllerSegueIdentifier = @"HomeViewControllerSegue";
static NSString *const doorReviewViewControllerSegueIdentifier = @"DoorReviewViewControllerSegue";
static NSString *const mediaViewControllerSegueIdentifier = @"MediaViewControllerSegue";
static NSString *const resourcesViewControllerSegueIdentifier = @"ResourcesViewControllerSegue";
static NSString *const segueViewControllerSegueIdentifier = @"SettingsViewController";

@interface ContainerViewController () <NiceTabBarViewDeleage>

@property (weak, nonatomic) IBOutlet NiceTabBarView *niceTabBarView;

@end

@implementation ContainerViewController

#pragma mark - HiceTabBarViewDelegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.niceTabBarView.delegate = self;
}

- (void)niceTabBarViewButtonPressed:(NiceTabBarButtonType)button
{
    if (button == NiceTabBarButtonTypeHome) {
        [self performSegueWithIdentifier:homeViewControllerSegueIdentifier sender:self];
    }
    else if (button == NiceTabBarButtonTypeDoorReview) {
        [self performSegueWithIdentifier:doorReviewViewControllerSegueIdentifier sender:self];
    }
    else if (button == NiceTabBarButtonTypeMedia) {
        [self performSegueWithIdentifier:mediaViewControllerSegueIdentifier sender:self];
    }
    else if (button == NiceTabBarButtonTypeResources) {
        [self performSegueWithIdentifier:resourcesViewControllerSegueIdentifier sender:self];
    }
    else if (button == NiceTabBarButtonTypeSettings) {
        [self performSegueWithIdentifier:segueViewControllerSegueIdentifier sender:self];
    }
    else if (button == NiceTabBarButtonTypeLogOut) {
#warning add logic for logout
    }
}

@end