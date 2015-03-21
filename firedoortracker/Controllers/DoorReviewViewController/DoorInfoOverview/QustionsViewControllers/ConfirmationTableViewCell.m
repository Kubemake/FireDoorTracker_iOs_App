//
//  ConfirmationTableViewCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 21.03.15.
//
//

#import "ConfirmationTableViewCell.h"

@interface ConfirmationTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answersLabel;

@end

@implementation ConfirmationTableViewCell

- (void)displayQuestion:(NSString *)question andAnswers:(NSArray *)answers {
    self.questionLabel.text = question;
    NSMutableString *answersString = [NSMutableString new];
    for (NSString *answer in answers) {
        [answersString appendString:[NSString stringWithFormat:@"%@, ",answer]];
    }
    self.answersLabel.text = answersString.length ? answersString : @"No Information";
}

@end
