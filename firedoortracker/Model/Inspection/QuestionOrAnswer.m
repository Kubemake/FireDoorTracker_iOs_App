//
//  Question.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 19.03.15.
//
//

#import "QuestionOrAnswer.h"

@implementation QuestionOrAnswer

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.idFormField = dict[@"idFormFields"];
        self.label = dict[@"label"];
        self.name = dict[@"name"];
        self.nextQuiestionID = dict[@"nextQuestionId"];
        self.questionID = dict[@"questionId"];
        self.selected = dict[@"selected"];
        self.status = dict[@"status"];
        self.type = dict[@"type"];
        if ([dict objectForKey:@"answers"]) {
            NSMutableArray *answers = [NSMutableArray array];
            for (NSDictionary *answer in [[dict objectForKey:@"answers"] allObjects]) {
                QuestionOrAnswer *encodedAnswer = [[QuestionOrAnswer alloc] initWithDictionary:answer];
                [answers addObject:encodedAnswer];
            }
            self.answers = answers;
        }
    }
    return self;
}

- (QuestionOrAnswer *)answerByID:(NSString *)answerID {
    for (QuestionOrAnswer *answer in self.answers) {
        if ([answer.idFormField isEqualToString:answerID]) {
            return answer;
        }
    }
    return nil;
}

@end
