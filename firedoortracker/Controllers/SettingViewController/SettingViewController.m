//
//  SettingViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import "SettingViewController.h"
#import "NetworkManager.h"
#import "UIColor+additionalInitializers.h"

static NSString *const firstNameKey = @"firstName";
static NSString *const lastNameKey = @"lastName";
static NSString *const emailKey = @"email";
static NSString *const phoneNumberKey = @"mobilePhone";

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

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
    [self updateUserProfile];
}

#pragma mark - Private Logic
#pragma mark -

- (void)loadData
{
    [self.activityIndicatorView startAnimating];
    
    __weak typeof (self) weakSelf = self;
    void(^completion)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        [weakSelf.activityIndicatorView stopAnimating];
        [weakSelf fillFieldsFromResponceObject:responseObject];
    };
    
    NSDictionary *params  = @{};
    [[NetworkManager sharedInstance] performRequestWithType:GetProfileInfoRequestType
                                                  andParams:params
                                             withCompletion:completion];
}

- (void)setupApearance
{
    self.title = @"SETTINGS";
    self.containerView.layer.borderColor = [[UIColor colorOpaqueWithUCharWhite:241] CGColor]; 
}

#pragma mark - Utilities
#pragma mark -

- (void)fillFieldsFromResponceObject:(id)responseObject
{
    NSString *firstName = responseObject[firstNameKey];
    NSString *lastName = responseObject[lastNameKey];
    NSString *phoneNumber = responseObject[phoneNumberKey];
    NSString *email = responseObject[emailKey];
    
    self.firstNameTextField.text = firstName;
    self.lastNameTextField.text = lastName;
    self.phoneNoTextField.text = phoneNumber;
    self.emailTextField.text = email;
}

- (void)updateUserProfile
{
    [self.activityIndicatorView startAnimating];
    
    __weak typeof (self) weakSelf = self;
    
    NSDictionary *params = @{ firstNameKey   : self.firstNameTextField.text,
                              lastNameKey    : self.lastNameTextField.text,
                              phoneNumberKey : self.phoneNoTextField.text,
                              emailKey       : self.emailTextField.text };
    
    void(^completion)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        [weakSelf.activityIndicatorView stopAnimating];
    };
    
    [[NetworkManager sharedInstance] performRequestWithType:UpdateProfileInfoRequestType
                                                  andParams:params
                                             withCompletion:completion];
}

@end