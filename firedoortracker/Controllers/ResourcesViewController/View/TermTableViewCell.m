//
//  TermTableViewCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 16.03.15.
//
//

#import "TermTableViewCell.h"

@interface TermTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation TermTableViewCell

#pragma mark - displaying methods

- (void)displayTerm:(Term *)term {
    self.titlelabel.text = term.name;
    self.descriptionLabel.text = term.termDescription;
}

@end
