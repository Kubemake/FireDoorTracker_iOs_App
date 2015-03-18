//
//  DoorInfoOveriviewViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import "DoorInfoOveriviewViewController.h"

//Import View
#import <HMSegmentedControl.h>

//Import Extension
#import "UIColor+FireDoorTrackerColors.h"

static const CGFloat doorInfoHeight = 200.0f;
static const CGFloat hidenDoorInfoHeight = 22.0f;
static const CGFloat doorInfoMenuSegmentInset = 22.0f;

@interface DoorInfoOveriviewViewController ()

//IBOutlets and View Properties
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doorInfoHeightConstraint;
@property (assign, nonatomic) BOOL isDoorInfoHidden;

@property (weak, nonatomic) IBOutlet HMSegmentedControl *doorInfoMenu;

@end

@implementation DoorInfoOveriviewViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDoorInfoMenu];
}

#pragma mark - Settup Methods
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
    [self.doorInfoMenu addTarget:self
                          action:@selector(doorInfoMenuChangedValue:)
                forControlEvents:UIControlEventValueChanged];
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
    
}

#pragma mark - Delegation Methods


@end
