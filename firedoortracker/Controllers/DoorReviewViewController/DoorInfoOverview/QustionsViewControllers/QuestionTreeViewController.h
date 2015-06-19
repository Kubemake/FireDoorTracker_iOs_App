//
//  QuestionTreeViewController.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 19.03.15.
//
//

#import <UIKit/UIKit.h>

//Import Model
#import "Tab.h"
#import "QuestionOrAnswer.h"

@protocol QuestionTreeDelegate <NSObject>

@required
- (void)userSelectAnswer:(QuestionOrAnswer *)answer
  questionTreeController:(id)controller;
- (void)uploadPhoto:(UIImage *)photo toAnswer:(QuestionOrAnswer *)answer withComment:(NSString *)comment sender:(id)controller;

@end

@interface QuestionTreeViewController : UIViewController

@property (nonatomic, weak) id<QuestionTreeDelegate> questionDelegate;

@property (nonatomic, weak) NSArray* questionForReview;
@property (nonatomic, weak) Tab *tabForDisplaying;

- (void)refreshViewWithNewImages:(NSArray *)images andComments:(NSArray *)comments;
- (void)updateCurrentQuestionAnswers:(NSArray *)answers;

@end
