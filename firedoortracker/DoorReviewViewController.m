//
//  SecondViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

//Import Controller
#import "DoorReviewViewController.h"
#import "DoorInfoOveriviewViewController.h"

//Import Model and API
#import "NetworkManager.h"
#import "CurrentUser.h"

//Import View
#import "InspectionCollectionViewCell.h"

static NSString* inspectionCellIdentifier = @"InspectionCollectionViewCell";
static NSString* showDoorInfoOverviewSegue = @"showDoorInfoOverviewSegueIdentifier";

static NSString* kUserInspections = @"inspections";

@interface DoorReviewViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//User Data
@property (strong, nonatomic) NSArray* inspectionsForDisplaying;
@property (weak, nonatomic) Inspection* selectedInspection;

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
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(refreshInspectionList:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
}

#pragma mark - API Methods
#pragma mark -

- (void)refreshInspectionList:(UIRefreshControl *)sender {
    [[NetworkManager sharedInstance] performRequestWithType:InspectionListByUserRequestType
                                                  andParams:@{}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 [sender endRefreshing];
                                                 if (error) {
                                                     //TODO: Display Error
                                                     return;
                                                 }
                                                 [CurrentUser sharedInstance].userInscpetions = [responseObject objectForKey:kUserInspections];
                                             }];
    
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
    self.selectedInspection = [self.inspectionsForDisplaying objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:showDoorInfoOverviewSegue sender:self];
}

#pragma mark - Segue delegate
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //TODO: Check for segue identifier
    DoorInfoOveriviewViewController *destionationVC = [segue destinationViewController];
    destionationVC.selectedInspection = self.selectedInspection;
}

@end
