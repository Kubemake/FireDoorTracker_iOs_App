//
//  AlphabetView.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 15.03.15.
//
//

#import "AlphabetView.h"

static const CGFloat symbolSpace = 5.0f;

@interface AlphabetView()

@property (nonatomic, strong) NSMutableArray* alphabetButtons;

@end

@implementation AlphabetView

#pragma mark - Display Methods
#pragma mark -

- (void)awakeFromNib {
    [self generateAlphabetButtons];
}

- (void)displayActiveLetters:(NSArray *)activeLetters {
    
}

#pragma mark - Alphabet Buttons Generation
#pragma mark -

- (void)generateAlphabetButtons {
    self.alphabetButtons = [NSMutableArray new];
    CGFloat buttonWidth = self.bounds.size.width / 26;
    CGFloat nextButtonXPosition = symbolSpace;
    for (char symbol = 'A'; symbol <= 'Z'; symbol++) {
        UIButton *symbolButton = [[UIButton alloc] initWithFrame:CGRectMake(nextButtonXPosition,
                                                                            0,
                                                                            buttonWidth,
                                                                            self.bounds.size.height)];
        [symbolButton setTitle:[NSString stringWithFormat:@"%c",symbol]
                      forState:UIControlStateNormal];
        [symbolButton setTitleColor:[UIColor grayColor]
                           forState:UIControlStateDisabled];
        nextButtonXPosition += buttonWidth;
        //TODO: Add Action Listener
        [symbolButton setEnabled:NO];
        [self addSubview:symbolButton];
        [self.alphabetButtons addObject:symbolButton];
    }
    
}

@end
