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
#import "AddDoorReviewViewController.h"

//Import View
#import "MediaCollectionViewCell.h"
#import "MediaHeaderCollectionReusableView.h"

//Import Pods
#import <QRCodeReaderViewController.h>
#import <SVProgressHUD.h>
#import <IDMPhotoBrowser.h>
#import <UIViewController+MJPopupViewController.h>

static NSString* inspectionSelectorID = @"DoorReviewViewController";
static NSString* kAperture = @"aperture_id";
static NSString* kFile = @"file";
static NSString* kFileName = @"file_name";
static NSString* kKeyword = @"keyword";
static NSString* kUserInspections = @"inspections";

static NSString* addDoorViewControllerIdentifier = @"AddDoorReviewViewController";
static NSString* kCIMediaPlusCollectionViewCellIdentifier = @"MediaPlusCollectionViewCellIdentifier";

typedef enum {
    NewPhotoButtonTypeTakePicture = 0,
    NewPhotoButtonTypeFromLibrary
} NewPhotoButtonType;


@interface MediaViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate,
QRCodeReaderDelegate, UICollectionViewDataSource, UICollectionViewDelegate,
UISearchBarDelegate, UIActionSheetDelegate, AddDoorReviewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//User Data
@property (strong, nonatomic) NSArray* inspectionsForDisplaying;
@property (weak, nonatomic) Inspection *selectedInspection;

@end

@implementation MediaViewController

#pragma mark - Lyfecircle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAndDisplayInspectionList:nil withKeyword:nil];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self presentPhotoDescriptionDialogForImage:chosenImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image Description Dialog

- (void)presentPhotoDescriptionDialogForImage:(UIImage *)image {
    UIAlertController *photoDescriptionDialog = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Description", nil)
                                                                                    message:NSLocalizedString(@"Please input photo description:", nil)
                                                                             preferredStyle:UIAlertControllerStyleAlert];
    [photoDescriptionDialog addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Description...", nil);
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        UITextField *descriptionTextField = [[photoDescriptionDialog textFields] firstObject];
                                            
                                                        [self uploadImage:image
                                                             toInspection:self.selectedInspection
                                                          withDescription:descriptionTextField.text];
                                                    }];
    [photoDescriptionDialog addAction:cancelAction];
    [photoDescriptionDialog addAction:okAction];
    
    [self presentViewController:photoDescriptionDialog
                       animated:YES
                     completion:nil];
}

#pragma mark - Inspection Selector Delegate

- (void)uploadImage:(UIImage *)image toInspection:(Inspection *)inspection withDescription:(NSString *)description {
    [SVProgressHUD show];
    __weak typeof(self) welf = self;
    
    NSDictionary *params = @{ kFile     : image,
                              kFileName : (description) ? : @"From iPad",
                              kAperture : (inspection.apertureId) ? : @"" };
    
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
        [self displayActionSheetToInspection:[self.inspectionsForDisplaying objectAtIndex:indexPath.section]];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    MediaHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                   withReuseIdentifier:[MediaHeaderCollectionReusableView identifier]
                                                                                          forIndexPath:indexPath];
    Inspection *inspection = [self.inspectionsForDisplaying objectAtIndex:indexPath.section];
    [header displayInspectionInfo:inspection];
    return header;
}

#pragma mark - Action Sheet

- (void)displayActionSheetToInspection:(Inspection *)inspection {
    self.selectedInspection = inspection;
    UIActionSheet *attachPhoto = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"New image source?", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"To Take Picture", @"From Library", nil];
    [attachPhoto showInView:self.view];
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
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined) {
        NSArray *types = @[AVMetadataObjectTypeQRCode];
        QRCodeReaderViewController *qrCodeReaderViewConroller = [QRCodeReaderViewController
                                                                 readerWithMetadataObjectTypes:types];
        qrCodeReaderViewConroller.modalPresentationStyle = UIModalPresentationFormSheet;
        qrCodeReaderViewConroller.delegate = self;
        
        [self presentViewController:qrCodeReaderViewConroller animated:YES completion:NULL];
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                    message:NSLocalizedString(@"Please enable access to camera by firedoortracker in settings", nil)
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark - Add Door 

- (IBAction)addDoorButtonPressed:(id)sender {
    AddDoorReviewViewController *addDoorVC = [self.storyboard instantiateViewControllerWithIdentifier:addDoorViewControllerIdentifier];
    addDoorVC.view.frame = CGRectMake(self.view.bounds.size.width / 3.0f,
                                      self.view.bounds.size.height / 2.0f,
                                      self.view.bounds.size.width * 2.0f / 3.0f,
                                      self.view.bounds.size.height / 2.0f);
    addDoorVC.delegate = self;
    [self presentPopupViewController:addDoorVC animationType:MJPopupViewAnimationSlideTopTop];
}

#pragma mark - Add New Inspection Delegate

- (void)inspectionSuccessfullyCreated:(Inspection *)createdInspection {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    [self loadAndDisplayInspectionList:nil withKeyword:nil];
}
#pragma mark - SearchBar Delegate
#pragma mark -

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self loadAndDisplayInspectionList:nil withKeyword:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [self loadAndDisplayInspectionList:nil withKeyword:nil];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
}

#pragma mark - Action Sheet Delegate
#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        //    picker.allowsEditing = YES;
        
        switch (buttonIndex) {
            case NewPhotoButtonTypeTakePicture:
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case NewPhotoButtonTypeFromLibrary:
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            default:
                return;
        }
        
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                    message:NSLocalizedString(@"Please enable access to camera by firedoortracker in settings", nil)
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }

}

@end