//
//  StartInterviewViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.03.15.
//
//

//Import Controllers
#import "StartInterviewViewController.h"

//Import View
#import <IQDropDownTextField.h>
#import "DoorOverviewEnumTableViewCell.h"
#import "DoorOverviewTextFieldCell.h"
#import <SVProgressHUD.h>

//Import Model
#import "NetworkManager.h"

static NSString* kType = @"type";
static NSString* vTypeEnum = @"enum";
static NSString* vTypeString = @"string";
static NSString* vTypeDouble = @"double";
static NSString* kName = @"name";
static NSString* kSelected = @"selected";
static NSString* kFroceRefresh = @"force_refresh";

static NSString* kOldData = @"olddata";
static NSString* kNewData = @"newdata";
static NSString* kApertureId = @"aperture_id";


static NSString* kCIDropDawnCellIdentifier = @"CIDoorInfoOverviewEnumInputCell";
static NSString* kCIStringCellIdentifier = @"CIDoorInfoOverviewTextInputCell";

@interface StartInterviewViewController () <DoorOverviewTextFieldCellDelegate, DoorOverviewEnumTableViewCellDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//Model
@property (strong, nonatomic) NSDictionary *previousAnswersDictionary;
@property (strong, nonatomic) NSMutableDictionary *answersDictionary;
@property (copy, nonatomic) NSString *apertureId;

@end

@implementation StartInterviewViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Display View Methods
#pragma mark -

- (void)displayDoorProperties:(NSDictionary *)doorProperties apertureId:(NSString *)apertureId {
    self.answersDictionary = [NSMutableDictionary dictionaryWithDictionary:doorProperties];
    self.previousAnswersDictionary = [NSDictionary dictionaryWithDictionary:self.answersDictionary];
    self.apertureId = apertureId;
    [self.tableView reloadData];
}

#pragma mark - UITableView Datasource
#pragma mark -

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self sectionNameByIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.answersDictionary allKeys].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *answers = [self answersBySectionIndex:section];
    return answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *answers = [self answersBySectionIndex:indexPath.section];
    NSDictionary *answer = [answers objectAtIndex:indexPath.row];
    
    if ([[answer objectForKey:kType] isEqualToString:vTypeEnum]) {
        DoorOverviewEnumTableViewCell *cell = (DoorOverviewEnumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCIDropDawnCellIdentifier];
        cell.answerDictionary = answer;
        cell.delegate = self;
        return cell;
    } else {
        DoorOverviewTextFieldCell *cell = (DoorOverviewTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:kCIStringCellIdentifier];
        cell.answerDictionary = answer;
        cell.delegate = self;
        return cell;
    }
    
    return nil;
}

#pragma mark - Delegates

- (void)userUpdateDictionary:(NSDictionary *)dictionary doorOverviewTextFieldCell:(id)cell {
    [self updateAnswerDictionaryWithAnswer:dictionary atIndexPath:[self.tableView indexPathForCell:cell]];
}

- (void)userUpdateDictionary:(NSDictionary *)updatedDictionary doorOverviewEnumTableViewCell:(id)cell {
    [self updateAnswerDictionaryWithAnswer:updatedDictionary atIndexPath:[self.tableView indexPathForCell:cell]];
}

#pragma mark - Answers Dictionary Access methods

- (NSDictionary *)sectionByName:(NSString *)name {
    for (NSString *key in [self.answersDictionary allKeys]) {
        if ([key isEqualToString:name]) {
            return [self.answersDictionary objectForKey:key];
        }
    }
    return nil;
}

- (NSString *)sectionNameByIndex:(NSInteger)index {
    NSArray *sections = @[@"Location",@"Others", @"Door Label", @"Frame Label"];
    if (index >= sections.count) {
        return @"Unknow Section";
    } else {
        return [sections objectAtIndex:index];
    }
}

- (NSArray *)answersBySectionIndex:(NSInteger)index {
    return [self.answersDictionary objectForKey:[self sectionNameByIndex:index]];
}

- (void)updateAnswerDictionaryWithAnswer:(NSDictionary *)updatedAnswer atIndexPath:(NSIndexPath *)indexPath {
    if (updatedAnswer) {
        NSMutableArray *answersForUpdate = [NSMutableArray arrayWithArray:[self answersBySectionIndex:indexPath.section]];
        [answersForUpdate replaceObjectAtIndex:indexPath.row withObject:updatedAnswer];
        [self.answersDictionary setObject:answersForUpdate forKey:[self sectionNameByIndex:indexPath.section]];
        if ([[updatedAnswer objectForKey:kFroceRefresh] integerValue]) {
            [self forceRefreshAnswers];
            return;
        }
        [self.tableView reloadData];
    }
}

- (void)forceRefreshAnswers {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:InspectionDoorOverviewRequestType
                                                  andParams:@{kNewData : [self createResultDictionary:self.answersDictionary],
                                                              kOldData : [self createResultDictionary:self.previousAnswersDictionary],
                                                              kApertureId : self.apertureId
                                                              }
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [SVProgressHUD showSuccessWithStatus:nil];
                                                 [welf displayDoorProperties:[responseObject objectForKey:@"info"]
                                                                  apertureId:welf.apertureId];
                                             }];
}

#pragma mark - Result Dictionary Accessory method

- (NSDictionary *)createResultDictionary:(NSDictionary *)inputDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSArray *sectionAnswers in [inputDictionary allValues]) {
        for (NSDictionary *answer in sectionAnswers) {
            [result setObject:[answer objectForKey:kSelected] forKey:[answer objectForKey:kName]];
        }
    }
    
    return result;
}

#pragma mark - IBActions
#pragma mark -

- (IBAction)submitButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(submitDoorOverview:)]) {
        [self.delegate submitDoorOverview:[self createResultDictionary:self.answersDictionary]];
    }
}

@end
