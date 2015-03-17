//
//  SecondViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import "DoorReviewViewController.h"

//Import Model and API
#import "NetworkManager.h"
#import "CurrentUser.h"

//Import View
#import "InspectionCollectionViewCell.h"

static NSString* inspectionCellIdentifier = @"InspectionCollectionViewCell";

@interface DoorReviewViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//User Data
@property (strong, nonatomic) NSArray* inspectionsForDisplaying;

@end

@implementation DoorReviewViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayCurrentUserInspections];
    [self addRefreshControll];
}

#pragma mark - display methods

- (void)displayCurrentUserInspections {
    self.inspectionsForDisplaying = [CurrentUser sharedInstance].userInscpetions;
    [self.collectionView reloadData];
}

- (void)addRefreshControll {
    
}

#pragma mark - API Methods
#pragma mark -

- (void)refreshInspectionList {
}

#pragma mark - CollectionView
#pragma makk - Collection View Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.inspectionsForDisplaying.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InspectionCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:inspectionCellIdentifier
                                                                                   forIndexPath:indexPath];
    [cell displayInspection:[self.inspectionsForDisplaying objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
