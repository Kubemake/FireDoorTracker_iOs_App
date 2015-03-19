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

static NSString* kTabs = @"tabs";
static NSString* kQuestions = @"issues";

@interface InterviewPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, startInterviewDelegate>

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

#pragma mark - Start Interview Delegate

- (void)submitDoorOverview {
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:InspectionQuestionListRequestType
                                                  andParams:@{kInspectionID : self.inspectionID,
                                                              kWallRating : [self doorOverviewPropertyByKey:kWallRating],
                                                              kSmokeRating : [self doorOverviewPropertyByKey:kSmokeRating],
                                                              kMaterial : [self doorOverviewPropertyByKey:kMaterial],
                                                              kRating : [self doorOverviewPropertyByKey:kRating]}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     //TODO: Display Error
                                                     return;
                                                 }
                                                 NSMutableArray *mutableTabs = [NSMutableArray array];
                                                 for (NSDictionary *tabDictionary in [[responseObject objectForKey:kTabs] allObjects]) {
                                                     //Server Bloody Issue fix
                                                     [mutableTabs addObject:[[Tab alloc] initWithDictionary:tabDictionary]];
                                                 }
                                                 welf.tabs = mutableTabs;
                                                 
                                                 NSMutableArray *mutableQuestions = [NSMutableArray array];
                                                 for (NSDictionary *quiestDict in [[responseObject objectForKey:kQuestions] allObjects]) {
                                                     QuestionOrAnswer *encodedQuestion = [[QuestionOrAnswer alloc] initWithDictionary:quiestDict];
                                                     [mutableQuestions addObject:encodedQuestion];
                                                 }
                                                 welf.questions = mutableQuestions;
                                                 [welf displayTabQuestionsViewControllers];
                                                 [welf displayTabsOnDoorInfoOverview];
                                             }];
}

- (NSString *)doorOverviewPropertyByKey:(NSString *)key {
    return [[self.doorOverviewDictionary objectForKey:key] objectForKey:kSelected];
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
        [contentViewControllersMutable addObject:questionVC];
    }
    //Add Confirmation View Controller
    InterviewConfirmationViewController *confVC = [self.storyboard instantiateViewControllerWithIdentifier:confirmationViewControllerIdentifier];
    [contentViewControllersMutable addObject:confVC];
    
    self.contentViewControllers = contentViewControllersMutable;
}

#pragma mark - public setters

- (void)setDoorOverviewDictionary:(NSDictionary *)doorOverviewDictionary {
    [self.startInterviewController displayDoorProperties:doorOverviewDictionary];
    _doorOverviewDictionary = doorOverviewDictionary;
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
