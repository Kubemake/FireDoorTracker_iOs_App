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
@property (assign, nonatomic) BOOL isAllowToEdit;

@end

static NSString* kSelected = @"selected";
static NSString* kValues = @"values";
static NSString* kLabel = @"label";
static NSString* kEnabled = @"enabled";
static NSString* kAlert = @"alert";

@implementation DoorOverviewEnumTableViewCell

- (void)setAnswerDictionary:(NSDictionary *)answerDictionary {
    NSArray *values = [answerDictionary objectForKey:kValues];
    self.dropDawnTextField.enabled = [[answerDictionary objectForKey:kEnabled] boolValue];
    [self setupDropDawnTextField:values];
    self.answerLabel.text = [answerDictionary objectForKey:kLabel];
    id selectedValue = [answerDictionary objectForKey:kSelected];
    NSString *selectedString;
    if ([selectedValue isKindOfClass:[NSNumber class]]) {
        selectedString = [selectedValue stringValue];
    } else {
        selectedString = (NSString *)selectedValue;
    }
    
    if (selectedString.length) {
        [self.dropDawnTextField setText:selectedString];
    } else {
        [self.dropDawnTextField setText:[values firstObject]];
    }
    _answerDictionary = answerDictionary;
}

- (void)setupDropDawnTextField:(NSArray *)values {
    NSMutableArray *formattedValues = [NSMutableArray array];
    for (id value in values) {
        if ([value isKindOfClass:[NSNumber class]]) {
            [formattedValues addObject:[value stringValue]];
        } else if ([value isKindOfClass:[NSString class]]) {
            [formattedValues addObject:value];
        }
    }
    
    self.dropDawnTextField.itemList = formattedValues;
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([[self.answerDictionary objectForKey:kAlert] length] && !self.isAllowToEdit) {
        UIAlertController *changeController = [UIAlertController alertControllerWithTitle:@"Attention"
                                                                                  message:[self.answerDictionary objectForKey:kAlert]
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        UIAlertAction *agree = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          self.isAllowToEdit = YES;
                                                          [textField becomeFirstResponder];
                                                      }];
        [changeController addAction:cancel];
        [changeController addAction:agree];
        if ([self.delegate respondsToSelector:@selector(presentAlertDialog:doorOverviewEnumTableViewCell:)]) {
            [self.delegate presentAlertDialog:changeController doorOverviewEnumTableViewCell:self];
        }
        return NO;
    }
    return YES;
}

- (IBAction)dropDawnDidEndEditing:(IQDropDownTextField *)sender {
    self.isAllowToEdit = NO;
    NSMutableDictionary *changedDictionary = [self.answerDictionary mutableCopy];
    
    NSString *selectedValue = @"Error";
    NSArray *values = [changedDictionary objectForKey:kValues];
    if (sender.selectedRow < values.count) {
        selectedValue = [values objectAtIndex:sender.selectedRow];
    }
    
    [changedDictionary setObject:selectedValue forKey:kSelected];
    if ([self.delegate respondsToSelector:@selector(userUpdateDictionary:doorOverviewEnumTableViewCell:)]) {
        [self.delegate userUpdateDictionary:changedDictionary doorOverviewEnumTableViewCell:self];
    }

}

@end
