//
//  DoorInfoOverviewHeaderTableViewCell.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.05.15.
//
//

#import <UIKit/UIKit.h>

@interface DoorInfoOverviewHeaderTableViewCell : UITableViewCell

- (void)displayHeader:(NSString *)headerText;

+ (NSString *)identifier;

@end
