//
//  AlphabetView.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import "AlphabetView.h"

@interface AlphabetView()

@property (nonatomic, strong) NSMutableArray* alphabetButtons;

@end

@implementation AlphabetView

#pragma mark - Display Methods
#pragma mark -

- (void)layoutSubviews {
    //This code need to resize alphabet letters
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self generateAlphabetButtons];
}

- (void)displayActiveLetters:(NSArray *)activeLetters {
    for (NSString* activeLetter in activeLetters) {
        for (UIButton *letterButton in self.alphabetButtons) {
            if ([letterButton.titleLabel.text isEqualToString:activeLetter]) {
                [letterButton setEnabled:YES];
            }
        }
    }
}

#pragma mark - Alphabet Button
#pragma mark -

- (void)generateAlphabetButtons {
    self.alphabetButtons = [NSMutableArray new];
    CGFloat buttonWidth = self.bounds.size.width / 26;
    CGFloat nextButtonXPosition = 0.0f;
    for (char symbol = 'A'; symbol <= 'Z'; symbol++) {
        UIButton *symbolButton = [[UIButton alloc] initWithFrame:CGRectMake(nextButtonXPosition,
                                                                            0,
                                                                            buttonWidth,
                                                                            self.bounds.size.height)];
        [symbolButton setTitle:[NSString stringWithFormat:@"%c",symbol]
                      forState:UIControlStateNormal];
        [symbolButton setTitleColor:[AlphabetView activeButtonCollor]
                           forState:UIControlStateNormal];
        [symbolButton setTitleColor:[UIColor grayColor]
                           forState:UIControlStateDisabled];
        [symbolButton addTarget:self
                         action:@selector(userTouchedButton:)
               forControlEvents:UIControlEventTouchUpInside];
        nextButtonXPosition += buttonWidth;
        [symbolButton setEnabled:NO];
        [self addSubview:symbolButton];
        [self.alphabetButtons addObject:symbolButton];
    }
}

- (void)userTouchedButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(userSelectLetter:)]) {
        [self.delegate userSelectLetter:sender.titleLabel.text];
    }
}

#pragma mark - Collors

+ (UIColor *)activeButtonCollor {
    return [UIColor colorWithRed:37/255.0f green:65/255.0f blue:135/255.0f alpha:1.0f];
}

@end
