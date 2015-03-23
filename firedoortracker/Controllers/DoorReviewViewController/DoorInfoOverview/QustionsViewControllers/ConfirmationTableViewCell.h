//
//  ConfirmationTableViewCell.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 21.03.15.
//
//

#import <UIKit/UIKit.h>

@interface ConfirmationTableViewCell : UITableViewCell

- (void)displayQuestion:(NSString *)question andAnswers:(NSArray *)answers;

@end
