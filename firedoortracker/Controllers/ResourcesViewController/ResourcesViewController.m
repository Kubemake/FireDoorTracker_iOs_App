//
//  ResourcesViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

//Import Controllers
#import "ResourcesViewController.h"
#import "WebViewController.h"

//Import View
#import "AlphabetView.h"
#import "TermTableViewCell.h"
#import <SVProgressHUD.h>

//Import Model
#import "Term.h"

//Import Network
#import "NetworkManager.h"

//Import Extension
#import "UIColor+FireDoorTrackerColors.h"

static NSString* kLetters = @"letters";
static NSString* kLetter = @"letter";
static NSString* kTerms = @"terms";
static NSString* kKeyWord = @"needle";

static NSString* termCellIdentifier = @"TermTableViewCell";

static NSString* webViewControllerIdentifier = @"WebViewController";

@interface ResourcesViewController() <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AlphabetViewDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet AlphabetView *alphabetView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarWidthConstraint;
@property (nonatomic, assign) CGFloat alphabetCanoneWidth;

//Display Data
@property (nonatomic, strong) NSMutableArray* terms;

@end

@implementation ResourcesViewController

#pragma mark - view controller lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBarButtonItems];
    [self setupDelegates];
    [self loadAndDisplayAvailableLetters];
    [self loadAndDispayGlossaryTermsByLetter:nil];
}

#pragma mark - Setup Methods
#pragma mark -

- (void)setupDelegates {
    self.alphabetView.delegate = self;
}

- (void)setupBarButtonItems {
    UIBarButtonItem *faqButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"faqIcon"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(faqButtonPressed:)];
    faqButton.tintColor = [UIColor FDTDarkGrayColor];
    UIBarButtonItem *videoTutorialButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"videoTutorIcon"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(videoTutorialButtonPressed:)];
    videoTutorialButton.tintColor = [UIColor FDTDarkGrayColor];
    self.navigationItem.rightBarButtonItems = @[faqButton, videoTutorialButton];
}

#pragma mark - API methods
#pragma mark -

- (void)loadAndDisplayAvailableLetters {
    __weak typeof(self) welf = self;
    [SVProgressHUD show];
    [[NetworkManager sharedInstance] performRequestWithType:GlossaryLettersRequestType
                                                  andParams:@{}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [SVProgressHUD dismiss];
                                                 [welf.alphabetView displayActiveLetters:[responseObject objectForKey:kLetters]];
                                             }];
}

- (void)loadAndDispayGlossaryTermsByLetter:(NSString *)letter {
    __weak typeof(self) welf = self;
    [SVProgressHUD show];
    [[NetworkManager sharedInstance] performRequestWithType:GlossaryTermsByLetterRequestType
                                                  andParams:@{kLetter : letter ? : [NSNull null]}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [SVProgressHUD dismiss];
                                                 welf.terms = [NSMutableArray array];
                                                 for (NSDictionary *termDictionary in [responseObject objectForKey:kTerms]) {
                                                     [welf.terms addObject:[[Term alloc] initWithDictionary:termDictionary]];
                                                 }
                                                 [welf.tableView reloadData];
                                             }];
}

#pragma mark - Delegates
#pragma mark - ALphabet View Delegate

- (void)userSelectLetter:(NSString *)letter {
    [self.backButton setEnabled:YES];
    [self loadAndDispayGlossaryTermsByLetter:letter];
}

#pragma mark - search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    __weak typeof(self) welf = self;
    [self.backButton setEnabled:YES];
    [SVProgressHUD show];
    [[NetworkManager sharedInstance] performRequestWithType:GlossaryKeyWordSearchRequestType
                                                  andParams:@{kKeyWord : searchBar.text ? : [NSNull null]}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [SVProgressHUD dismiss];
                                                 welf.terms = [NSMutableArray array];
                                                 for (NSDictionary *termDictionary in [responseObject objectForKey:kTerms]) {
                                                     [welf.terms addObject:[[Term alloc] initWithDictionary:termDictionary]];
                                                 }
                                                 [welf.tableView reloadData];
                                             }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:nil];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES];
    self.alphabetCanoneWidth = self.alphabetView.bounds.size.width;
    self.searchBarWidthConstraint.constant += self.alphabetCanoneWidth;
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO];
    self.searchBarWidthConstraint.constant -= self.alphabetCanoneWidth;
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         [self backButtonTouched:nil];
                     }];
}

#pragma mark - Table View Delegate

#pragma mark - Table View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.terms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TermTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:termCellIdentifier];
    [cell displayTerm:[self.terms objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - IBActions
#pragma mark -

- (IBAction)backButtonTouched:(UIBarButtonItem *)sender {
    [self.backButton setEnabled:NO];
    [self loadAndDispayGlossaryTermsByLetter:nil];
    [self loadAndDisplayAvailableLetters];
}


- (void)faqButtonPressed:(id)sender {
    WebViewController *webController = [self.storyboard instantiateViewControllerWithIdentifier:webViewControllerIdentifier];
    webController.typeForDisplaying = WebViewPageTypeFAQ;
    
    [self.navigationController pushViewController:webController
                                         animated:YES];
}

- (IBAction)videoTutorialButtonPressed:(id)sender {
    WebViewController *webController = [self.storyboard instantiateViewControllerWithIdentifier:webViewControllerIdentifier];
    webController.typeForDisplaying = WebViewPageTypeVideoTutorial;
    
    [self.navigationController pushViewController:webController
                                         animated:YES];
}

@end
