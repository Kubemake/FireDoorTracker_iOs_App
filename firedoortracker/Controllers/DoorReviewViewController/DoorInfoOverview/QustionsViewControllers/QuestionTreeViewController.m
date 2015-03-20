//
//  QuestionTreeViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 19.03.15.
//
//

//Imporrt Controllers
#import "QuestionTreeViewController.h"

//Import Model
#import "Inspection.h"

//Import Extension
#import "UIFont+FDTFonts.h"
#import "UIColor+FireDoorTrackerColors.h"

static const CGFloat maxAnswerButtonHeight = 65.0f;
static const CGFloat answerButtonPadding = 5.0f;

@interface QuestionTreeViewController ()

//IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *questionBodyView;
@property (nonatomic, strong) NSArray* answerButtons;
@property (weak, nonatomic) IBOutlet UIButton *previousQuestionButton;
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionButton;

//User Data
@property (nonatomic, weak) QuestionOrAnswer *previosQuestion;
@property (nonatomic, weak) QuestionOrAnswer *currentQuestion;
@property (nonatomic, weak) QuestionOrAnswer *selectedAnswer;

@end

@implementation QuestionTreeViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayTab:self.tabForDisplaying];
}

#pragma mark - Display Methods

- (void)displayTab:(Tab *)tabForReview {
    QuestionOrAnswer *firstQuestionForTab = [self questionByID:tabForReview.nextQuiestionID];
    [self displayQuestion:firstQuestionForTab];
}

#pragma mark - Display Question

- (void)displayQuestion:(QuestionOrAnswer *)question {
    self.currentQuestion = question;
    self.questionTitleLabel.text = question.label;
    
    self.previousQuestionButton.enabled = (self.previosQuestion) ? YES : NO;
    self.nextQuestionButton.enabled = NO;
    
    [self removeAllButtonsFromView];
    CGFloat answerButtonHeight = self.questionBodyView.bounds.size.height / self.currentQuestion.answers.count;
    CGFloat answerButtonY = 0;
    NSMutableArray *answerButtons = [NSMutableArray array];
    for (QuestionOrAnswer *answer in question.answers) {
        UIButton *answerButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                            answerButtonY,
                                                                            self.questionBodyView.bounds.size.width,
                                                                            MIN(answerButtonHeight-answerButtonPadding,maxAnswerButtonHeight))];
        //TODO: Change to answer collor
        [answerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [answerButton.titleLabel setFont:[UIFont FDTTimesNewRomanBoldWithSize:24.0f]];
        
        if ([answer.selected boolValue]) {
            //TODO: Add to the question array
            self.nextQuestionButton.enabled = YES;
            self.selectedAnswer = answer;
            [answerButton setBackgroundColor:[Inspection colorForStatus:answer.status.integerValue]];
        } else {
            [answerButton setBackgroundColor:[UIColor FDTDeepBlueColor]];
        }
        
        answerButton.tag = [answer.idFormField integerValue];
        [answerButton setTitle:answer.label forState:UIControlStateNormal];
        [answerButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answerButton.titleLabel setShadowOffset:CGSizeMake(1, 1)];
        
        [answerButton addTarget:self action:@selector(answerSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.questionBodyView addSubview:answerButton];
        [answerButtons addObject:answerButton];
        answerButtonY += answerButtonHeight;
    }
    self.answerButtons = answerButtons;
}

#pragma mark - Supporting Methods


- (void)removeAllButtonsFromView {
    for (UIButton* button in self.questionBodyView.subviews) {
        [button removeFromSuperview];
    }
}

#pragma mark - Actions
#pragma mark - 

- (void)answerSelected:(UIButton *)sender {
    //TODO: Save current Answer for the crump breads
    self.selectedAnswer = [self.currentQuestion answerByID:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    self.selectedAnswer.selected = [NSNumber numberWithBool:![self.selectedAnswer.selected boolValue]];
    if ([self.selectedAnswer.status integerValue] == inspectionStatusCompliant) {
        [self resetAllAnswerSelectionWithousStatus:inspectionStatusCompliant];
    } else {
        [self resetAllAnswersWithStatus:inspectionStatusCompliant];
    }
    //Reset UI View
    [self displayQuestion:self.currentQuestion];
    
    //TODO: Colorize Previous Answer Status as selected
    
    //If Answer not have side effect -> go to next question
    if (self.selectedAnswer.status.integerValue == 0) {
        [self nextQuestionButtonPressed:sender];
    }
}

- (void)resetAllAnswerSelectionWithousStatus:(inspectionStatus)status {
    //Reset Model State
    for (QuestionOrAnswer *answers in self.currentQuestion.answers) {
        if (answers.status.integerValue != status) {
            answers.selected = [NSNumber numberWithBool:NO];
        }
    }
}

- (void)resetAllAnswersWithStatus:(inspectionStatus)status {
    //Reset Model State
    for (QuestionOrAnswer *answers in self.currentQuestion.answers) {
        if (answers.status.integerValue == status) {
            answers.selected = [NSNumber numberWithBool:NO];
        }
    }
}


- (IBAction)nextQuestionButtonPressed:(id)sender {
    self.previosQuestion = self.currentQuestion;
    QuestionOrAnswer *nextQuestion = [self questionByID:self.selectedAnswer.nextQuiestionID];
    
    //Delegate Notifyng
    if ([self.questionDelegate respondsToSelector:@selector(userSelectAnswer:)]) {
        [self.questionDelegate userSelectAnswer:self.selectedAnswer];
    }
    
    [self displayQuestion:nextQuestion];
}

- (IBAction)previousQuestionButtonPressed:(id)sender {
    self.currentQuestion = self.previosQuestion;
    [self displayQuestion:self.currentQuestion];
}

#pragma mark - Support Question Methods
#pragma mark - Find question by ID

- (QuestionOrAnswer *)questionByID:(NSString *)uid {
    for (QuestionOrAnswer *question in self.questionForReview) {
        if ([question.idFormField isEqualToString:uid]) {
            return question;
        }
    }
    return nil;
}

@end
