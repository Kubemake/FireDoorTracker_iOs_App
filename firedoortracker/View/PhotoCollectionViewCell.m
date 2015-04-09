//
//  PhotoCollectionViewCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 09.04.15.
//
//

#import "PhotoCollectionViewCell.h"

#import <UIImageView+WebCache.h>

@interface PhotoCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation PhotoCollectionViewCell

- (void)displayImage:(NSString *)imageUrl {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

+ (NSString *)reuseIdentifier {
    return  NSStringFromClass ([self class]);
}

@end
