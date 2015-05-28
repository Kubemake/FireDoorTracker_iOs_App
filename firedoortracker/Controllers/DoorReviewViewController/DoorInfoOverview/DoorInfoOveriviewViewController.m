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
#import <SVProgressHUD.h>

//Import Extension
#import "UIColor+FireDoorTrackerColors.h"
#import "UIFont+FDTFonts.h"
#import "UIImage+Utilities.h"

#import "NavigationBarButtons.h"

static const CGFloat doorInfoHeight = 200.0f;
static const CGFloat hidenDoorInfoHeight = 22.0f;
static const CGFloat doorInfoMenuSegmentInset = 22.0f;

static NSString* segueEmbededInterviewControllerIdentifier = @"EmbededInterviewControllerSegueIdentifier";

static NSString* kApertureID = @"aperture_id";

@interface DoorInfoOveriviewViewController ()<InterviewPageDelegate>

//IBOutlets and View Properties
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doorInfoHeightConstraint;
@property (assign, nonatomic) BOOL isDoorInfoHidden;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *doorInfoMenu;

@property (weak, nonatomic) IBOutlet UILabel *doorStatusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelXConstraint;
@property (nonatomic, strong) NSMutableArray *statusViews;
@property (weak, nonatomic) IBOutlet UILabel *inspectionInfoLabel;

//Embeded View Controller
@property (weak, nonatomic) InterviewPageViewController* embededInterviewController;

@end

@implementation DoorInfoOveriviewViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    self.navigationItem.leftBarButtonItem = [NavigationBarButtons backBarButtonItem];
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(backButtonPressed)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDoorInfoMenu];
    [self loadDoorOverview];
    [self setupInspectionInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(DoorInfoOveriviewViewController:didUpdateInspection:)]) {
        [self.delegate DoorInfoOveriviewViewController:self didUpdateInspection:self.selectedInspection];
    }
}

#pragma mark - Actions
#pragma mark -

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segue Delegation
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:segueEmbededInterviewControllerIdentifier]) {
        self.embededInterviewController = segue.destinationViewController;
        self.embededInterviewController.inspectionID = self.selectedInspection.uid;
        self.embededInterviewController.interviewDelegate = self;
    }
}

#pragma mark - Setup Methods
#pragma mark - 

- (void)setupInspectionInfo {
    self.inspectionInfoLabel.text = [NSString stringWithFormat:@"%@\n%@ %@\n%@ %@\n%@",self.selectedInspection.barCode,
                                 self.selectedInspection.buildingName, self.selectedInspection.locationName,
                                 self.selectedInspection.firstName, self.selectedInspection.lastName,
                                 self.selectedInspection.completionDate
                                 ];
    if ([self.selectedInspection.colorStatus count]) {
        [self changeInspectionStatusTo:self.selectedInspection.colorStatus];
    }
}

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
    [self.doorInfoMenu addTarget:self
                          action:@selector(doorInfoMenuChangedValue:)
                forControlEvents:UIControlEventValueChanged];
}

- (void)loadDoorOverview {
    __weak typeof(self) welf = self;
    [SVProgressHUD show];
    [[NetworkManager sharedInstance] performRequestWithType:InspectionDoorOverviewRequestType
                                                  andParams:@{kApertureID : self.selectedInspection.apertureId}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [SVProgressHUD dismiss];
                                                 [welf.embededInterviewController setDoorOverviewDictionary:[responseObject objectForKey:@"info"]
                                                                                               toApertureId:self.selectedInspection.apertureId
                                                                                                   sections:[responseObject objectForKey:@"sections"]];
                                                 ;
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
#pragma mark - Interview Page Delegate 

- (void)enableMenuTitles:(NSArray *)menuItems {
    NSMutableArray *sectionTitles = [NSMutableArray arrayWithArray:menuItems];
    [sectionTitles insertObject:@"Door Info Overview" atIndex:0];
    [sectionTitles insertObject:@"Confirm" atIndex:sectionTitles.count];
    [self.doorInfoMenu setSectionTitles:sectionTitles];
    [self.doorInfoMenu setSelectedSegmentIndex:1];
    [self.embededInterviewController setSelectedPage:1];
}

- (void)didScrollToMenuItem:(NSInteger)menuItem {
    [self.doorInfoMenu setSelectedSegmentIndex:menuItem animated:YES];
}

- (void)changeInspectionStatusTo:(NSArray *)newStatuses {
    //Remove previous statuses
    for (UIView *statusSubview in self.statusViews) {
        [statusSubview removeFromSuperview];
    }
    [self.statusViews removeAllObjects];
    self.statusViews = [NSMutableArray array];
    
    //move status label to new position to display new statuses
    self.statusLabelXConstraint.constant = newStatuses.count * 50.0f;
    [self.view layoutIfNeeded];
    
    for (NSNumber *nextStatus in newStatuses) {
        inspectionStatus encodedStatus = (inspectionStatus)[nextStatus integerValue];
        [self addAndDisplayStatusView:encodedStatus];
    }
    //save changes ins inspection object
    self.selectedInspection.colorStatus = newStatuses;
}

- (void)inspectionUpdated:(Inspection *)updatedInspection {
    if (updatedInspection) {
        self.selectedInspection = updatedInspection;
        [self setupInspectionInfo];
    }
}

#pragma mark - Display Methods 

- (void)addAndDisplayStatusView:(inspectionStatus)status {
    NSString *statusName = [Inspection stringForStatus:status];
    
    CGSize statusTextSize = [statusName sizeWithAttributes:@{NSFontAttributeName:[UIFont FDTRobotoLightWithSize:17.0f]}];
    UILabel *statusNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         statusTextSize.width,
                                                                         statusTextSize.height)];
    [statusNameLabel setFont:[UIFont FDTRobotoLightWithSize:17.0f]];
    [statusNameLabel setTextColor:[UIColor FDTDarkGrayColor]];
    statusNameLabel.text = statusName;
    
    UIImageView *statusIcon = [[UIImageView alloc] initWithImage:[UIImage imageForReviewStaton:status]];
    statusIcon.frame = CGRectMake(statusNameLabel.bounds.size.width + 5.0f,
                                  0,
                                  statusIcon.bounds.size.width,
                                  statusIcon.bounds.size.height);
    
    CGFloat lastStatusLabelXWithWidth = self.doorStatusLabel.bounds.size.width;
    
    if ([self.statusViews lastObject]) {
        UIView *lastStatusView = (UIView *)[self.statusViews lastObject];
        lastStatusLabelXWithWidth = lastStatusView.frame.origin.x + lastStatusView.bounds.size.width + 10.0f;
    }
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(lastStatusLabelXWithWidth,
                                                                 0,
                                                                 statusNameLabel.bounds.size.width + statusIcon.bounds.size.width,
                                                                 statusNameLabel.bounds.size.height)];
    [statusView addSubview:statusNameLabel];
    [statusView addSubview:statusIcon];
    
    [self.doorStatusLabel addSubview:statusView];
    [self.statusViews addObject:statusView];
}

#pragma mark - Door Info Overview Delegate

- (void)inspectionConfirmded {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.selectedInspection.completionDate = [formatter stringFromDate:date];
}

@end
