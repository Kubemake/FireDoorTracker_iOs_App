//
//  InterviewConfirmationViewController.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 19.03.15.
//
//

#import "InterviewConfirmationViewController.h"

//Import View
#import "ConfirmationTableViewCell.h"

//Import Model
#import "Tab.h"
#import "QuestionOrAnswer.h"
#import "NetworkManager.h"

static NSString* confirmationCellIdentifier = @"ConfirmationTableViewCell";

@interface InterviewConfirmationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InterviewConfirmationViewController

#pragma mark - View Controller Lyfecircle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - TableView
#pragma mark - Table View Datasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Tab *sectionTab = [self.tabs objectAtIndex:section];
    return sectionTab.label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tabs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Tab *sectionTab = [self.tabs objectAtIndex:section];
    QuestionOrAnswer *rootQuestion = [self questionByID:sectionTab.nextQuiestionID];
    return rootQuestion.answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tab *sectionTab = [self.tabs objectAtIndex:indexPath.section];
    QuestionOrAnswer *rootQuestion = [self questionByID:sectionTab.nextQuiestionID];
    QuestionOrAnswer *cellQuestion = [rootQuestion.answers objectAtIndex:indexPath.row];
    NSString* cellQuestionLabel = cellQuestion.label;
    cellQuestion = [self questionByID:cellQuestion.nextQuiestionID];
    
    ConfirmationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:confirmationCellIdentifier];
    [cell displayQuestion:cellQuestionLabel andAnswers:[cellQuestion selectedAnswersLabels]];
    
    return cell;
}

#pragma mark - Table View Delegate

#pragma mark - Supporting Methods

- (QuestionOrAnswer *)questionByID:(NSString *)uid {
    for (QuestionOrAnswer *question in self.questionAndAnswers) {
        if ([question.idFormField isEqualToString:uid]) {
            return question;
        }
    }
    return nil;
}

#pragma mark - IBActions

- (IBAction)submitButtonPressed:(id)sender {
    if ([self.confirmationDelegate respondsToSelector:@selector(interviewConfirmed)]) {
        [self.confirmationDelegate interviewConfirmed];
    }
}

@end
