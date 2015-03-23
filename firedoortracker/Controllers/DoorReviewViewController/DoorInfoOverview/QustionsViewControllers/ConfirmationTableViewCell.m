//
//  ConfirmationTableViewCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 21.03.15.
//
//

//Import View
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
        [answersString appendString:[NSString stringWithFormat:@"%@,/n ",answer]];
    }
    self.answersLabel.text = answersString.length ? answersString : @"No Information";
}

/**
 *  return dynamic height for the answers string length
 *
 *  @param answers answers for displaying in method display question
 *
 *  @return height of cell
 */

+ (CGFloat)heightForAnswers:(NSArray *)answers {
    NSMutableString *answersString = [NSMutableString new];
    for (NSString *answer in answers) {
        [answersString appendString:[NSString stringWithFormat:@"%@,/n ",answer]];
    }
    CGSize answersLabelSize = [answersString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
    return answersLabelSize.height;
}

@end
