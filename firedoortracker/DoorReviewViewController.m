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
#import "AddDoorReviewViewController.h"

//Import Model and API
#import "NetworkManager.h"
#import "CurrentUser.h"

//Import View
#import "InspectionCollectionViewCell.h"
#import "AddDoorReviewCollectionViewCell.h"
#import <SVProgressHUD.h>
#import <UIViewController+MJPopupViewController.h>

static NSString* inspectionCellIdentifier = @"InspectionCollectionViewCell";
static NSString* addInspectionCellIdentifier = @"AddDoorReviewCollectionViewCell";
static NSString* addDoorViewControllerIdentifier = @"AddDoorReviewViewController";

static NSString* showDoorInfoOverviewSegue = @"showDoorInfoOverviewSegueIdentifier";

static NSString* kUserInspections = @"inspections";
static NSString* kKeyword = @"keyword";

@interface DoorReviewViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate,  AddDoorReviewDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *noInspectionsLabel;

//User Data
@property (strong, nonatomic) Inspection* createdInspection;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

#pragma mark - display methods

- (void)displayCurrentUserInspections {
    self.inspectionsForDisplaying = [CurrentUser sharedInstance].userInscpetions;
    self.noInspectionsLabel.hidden = (self.inspectionsForDisplaying.count) ? YES : NO;
    [self.collectionView reloadData];
}

- (void)addRefreshControll {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    [refreshControl addTarget:self action:@selector(loadAndDisplayInspectionList:withKeyword:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    if (!self.inspectionsForDisplaying) [refreshControl beginRefreshing];
}

#pragma mark - API Methods
#pragma mark -

- (void)loadAndDisplayInspectionList:(UIRefreshControl *)sender withKeyword:(NSString *)keyword {
    [SVProgressHUD show];
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:InspectionListByUserRequestType
                                                  andParams:@{kKeyword : (keyword) ? : @""}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 [sender endRefreshing];
                                                 if (error) {
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [SVProgressHUD showSuccessWithStatus:nil];
                                                 [CurrentUser sharedInstance].userInscpetions = [[responseObject objectForKey:kUserInspections] allObjects];
                                                 welf.inspectionsForDisplaying = [CurrentUser sharedInstance].userInscpetions;
                                                 
                                                 //Move new inspection in beginning
                                                 if (welf.createdInspection) {
                                                     [welf openCreatedInspection:welf.createdInspection
                                                               inInspectionArray:welf.inspectionsForDisplaying];
                                                 }
                                                 
                                                 welf.noInspectionsLabel.hidden = (welf.inspectionsForDisplaying.count) ? YES : NO;
                                                 
                                                 [welf.collectionView reloadData];
                                             }];
    
}

#pragma mark - Support Data Methods
#pragma mark -

- (void)openCreatedInspection:(Inspection *)inspection inInspectionArray:(NSArray *)array {
    if (inspection && inspection.uid) {
        for(Inspection *insp in array) {
            if (inspection.uid.integerValue == insp.uid.integerValue) {
                self.selectedInspection = insp;
                [self performSegueWithIdentifier:showDoorInfoOverviewSegue sender:self];
            }
        }
    }
    self.createdInspection = nil;
}

#pragma mark - CollectionView
#pragma makk - Collection View Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.inspectionsForDisplaying.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AddDoorReviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addInspectionCellIdentifier
                                                                                          forIndexPath:indexPath];
        return cell;
    }
    
    InspectionCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:inspectionCellIdentifier
                                                                                   forIndexPath:indexPath];
    [cell displayInspection:[self.inspectionsForDisplaying objectAtIndex:indexPath.row - 1]];
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AddDoorReviewViewController *addDoorVC = [self.storyboard instantiateViewControllerWithIdentifier:addDoorViewControllerIdentifier];
        addDoorVC.view.frame = CGRectMake(self.view.bounds.size.width / 3.0f,
                                          self.view.bounds.size.height / 2.0f,
                                          self.view.bounds.size.width * 2.0f / 3.0f,
                                          self.view.bounds.size.height / 4.0f);
        addDoorVC.delegate = self;
        [self presentPopupViewController:addDoorVC animationType:MJPopupViewAnimationSlideTopTop];
        return;
    }
    
    self.selectedInspection = [self.inspectionsForDisplaying objectAtIndex:indexPath.row - 1];
    
    if ([self.inspectionSelectionDelegate respondsToSelector:@selector(inspectionSelected:doorReviewController:)]) {
        [self.inspectionSelectionDelegate inspectionSelected:self.selectedInspection
                                        doorReviewController:self];
        return;
    }
    
    [self performSegueWithIdentifier:showDoorInfoOverviewSegue sender:self];
}

#pragma mark - Search Bar Delegate
#pragma mark -

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self loadAndDisplayInspectionList:nil withKeyword:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self loadAndDisplayInspectionList:nil withKeyword:searchText];
}

#pragma mark - Segue delegate
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //TODO: Check for segue identifier
    DoorInfoOveriviewViewController *destionationVC = [segue destinationViewController];
    destionationVC.selectedInspection = self.selectedInspection;
}

#pragma mark - Add New Inspection Delegate

- (void)inspectionSuccessfullyCreated:(Inspection *)createdInspection {
    self.createdInspection = createdInspection;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    [self loadAndDisplayInspectionList:nil withKeyword:nil];
}

@end
