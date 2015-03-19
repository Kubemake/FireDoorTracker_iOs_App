//
//  ContactExpertView.h
//  FTD-Test
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 npalamar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactExpertView : UIView

@property (strong, nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic, readonly) UICollectionView        *collectionView;

@end