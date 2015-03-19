//
//  ContactExpertView.m
//  FTD-Test
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 npalamar. All rights reserved.
//

#import "ContactExpertView.h"
#import "ContactExpertCell.h"

static const CGFloat itemInternalSpacing = 20.0f;

@interface ContactExpertView ()

@property (strong, nonatomic, readwrite) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic, readwrite) UICollectionView        *collectionView;

@end

@implementation ContactExpertView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self commonLayoutSubviews];
}

#pragma mark - Private Logic

- (void)commonInit
{
    self.backgroundColor = [UIColor whiteColor];
   
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumInteritemSpacing = itemInternalSpacing;
    flowLayout.minimumLineSpacing = itemInternalSpacing;
    flowLayout.itemSize = [self cellSize];
    [flowLayout setSectionInset:UIEdgeInsetsMake(itemInternalSpacing, itemInternalSpacing,
                                                 itemInternalSpacing, itemInternalSpacing)];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[ContactExpertCell class]
            forCellWithReuseIdentifier:[ContactExpertCell reusableIdentifier]];
    [self addSubview:self.collectionView];
    
    self.activityIndicatorView = [UIActivityIndicatorView new];
    [self addSubview:self.activityIndicatorView];
}

#pragma mark - Private UI

- (void)commonLayoutSubviews
{
    self.collectionView.frame = self.bounds;
}

#pragma mark - Private Utilities

- (CGSize)cellSize
{
    CGFloat cellWidth = roundf([UIScreen mainScreen].bounds.size.width / 2 - itemInternalSpacing * 1.5f);
    
    return CGSizeMake(cellWidth, 160.0f);
}

@end