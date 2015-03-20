//
//  AlphabetView.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import <UIKit/UIKit.h>

@protocol AlphabetViewDelegate <NSObject>

@required
- (void)userSelectLetter:(NSString *)letter;

@end

@interface AlphabetView : UIView

@property (nonatomic, weak) id<AlphabetViewDelegate> delegate;

- (void)displayActiveLetters:(NSArray *)activeLetters;

@end
