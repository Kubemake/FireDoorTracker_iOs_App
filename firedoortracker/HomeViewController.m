//
//  FirstViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import "NiceTabBarView.h"
#import "ContainerViewController.h"
#import "HomeMenuCollectionViewCell.h"
#import "HomeViewController.h"
#import "ContactExpertViewController.h"

typedef enum{
    homeMenuItemDoorReview = 0,
    homeMenuItemContactAnExpert,
    homeMenuItemMedia,
    homeMenuItemResources,
    homeMenuItemUserSettings,
    homeMenuItemLogOut,
    homeMenuItemCount
}homeMenuItem;

static NSString* homeCellIdentifier = @"HomeMenuCollectionViewCell";

@interface HomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HomeViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - CollectionView
#pragma makk - Collection View Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return homeMenuItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeCellIdentifier
                                                                                 forIndexPath:indexPath];
    switch (indexPath.row) {
        case homeMenuItemDoorReview:
            [cell displayWithIcon:[UIImage imageNamed:@"buildingReview"]
                         andTitle:NSLocalizedString(@"DOOR REVIEW", nil)];
            break;
        case homeMenuItemContactAnExpert:
            [cell displayWithIcon:[UIImage imageNamed:@"contactAnExpert"]
                         andTitle:NSLocalizedString(@"CONTACT AN EXPERT", nil)];
            break;
        case homeMenuItemMedia:
            [cell displayWithIcon:[UIImage imageNamed:@"userFiles"]
                         andTitle:NSLocalizedString(@"MEDIA", nil)];
            break;
        case homeMenuItemResources:
            [cell displayWithIcon:[UIImage imageNamed:@"onlineDoorData"]
                         andTitle:NSLocalizedString(@"RESOURCES", nil)];
            break;
        case homeMenuItemUserSettings:
            [cell displayWithIcon:[UIImage imageNamed:@"userSettings"]
                         andTitle:NSLocalizedString(@"USER SETTINGS", nil)];
            break;
        case homeMenuItemLogOut:
            [cell displayWithIcon:[UIImage imageNamed:@"signOut"]
                         andTitle:NSLocalizedString(@"LOG OUT", nil)];
            break;

    }
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *navController = (UINavigationController *)self.parentViewController;
    ContainerViewController *parentViewController = (ContainerViewController *)navController.parentViewController;
    
    switch (indexPath.row) {
        case homeMenuItemDoorReview: {
            [parentViewController.niceTabBarView setSelectedButton:1];
            [parentViewController performSegueWithIdentifier:doorReviewViewControllerSegueIdentifier
                                                      sender:parentViewController];
        }
            break;
        case homeMenuItemContactAnExpert: {
            ContactExpertViewController *contactExpertViewController = [ContactExpertViewController new];
            [self.navigationController pushViewController:contactExpertViewController animated:YES];
        }
            break;
        case homeMenuItemMedia: {
            [parentViewController.niceTabBarView setSelectedButton:2];
            [parentViewController performSegueWithIdentifier:mediaViewControllerSegueIdentifier
                                                      sender:parentViewController];
        }
            break;
        case homeMenuItemResources: {
            [parentViewController.niceTabBarView setSelectedButton:3];
            [parentViewController performSegueWithIdentifier:resourcesViewControllerSegueIdentifier
                                                      sender:parentViewController];
        }
            break;
        case homeMenuItemUserSettings: {
            [parentViewController.niceTabBarView setSelectedButton:4];
            [parentViewController performSegueWithIdentifier:settingsViewControllerSegueIdentifier
                                                      sender:parentViewController];
        }
            break;
        case homeMenuItemLogOut: {
            [parentViewController.niceTabBarView setSelectedButton:5];
            [parentViewController performSegueWithIdentifier:loginViewControllerSegueIdentifier
                                                      sender:parentViewController];
        }
            break;
    }
}

@end