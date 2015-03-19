//
//  Question.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 19.03.15.
//
//

#import <Foundation/Foundation.h>

@interface QuestionOrAnswer : NSObject

@property (nonatomic, copy) NSString *idFormField;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *questionID;
@property (nonatomic, copy) NSString *nextQuiestionID;
@property (nonatomic, copy) NSString *selected;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray* answers;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

//Public accessory methods
- (QuestionOrAnswer *)answerByID:(NSString *)answerID;

@end
