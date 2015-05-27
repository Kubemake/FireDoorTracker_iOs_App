//
//  DoorOverviewTextFieldCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 06.05.15.
//
//

#import "DoorOverviewTextFieldCell.h"

//Import Extensions
#import "UIFont+FDTFonts.h"
#import "UIColor+FireDoorTrackerColors.h"

@interface DoorOverviewTextFieldCell() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (assign, nonatomic) BOOL isAllowToEdit;

@end

static NSString* kSelected = @"selected";
static NSString* kLabel = @"label";
static NSString* kEnabled = @"enabled";
static NSString* kAlert = @"alert";

@implementation DoorOverviewTextFieldCell

- (void)setAnswerDictionary:(NSDictionary *)answerDictionary {
    self.textField.enabled = [[answerDictionary objectForKey:kEnabled] boolValue];
    self.titleLabel.text = [answerDictionary objectForKey:kLabel];
    self.textField.text = [answerDictionary objectForKey:kSelected];
    _answerDictionary = answerDictionary;
    [self customizeAndAddToolBarToTextField:self.textField];
}

#pragma mark - Support View Methods

- (void)customizeAndAddToolBarToTextField:(UITextField *)textField {
    textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyLeftView"]];
    textField.leftViewMode = UITextFieldViewModeAlways;

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

#pragma mark - UITextField IBAction

- (IBAction)textFieldDidBeginEditing:(id)sender {
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
                                                          [sender becomeFirstResponder];
                                                      }];
        [changeController addAction:cancel];
        [changeController addAction:agree];
        if ([self.delegate respondsToSelector:@selector(presentAlertDialog:doorOverviewTextFieldCell:)]) {
            [self.delegate presentAlertDialog:changeController doorOverviewTextFieldCell:self];
        }
    }
}

- (IBAction)textFieldDidChangeText:(UITextField *)sender {
    self.isAllowToEdit = NO;
    NSMutableDictionary *changedAnswer = [self.answerDictionary mutableCopy];
    [changedAnswer setObject:sender.text forKey:kSelected];
    if ([self.delegate respondsToSelector:@selector(userUpdateDictionary:doorOverviewTextFieldCell:)]) {
        [self.delegate userUpdateDictionary:changedAnswer doorOverviewTextFieldCell:self];
    }
}

@end
