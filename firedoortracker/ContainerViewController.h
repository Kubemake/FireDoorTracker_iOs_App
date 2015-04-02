//
//  ContainerViewController.h
//  firedoortracker
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 chikipiki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoconutKit.h"   
#import "NiceTabBarView.h"

static NSString *const homeViewControllerSegueIdentifier = @"HomeViewControllerSegue";
static NSString *const doorReviewViewControllerSegueIdentifier = @"DoorReviewViewControllerSegue";
static NSString *const mediaViewControllerSegueIdentifier = @"MediaViewControllerSegue";
static NSString *const resourcesViewControllerSegueIdentifier = @"ResourcesViewControllerSegue";
static NSString *const contactAnExpertControllerSegueIdentifier = @"showContactAnExpertSegue";
static NSString *const settingsViewControllerSegueIdentifier = @"SettingsViewController";
static NSString *const loginViewControllerSegueIdentifier = @"loginViewControllerSegueIdentifier";

@interface ContainerViewController : HLSPlaceholderViewController

@property (weak, nonatomic, readonly) IBOutlet NiceTabBarView *niceTabBarView;

@end