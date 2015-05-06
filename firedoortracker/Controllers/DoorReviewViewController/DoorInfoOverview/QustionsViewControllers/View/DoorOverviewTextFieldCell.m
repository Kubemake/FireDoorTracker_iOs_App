//
//  DoorOverviewTextFieldCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 06.05.15.
//
//

#import "DoorOverviewTextFieldCell.h"

@interface DoorOverviewTextFieldCell() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

static NSString* kSelected = @"selected";
static NSString* kLabel = @"label";

@implementation DoorOverviewTextFieldCell

- (void)setAnswerDictionary:(NSMutableDictionary *)answerDictionary {
    self.titleLabel.text = [answerDictionary objectForKey:kLabel];
    self.textField.text = [answerDictionary objectForKey:kSelected];
    _answerDictionary = answerDictionary;
}

#pragma mark - UITextField IBAction

- (IBAction)textFieldDidChangeText:(UITextField *)sender {
    [self.answerDictionary setObject:sender.text forKey:kSelected];
}

@end
