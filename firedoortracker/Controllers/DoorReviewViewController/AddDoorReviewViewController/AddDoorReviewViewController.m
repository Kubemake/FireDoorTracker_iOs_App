//
//  AddDoorReviewViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 26.03.15.
//
//

//Controllers
#import "AddDoorReviewViewController.h"

//Import Model
#import "NetworkManager.h"
#import "BuildingOrLocation.h"

//Inport View
#import <IQDropDownTextField.h>
#import <SVProgressHUD.h>

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

@interface AddDoorReviewViewController () <IQDropDownTextFieldDelegate>

//IBOutlets
@property (strong, nonatomic) IBOutletCollection(IQDropDownTextField) NSArray *inspetionInfoFields;

//Model
@property (nonatomic, strong) NSMutableArray *buildingsAndLocations;
@property (nonatomic, strong) NSArray *buildings;
@property (nonatomic, strong) NSArray *buildingLocations;


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
            case NewInspectionInputFieldLocation:
            case NewInspectionInputFieldStartDate: {
                field.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviewLeftViewField"]];
                field.isOptionalDropDown = NO;
                
                if (i == NewInspectionInputFieldStartDate) {
                    field.dropDownMode = IQDropDownModeDatePicker;
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
            return inputField.tag;
        }
    }
    return -1;
}

#pragma mark - Get Buildings

- (NSArray *)buildingsList {
    NSMutableArray *buildings = [NSMutableArray array];
    for (BuildingOrLocation *buildingOrLocation in self.buildingsAndLocations) {
        if ([buildingOrLocation.root integerValue] == [buildingOrLocation.idBuildings integerValue]
            || [buildingOrLocation.parent integerValue] == 0) {
            [buildings addObject:buildingOrLocation];
        }
    }
    return buildings;
}

- (BuildingOrLocation *)buildingByName:(NSString *)name {
    for (BuildingOrLocation *building in self.buildings) {
        if ([building.name isEqualToString:name]) {
            return building;
        }
    }
    return nil;
}

#pragma mark - Get Locations by Selected Building

- (NSArray *)locationListByCurrentBuilding {
    NSMutableArray *locations = [NSMutableArray array];

    BuildingOrLocation *selectedBuilding = [self buildingByName:[self fieldByType:NewInspectionInputFieldBuilding].text];
    for (BuildingOrLocation *location in self.buildingsAndLocations) {
        if ([location.root integerValue] == [selectedBuilding.idBuildings integerValue] &&
            [location.parent integerValue] != 0) {
            [locations addObject:location];
        }
    }
    return locations;
}

#pragma mark - Delegate methods
#pragma mark - IQDropDawnFieldDelegate

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

#pragma mark - Load Location By Building ID

- (void)loadAndDisplayLocationsByBuildingID:(NSString *)buildingID
                               OnInputField:(IQDropDownTextField *)field {
    
}

#pragma mark - UI Actions
#pragma mark - scan qr code action

- (IBAction)scanQrButtonPressed:(id)sender {
}

#pragma mark - Save created Inspection

- (IBAction)saveButtonPressed:(id)sender {
}

@end
