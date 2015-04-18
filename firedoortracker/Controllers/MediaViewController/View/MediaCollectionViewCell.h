//
//  MediaCollectionViewCell.h
//  firedoortracker
//
//  Created by Dmitriy Bagrov on 18.04.15.
//
//

#import <UIKit/UIKit.h>

@interface MediaCollectionViewCell : UICollectionViewCell

- (void)displayImageWithUrl:(NSString *)imgUrl;

+ (NSString *)identifier;

@end
