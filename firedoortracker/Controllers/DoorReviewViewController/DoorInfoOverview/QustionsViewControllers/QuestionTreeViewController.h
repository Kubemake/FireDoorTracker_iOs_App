//
//  QuestionTreeViewController.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 19.03.15.
//
//

#import <UIKit/UIKit.h>

//Import Model
#import "Tab.h"

@interface QuestionTreeViewController : UIViewController

@property (nonatomic, weak) NSArray* questionForReview;

- (void)displayTab:(Tab *)tabForReview;

@end
