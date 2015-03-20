//
//  SettingViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import "SettingViewController.h"
#import "UIColor+additionalInitializers.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *lNewPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation SettingViewController

#pragma mark - Lifecycle
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupApearance];
    [self loadData];
}

#pragma makr - Actions
#pragma mark -

- (IBAction)saveButtonPressed:(id)sender
{
    
}

#pragma mark - Private Logic
#pragma mark -

- (void)loadData
{
    
}

- (void)setupApearance
{
    self.title = @"SETTINGS";
    self.containerView.layer.borderColor = [[UIColor colorOpaqueWithUCharWhite:241] CGColor]; 
}

#pragma mark - Utilities
#pragma mark -

@end