//
//  MediaCollectionViewCell.m
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.04.15.
//
//

#import "MediaCollectionViewCell.h"

#import <UIImageView+WebCache.h>

@interface MediaCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *inspectionImageView;

@end

@implementation MediaCollectionViewCell

- (void)displayImageWithUrl:(NSString *)imgUrl {
    [self.inspectionImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

+ (NSString *)identifier {
    return @"MediaCollectionViewCellIdentifier";
}

@end
