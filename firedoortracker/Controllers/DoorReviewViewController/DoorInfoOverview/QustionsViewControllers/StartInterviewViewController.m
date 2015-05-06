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

//Import Extensions
#import "UIFont+FDTFonts.h"
#import "UIColor+FireDoorTrackerColors.h"

static NSString* kType = @"type";
static NSString* vTypeEnum = @"enum";
static NSString* vTypeString = @"string";
static NSString* vTypeDouble = @"double";
static NSString* kName = @"name";

static NSString* kCIDropDawnCellIdentifier = @"CIDoorInfoOverviewEnumInputCell";
static NSString* kCIStringCellIdentifier = @"CIDoorInfoOverviewTextInputCell";

@interface StartInterviewViewController () <IQDropDownTextFieldDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

//IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//Model
@property (weak, nonatomic) NSDictionary *answersDictionary;
@property (strong, nonatomic) NSMutableDictionary *resultDictionary;

@end

@implementation StartInterviewViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Display View Methods
#pragma mark -

- (void)displayDoorProperties:(NSDictionary *)doorProperties {
    self.answersDictionary = doorProperties;
    self.resultDictionary = [NSMutableDictionary dictionary];
    [self.tableView reloadData];
}

#pragma mark - Support View Methods

- (void)customizeAndAddToolBarToTextField:(UITextField *)textField {
    textField.background = [UIImage imageNamed:@"reviewDropDownFieldBackground"];
    textField.font = [UIFont FDTTimesNewRomanRegularWithSize:15.0f];
    textField.textColor = [UIColor FDTMediumGayColor];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,42)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:textField
                                                                                action:@selector(resignFirstResponder)];
    [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    [textField setInputAccessoryView:toolBar];
}

#pragma mark - UITableView Datasource
#pragma mark -

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
        return cell;
    } else {
        DoorOverviewTextFieldCell *cell = (DoorOverviewTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:kCIStringCellIdentifier];
        cell.answerDictionary = answer;
        return cell;
    }
    
    return nil;
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
    NSArray *sections = @[@"Location", @"Door Label", @"Frame Label", @"Others"];
    if (index >= sections.count) {
        return @"Unknow Section";
    } else {
        return [sections objectAtIndex:index];
    }
}

- (NSArray *)answersBySectionIndex:(NSInteger)index {
    return [self.answersDictionary objectForKey:[self sectionNameByIndex:index]];
}

#pragma mark - IBActions
#pragma mark -

- (IBAction)submitButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(submitDoorOverview:)]) {
        [self.delegate submitDoorOverview:self.resultDictionary];
    }
}

@end
