//
//  ResourcesViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import "ResourcesViewController.h"

//Import View
#import "AlphabetView.h"
#import "TermTableViewCell.h"

//Import Model
#import "Term.h"

//Import Network
#import "NetworkManager.h"

static NSString* kLetters = @"letters";
static NSString* kLetter = @"letter";
static NSString* kTerms = @"terms";

static NSString* termCellIdentifier = @"TermTableViewCell";

@interface ResourcesViewController() <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AlphabetViewDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet AlphabetView *alphabetView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//Display Data
@property (nonatomic, strong) NSMutableArray* terms;

@end

@implementation ResourcesViewController

#pragma mark - view controller lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDelegates];
    [self loadAndDisplayAvailableLetters];
}

#pragma mark - Setup Methods
#pragma mark -

- (void)setupDelegates {
    self.alphabetView.delegate = self;
}

#pragma mark - API methods
#pragma mark -

- (void)loadAndDisplayAvailableLetters {
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:GlossaryLettersRequestType
                                                  andParams:@{}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     //TODO: Display Error
                                                 }
                                                 [welf.alphabetView displayActiveLetters:[responseObject objectForKey:kLetters]];
                                             }];
}

- (void)loadAndDispayGlossaryTermsByLetter:(NSString *)letter {
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:GlossaryTermsByLetterRequestType
                                                  andParams:@{kLetter : letter}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     //TODO: Display error
                                                 }
                                                 welf.terms = [NSMutableArray array];
                                                 for (NSDictionary *termDictionary in [responseObject objectForKey:kTerms]) {
                                                     [welf.terms addObject:[[Term alloc] initWithDictionary:termDictionary]];
                                                     [welf.tableView reloadData];
                                                 }
                                             }];
}

#pragma mark - Delegates
#pragma mark - ALphabet View Delegate

- (void)userSelectLetter:(NSString *)letter {
    [self loadAndDispayGlossaryTermsByLetter:letter];
}

#pragma mark - search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //TODO: Make Special search
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.terms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TermTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:termCellIdentifier];
    [cell displayTerm:[self.terms objectAtIndex:indexPath.row]];
    return cell;
}

@end
