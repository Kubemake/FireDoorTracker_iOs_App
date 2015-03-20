//
//  StartInterviewViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

//Import Controllers
#import "StartInterviewViewController.h"

//Import View
#import <IQDropDownTextField.h>

//Import Extensions
#import "UIFont+FDTFonts.h"
#import "UIColor+FireDoorTrackerColors.h"

static NSString* kSelected = @"selected";
static NSString* kType = @"type";
static NSString* vTypeEnum = @"enum";
static NSString* vTypeString = @"string";
static NSString* vTypeDouble = @"double";
static NSString* kValues = @"values";
static NSString* kName = @"name";

static const CGFloat maxInputFieldHeght = 37.0f;

@interface StartInterviewViewController () <IQDropDownTextFieldDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *doorPropertiesView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation StartInterviewViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Display View Methods
#pragma mark -

- (void)displayDoorProperties:(NSDictionary *)doorProperties {
    CGFloat propertyLabelHeight = self.doorPropertiesView.bounds.size.height / (doorProperties.count + 1);
    CGFloat propertyTitleLabelWidth = self.doorPropertiesView.bounds.size.width / 3.0f;
    CGFloat propertyValueLabelWidth = self.doorPropertiesView.bounds.size.width - propertyTitleLabelWidth;
    CGFloat propertyLabelY = propertyLabelHeight / 2.0f;
    for (NSDictionary* property in [doorProperties allValues]) {
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        propertyLabelY,
                                                                        propertyTitleLabelWidth,
                                                                        MIN(maxInputFieldHeght, propertyLabelHeight))];
        titleLabel.font = [UIFont FDTTimesNewRomanBoldWithSize:16.0f];
        titleLabel.textColor = [UIColor FDTMediumGayColor];
        titleLabel.text = [property objectForKey:kName];
        [self.doorPropertiesView addSubview:titleLabel];
        
        if ([[property  objectForKey:kType] isEqualToString:vTypeEnum]) {
            IQDropDownTextField *dropDownField = [[IQDropDownTextField alloc] initWithFrame:CGRectMake(propertyTitleLabelWidth,
                                                                                                                                propertyLabelY,
                                                                                                                                                                            propertyValueLabelWidth,
                                                                                                                                                                            MIN(maxInputFieldHeght, propertyLabelHeight))];
            dropDownField.isOptionalDropDown = NO;
            dropDownField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviewLeftViewField"]];
            dropDownField.leftViewMode = UITextFieldViewModeAlways;
            dropDownField.delegate = self;
            
            [self customizeAndAddToolBarToTextField:dropDownField];
            if ([[property objectForKey:kValues] isKindOfClass:[NSDictionary class]]) {
                dropDownField.itemList = [[property objectForKey:kValues] allValues];
            } else if ([[property objectForKey:kValues] isKindOfClass:[NSString class]]) {
                dropDownField.itemList = [[property objectForKey:kValues] componentsSeparatedByString:@"\n"];
            }
            dropDownField.text = [property objectForKey:kSelected];
            [self.doorPropertiesView addSubview:dropDownField];
        } else {
            UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectMake(propertyTitleLabelWidth,
                                                                                   propertyLabelY,
                                                                                   propertyValueLabelWidth,
                                                                                   MIN(maxInputFieldHeght, propertyLabelHeight))];
            inputField.text = [property objectForKey:kSelected];
            inputField.delegate = self;
            inputField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyLeftView"]];
            inputField.leftViewMode = UITextFieldViewModeAlways;
            [self customizeAndAddToolBarToTextField:inputField];
            [self.doorPropertiesView addSubview:inputField];
        }
        propertyLabelY += propertyLabelHeight;
    }
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                       propertyLabelY,
                                                                       propertyTitleLabelWidth + propertyValueLabelWidth,
                                                                       MIN(maxInputFieldHeght, propertyLabelHeight))];
    [submitButton setTitle:NSLocalizedString(@"SUBMIT", nil) forState:UIControlStateNormal];
    [submitButton setBackgroundColor:[UIColor FDTDeepBlueColor]];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton.titleLabel setFont:[UIFont FDTTimesNewRomanBoldWithSize:18.0f]];
    [self.doorPropertiesView addSubview:submitButton];
    [self.activityView stopAnimating];
}

#pragma mark - Delegation Methods
#pragma mark - IQDropDownTextField

-(void)textField:(IQDropDownTextField*)textField didSelectItem:(NSString*)item {
    //TODO: Save changed data to dictionary
}

#pragma mark - UITextfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Support View Methods

- (void)customizeAndAddToolBarToTextField:(UITextField *)textField {
    textField.background = [UIImage imageNamed:@"reviewDropDownFieldBackground"];
    textField.font = [UIFont FDTTimesNewRomanRegularWithSize:15.0f];
    textField.textColor = [UIColor FDTMediumGayColor];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,42)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:textField
                                                                                action:@selector(resignFirstResponder)];
    [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    [textField setInputAccessoryView:toolBar];
}

#pragma mark - IBActions
#pragma mark -

- (void)submitButtonPressed:(id)sender {
    //TODO: Add Validation
    if ([self.delegate respondsToSelector:@selector(submitDoorOverview)]) {
        [self.delegate submitDoorOverview];
//        [sender setEnabled:NO];
    }
}

@end
