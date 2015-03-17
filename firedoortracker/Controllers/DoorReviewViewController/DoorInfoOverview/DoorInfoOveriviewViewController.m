//
//  DoorInfoOveriviewViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import "DoorInfoOveriviewViewController.h"

static const CGFloat doorInfoHeight = 200.0f;
static const CGFloat hidenDoorInfoGeight = 22.0f;

@interface DoorInfoOveriviewViewController ()

//IBoutlets and View Properties
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doorInfoHeightConstraint;
@property (assign, nonatomic) BOOL isDoorInfoHidden;

@end

@implementation DoorInfoOveriviewViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - IBOutlets
#pragma mark -

- (IBAction)showDoorInfoStatusButtonPressed:(id)sender {
    self.doorInfoHeightConstraint.constant = (self.isDoorInfoHidden) ? doorInfoHeight : hidenDoorInfoGeight;
    self.isDoorInfoHidden = !self.isDoorInfoHidden;
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}


@end
