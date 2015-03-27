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
#import <QRCodeReaderViewController.h>
#import <SVProgressHUD.h>
#import <NPAlertViewHelper.h>

static NSString* inspectionSelectorID = @"DoorReviewViewController";
static NSString* kAperture = @"aperture_id";
static NSString* kFile = @"file";
static NSString* kFileName = @"file_name";

@interface MediaViewController() <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                                  DoorReviewSelectionProtocol, QRCodeReaderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UIButton *scanQRCodeButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelImageButton;
@property (weak, nonatomic) IBOutlet UITextField *descriptiontextField;

@end

@implementation MediaViewController

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self submitButtomPressed:textField];

    return YES;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self displayImage:chosenImage andHideImageSelectionButtons:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Inspection Selector Delegate

- (void)inspectionSelected:(Inspection *)inspection doorReviewController:(UIViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD show];
    __weak typeof(self) welf = self;
   
    NSDictionary *params = @{ kFile     : self.photoImageView.image,
                              kFileName : self.descriptiontextField.text,
                              kAperture : inspection.apertureId };
    
    [[NetworkManager sharedInstance] performRequestWithType:uploadFileRequestType andParams:params withCompletion:^(id responseObject, NSError *error)
    {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"File Attached to the Inspection and Sent to the Server", nil)];
        [welf displayImage:nil andHideImageSelectionButtons:NO];
    }];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIPasteboard generalPasteboard] setString:result];
        NSString *message = NSLocalizedString(@"QR Information was copied to clipboard!", @"");
        [NPAlertViewHelper showOkAlertWithTitle:nil withMessage:message presenter:self];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UI Modifying methods
#pragma mark -

- (void)displayImage:(UIImage *)image andHideImageSelectionButtons:(BOOL)hideButtons
{
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

- (IBAction)photoButtonPressed:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)galleryButtonPressed:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)scanQRCodePressed:(id)sender
{
    NSArray *types = @[AVMetadataObjectTypeQRCode];
    QRCodeReaderViewController *qrCodeReaderViewConroller = [QRCodeReaderViewController
                                                             readerWithMetadataObjectTypes:types];
    qrCodeReaderViewConroller.modalPresentationStyle = UIModalPresentationFormSheet;
    qrCodeReaderViewConroller.delegate = self;
  
    [self presentViewController:qrCodeReaderViewConroller animated:YES completion:NULL];
}

- (IBAction)cancelImageButtonPressed:(id)sender
{
    [self displayImage:nil andHideImageSelectionButtons:NO];
}

- (IBAction)submitButtomPressed:(id)sender
{
    if ([self validateIFilledInfo]) {
        DoorReviewViewController *inspectionSelector = [self.storyboard
                                                        instantiateViewControllerWithIdentifier:inspectionSelectorID];
        inspectionSelector.inspectionSelectionDelegate = self;
        [self.navigationController pushViewController:inspectionSelector animated:YES];
    }
}

@end