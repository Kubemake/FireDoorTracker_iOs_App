//
//  InterviewPageViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

//Import Controllers
#import "InterviewPageViewController.h"
#import "StartInterviewViewController.h"

typedef enum{
    interviewPageControllerOverview = 0,
    interviewPageControllerQuestion = 1
}interviewPageController;

static NSString* startInterviewControllerIdentifier = @"startInterviewControllerIdentifier";

@interface InterviewPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) StartInterviewViewController* startInterviewController;

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

#pragma mark - public setters

- (void)setDoorOverviewDictionary:(NSDictionary *)doorOverviewDictionary {
    [self.startInterviewController displayDoorProperties:doorOverviewDictionary];
}

@end
