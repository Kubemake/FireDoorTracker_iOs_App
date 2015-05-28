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
static NSString* kInspectionId = @"inspection_id";
static NSString* kApertireId = @"aperture_id";
static NSString* kKeyword = @"keyword";

@interface DoorReviewViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate,  AddDoorReviewDelegate, InspectionCollectionViewCellDelegate, DoorInfoOveriviewViewControllerDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *noInspectionsLabel;
@property (assign, nonatomic) BOOL editingMode;

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
    [cell displayInspection:[self.inspectionsForDisplaying objectAtIndex:indexPath.row - 1] editingMode:self.editingMode];
    cell.delegate = self;
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
                                          self.view.bounds.size.height / 2.0f);
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
    destionationVC.delegate = self;
}

#pragma mark - Add New Inspection Delegate

- (void)inspectionSuccessfullyCreated:(Inspection *)createdInspection {
    self.createdInspection = createdInspection;
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    [self loadAndDisplayInspectionList:nil withKeyword:nil];
}

#pragma mark - Update Inspection method

- (void)updateInspection:(Inspection *)updatedInspection {
    for (Inspection *insp in self.inspectionsForDisplaying) {
        if (insp.uid.integerValue == updatedInspection.uid.integerValue) {
            insp.colorStatus = updatedInspection.colorStatus;
            insp.barCode = updatedInspection.barCode;
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - IBActions
#pragma mark -

- (IBAction)editButtonTouched:(id)sender {
    self.editingMode = !self.editingMode;
    [self.collectionView reloadData];
}

#pragma mark - InspectionCollectionViewCellDelegate
#pragma mark -

- (void)inspectionCollectionViewCell:(UICollectionViewCell *)cell userTouchedDeleteButton:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    Inspection *inspectionForDelete = (Inspection *)[self.inspectionsForDisplaying objectAtIndex:indexPath.row-1];
    [self presentDeleteReviewDialog:inspectionForDelete];
}

- (void)presentDeleteReviewDialog:(Inspection *)inspection {
    UIAlertController *deleteController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Delete", nil)
                                                                              message:[NSString stringWithFormat:@"Are you sure you want to permanently delete this review?"]
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil)
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             __weak typeof(self) welf = self;
                                                             [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Removing Review %@", inspection.uid]];
                                                             [[NetworkManager sharedInstance] performRequestWithType:DeleteInspectionRequestType
                                                                                                           andParams:@{kInspectionId : (inspection.uid) ? : [NSNull null],
                                                                                                                       kApertireId: (inspection.apertureId) ? : [NSNull null]}
                                                                                                      withCompletion:^(id responseObject, NSError *error) {
                                                                                                          if (error) {
                                                                                                              [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                                                                              return;
                                                                                                          }
                                                                                                          [welf loadAndDisplayInspectionList:nil withKeyword:nil];
                                                                                                      }];
                                                         }];
    [deleteController addAction:deleteAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [deleteController addAction:cancelAction];
    [self presentViewController:deleteController animated:YES completion:nil];
}

#pragma mark - DoorInfoOveriviewViewControllerDelegate
#pragma mark - 

- (void)DoorInfoOveriviewViewController:(id)doorInfoOveriviewViewController didUpdateInspection:(Inspection *)inspection {
    [self updateInspection:inspection];
}

@end
