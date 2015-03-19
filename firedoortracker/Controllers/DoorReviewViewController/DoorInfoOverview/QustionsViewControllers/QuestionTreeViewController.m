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
#import "QuestionOrAnswer.h"

//Import Extension
#import "UIFont+FDTFonts.h"
#import "UIColor+FireDoorTrackerColors.h"

static const CGFloat maxAnswerButtonHeight = 65.0f;
static const CGFloat answerButtonPadding = 5.0f;

@interface QuestionTreeViewController ()

//IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *questionBodyView;

//User Data
@property (nonatomic, weak) QuestionOrAnswer *currentQuestion;

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
    
    [self removeAllButtonsFromView];
    CGFloat answerButtonHeight = self.questionBodyView.bounds.size.height / self.currentQuestion.answers.count;
    CGFloat answerButtonY = 0;
    for (QuestionOrAnswer *answer in question.answers) {
        UIButton *answerButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                            answerButtonY,
                                                                            self.questionBodyView.bounds.size.width,
                                                                            MIN(answerButtonHeight-answerButtonPadding,maxAnswerButtonHeight))];
        //TODO: Change to answer collor
        [answerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [answerButton.titleLabel setFont:[UIFont FDTTimesNewRomanBoldWithSize:24.0f]];
        [answerButton setBackgroundColor:[UIColor FDTDeepBlueColor]];
        
        answerButton.tag = [answer.idFormField integerValue];
        [answerButton setTitle:answer.label forState:UIControlStateNormal];
        
        [answerButton addTarget:self action:@selector(answerSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.questionBodyView addSubview:answerButton];
        answerButtonY += answerButtonHeight;
    }
}

- (void)removeAllButtonsFromView {
    for (UIButton* button in self.questionBodyView.subviews) {
        [button removeFromSuperview];
    }
}

#pragma mark - Actions
#pragma mark - 

- (void)answerSelected:(UIButton *)sender {
    //TODO: Save current Answer for the crump breads
    QuestionOrAnswer *currentAnswer = [self questionByID:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    QuestionOrAnswer *nextAnswer = [self questionByID:currentAnswer.nextQuiestionID];
    [self displayQuestion:nextAnswer];
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
