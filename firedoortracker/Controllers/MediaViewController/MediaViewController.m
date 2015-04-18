//
//  MediaViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import "MediaViewController.h"
#import "DoorReviewViewController.h"
#import "NetworkManager.h"
#import "CurrentUser.h"

//Import View
#import "MediaCollectionViewCell.h"

//Import Pods
#import <QRCodeReaderViewController.h>
#import <SVProgressHUD.h>
#import <IDMPhotoBrowser.h>

static NSString* inspectionSelectorID = @"DoorReviewViewController";
static NSString* kAperture = @"aperture_id";
static NSString* kFile = @"file";
static NSString* kFileName = @"file_name";
static NSString* kKeyword = @"keyword";
static NSString* kUserInspections = @"inspections";

static NSString* kCIMediaPlusCollectionViewCellIdentifier = @"MediaPlusCollectionViewCellIdentifier";

@interface MediaViewController() <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                                  QRCodeReaderDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//User Data
@property (strong, nonatomic) NSArray* inspectionsForDisplaying;


@end

@implementation MediaViewController

#pragma mark - Lyfecircle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadAndDisplayInspectionList:nil withKeyword:nil];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Inspection Selector Delegate

- (void)uploadImage:(UIImage *)image toInspection:(Inspection *)inspection withDescription:(NSString *)description {
    [SVProgressHUD show];
    __weak typeof(self) welf = self;
    
    NSDictionary *params = @{ kFile     : image,
                              kFileName : description,
                              kAperture : inspection.apertureId };
    
    [[NetworkManager sharedInstance] performRequestWithType:uploadFileRequestType
                                                  andParams:params
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Image Attached to the Review", nil)];
                                                 welf.searchBar.text = @"";
                                                 [welf loadAndDisplayInspectionList:nil withKeyword:nil];
                                                 //TODO: Scroll to selected inspection or add cell to view with new image
                                             }];
}

#pragma mark - Collection View Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.inspectionsForDisplaying.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    Inspection *sectionInspection = [self.inspectionsForDisplaying objectAtIndex:section];
    return sectionInspection.images.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:kCIMediaPlusCollectionViewCellIdentifier
                                                         forIndexPath:indexPath];
    }
    MediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MediaCollectionViewCell identifier]
                                                                              forIndexPath:indexPath];
    Inspection *sectionInspection = [self.inspectionsForDisplaying objectAtIndex:indexPath.section];
    [cell displayImageWithUrl:[sectionInspection.images objectAtIndex:indexPath.row-1]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //TODO: Display Make/Select photo flow
        return;
    }
    
    NSMutableArray *photos = [NSMutableArray new];
    Inspection *sectionInspection = [self.inspectionsForDisplaying objectAtIndex:indexPath.section];
    
    for (NSString *url in sectionInspection.images) {
        IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:url]];
        [photos addObject:photo];
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos
                                                      animatedFromView:nil];
    [browser setInitialPageIndex:indexPath.row-1];
    [self presentViewController:browser animated:YES completion:nil];
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
                                                 
                                                 [welf.collectionView reloadData];
                                             }];
    
}

#pragma mark - QRCodeReader Delegate Methods
#pragma mark -

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [self dismissViewControllerAnimated:YES completion:^{
        self.searchBar.text = result;
        [self loadAndDisplayInspectionList:nil withKeyword:result];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - IBActions
#pragma mark - Actions from buttons

- (IBAction)scanQRCodePressed:(id)sender {
    NSArray *types = @[AVMetadataObjectTypeQRCode];
    QRCodeReaderViewController *qrCodeReaderViewConroller = [QRCodeReaderViewController
                                                             readerWithMetadataObjectTypes:types];
    qrCodeReaderViewConroller.modalPresentationStyle = UIModalPresentationFormSheet;
    qrCodeReaderViewConroller.delegate = self;
    
    [self presentViewController:qrCodeReaderViewConroller animated:YES completion:NULL];
}

#pragma mark - SearchBar Delegate
#pragma mark - 

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self loadAndDisplayInspectionList:nil withKeyword:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    [self loadAndDisplayInspectionList:nil withKeyword:nil];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
}

@end