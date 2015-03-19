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

//Import Controllers
#import "InterviewPageViewController.h"
#import "StartInterviewViewController.h"

typedef enum{
    interviewPageControllerOverview = 0,
    interviewPageControllerQuestion = 1
}interviewPageController;

static NSString* startInterviewControllerIdentifier = @"startInterviewControllerIdentifier";

static NSString* kApertureID = @"aperture_id";
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
@property (nonatomic, strong) NSDictionary *questions;

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
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    return nil;
}

#pragma mark - UIPageViewControllerDelegate

#pragma mark - Start Interview Delegate

- (void)submitDoorOverview {
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:InspectionQuestionListRequestType
                                                  andParams:@{kApertureID : self.apertureID,
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
                                                 welf.questions = [responseObject objectForKey:kQuestions];
                                                 [welf displayTabsOnDoorInfoOverview];
                                             }];
}

- (NSString *)doorOverviewPropertyByKey:(NSString *)key {
    return [[self.doorOverviewDictionary objectForKey:key] objectForKey:kSelected];
}

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

#pragma mark - public setters

- (void)setDoorOverviewDictionary:(NSDictionary *)doorOverviewDictionary {
    [self.startInterviewController displayDoorProperties:doorOverviewDictionary];
    _doorOverviewDictionary = doorOverviewDictionary;
}

@end
