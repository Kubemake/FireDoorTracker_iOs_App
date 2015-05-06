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

@interface StartInterviewViewController () <IQDropDownTextFieldDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

//IBOutlets

//Model
@property (weak, nonatomic) NSDictionary *answersDictionary;
@property (strong, nonatomic) NSMutableDictionary *resultDictionary;

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
    self.answersDictionary = doorProperties;
    self.resultDictionary = [NSMutableDictionary dictionary];

    }

#pragma mark - Delegation Methods
#pragma mark - IQDropDownTextField

-(void)textField:(IQDropDownTextField*)textField didSelectItem:(NSString*)item {
}

#pragma mark - UITextfield Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
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

#pragma mark - UITableView Datasource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - IBActions
#pragma mark -

- (IBAction)submitButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(submitDoorOverview:)]) {
        [self.delegate submitDoorOverview:self.resultDictionary];
    }
}

@end
