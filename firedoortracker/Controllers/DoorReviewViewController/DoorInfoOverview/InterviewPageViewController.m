//
//  InterviewPageViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

//Import Network Manager and Model
#import "NetworkManager.h"
#import "Tab.h"
#import "QuestionOrAnswer.h"

//Import Controllers
#import "InterviewPageViewController.h"
#import "StartInterviewViewController.h"
#import "QuestionTreeViewController.h"
#import "InterviewConfirmationViewController.h"

//Import View
#import <SVProgressHUD.h>

typedef enum{
    interviewPageControllerOverview = 0,
    interviewPageControllerQuestion = 1
}interviewPageController;

static NSString* startInterviewControllerIdentifier = @"startInterviewControllerIdentifier";
static NSString* questionTreeViewControllerIdentifier = @"QuestionTreeViewController";
static NSString* confirmationViewControllerIdentifier = @"InterviewConfirmationViewController";

static NSString* kInspectionID = @"inspection_id";
static NSString* kWallRating = @"wall_Rating";
static NSString* kSmokeRating = @"smoke_Rating";
static NSString* kMaterial = @"material";
static NSString* kRating = @"rating";
static NSString* kSelected = @"selected";
static NSString* kStatus = @"status";
static NSString* kidFormField = @"idFormFields";
static NSString* kAperture = @"aperture_id";
static NSString* kFile = @"file";
static NSString* kFileName = @"file_name";
static NSString* kSpecial = @"Special";
static NSString* kQuestionId = @"questionId";

static NSString* kTabs = @"tabs";
static NSString* kQuestions = @"issues";
static NSString* kAnswers = @"answers";
static NSString* kUpdatedInspection = @"updated_inspection";

@interface InterviewPageViewController () <UIPageViewControllerDataSource,
UIPageViewControllerDelegate,
startInterviewDelegate,
QuestionTreeDelegate,
InterviewConfirmationProtocol>

//Child View Controllers
@property (nonatomic, strong) StartInterviewViewController* startInterviewController;

//Inspections Quiestions and Tabs
@property (nonatomic, strong) NSArray *tabs;
@property (nonatomic, strong) NSArray *questions;

//Page Content controllers
@property (nonatomic, strong) NSArray *contentViewControllers;

@end

@implementation InterviewPageViewController

#pragma mark - View Controller Leyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPageController];
}

#pragma mark - Setup Methods

- (void)setupPageController {
    self.delegate = self;
    self.dataSource = self;
    self.startInterviewController = [self.storyboard instantiateViewControllerWithIdentifier:startInterviewControllerIdentifier];
    self.startInterviewController.delegate = self;
    [self setViewControllers:@[self.startInterviewController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
}

#pragma mark - UIPageViewController
#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfContentViewController:viewController];
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfContentViewController:viewController];
    
    
    index++;
    
    if (index == self.contentViewControllers.count || index == NSNotFound) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    if (index != NSNotFound && index < self.contentViewControllers.count) {
        return [self.contentViewControllers objectAtIndex:index];
    }
    return nil;
}

- (NSInteger)indexOfContentViewController:(UIViewController *)controller {
    for (UIViewController* contentController in self.contentViewControllers) {
        if (controller == contentController) {
            return [self.contentViewControllers indexOfObject:contentController];
        }
    }
    return NSNotFound;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (completed) {
        UIViewController *currentVC = [pageViewController.viewControllers lastObject];
        NSInteger indexOfCurrentVC = [self indexOfContentViewController:currentVC];
        if ([self.interviewDelegate respondsToSelector:@selector(didScrollToMenuItem:)]) {
            [self.interviewDelegate didScrollToMenuItem:indexOfCurrentVC];
        }
    }
}

#pragma mark - Start Interview Delegate

- (void)submitDoorOverview:(NSDictionary *)answersDictionary {
    __weak typeof(self) welf = self;
    [SVProgressHUD show];
    NSMutableDictionary *answersWithInspectionID = [NSMutableDictionary dictionaryWithDictionary:answersDictionary];
    [answersWithInspectionID setObject:self.inspectionID forKey:kInspectionID];
    [[NetworkManager sharedInstance] performRequestWithType:InspectionQuestionListRequestType
                                                  andParams:answersWithInspectionID
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [SVProgressHUD showSuccessWithStatus:nil];
                                                 NSMutableArray *mutableTabs = [NSMutableArray array];
                                                 for (NSDictionary *tabDictionary in [[responseObject objectForKey:kTabs] allObjects]) {
                                                     [mutableTabs addObject:[[Tab alloc] initWithDictionary:tabDictionary]];
                                                 }
                                                 welf.tabs = mutableTabs;
                                                 
                                                 NSMutableArray *mutableQuestions = [NSMutableArray array];
                                                 for (NSDictionary *quiestDict in [[responseObject objectForKey:kQuestions] allObjects]) {
                                                     QuestionOrAnswer *encodedQuestion = [[QuestionOrAnswer alloc] initWithDictionary:quiestDict];
                                                     [mutableQuestions addObject:encodedQuestion];
                                                 }
                                                 welf.questions = mutableQuestions;
                                                 Inspection *updatedInspection = [[Inspection alloc] initWithDictionary:[responseObject objectForKey:kUpdatedInspection]];
                                                 [welf.interviewDelegate inspectionUpdated:updatedInspection];
                                                 [welf displayTabQuestionsViewControllers];
                                                 [welf displayTabsOnDoorInfoOverview];
                                                 [welf notifyDelagateAboutStatusChanges];
                                             }];
}

#pragma mark - Question-Answer delegate

- (void)userSelectAnswer:(QuestionOrAnswer *)answer questionTreeController:(id)controller {
    //TODO: Maybe call this method ever
    [self notifyDelagateAboutStatusChanges];
    //Save info and server
    if ([answer.forceRefresh boolValue]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    [[NetworkManager sharedInstance] performRequestWithType:InspectionUpdateDataRequestType
                                                  andParams:@{kInspectionID : self.inspectionID,
                                                              kidFormField : (answer.idFormField) ? : [NSNull null],
                                                              kSelected : (answer.selected) ? : [NSNull null],
                                                              kStatus : (answer.status) ? : [NSNull null],
                                                              kSpecial : (answer.special) ? : [NSNull null],
                                                              kQuestionId: (answer.questionID) ? : [NSNull null]}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 [SVProgressHUD dismiss];
                                                 if (error) {
                                                     //TODO: Display Error
                                                     return;
                                                 }
                                                 NSDictionary *updatedAnswers = [responseObject objectForKey:kAnswers];
                                                 if (updatedAnswers) {
                                                     NSMutableArray *answers = [NSMutableArray array];
                                                     for (NSDictionary *answer in updatedAnswers) {
                                                         [answers addObject:[[QuestionOrAnswer alloc] initWithDictionary:answer]];
                                                     }
                                                     [controller updateCurrentQuestionAnswers:answers];
                                                 }
                                             }];
}

- (void)userMakePhoto:(UIImage *)photo
             toAnswer:(QuestionOrAnswer *)answer
questionTreeController:(id)controller {
    [SVProgressHUD show];
    __weak typeof(self) welf = self;
    
    NSDictionary *params = @{ kFile     : photo,
                              kFileName : answer.label,
                              kInspectionID : self.inspectionID,
                              kidFormField : answer.idFormField};
    
    [[NetworkManager sharedInstance] performRequestWithType:uploadFileRequestType
                                                  andParams:params
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [SVProgressHUD showSuccessWithStatus:@""];
                                                 [controller refreshViewWithNewImages:[responseObject objectForKey:@"images"]];
                                             }];
}

- (void)notifyDelagateAboutStatusChanges {
    if ([self.interviewDelegate respondsToSelector:@selector(changeInspectionStatusTo:)]) {
        [self.interviewDelegate
         changeInspectionStatusTo:[QuestionOrAnswer statusesByQuestionAndAnswersArray:self.questions]];
    }
}

#pragma mark - Review Confirmation Delegate

- (void)interviewConfirmed {
    [SVProgressHUD show];
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:InspectionConfirmationRequestType
                                                  andParams:@{kInspectionID : self.inspectionID}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [welf.navigationController popToRootViewControllerAnimated:YES];
                                                 [welf.interviewDelegate inspectionConfirmded];
                                                 [SVProgressHUD showSuccessWithStatus:@"Inspection Sent to the Server"];
                                             }];
}

#pragma mark - Display Methods
#pragma mark - Interview Page Delegate Methods

- (void)displayTabsOnDoorInfoOverview {
    NSMutableArray *tabsForDisplaying = [NSMutableArray array];
    for (Tab *tab in self.tabs) {
        [tabsForDisplaying addObject:tab.label];
    }
    if ([self.interviewDelegate respondsToSelector:@selector(enableMenuTitles:)]) {
        [self.interviewDelegate enableMenuTitles:tabsForDisplaying];
    }
}

#pragma mark - Display Tabs View Controllers

- (void)displayTabQuestionsViewControllers {
    NSMutableArray *contentViewControllersMutable = [NSMutableArray arrayWithObject:self.startInterviewController];
    for (Tab *currentTab in self.tabs) {
        QuestionTreeViewController *questionVC = [self.storyboard instantiateViewControllerWithIdentifier:questionTreeViewControllerIdentifier];
        questionVC.questionForReview = self.questions;
        questionVC.tabForDisplaying = currentTab;
        questionVC.questionDelegate = self;
        [contentViewControllersMutable addObject:questionVC];
    }
    //Add Confirmation View Controller
    InterviewConfirmationViewController *confVC = [self.storyboard instantiateViewControllerWithIdentifier:confirmationViewControllerIdentifier];
    confVC.tabs = self.tabs;
    confVC.questionAndAnswers = self.questions;
    confVC.confirmationDelegate = self;
    [contentViewControllersMutable addObject:confVC];
    
    self.contentViewControllers = contentViewControllersMutable;
}

#pragma mark - public setters

- (void)setDoorOverviewDictionary:(NSDictionary *)doorOverviewDictionary
                     toApertureId:(NSString *)apertureId
                         sections:(NSArray *)sections {
    [self.startInterviewController displayDoorProperties:doorOverviewDictionary
                                              apertureId:apertureId
                                                sections:sections];
}

- (void)setSelectedPage:(NSInteger)selectedPage {
    if ([self viewControllerAtIndex:selectedPage] ) {
        [self setViewControllers:@[[self viewControllerAtIndex:selectedPage]]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:YES
                      completion:nil];
    }
}

@end
