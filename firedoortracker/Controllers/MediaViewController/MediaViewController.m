//
//  MediaViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import "MediaViewController.h"

@interface MediaViewController() <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
}

@end
