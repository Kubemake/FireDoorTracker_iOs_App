//
//  ViewController.m
//  FTD-Test
//
//  Created by Nikolay Palamar on 15/03/15.
//  Copyright (c) 2015 npalamar. All rights reserved.
//

#import "ContactExpertViewController.h"
#import "ContactExpertCell.h"
#import "NavigationBarButtons.h"

//Import Model
#import "NetworkManager.h"
#import "CellDataModel.h"

//Import View
#import <SVProgressHUD.h>

static NSString *const kExperts = @"experts";

@interface ContactExpertViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *expertObjects;

@end

@implementation ContactExpertViewController

#pragma mar - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

#pragma mark - Actions

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CellDataModel *object = self.expertObjects[indexPath.row];
   
    ContactExpertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ContactExpertCell reusableIdentifier]
                                                                        forIndexPath:indexPath];
    [cell displayExpertData:object];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.expertObjects count];
}

#pragma mark - Private Logic

- (void)loadData {
    [SVProgressHUD show];
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] performRequestWithType:ExpertsListRequestType
                                                  andParams:@{}
                                             withCompletion:^(id responseObject, NSError *error) {
                                                 if (error) {
                                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                     return;
                                                 }
                                                 [SVProgressHUD showSuccessWithStatus:nil];
                                                 welf.expertObjects = [NSMutableArray array];
                                                 NSArray *rowExperts = [responseObject objectForKey:kExperts];
                                                 for (NSDictionary *rowExprt in rowExperts) {
                                                     CellDataModel *expert = [[CellDataModel alloc] initWithDictionary:rowExprt];
                                                     [welf.expertObjects addObject:expert];
                                                 }
                                                 [welf.collectionView reloadData];
                                             }];
}

@end