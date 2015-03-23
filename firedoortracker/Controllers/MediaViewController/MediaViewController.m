//
//  MediaViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

//Import Controllers
#import "MediaViewController.h"
#import "DoorReviewViewController.h"

//Import View
#import <SVProgressHUD.h>

//Imprt Model
#import "NetworkManager.h"

static NSString* inspectionSelectorID = @"DoorReviewViewController";

static NSString* kFile = @"file";
static NSString* kFileName = @"file_name";
static NSString* kAperture = @"aperture_id";

@interface MediaViewController() <UITextFieldDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
DoorReviewSelectionProtocol>

//IBOutlets
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UIButton *scanQRCodeButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelImageButton;
@property (weak, nonatomic) IBOutlet UITextField *descriptiontextField;

@end

@implementation MediaViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Delegate Methods
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self submitButtomPressed:textField];
    return YES;
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self displayImage:chosenImage andHideImageSelectionButtons:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Inspection Selector Delegate

- (void)inspectionSelected:(Inspection *)inspection
      doorReviewController:(UIViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD show];
    [[NetworkManager sharedInstance] performRequestWithType:uploadFileRequestType
                                                  andParams:@{kFile : self.photoImageView.image,
                                                              kFileName : self.descriptiontextField.text,
                                                              kAperture : inspection.apertureId}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"File Attached to the Inspection and Sent to the Server", nil)];
                                             }];
}

#pragma mark - UI Modifying methods
#pragma mark -

- (void)displayImage:(UIImage *)image andHideImageSelectionButtons:(BOOL)hideButtons {
    self.photoImageView.image = image;
    [self.photoImageView setHidden:(BOOL)!image];
    [self.cancelImageButton setHidden:(BOOL)!image];
    [self.photoButton setHidden:hideButtons];
    [self.galleryButton setHidden:hideButtons];
    [self.scanQRCodeButton setHidden:hideButtons];
}

- (BOOL)validateIFilledInfo {
    if (!self.descriptiontextField.text.length) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please input Description first", nil)];
        return NO;
    } else if (!self.photoImageView.image) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please select Image or Scan QR", nil)];
        return NO;
    }
    return YES;
}

#pragma mark - IBActions
#pragma mark - Actions from buttons

- (IBAction)photoButtonPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)galleryButtonPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)scanQRCodePressed:(id)sender {
}

- (IBAction)cancelImageButtonPressed:(id)sender {
    [self displayImage:nil andHideImageSelectionButtons:NO];
}

- (IBAction)submitButtomPressed:(id)sender {
    if ([self validateIFilledInfo]) {
        DoorReviewViewController *inspectionSelector = [self.storyboard instantiateViewControllerWithIdentifier:inspectionSelectorID];
        inspectionSelector.inspectionSelectionDelegate = self;
        [self.navigationController pushViewController:inspectionSelector animated:YES];
    }
}

@end
