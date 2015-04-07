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
    NewInspectionInputFieldLocation,
    NewInspectionInputFieldSummary,
    NewInspectionInputFieldStartDate,
    NewInspectionInputFieldCount
} NewInspectionInputField;

static NSString* kDoorID = @"barcode";
static NSString* kLocations = @"location";
static NSString* kStartDate = @"StartDate";
static NSString* kLocationID = @"location_id";

@interface AddDoorReviewViewController () <IQDropDownTextFieldDelegate, QRCodeReaderDelegate>

@property (weak,   nonatomic) IBOutlet UITextField *doorIdTextField;
@property (strong, nonatomic) IBOutletCollection(IQDropDownTextField) NSArray *inspetionInfoFields;

@property (nonatomic, strong) NSMutableArray *buildingsAndLocations;
@property (nonatomic, strong) NSArray *buildings;
@property (nonatomic, strong) NSArray *buildingLocations;

@end

@implementation AddDoorReviewViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupInputFields];
}

#pragma mark - Setup Methods

- (void)setupInputFields
{
    for (int i = 0; i < NewInspectionInputFieldCount; i++) {
        IQDropDownTextField *field = [self fieldByType:i];
        switch (i) {
            case NewInspectionInputFieldBuilding:
            case NewInspectionInputFieldLocation:
            case NewInspectionInputFieldStartDate: {
                field.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviewLeftViewField"]];
                field.isOptionalDropDown = NO;
                
                if (i == NewInspectionInputFieldStartDate) {
                    field.dropDownMode = IQDropDownModeDatePicker;
                    [field setDate:[NSDate date]];
                }
                
                break;
            }
            case NewInspectionInputFieldDoorID:
            case NewInspectionInputFieldSummary:
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

- (IQDropDownTextField *)fieldByType:(NewInspectionInputField)type
{
    for (IQDropDownTextField *inputField in self.inspetionInfoFields) {
        if (inputField.tag == type) {
            return inputField;
        }
    }
    return nil;
}

- (NewInspectionInputField)typeByField:(UITextField *)field
{
    for (UITextField *inputField in self.inspetionInfoFields) {
        if (inputField == field) {
            return (NewInspectionInputField)inputField.tag;
        }
    }
    return -1;
}

#pragma mark - Get Buildings

- (NSArray *)buildingsList
{
    NSMutableArray *buildings = [NSMutableArray array];
    for (BuildingOrLocation *buildingOrLocation in self.buildingsAndLocations) {
        if ([buildingOrLocation.root integerValue] == [buildingOrLocation.idBuildings integerValue]
            || [buildingOrLocation.parent integerValue] == 0) {
            [buildings addObject:buildingOrLocation];
        }
    }
    return buildings;
}

- (BuildingOrLocation *)buildingOrLocationByName:(NSString *)name {
    for (BuildingOrLocation *building in self.buildingsAndLocations) {
        if ([building.name isEqualToString:name]) {
            return building;
        }
    }
    return nil;
}

#pragma mark - Get Locations by Selected Building

- (NSArray *)locationListByCurrentBuilding {
    NSMutableArray *locations = [NSMutableArray array];
    
    BuildingOrLocation *selectedBuilding = [self buildingOrLocationByName:[self fieldByType:NewInspectionInputFieldBuilding].text];
    for (BuildingOrLocation *location in self.buildingsAndLocations) {
        if ([location.root integerValue] == [selectedBuilding.idBuildings integerValue] &&
            [location.parent integerValue] != 0) {
            [locations addObject:location];
        }
    }
    return locations;
}

#pragma mark - QRCodeReader Delegate Methods
#pragma mark -

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    __weak typeof (self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.doorIdTextField.text = result;
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - IQDropDawnFieldDelegate
#pragma mark - 

- (void)textField:(IQDropDownTextField *)textField didSelectItem:(NSString *)item {
    NewInspectionInputField selectedFieldType = [self typeByField:textField];
    switch (selectedFieldType) {
        case NewInspectionInputFieldBuilding: {
            if (textField.text.length) {
                [self displayLocations];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Unknow Building ID", nil)];
            }
            break;
        }
        case NewInspectionInputFieldLocation:
            break;
        case NewInspectionInputFieldStartDate:
            break;
            
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NewInspectionInputField selectedFieldType = [self typeByField:textField];
    switch (selectedFieldType) {
        case NewInspectionInputFieldDoorID:
            break;
        case NewInspectionInputFieldBuilding: {
            NSString *selectedDoorID = [self fieldByType:NewInspectionInputFieldDoorID].text;
            if (!selectedDoorID.length) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please Select Door ID First", nil)];
                [textField resignFirstResponder];
            }
            break;
        }
        case NewInspectionInputFieldLocation: {
            NSString *selectedBuildingID = [self fieldByType:NewInspectionInputFieldBuilding].text;
            if (!selectedBuildingID.length) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please Select Building First", nil)];
                [textField resignFirstResponder];
            }
            break;
        }
        case NewInspectionInputFieldStartDate: {
            break;
        }
        case NewInspectionInputFieldSummary:
            break;
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NewInspectionInputField selectedFieldType = [self typeByField:textField];
    switch (selectedFieldType) {
        case NewInspectionInputFieldDoorID: {
            NSString *selectedDoorID = textField.text;
            IQDropDownTextField *buildingTextField = [self fieldByType:NewInspectionInputFieldBuilding];
            if (selectedDoorID.length) {
                [self loadAndDisplayBuildingsByDoorID:selectedDoorID
                                         OnInputField:buildingTextField];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Unknow Door ID", nil)];
            }
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - API callers

#pragma mark - Load Buildings By Door ID

- (void)loadAndDisplayBuildingsByDoorID:(NSString *)doorID
                           OnInputField:(IQDropDownTextField *)field {
    __weak typeof(self) welf = self;
    [SVProgressHUD show];
    [[NetworkManager sharedInstance] performRequestWithType:InspectionCreateChackDoorID
                                                  andParams:@{kDoorID : doorID}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [welf fieldByType:NewInspectionInputFieldDoorID].text = nil;
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 //TODO: Display Case
                                                 [SVProgressHUD showSuccessWithStatus:@""];
                                                 welf.buildingsAndLocations = [NSMutableArray array];
                                                 for (NSDictionary *dict in [responseObject objectForKey:kLocations]) {
                                                     BuildingOrLocation *buildingOrLocation = [[BuildingOrLocation alloc] initWithDictionary:dict];
                                                     [welf.buildingsAndLocations addObject:buildingOrLocation];
                                                 }
                                                 [welf displayBuildingsAndLocations];
                                             }];
    
}

#pragma mark - Display Methods
#pragma mark -

- (void)displayBuildingsAndLocations {
    self.buildings = [self buildingsList];
    NSMutableArray *buildingNames = [NSMutableArray array];
    for (BuildingOrLocation *building in self.buildings) {
        [buildingNames addObject:building.name];
    }
    IQDropDownTextField *buildingsField = [self fieldByType:NewInspectionInputFieldBuilding];
    buildingsField.itemList = buildingNames;
    [self displayLocations];
}

- (void)displayLocations {
    self.buildingLocations = [self locationListByCurrentBuilding];
    NSMutableArray *locationNames = [NSMutableArray array];
    for (BuildingOrLocation *location in self.buildingLocations) {
        [locationNames addObject:location.name];
    }
    IQDropDownTextField *locationsField = [self fieldByType:NewInspectionInputFieldLocation];
    locationsField.itemList = locationNames;
    locationsField.text = [locationNames firstObject];
}

#pragma mark - UI Actions
#pragma mark - scan qr code action

- (IBAction)scanQrButtonPressed:(id)sender {
    NSArray *types = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode93Code];
    QRCodeReaderViewController *qrCodeReaderViewConroller = [QRCodeReaderViewController
                                                             readerWithMetadataObjectTypes:types];
    qrCodeReaderViewConroller.modalPresentationStyle = UIModalPresentationFormSheet;
    qrCodeReaderViewConroller.delegate = self;
  
    [self presentViewController:qrCodeReaderViewConroller animated:YES completion:NULL];
    
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
                                                     if ([welf.delegate respondsToSelector:@selector(inspectionSuccessfullyCreated)]) {
                                                         [welf.delegate inspectionSuccessfullyCreated];
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
    
    if ([self fieldByType:NewInspectionInputFieldDoorID].text.length) {
        [inspectionDictionary setObject:[self fieldByType:NewInspectionInputFieldDoorID].text
                                 forKey:kDoorID];
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please Input Door ID First", nil)];
        return nil;
    }
    BuildingOrLocation *selectedLocation = [self buildingOrLocationByName:[self fieldByType:NewInspectionInputFieldLocation].text];
    if (selectedLocation.idBuildings) {
        [inspectionDictionary setObject:selectedLocation.idBuildings
                                 forKey:kLocationID];
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please Select Building ID First", nil)];
        return nil;
    }
    
    if ([self fieldByType:NewInspectionInputFieldStartDate].text.length) {
        IQDropDownTextField *dateField = [self fieldByType:NewInspectionInputFieldStartDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [inspectionDictionary setObject:[dateFormatter stringFromDate:dateField.date]
                                 forKey:kStartDate];
    } else {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please Select Inspection Start Date", nil)];
        return nil;
    }
    
    return inspectionDictionary;
}

@end
