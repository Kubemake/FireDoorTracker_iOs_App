//
//  FirstViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import "HomeViewController.h"

//Import View
#import "HomeMenuCollectionViewCell.h"

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
                         andTitle:NSLocalizedString(@"LOGOUT OUT", nil)];
            break;

    }
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case homeMenuItemDoorReview:
            [self.tabBarController setSelectedIndex:1];
            break;
        case homeMenuItemContactAnExpert:
            //TODO: display contacts
            break;
        case homeMenuItemMedia:
        case homeMenuItemResources:
        case homeMenuItemUserSettings:
        case homeMenuItemLogOut:
            [self.tabBarController setSelectedIndex:indexPath.row];
            break;
    }
}

@end
