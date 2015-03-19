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

#pragma mark - Public Setters and Getter

- (NSNumber *)selected {
    if (_selected == [NSNull null]) {
        return @(NO);
    } else  {
        return _selected;
    }
}

- (NSNumber *)status {
    if (_status == [NSNull null]) {
        return @(0);
    } else {
        return _status;
    }
}

#pragma mark - Supporting Methods

- (QuestionOrAnswer *)answerByID:(NSString *)answerID {
    for (QuestionOrAnswer *answer in self.answers) {
        if ([answer.idFormField isEqualToString:answerID]) {
            return answer;
        }
    }
    return nil;
}

@end
