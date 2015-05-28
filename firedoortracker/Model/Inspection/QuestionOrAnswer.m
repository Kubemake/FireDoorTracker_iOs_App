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
        self.autoSubmit = [dict objectForKey:@"autoSubmit"];
        self.forceRefresh = [dict objectForKey:@"forceRefresh"];
        if ([dict objectForKey:@"answers"]) {
            NSMutableArray *answers = [NSMutableArray array];
            for (NSDictionary *answer in [[dict objectForKey:@"answers"] allObjects]) {
                QuestionOrAnswer *encodedAnswer = [[QuestionOrAnswer alloc] initWithDictionary:answer];
                [answers addObject:encodedAnswer];
            }
            self.answers = answers;
        }
        self.images = [dict objectForKey:@"images"];
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

- (NSArray *)selectedAnswersLabels {
    NSMutableArray *answersLabels = [NSMutableArray array];
    for (QuestionOrAnswer *answer in self.answers) {
        if ([answer.selected boolValue]) {
            [answersLabels addObject:answer.label];
        }
    }
    return answersLabels;
}

#pragma mark - Inspection Status

+ (NSArray *)statusesByQuestionAndAnswersArray:(NSArray *)questionAndAnswers {
    NSMutableArray *scanedStatuses = [NSMutableArray array];
    for (QuestionOrAnswer *currentQuestion in questionAndAnswers) {
        for (QuestionOrAnswer *currentAnswer in currentQuestion.answers) {
            if ([currentAnswer.selected boolValue]) {
                switch (currentAnswer.status.integerValue) {
                    case inspectionStatusCompliant: {
                        if (![scanedStatuses containsObject:@(inspectionStatusCompliant)]
                            && [scanedStatuses count] == 0) {
                            [scanedStatuses addObject:@(inspectionStatusCompliant)];
                        }
                        break;
                    }
                    case inspectionStatusMaintenance:
                    case inspectionStatusRecertify:
                    case inspectionStatusRepair:
                    case inspectionStatusReplace: {
                        if ([scanedStatuses containsObject:@(inspectionStatusCompliant)]) {
                            [scanedStatuses removeObject:@(inspectionStatusCompliant)];
                        }
                        if (![scanedStatuses containsObject:currentAnswer.status]) {
                            [scanedStatuses addObject:currentAnswer.status];
                        }
                        break;
                    }
                        
                    default:
                        break;
                }
            }
        }
    }
    if ([scanedStatuses count] == 0) {
        [scanedStatuses addObject:@(inspectionStatusUnknow)];
    }
    return scanedStatuses;
}

@end
