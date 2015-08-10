
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
#import <AVFoundation/AVFoundation.h>

static const CGFloat maxAnswerButtonHeight = 65.0f;
static const CGFloat answerButtonPadding = 5.0f;
static NSString* kuserTutorial = @"userTutorial";

@interface QuestionTreeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
@property (nonatomic, strong) QuestionOrAnswer *photoAnswer;

@end

@implementation QuestionTreeViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayTab:self.tabForDisplaying];
}

- (void)refreshViewWithNewImages:(NSArray *)images andComments:(NSArray *)comments {
    self.currentQuestion.images = images;
    self.currentQuestion.imagesComments = comments;
    [self.photosCollectionView reloadData];
}

- (void)updateCurrentQuestionAnswers:(NSArray *)answers {
    self.currentQuestion.answers = answers;
    [self displayQuestion:self.currentQuestion hidePhotoButton:YES];
}

#pragma mark - Display Methods

- (void)displayTab:(Tab *)tabForReview {
    QuestionOrAnswer *firstQuestionForTab = [self questionByID:tabForReview.nextQuiestionID];
    [self displayQuestion:firstQuestionForTab hidePhotoButton:YES];
}

#pragma mark - Display Question

- (void)displayQuestion:(QuestionOrAnswer *)question hidePhotoButton:(BOOL)hidePhotoButton {
    self.makePhotoButton.hidden = hidePhotoButton;
    [self.photosCollectionView reloadData];
    self.currentQuestion = question;
    self.questionTitleLabel.text = question.label;
    
    self.previousQuestionButton.enabled = (self.previosQuestion) ? YES : NO;
    
    self.nextQuestionButton.enabled = NO;
    
    //Hotfix for question
    if ([question.nextQuiestionID integerValue] > 0) {
        self.nextQuestionButton.enabled = YES;
    }
    
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
        answerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        
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
        
        if (![self.currentQuestion.name isEqualToString:@"SelecttheQuantityofHoles"]) {
            [self addStatusIconsToButton:answerButton withAnswer:answer];
        }
        
        [answerButtons addObject:answerButton];
        answerButtonY += answerButtonHeight;
    }
    self.answerButtons = answerButtons;
    self.selectedAnswer = nil;
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
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kuserTutorial]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kuserTutorial];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertController *tutorialAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Attention", nil)
                                                                               message:NSLocalizedString(@"Please note: if you have to change your answer, please first un-select your original answer before selecting the new one", nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [tutorialAlert addAction:okAction];
        [self presentViewController:tutorialAlert animated:YES completion:nil];
    }
    
    //TODO: Save current Answer for the crump breads
    self.selectedAnswer = [self.currentQuestion answerByID:[NSString stringWithFormat:@"%d",sender.tag]];
    if ([self.selectedAnswer.label isEqualToString:@"Other"] || [self.selectedAnswer.label isEqualToString:@"Write-in Option"]) {
        [self showOtherAlertView];
        return;
    }
    if ([self.currentQuestion.name containsString:@"EnterinDimensionsofSigns"]) {
        [self showDoorSizeAlert];
        return;
    }
    self.selectedAnswer.selected = ([self.selectedAnswer.selected boolValue]) ? @"NO" : @"YES";
    if ([self.selectedAnswer.status integerValue] == inspectionStatusCompliant) {
        [self resetAllAnswerSelectionWithousStatus:inspectionStatusCompliant];
    } else {
        [self resetAllAnswersWithStatus:inspectionStatusCompliant];
    }
    
    //TODO: Colorize Previous Answer Status as selected
    
    BOOL needToHidePhotoButton = YES;
    
    //If Answer not have side effect -> go to next question
    if (self.selectedAnswer.status.integerValue == 0 || ([self.selectedAnswer.autoSubmit boolValue] && [self.selectedAnswer.selected boolValue])) {
        
        if ([self.selectedAnswer.alert length]) {
            [self showQuestionAlert];
            return;
        }
        
        [self nextQuestionButtonPressed:sender];
    } else if ([self.selectedAnswer.selected boolValue]) {
        needToHidePhotoButton = NO;
        [self showPhotoButtonOppositeButton:sender];
    }
    //Delegate Notifyng
    if ([self.questionDelegate respondsToSelector:@selector(userSelectAnswer:questionTreeController:)]) {
        [self.questionDelegate userSelectAnswer:self.selectedAnswer questionTreeController:self];
    }
    
    //Reset UI View
    [self displayQuestion:self.currentQuestion hidePhotoButton:needToHidePhotoButton];
    self.nextQuestionButton.enabled = YES;
}

- (void)showQuestionAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Attention", nil)
                                                                   message:self.selectedAnswer.alert
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         if ([self.questionDelegate respondsToSelector:@selector(userSelectAnswer:questionTreeController:)]) {
                                                             [self.questionDelegate userSelectAnswer:self.selectedAnswer questionTreeController:self];
                                                         }
                                                     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

- (void)showOtherAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Other", nil)
                                                                   message:NSLocalizedString(@"Please input description", nil)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) welf = self;
    UIAlertAction *submit = [UIAlertAction actionWithTitle:NSLocalizedString(@"Submit", nil)
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       UITextField *descriptionInput = (UITextField *)[[alert textFields] firstObject];
                                                       welf.selectedAnswer.selected = descriptionInput.text;
                                                       if ([welf.questionDelegate respondsToSelector:@selector(userSelectAnswer:questionTreeController:)]) {
                                                           [welf.questionDelegate userSelectAnswer:welf.selectedAnswer questionTreeController:self];
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }
                                                   }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alert addAction:submit];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Description...", nil);
        textField.text = ([self.selectedAnswer.selected isKindOfClass:[NSString class]]) ? self.selectedAnswer.selected : @"";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showDoorSizeAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Door Sign", nil)
                                                                   message:NSLocalizedString(@"Please enter in dimensions of signs", nil)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) welf = self;
    UIAlertAction *submit = [UIAlertAction actionWithTitle:NSLocalizedString(@"Submit", nil)
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {
                                                       welf.selectedAnswer.selected = @"";
                                                       for(UITextField* field in [alert textFields]) {
                                                           if (welf.selectedAnswer.selected.length) {
                                                               welf.selectedAnswer.selected = [welf.selectedAnswer.selected stringByAppendingString:@","];
                                                           }
                                                           welf.selectedAnswer.selected = [welf.selectedAnswer.selected stringByAppendingString:[NSString stringWithFormat:@"%@",field.text]];
                                                       }
                                                       welf.selectedAnswer.special = self.currentQuestion.idFormField;
                                                       if ([welf.questionDelegate respondsToSelector:@selector(userSelectAnswer:questionTreeController:)]) {
                                                           [welf.questionDelegate userSelectAnswer:welf.selectedAnswer questionTreeController:self];
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }
                                                   }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    //    UIAlertAction* delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil)
    //                                                     style:UIAlertActionStyleCancel
    //                                                   handler:^(UIAlertAction * action) {
    //                                                       welf.selectedAnswer.selected = @"0,0";
    //                                                       if ([welf.questionDelegate respondsToSelector:@selector(userSelectAnswer:questionTreeController:)]) {
    //                                                           [welf.questionDelegate userSelectAnswer:welf.selectedAnswer questionTreeController:self];
    //                                                           [alert dismissViewControllerAnimated:YES completion:nil];
    //                                                       }
    //                                                   }];
    [alert addAction:submit];
    [alert addAction:cancel];
    //    [alert addAction:delete];
    
    NSArray *oldSize = @[[NSNull null]];
    
    if (self.selectedAnswer.selected) {
        oldSize = [self.selectedAnswer.selected componentsSeparatedByString:@","];
    }
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Width...", nil);
        if ([oldSize firstObject]) {
            textField.text = (NSString *)[oldSize firstObject];
        }
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Height...", nil);
        if ([oldSize lastObject]) {
            textField.text = (NSString *)[oldSize lastObject];
        }
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showPhotoButtonOppositeButton:(UIButton *)button {
    self.makePhotoButtonTopConstraint.constant = button.frame.origin.y + (button.bounds.size.height / 2.0f) - (self.makePhotoButton.bounds.size.height / 2.0f);
    
    self.makePhotoButton.tag = [self.selectedAnswer.idFormField integerValue];
    self.photoAnswer = self.selectedAnswer;
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
            answers.selected = @"NO";
        }
    }
}

- (void)resetAllAnswersWithStatus:(inspectionStatus)status {
    //Reset Model State
    for (QuestionOrAnswer *answers in self.currentQuestion.answers) {
        if (answers.status.integerValue == status) {
            answers.selected = @"NO";
        }
    }
}


- (IBAction)nextQuestionButtonPressed:(id)sender {
    QuestionOrAnswer *nextQuestion;
    if (self.selectedAnswer) {
        nextQuestion = [self questionByID:self.selectedAnswer.nextQuiestionID];
    } else {
        nextQuestion = [self questionByID:self.currentQuestion.nextQuiestionID];
    }
    
    //Delegate Notifyng
    if ([self.questionDelegate respondsToSelector:@selector(userSelectAnswer:questionTreeController:)]) {
        [self.questionDelegate userSelectAnswer:self.selectedAnswer questionTreeController:self];
    }
    
    if ([nextQuestion.idFormField integerValue] > 0) {
        self.previosQuestion = self.currentQuestion;
        [self displayQuestion:nextQuestion hidePhotoButton:YES];
    }
}

- (IBAction)previousQuestionButtonPressed:(id)sender {
    QuestionOrAnswer *previousQuestion = [self parentQuestionForQuestion:self.currentQuestion];
    if (previousQuestion) {
        self.currentQuestion = previousQuestion;
    } else {
        //TODO: Display Error
        self.currentQuestion = self.previosQuestion;
    }
    
    [self displayQuestion:self.currentQuestion hidePhotoButton:YES];
}

- (IBAction)makePhotoButonPressed:(UIButton *)sender {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                    message:NSLocalizedString(@"Please enable access to camera by firedoortracker in settings", nil)
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIAlertController *photoDescriptionDialog;
    if (chosenImage) {
        photoDescriptionDialog = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Description", nil)
                                                                     message:NSLocalizedString(@"Please input photo description:", nil)
                                                              preferredStyle:UIAlertControllerStyleAlert];
        [photoDescriptionDialog addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"Description...", nil);
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             UITextField *descriptionTextField = [[photoDescriptionDialog textFields] firstObject];
                                                             if ([self.questionDelegate respondsToSelector:@selector(uploadPhoto:toAnswer:withComment:sender:)]) {
                                                                 [self.questionDelegate uploadPhoto:chosenImage
                                                                                           toAnswer:self.photoAnswer
                                                                                        withComment:descriptionTextField.text
                                                                                             sender:self];
                                                             }
                                                         }];
        [photoDescriptionDialog addAction:okAction];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (photoDescriptionDialog) {
            [self presentViewController:photoDescriptionDialog animated:YES completion:nil];
        }
    }];
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

- (QuestionOrAnswer *)parentQuestionForQuestion:(QuestionOrAnswer *)question {
    for (QuestionOrAnswer *parentQuestion in self.questionForReview) {
        for (QuestionOrAnswer *parentAnswer in parentQuestion.answers) {
            if ([parentAnswer.idFormField isEqualToString:question.parent]) {
                return parentQuestion;
            }
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
    
    for (int i=0; i < self.currentQuestion.images.count; i++) {
        NSURL *url = [NSURL URLWithString:[self.currentQuestion.images objectAtIndex:i]];
        IDMPhoto *photo = [IDMPhoto photoWithURL:url];
        photo.caption = [self.currentQuestion.imagesComments objectAtIndex:i];
        [photos addObject:photo];
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    [browser setInitialPageIndex:indexPath.row];
    [self presentViewController:browser animated:YES completion:nil];
}

@end
