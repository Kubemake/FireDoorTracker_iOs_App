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
#import "UIImage+Utilities.h"

//Import View
#import "PhotoCollectionViewCell.h"

//Import Pods
#import <IDMPhotoBrowser.h>

static const CGFloat maxAnswerButtonHeight = 65.0f;
static const CGFloat answerButtonPadding = 5.0f;

@interface QuestionTreeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *questionBodyView;
@property (nonatomic, strong) NSArray* answerButtons;
@property (weak, nonatomic) IBOutlet UIButton *previousQuestionButton;
@property (weak, nonatomic) IBOutlet UIButton *nextQuestionButton;
@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *makePhotoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *makePhotoButtonTopConstraint;

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

- (void)refreshViewWithNewImages:(NSArray *)images {
    self.currentQuestion.images = images;
    [self.photosCollectionView reloadData];
}

#pragma mark - Display Methods

- (void)displayTab:(Tab *)tabForReview {
    QuestionOrAnswer *firstQuestionForTab = [self questionByID:tabForReview.nextQuiestionID];
    [self displayQuestion:firstQuestionForTab];
}

#pragma mark - Display Question

- (void)displayQuestion:(QuestionOrAnswer *)question {
    self.makePhotoButton.hidden = YES;
    [self.photosCollectionView reloadData];
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
                                                                            self.questionBodyView.bounds.size.width - 45.0f,
                                                                            MIN(answerButtonHeight-answerButtonPadding,maxAnswerButtonHeight))];
        //TODO: Change to answer collor
        [answerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [answerButton.titleLabel setFont:[UIFont FDTTimesNewRomanBoldWithSize:24.0f]];
        
        if ([answer.selected boolValue]) {
            //TODO: Add to the question array
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
        [self addStatusIconsToButton:answerButton withAnswer:answer];
        
        [answerButtons addObject:answerButton];
        answerButtonY += answerButtonHeight;
    }
    self.answerButtons = answerButtons;
}

- (void)addStatusIconsToButton:(UIButton *)button withAnswer:(QuestionOrAnswer *)answer {
    CGFloat statusIconX = button.frame.origin.x + button.bounds.size.width + 2.0f;
    QuestionOrAnswer *nextQuestionWithAnswers = [self questionByID:answer.nextQuiestionID];
    for (QuestionOrAnswer *subQuestions in nextQuestionWithAnswers.answers) {
        if ([subQuestions.selected boolValue]) {
            UIImageView *statusIcon = [[UIImageView alloc] initWithImage:[UIImage imageForReviewStaton:subQuestions.status.integerValue]];
            statusIcon.frame = CGRectMake(statusIconX, 0, statusIcon.bounds.size.width, statusIcon.bounds.size.height);
            [button addSubview:statusIcon];
            statusIconX += statusIcon.bounds.size.width + 2.0f;
        }
    }
}

#pragma mark - Supporting Methods


- (void)removeAllButtonsFromView {
    for (UIButton* button in self.questionBodyView.subviews) {
        if (button != self.makePhotoButton) {
            [button removeFromSuperview];
        }
    }
}

#pragma mark - Actions
#pragma mark -

- (void)answerSelected:(UIButton *)sender {
    //TODO: Save current Answer for the crump breads
    self.selectedAnswer = [self.currentQuestion answerByID:[NSString stringWithFormat:@"%d",sender.tag]];
    self.selectedAnswer.selected = [NSNumber numberWithBool:![self.selectedAnswer.selected boolValue]];
    if ([self.selectedAnswer.status integerValue] == inspectionStatusCompliant) {
        [self resetAllAnswerSelectionWithousStatus:inspectionStatusCompliant];
    } else {
        [self resetAllAnswersWithStatus:inspectionStatusCompliant];
    }
    //Reset UI View
    [self displayQuestion:self.currentQuestion];
    self.nextQuestionButton.enabled = YES;
    
    //TODO: Colorize Previous Answer Status as selected
    
    //If Answer not have side effect -> go to next question
    if (self.selectedAnswer.status.integerValue == 0) {
        [self nextQuestionButtonPressed:sender];
    } else if ([self.selectedAnswer.selected boolValue]) {
        [self showPhotoButtonOppositeButton:sender];
    }
}

- (void)showPhotoButtonOppositeButton:(UIButton *)button {
    self.makePhotoButtonTopConstraint.constant = button.frame.origin.y + (button.bounds.size.height / 2.0f) - (self.makePhotoButton.bounds.size.height / 2.0f);
    
    self.makePhotoButton.tag = [self.selectedAnswer.idFormField integerValue];
    self.makePhotoButton.hidden = NO;
    
    [UIView animateWithDuration:0.25f
                          delay:0
         usingSpringWithDamping:0.75f
          initialSpringVelocity:0.05f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.makePhotoButton layoutIfNeeded];
                     } completion:nil];
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

- (IBAction)makePhotoButonPressed:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if ([self.questionDelegate respondsToSelector:@selector(userMakePhoto:toAnswer:questionTreeController:)]) {
        [self.questionDelegate userMakePhoto:chosenImage
                                    toAnswer:self.selectedAnswer
         questionTreeController:self];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - Images Collection View
#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentQuestion.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionViewCell reuseIdentifier]
                                                                              forIndexPath:indexPath];
    [cell displayImage:[self.currentQuestion.images objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photos = [NSMutableArray new];
    
    for (NSString *url in self.currentQuestion.images) {
        IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:url]];
        [photos addObject:photo];
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos
                                                      animatedFromView:self.view];
    [browser setInitialPageIndex:indexPath.row];
    [self presentViewController:browser animated:YES completion:nil];

}

@end
