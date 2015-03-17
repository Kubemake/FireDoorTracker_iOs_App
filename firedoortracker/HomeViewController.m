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
    homeMenuItemBuildingReview = 0,
    homeMenuItemOnlineDoorData,
    homeMenuItemUserFiles,
    homeMenuItemBuildingOwners,
    homeMenuItemBuilding,
    homeMenuItemSignOut,
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
        case homeMenuItemBuildingReview:
            [cell displayWithIcon:[UIImage imageNamed:@"buildingReview"]
                         andTitle:NSLocalizedString(@"BUILDING REVIEW", nil)];
            break;
        case homeMenuItemOnlineDoorData:
            [cell displayWithIcon:[UIImage imageNamed:@"onlineDoorData"]
                         andTitle:NSLocalizedString(@"ONLINE DOORDATA", nil)];
            break;
        case homeMenuItemUserFiles:
            [cell displayWithIcon:[UIImage imageNamed:@"userFiles"]
                         andTitle:NSLocalizedString(@"USER FILES", nil)];
            break;
        case homeMenuItemBuildingOwners:
            [cell displayWithIcon:[UIImage imageNamed:@"buildngOwners"]
                         andTitle:NSLocalizedString(@"BUILDING OWNERS", nil)];
            break;
        case homeMenuItemBuilding:
            [cell displayWithIcon:[UIImage imageNamed:@"buildings"]
                         andTitle:NSLocalizedString(@"BUILDINGS", nil)];
            break;
        case homeMenuItemSignOut:
            [cell displayWithIcon:[UIImage imageNamed:@"signOut"]
                         andTitle:NSLocalizedString(@"SIGN OUT", nil)];
            break;

    }
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
