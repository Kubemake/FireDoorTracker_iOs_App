//
//  DoorOverviewEnumTableViewCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 06.05.15.
//
//

#import "DoorOverviewEnumTableViewCell.h"

#import <IQDropDownTextField/IQDropDownTextField.h>

//Import Extensions
#import "UIFont+FDTFonts.h"
#import "UIColor+FireDoorTrackerColors.h"

@interface DoorOverviewEnumTableViewCell() <IQDropDownTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *dropDawnTextField;

@end

static NSString* kSelected = @"selected";
static NSString* kValues = @"values";
static NSString* kLabel = @"label";

@implementation DoorOverviewEnumTableViewCell

- (void)setAnswerDictionary:(NSDictionary *)answerDictionary {
    NSArray *values = [answerDictionary objectForKey:kValues];
    [self setupDropDawnTextField:values];
    self.answerLabel.text = [answerDictionary objectForKey:kLabel];
    NSString *selectedString = (NSString *)[answerDictionary objectForKey:kSelected];
    if (selectedString.length) {
        [self.dropDawnTextField setText:selectedString];
    } else {
        [self.dropDawnTextField setText:[values firstObject]];
    }
    _answerDictionary = answerDictionary;
}

- (void)setupDropDawnTextField:(NSArray *)values {
    self.dropDawnTextField.itemList = values;
    self.dropDawnTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviewLeftViewField"]];
    self.dropDawnTextField.leftViewMode = UITextFieldViewModeAlways;
    self.dropDawnTextField.delegate = self;
    self.dropDawnTextField.isOptionalDropDown = NO;
    [self customizeAndAddToolBarToTextField:self.dropDawnTextField];
}

#pragma mark - Support View Methods

- (void)customizeAndAddToolBarToTextField:(UITextField *)textField {
    textField.background = [UIImage imageNamed:@"reviewDropDownFieldBackground"];
    textField.font = [UIFont FDTTimesNewRomanRegularWithSize:15.0f];
    textField.textColor = [UIColor FDTMediumGayColor];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,42)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:textField
                                                                                action:@selector(resignFirstResponder)];
    [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    [textField setInputAccessoryView:toolBar];
}

#pragma mark - Delegate

- (IBAction)dropDawnDidEndEditing:(IQDropDownTextField *)sender {
    NSMutableDictionary *changedDictionary = [self.answerDictionary mutableCopy];
    NSString *selectedValue = (sender.selectedItem) ? : [sender.itemList firstObject];
    
    [changedDictionary setObject:selectedValue forKey:kSelected];
    if ([self.delegate respondsToSelector:@selector(userUpdateDictionary:doorOverviewEnumTableViewCell:)]) {
        [self.delegate userUpdateDictionary:changedDictionary doorOverviewEnumTableViewCell:self];
    }

}

@end