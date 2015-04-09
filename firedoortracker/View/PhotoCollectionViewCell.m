//
//  PhotoCollectionViewCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 09.04.15.
//
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation PhotoCollectionViewCell

- (void)displayImage:(UIImage *)image {
    self.imageView.image = image;
}

+ (NSString *)reuseIdentifier {
    return  NSStringFromClass ([self class]);
}

@end
