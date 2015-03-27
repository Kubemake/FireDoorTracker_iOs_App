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
#import "ContainerViewController.h"
#import <SVProgressHUD.h>

static NSString *const userInfoKey = @"userInfoKey";

static NSString *const firstNameKey   = @"firstName";
static NSString *const lastNameKey    = @"lastName";
static NSString *const emailKey       = @"email";
static NSString *const phoneNumberKey = @"mobilePhone";
static NSString *const passwordKey    = @"password";

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *lNewPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (assign, nonatomic, getter=isPasswordChanged) BOOL passwordChanged;

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
    [self.view endEditing:YES];
    [self updateUserProfile];
}

#pragma mark - Private Logic
#pragma mark -

- (void)loadData
{
    if ([self isUserExist]) {
        [self fillFieldsFromUserDefaults];
    }
    else {
        [SVProgressHUD show];
        
        __weak typeof (self) weakSelf = self;
        void(^completion)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"Connection problems!"];
            }
            else {
                [weakSelf fillFieldsFromResponceObject:responseObject];
                [weakSelf writeUserToUserDefaults];
            }
        };
        
        NSDictionary *params  = @{};
        [[NetworkManager sharedInstance] performRequestWithType:GetProfileInfoRequestType
                                                      andParams:params
                                                 withCompletion:completion];
    }
}

#pragma mark - Private UI
#pragma mark -

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
    __weak typeof (self) weakSelf = self;
    void(^completion)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"Something wrong!"];
        }
        else {
            [self writeUserToUserDefaults];
            if (weakSelf.isPasswordChanged) {
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"login"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_checked"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                UINavigationController *navController = (UINavigationController *)self.parentViewController;
                ContainerViewController *parentViewController = (ContainerViewController *)navController.parentViewController;
                [parentViewController.niceTabBarView setSelectedButton:5];
                [parentViewController performSegueWithIdentifier:loginViewControllerSegueIdentifier
                                                          sender:self];
            }
            else {
                [SVProgressHUD showSuccessWithStatus:@"Profile succesfullty updated!"];
            }
        }
    };
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if ([self isNewUserDataCorrect]) {
        [params setObject:self.firstNameTextField.text forKey:firstNameKey];
        [params setObject:self.lastNameTextField.text  forKey:lastNameKey];
        [params setObject:self.phoneNoTextField.text   forKey:phoneNumberKey];
        [params setObject:self.emailTextField.text     forKey:emailKey];
        
        if (self.lNewPasswordTextField.text.length || self.confirmPasswordTextField.text.length) {
            if ([self isNewPasswordCorret]) {
                [params setObject:self.confirmPasswordTextField.text forKey:passwordKey];
                self.passwordChanged = YES;
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"Please check passwords!"];
                return;
            }
        }

        [SVProgressHUD show];
        [[NetworkManager sharedInstance] performRequestWithType:UpdateProfileInfoRequestType
                                                      andParams:[params copy]
                                                 withCompletion:completion];
    }
}

- (BOOL)isNewUserDataCorrect
{
    BOOL correct = YES;
    
    if (self.firstNameTextField.text.length == 0) {
        correct = NO;
        [SVProgressHUD showErrorWithStatus:@"Incorrect first name!"];
    }
    else if (self.lastNameTextField.text.length == 0) {
        correct = NO;
        [SVProgressHUD showErrorWithStatus:@"Incorrect last name!"];
    }
    else if (self.phoneNoTextField.text.length == 0) {
        correct = NO;
        [SVProgressHUD showErrorWithStatus:@"Incorrect phone number!"];
    }
    else if (self.emailTextField.text.length == 0) {
        correct = NO;
        [SVProgressHUD showErrorWithStatus:@"Incorrect email!"];
    }
    
    return correct;
}

- (BOOL)isNewPasswordCorret
{
    return self.lNewPasswordTextField.text.length && self.confirmPasswordTextField.text.length
           && ([self.lNewPasswordTextField.text isEqualToString:self.confirmPasswordTextField.text]);
}

#pragma mark - User Defaults

- (void)writeUserToUserDefaults
{
    NSDictionary *user = @{ firstNameKey   : self.firstNameTextField.text,
                            lastNameKey    : self.lastNameTextField.text,
                            phoneNumberKey : self.phoneNoTextField.text,
                            emailKey       : self.emailTextField.text };
    
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:userInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)fillFieldsFromUserDefaults
{
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey];
    
    NSString *firstName = userData[firstNameKey];
    NSString *lastName = userData[lastNameKey];
    NSString *phoneNumber = userData[phoneNumberKey];
    NSString *email = userData[emailKey];
    
    self.firstNameTextField.text = firstName;
    self.lastNameTextField.text = lastName;
    self.phoneNoTextField.text = phoneNumber;
    self.emailTextField.text = email;   
}

- (BOOL)isUserExist
{
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:userInfoKey];
    
    return [userData allKeys].count;
}

@end