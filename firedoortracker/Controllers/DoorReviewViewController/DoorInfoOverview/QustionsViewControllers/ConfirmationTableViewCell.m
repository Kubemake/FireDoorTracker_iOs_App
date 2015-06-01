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
    for (int i = 0; i < answers.count; i++) {
        [answersString appendString:[NSString stringWithFormat:@"%@",[answers objectAtIndex:i]]];
        if ((i + 1) < answers.count) [answersString appendString:@",\n"];
    }
    self.answersLabel.text = answersString.length ? answersString : @"Compliant";
}

@end
