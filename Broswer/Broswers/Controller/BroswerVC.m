//
//  BroswerVC.m
//  Transmitter
//
//  Created by 林泽华 on 10/23/15.
//  Copyright (c) 2015 zjw. All rights reserved.
//

#import "BroswerVC.h"
#import "BroswerCell.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface BroswerVC () <UIScrollViewDelegate, BroswerCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSArray *assets; // 图片数组
@property (nonatomic, assign) NSInteger currentPage;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation BroswerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_assets == nil) {
        _assets = [NSArray array];
    }
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

#pragma mark - BroswerCellDelegate

- (void)broswerCellSingleTap:(BroswerCell *)cell {
    
    if (_navView.alpha == 1) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _navView.alpha = 0;
        }];
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _navView.alpha = 1;
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    collectionView.contentOffset = CGPointMake(screenWidth * _currentPage, 0);
    [self scrollViewDidEndDecelerating:collectionView];
    return _assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"BroswerCell";
    BroswerCell *cell = (BroswerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.delegate = self;
    cell.asset = _assets[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(screenWidth, screenHeight);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _collectionView) {
        
        NSInteger indexPathItem = scrollView.contentOffset.x / screenWidth;
            
        ALAsset *asset = _assets[indexPathItem];
        _titleLabel.text = asset.defaultRepresentation.filename;
    }
}

#pragma mark - set方法

- (void)setAssets:(NSArray *)assets currentPage:(NSInteger)currentPage
{
    _assets = assets;
    _currentPage = currentPage;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
