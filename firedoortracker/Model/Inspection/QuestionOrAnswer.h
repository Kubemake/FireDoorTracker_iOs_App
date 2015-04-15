//
//  Question.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 19.03.15.
//
//

#import <Foundation/Foundation.h>
#import "Inspection.h"

@interface QuestionOrAnswer : NSObject

@property (nonatomic, copy) NSString *idFormField;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *questionID;
@property (nonatomic, copy) NSString *nextQuiestionID;
@property (nonatomic, copy) NSString *selected;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray* answers;
@property (nonatomic, strong) NSArray *images;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

//Public accessory methods
- (QuestionOrAnswer *)answerByID:(NSString *)answerID;
- (NSArray *)selectedAnswersLabels;

//Status for Door Review
+ (NSArray *)statusesByQuestionAndAnswersArray:(NSArray *)questionAndAnswers;

@end
