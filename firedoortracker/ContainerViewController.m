//
//  ContainerViewController.m
//  firedoortracker
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 chikipiki. All rights reserved.
//

#import "ContainerViewController.h"

//Import Extension
#import "UINavigationController+FireDoorTrackerOptions.h"

static NSString *const segueRestorationStateIdentidier = @"segueRestorationStateIdentidier";

@interface ContainerViewController () <NiceTabBarViewDeleage>

@property (weak, nonatomic, readwrite) IBOutlet NiceTabBarView *niceTabBarView;

//View Controllers Storage
@property (nonatomic, strong) NSMutableArray *displayedControllers;
@property (nonatomic, assign) NiceTabBarButtonType selectedType;

@end

@implementation ContainerViewController

#pragma mark - HiceTabBarViewDelegate

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.niceTabBarView.delegate = self;
    self.displayedControllers = [NSMutableArray array];
}

- (void)niceTabBarViewButtonPressed:(NiceTabBarButtonType)button {
    self.selectedType = button;
    //TODO: If Controller cached, display that
    UIViewController *cachedVC = [self cachedViewControllerByType:button];
    //HOTFIX: Instead Home VC (crash)
    if (cachedVC && button != NiceTabBarButtonTypeHome) {
        HLSPlaceholderInsetStandardSegue *displaySegue = [[HLSPlaceholderInsetStandardSegue alloc] initWithIdentifier:segueRestorationStateIdentidier
                                                                                                               source:self
                                                                                                          destination:cachedVC
                                                                                                      transitionClass:[HLSTransitionNone class]];
        [self prepareForSegue:displaySegue sender:self];
        [displaySegue perform];
        return;
    }
    
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
    else if (button == NiceTabBarButtonTypeContactAnExpert) {
        [self performSegueWithIdentifier:contactAnExpertControllerSegueIdentifier sender:self];
    }
    else if (button == NiceTabBarButtonTypeSettings) {
        [self performSegueWithIdentifier:settingsViewControllerSegueIdentifier sender:self];
    }
    else if (button == NiceTabBarButtonTypeLogOut) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userInfoKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:loginViewControllerSegueIdentifier sender:self];
    }
}

- (UIViewController *)cachedViewControllerByType:(NiceTabBarButtonType)type {
    for (UINavigationController_FireDoorTrackerOptions *navController in self.displayedControllers) {
        if (navController.typeOfNavigationFlow == type) {
            return navController;
        }
    }
    return nil;
}

#pragma mark - Segue Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController_FireDoorTrackerOptions *destinationVC = segue.destinationViewController;

    if (![self.displayedControllers containsObject:destinationVC]) {
        [self.displayedControllers addObject:segue.destinationViewController];
    }
    
    if ([destinationVC respondsToSelector:@selector(setTypeOfNavigationFlow:)]) {
        destinationVC.typeOfNavigationFlow = self.selectedType;
    }
}

@end