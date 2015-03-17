//
//  HomeMenuCollectionViewCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 17.03.15.
//
//

#import "HomeMenuCollectionViewCell.h"

@interface HomeMenuCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HomeMenuCollectionViewCell

- (void)displayWithIcon:(UIImage *)icon andTitle:(NSString *)title {
    self.iconImageView.image = icon;
    self.titleLabel.text = title;
    
}

@end
