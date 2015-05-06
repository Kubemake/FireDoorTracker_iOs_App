//
//  DoorOverviewTextFieldCell.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 06.05.15.
//
//

#import <UIKit/UIKit.h>

@protocol DoorOverviewTextFieldCellDelegate <NSObject>

@required
- (void)userUpdateDictionary:(NSDictionary *)dictionary doorOverviewTextFieldCell: (id)cell;

@end

@interface DoorOverviewTextFieldCell : UITableViewCell

@property (nonatomic, weak) NSDictionary *answerDictionary;

@property (nonatomic, weak) id<DoorOverviewTextFieldCellDelegate> delegate;

@end
