//
//  AuthorizationViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 16.03.15.
//
//

#import "AuthorizationViewController.h"
#import "NetworkManager.h"
#import "CurrentUser.h"
#import <SVProgressHUD.H>
#import <M13Checkbox.h>

static NSString* showTabBarFlowSegueIdentifier = @"showTabBarFlowSegueIdentifier";
static NSString* kUserInspections = @"inspections";

@interface AuthorizationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet M13Checkbox *checkBoxView;

@end

@implementation AuthorizationViewController

#pragma mark - Lifecycle

- (void)awakeFromNib
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCheckBoxAppearance];
    [self loadInitialData];
}

#pragma mark - API Methods
#pragma mark - Login

- (void)loadInitialData
{
    self.loginTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    self.checkBoxView.checkState = [[NSUserDefaults standardUserDefaults] boolForKey:@"is_checked"];
}

- (void)logInWithCashedCredentials
{
    [self changeViewStatus:YES];
    
    NSDictionary *params = @{ @"login"    : (self.loginTextField.text) ?    : [NSNull null],
                              @"password" : (self.passwordTextField.text) ? : [NSNull null] };
 
    BOOL isChecked = (self.checkBoxView.checkState == M13CheckboxStateChecked);
    if (isChecked) {
        [[NSUserDefaults standardUserDefaults] setObject:self.loginTextField.text forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setBool:isChecked forKey:@"is_checked"];
    }
    else {
         [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setBool:isChecked forKey:@"is_checked"];    
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    __weak typeof(self) welf = self;
    void(^completion)(id responseObject, NSError *error) = ^(id responseObject, NSError *error) {
        [welf changeViewStatus:NO];
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
       
        NSString *text = NSLocalizedString(@"Authorization Completed",nil);
        [welf.descriptionLabel setText:text];
        [welf loadIssuesListFromServer];
        
        [SVProgressHUD dismiss];
    };
   
    [SVProgressHUD show];
    [[NetworkManager sharedInstance] performRequestWithType:AuthorizationRequestType
                                                  andParams:params
                                             withCompletion:completion];
}

#pragma mark - Issues List

- (void)loadIssuesListFromServer
{
    [self changeViewStatus:YES];
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:InspectionListByUserRequestType
                                                  andParams:@{}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 [welf changeViewStatus:NO];
                                                 if (error) {
                                                     [welf.descriptionLabel setText:NSLocalizedString(@"Error in Issues List Loading", nil)];
                                                 }
                                                 [welf.descriptionLabel setText:NSLocalizedString(@"Issues List Loading Completed",nil)];
                                                 [CurrentUser sharedInstance].userInscpetions = [[responseObject objectForKey:kUserInspections] allObjects];
                                                 [welf performSegueWithIdentifier:showTabBarFlowSegueIdentifier
                                                                           sender:welf];
                                             }];
}

#pragma mark - UI Supporting methods

- (void)changeViewStatus:(BOOL)isLoading
{
    if (isLoading) {
        [self.descriptionLabel setHidden:NO];
        [self.logInButton      setEnabled:NO];
    }
    else {
        [self.descriptionLabel setHidden:YES];
        [self.logInButton      setEnabled:YES];
    }
}

- (void)setupCheckBoxAppearance
{
    self.checkBoxView.strokeColor = [UIColor lightGrayColor];
}

#pragma mark Segue methods
#pragma mark - IBActions

- (IBAction)loginButtonPressed:(id)sender
{
    [self logInWithCashedCredentials];
}

@end