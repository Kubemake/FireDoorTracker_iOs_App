//
//  AddDoorReviewViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 26.03.15.
//
//

#import "AddDoorReviewViewController.h"
#import "BuildingOrLocation.h"
#import "NetworkManager.h"
#import <IQDropDownTextField.h>
#import <SVProgressHUD.h>
#import <QRCodeReaderViewController.h>

typedef enum{
    NewInspectionInputFieldDoorID = 0,
    NewInspectionInputFieldBuilding,
    NewInspectionInputFieldFloor,
    NewInspectionInputFieldWing,
    NewInspectionInputFieldArea,
    NewInspectionInputFieldLevel,
    NewInspectionInputFieldCount
} NewInspectionInputField;

static NSString* kDoorID = @"barcode";
static NSString* kStartDate = @"StartDate";
static NSString* kLocation = @"location";
static NSString* kOldData = @"olddata";
static NSString* kNewData = @"newdata";

static NSString* kName = @"name";
static NSString* kValues = @"values";
static NSString* kEnabled = @"enabled";
static NSString* kForceRefresh = @"force_refresh";
static NSString* kSelected = @"selected";

static NSString* kCreatedInspection = @"CreatedInspection";

static const NSInteger cMaxDoorIdLength = 6;

@interface AddDoorReviewViewController () <IQDropDownTextFieldDelegate, QRCodeReaderDelegate>

@property (weak,   nonatomic) IBOutlet UITextField *doorIdTextField;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *inspetionInfoFields;

@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSMutableArray *oldLocations;

@end

@implementation AddDoorReviewViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInputFields];
}

#pragma mark - Setup Methods

- (void)setupInputFields {
    for (int i = 0; i < NewInspectionInputFieldCount; i++) {
        IQDropDownTextField *field = [self fieldByType:i];
        switch (i) {
            case NewInspectionInputFieldBuilding:
            case NewInspectionInputFieldFloor:
            case NewInspectionInputFieldWing:
            case NewInspectionInputFieldArea:
            case NewInspectionInputFieldLevel: {
                field.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviewLeftViewField"]];
                field.isOptionalDropDown = NO;
                field.delegate = self;
                
                break;
            }
            case NewInspectionInputFieldDoorID:
                field.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyLeftView"]];
                break;
            default:
                break;
        }
        field.leftViewMode = UITextFieldViewModeAlways;
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,42)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:field
                                                                                    action:@selector(resignFirstResponder)];
        [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
        [field setInputAccessoryView:toolBar];
    }
}

#pragma mark - Supporting Methods
#pragma mark - Get Inspection Field by Type

- (IQDropDownTextField *)fieldByType:(NewInspectionInputField)type {
    for (IQDropDownTextField *inputField in self.inspetionInfoFields) {
        if (inputField.tag == type) {
            return inputField;
        }
    }
    return nil;
}

- (NewInspectionInputField)typeByField:(UITextField *)field {
    for (UITextField *inputField in self.inspetionInfoFields) {
        if (inputField == field) {
            return (NewInspectionInputField)inputField.tag;
        }
    }
    return -1;
}

#pragma mark - QRCodeReader Delegate Methods
#pragma mark -

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    __weak typeof (self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.doorIdTextField.text = result;
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - IQDropDawnFieldDelegate
#pragma mark -

- (void)textField:(IQDropDownTextField *)textField didSelectItem:(NSString *)item {
    NewInspectionInputField selectedFieldType = [self typeByField:textField];
    switch (selectedFieldType) {
        case NewInspectionInputFieldBuilding:
        case NewInspectionInputFieldFloor:
        case NewInspectionInputFieldWing:
        case NewInspectionInputFieldArea:
        case NewInspectionInputFieldLevel: {
            NSMutableDictionary *inspectionInfo = [NSMutableDictionary dictionaryWithDictionary:[self.locations objectAtIndex:selectedFieldType-1]];
            [inspectionInfo setObject:item forKey:kSelected];
            [self saveLocationInfo:inspectionInfo byType:selectedFieldType];
            break;
        }
            
        default:
            break;
    }
    [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NewInspectionInputField selectedFieldType = [self typeByField:textField];
    switch (selectedFieldType) {
        case NewInspectionInputFieldDoorID:
            break;
        case NewInspectionInputFieldBuilding:
        case NewInspectionInputFieldFloor:
        case NewInspectionInputFieldWing:
        case NewInspectionInputFieldArea:
        case NewInspectionInputFieldLevel: {
            NSString *selectedDoorID = [self fieldByType:NewInspectionInputFieldDoorID].text;
            if (!selectedDoorID.length) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please Select Door ID First", nil)];
                [textField resignFirstResponder];
            }
            break;
        }
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NewInspectionInputField selectedFieldType = [self typeByField:textField];
    switch (selectedFieldType) {
        case NewInspectionInputFieldDoorID: {
            NSString *selectedDoorID = textField.text;
            if (selectedDoorID.length) {
                [self loadAndDisplayBuildingsByDoorID:selectedDoorID];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Unknow Door ID", nil)];
            }
            
            break;
        }
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NewInspectionInputField selectedFieldType = [self typeByField:textField];
    switch (selectedFieldType) {
        case NewInspectionInputFieldDoorID: {
            if (textField.text.length >= cMaxDoorIdLength && string.length) {
                return NO;
            }
            return YES;
        }
            default:
            return YES;
    }
}


#pragma mark - API callers
#pragma mark - Load Buildings By Door ID

- (void)loadAndDisplayBuildingsByDoorID:(NSString *)doorID {
    __weak typeof(self) welf = self;
    [SVProgressHUD show];
    NSMutableDictionary *addInspectionInfo = [NSMutableDictionary dictionaryWithDictionary:@{kDoorID : doorID}];
    if (self.locations && self.oldLocations) {
        [addInspectionInfo setObject:[self selectedValuesFromLocationsArray:self.locations] forKey:kNewData];
        [addInspectionInfo setObject:[self selectedValuesFromLocationsArray:self.oldLocations] forKey:kOldData];
    }
    [[NetworkManager sharedInstance] performRequestWithType:InspectionCreateChackDoorID
                                                  andParams:addInspectionInfo
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [welf fieldByType:NewInspectionInputFieldDoorID].text = nil;
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [welf setupLocation:[responseObject objectForKey:kLocation]];
                                                 [SVProgressHUD showSuccessWithStatus:nil];
                                             }];
}

- (void)setupLocation:(NSArray *)location {
    if (location) {
        self.locations = [NSMutableArray arrayWithArray:location];
        self.oldLocations = [self.locations mutableCopy];
        [self setupLocationFields];
    } else {
        //TODO: Diplsay error
    }
}

- (void)setupLocationFields {
    for (int i = NewInspectionInputFieldBuilding; i < NewInspectionInputFieldCount; i++) {
        IQDropDownTextField *field = [self.inspetionInfoFields objectAtIndex:i];
        NSDictionary *fieldInfo = [self.locations objectAtIndex:i-1];
        field.enabled = [[fieldInfo objectForKey:kEnabled] boolValue];
        field.itemList = [fieldInfo objectForKey:kValues];
        field.text = [fieldInfo objectForKey:kSelected];
    }
}

- (void)saveLocationInfo:(NSDictionary *)info byType:(NewInspectionInputField)type {
    [self.locations replaceObjectAtIndex:type-1 withObject:info];
    if ([[info objectForKey:kForceRefresh] boolValue]) {
        [self loadAndDisplayBuildingsByDoorID:self.doorIdTextField.text];
    } else {
        self.oldLocations = [self.locations mutableCopy];
    }
}

- (NSDictionary *)selectedValuesFromLocationsArray:(NSArray *)array {
    NSMutableDictionary *selectedDict = [NSMutableDictionary dictionary];
    for (NSDictionary *location in array) {
        if ([[location objectForKey:kEnabled] boolValue]) {
            [selectedDict setObject:[location objectForKey:kSelected] forKey:[location objectForKey:kName]];
        }
    }
    return selectedDict;
}

#pragma mark - UI Actions
#pragma mark - scan qr code action

- (IBAction)scanQrButtonPressed:(id)sender {
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

#pragma mark - Save created Inspection

- (IBAction)saveButtonPressed:(id)sender {
    __weak typeof(self) welf = self;
    NSDictionary *newInspectionInfo = [self validNewInspectionInfo];
    if (newInspectionInfo) {
        [SVProgressHUD show];
        [[NetworkManager sharedInstance] performRequestWithType:InspectionAddRequestType
                                                      andParams:newInspectionInfo
                                                 withCompletion:^(id responseObject, NSError *error) {
                                                     if (error) {
                                                         [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                         return;
                                                     }
                                                     Inspection *createdInspection = [[Inspection alloc] initWithDictionary:[responseObject objectForKey:kCreatedInspection]];
                                                     
                                                     if ([welf.delegate respondsToSelector:@selector(inspectionSuccessfullyCreated:)]) {
                                                         [welf.delegate inspectionSuccessfullyCreated:createdInspection];
                                                     }
                                                 }];
    }
}

#pragma mark - Validation Methods
#pragma mark - New Inspection Validation

/**
 *  Validate inputed by user info
 *
 *  @return return nil if user new inspection didn't valid
 */

- (NSDictionary *)validNewInspectionInfo {
    NSMutableDictionary *inspectionDictionary = [NSMutableDictionary dictionary];
    
    if ([self fieldByType:NewInspectionInputFieldDoorID].text.length == cMaxDoorIdLength) {
        [inspectionDictionary setObject:[self fieldByType:NewInspectionInputFieldDoorID].text
                                 forKey:kDoorID];
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Door ID must contain 6 characters", nil)];
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [inspectionDictionary setObject:[dateFormatter stringFromDate:[NSDate date]]
                             forKey:kStartDate];
    
    if ([self selectedValuesFromLocationsArray:self.locations]) {
        [inspectionDictionary setObject:[self selectedValuesFromLocationsArray:self.locations]
                                 forKey:kLocation];
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Missed Location", nil)];
        return nil;
    }
    
    
    return inspectionDictionary;
}

@end
