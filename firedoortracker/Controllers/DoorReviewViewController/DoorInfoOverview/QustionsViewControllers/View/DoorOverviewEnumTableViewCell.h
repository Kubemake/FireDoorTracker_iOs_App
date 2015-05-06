//
//  DoorOverviewEnumTableViewCell.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 06.05.15.
//
//

#import <UIKit/UIKit.h>

@protocol DoorOverviewEnumTableViewCellDelegate <NSObject>

@required
- (void)userUpdateDictionary:(NSDictionary *)updatedDictionary doorOverviewEnumTableViewCell:(id)cell;

@end

@interface DoorOverviewEnumTableViewCell : UITableViewCell

@property (nonatomic, weak) NSDictionary *answerDictionary;
@property (nonatomic, weak) id<DoorOverviewEnumTableViewCellDelegate> delegate;


@end
