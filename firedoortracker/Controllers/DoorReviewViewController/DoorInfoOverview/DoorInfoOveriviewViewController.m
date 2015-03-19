//
//  DoorInfoOveriviewViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

//Import Controllers
#import "DoorInfoOveriviewViewController.h"
#import "InterviewPageViewController.h"

//Import Model and Network Manager
#import "NetworkManager.h"

//Import View
#import <HMSegmentedControl.h>

//Import Extension
#import "UIColor+FireDoorTrackerColors.h"

static const CGFloat doorInfoHeight = 150.0f;
static const CGFloat hidenDoorInfoHeight = 22.0f;
static const CGFloat doorInfoMenuSegmentInset = 22.0f;

static NSString* segueEmbededInterviewControllerIdentifier = @"EmbededInterviewControllerSegueIdentifier";

static NSString* kApertureID = @"aperture_id";

@interface DoorInfoOveriviewViewController () <InterviewPageDelegate>

//IBOutlets and View Properties
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doorInfoHeightConstraint;
@property (assign, nonatomic) BOOL isDoorInfoHidden;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *doorInfoMenu;

//Embeded View Controller
@property (weak, nonatomic) InterviewPageViewController* embededInterviewController;

@end

@implementation DoorInfoOveriviewViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDoorInfoMenu];
    [self loadDoorOverview];
}

#pragma mark - Segue Delegation
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:segueEmbededInterviewControllerIdentifier]) {
        self.embededInterviewController = segue.destinationViewController;
        self.embededInterviewController.interviewDelegate = self;
    }
}

#pragma mark - Setup Methods
#pragma mark - 

- (void)setupDoorInfoMenu {
    //TODO: Change section titles
    self.doorInfoMenu.sectionTitles = @[@"Door Info Overview", @"Frame", @"Door", @"Hardware",@"Glazing",@"Operational Test", @"Confirm"];
    self.doorInfoMenu.selectionIndicatorColor = [UIColor FDTDarkGrayColor];
    self.doorInfoMenu.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor FDTLightGrayColor],
                                              NSFontAttributeName : [UIFont fontWithName:@"TimesNewRomanPSMT" size:15.0f]};
    self.doorInfoMenu.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor FDTDarkGrayColor],
                                                      NSFontAttributeName : [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:15.0f]};
    self.doorInfoMenu.selectionIndicatorHeight = 1.0f;
    self.doorInfoMenu.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    self.doorInfoMenu.segmentEdgeInset = UIEdgeInsetsMake(0, doorInfoMenuSegmentInset, 0, doorInfoMenuSegmentInset);
    self.doorInfoMenu.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(doorInfoMenuSegmentInset/2.0f, 0, 0, 0);
    self.doorInfoMenu.touchEnabled = NO;
    [self.doorInfoMenu addTarget:self
                          action:@selector(doorInfoMenuChangedValue:)
                forControlEvents:UIControlEventValueChanged];
}

- (void)loadDoorOverview {
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:InspectionDoorOverviewRequestType
                                                  andParams:@{kApertureID : self.selectedInspection.apertureId}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     //TODO: Display Error
                                                     return;
                                                 }
                                                 welf.embededInterviewController.doorOverviewDictionary = [responseObject objectForKey:@"info"];
                                                 welf.embededInterviewController.inspectionID = [self.selectedInspection uid];
                                             }];
}

#pragma mark - IBOutlets
#pragma mark -

- (IBAction)showDoorInfoStatusButtonPressed:(id)sender {
    self.doorInfoHeightConstraint.constant = (self.isDoorInfoHidden) ? doorInfoHeight : hidenDoorInfoHeight;
    self.isDoorInfoHidden = !self.isDoorInfoHidden;
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)doorInfoMenuChangedValue:(id)sender {
    [self.embededInterviewController setSelectedPage:self.doorInfoMenu.selectedSegmentIndex];
}

#pragma mark - Delegation Methods
#pragma mark - InterviewPageCOntroller Delegate

- (void)enableMenuTitles:(NSArray *)menuItems {
    self.doorInfoMenu.touchEnabled = YES;
    //TODO: Rwork this hardcode
    [self.doorInfoMenu setSelectedSegmentIndex:1 animated:YES];
    [self doorInfoMenuChangedValue:self.doorInfoMenu];
}


@end
