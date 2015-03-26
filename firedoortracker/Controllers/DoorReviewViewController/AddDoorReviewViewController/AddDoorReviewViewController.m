//
//  AddDoorReviewViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 26.03.15.
//
//

//Controllers
#import "AddDoorReviewViewController.h"

//Inport View
#import <IQDropDownTextField.h>

typedef enum{
    NewInspectionInputFieldDoorID = 0,
    NewInspectionInputFieldBuilding,
    NewInspectionInputFieldLocation,
    NewInspectionInputFieldSummary,
    NewInspectionInputFieldStartDate,
    NewInspectionInputFieldCount
} NewInspectionInputField;

@interface AddDoorReviewViewController ()

//IBOutlets
@property (strong, nonatomic) IBOutletCollection(IQDropDownTextField) NSArray *inspetionInfoFields;


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
        field.isOptionalDropDown = NO;
        switch (i) {
            case NewInspectionInputFieldDoorID:
            case NewInspectionInputFieldBuilding:
            case NewInspectionInputFieldLocation:
            case NewInspectionInputFieldStartDate: {
                field.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviewLeftViewField"]];
                break;
            }
            case NewInspectionInputFieldSummary:
                field.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyLeftView"]];
                
            default:
                break;
        }
        field.leftViewMode = UITextFieldViewModeAlways;
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

@end
