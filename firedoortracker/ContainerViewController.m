//
//  ContainerViewController.m
//  firedoortracker
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 chikipiki. All rights reserved.
//

#import "ContainerViewController.h"
#import "NiceTabBarView.h"

static NSString *const HomeViewControllerSegueIdentifier = @"";
static NSString *const DoorReviewViewControllerSegueIdentifier = @"";
static NSString *const MediaViewControllerSegueIdentifier = @"";
static NSString *const ResourcesViewControllerSegueIdentifier = @"";
static NSString *const SegueViewControllerSegueIdentifier = @"";

@interface ContainerViewController () <NiceTabBarViewDeleage>
@end

@implementation ContainerViewController

#pragma mark - HiceTabBarViewDelegate

- (void)niceTabBarViewButtonPressed:(NiceTabBarButtonType)button
{
    if (button == NiceTabBarButtonTypeHome) {
//        [self seg]
    }
}

@end