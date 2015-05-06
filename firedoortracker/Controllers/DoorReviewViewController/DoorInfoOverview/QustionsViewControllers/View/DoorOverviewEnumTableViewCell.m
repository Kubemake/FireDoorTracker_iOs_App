//
//  DoorOverviewEnumTableViewCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 06.05.15.
//
//

#import "DoorOverviewEnumTableViewCell.h"

#import <IQDropDownTextField/IQDropDownTextField.h>

@interface DoorOverviewEnumTableViewCell() <IQDropDownTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *dropDawnTextField;

@end

static NSString* kSelected = @"selected";
static NSString* kValues = @"values";
static NSString* kLabel = @"label";

@implementation DoorOverviewEnumTableViewCell

- (void)setAnswerDictionary:(NSMutableDictionary *)answerDictionary {
    [self setupDropDawnTextField:[answerDictionary objectForKey:kValues]];
    self.answerLabel.text = [answerDictionary objectForKey:kLabel];
    if ([answerDictionary objectForKey:kSelected]) {
        [self.dropDawnTextField setSelectedItem:[answerDictionary objectForKey:kSelected]];
    }
    _answerDictionary = answerDictionary;
}

- (void)setupDropDawnTextField:(NSArray *)values {
    self.dropDawnTextField.itemList = values;
    self.dropDawnTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reviewLeftViewField"]];
    self.dropDawnTextField.leftViewMode = UITextFieldViewModeAlways;
    self.dropDawnTextField.delegate = self;
}

#pragma mark - Delegate

- (void)textField:(IQDropDownTextField *)textField didSelectItem:(NSString *)item {
//    [self.answerDictionary setObject:item forKey:kSelected];
}

@end
