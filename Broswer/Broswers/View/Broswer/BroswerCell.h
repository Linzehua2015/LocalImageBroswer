//
//  BroswerCell.h
//  Transmitter
//
//  Created by LinZehua on 25/10/15.
//  Copyright © 2015 zjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class BroswerCell, PhotoAsset;

@protocol BroswerCellDelegate <NSObject>

@optional
- (void)broswerCellSingleTap:(BroswerCell *)cell;
@end



@interface BroswerCell : UICollectionViewCell

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, weak) id<BroswerCellDelegate> delegate;
@end
