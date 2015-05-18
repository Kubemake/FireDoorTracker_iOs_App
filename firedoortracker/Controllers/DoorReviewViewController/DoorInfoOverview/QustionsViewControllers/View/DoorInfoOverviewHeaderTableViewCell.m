//
//  DoorInfoOverviewHeaderTableViewCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.05.15.
//
//

#import "DoorInfoOverviewHeaderTableViewCell.h"

@interface DoorInfoOverviewHeaderTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *sectionHeaderLabel;


@end

@implementation DoorInfoOverviewHeaderTableViewCell

- (void)displayHeader:(NSString *)headerText {
    self.sectionHeaderLabel.text = headerText;
}

+ (NSString *)identifier {
    return @"DoorInfoOverviewHeaderTableViewCellIdentifier";
}

@end
