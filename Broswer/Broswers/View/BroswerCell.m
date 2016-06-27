//
//  BroswerCell.m
//  Transmitter
//
//  Created by LinZehua on 25/10/15.
//  Copyright © 2015 zjw. All rights reserved.
//

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

#import "BroswerCell.h"

@interface BroswerCell() <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat maxScale;
@property (nonatomic, strong) NSMutableDictionary *imageDict; // 用来缓存Asset转换过来的Image，提高性能

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation BroswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _scrollView.delegate = self;
    
    if (_imageDict == nil) {
        _imageDict = [NSMutableDictionary dictionary];
    }
    
    // 添加手势识别
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [_scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [_scrollView addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (void)setAsset:(ALAsset *)asset {
    _asset = asset;

    NSString *key = asset.defaultRepresentation.filename;
    __block UIImage *image = nil;
    if ([_imageDict.allKeys containsObject:key]) {
        
        image = [_imageDict objectForKey:key];
        [self resetLayoutWithImage:image];
        
    } else {
        
        image = [UIImage imageNamed:@"file_filegray"];
        [self resetLayoutWithImage:image];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            if (_imageDict.allKeys.count > 5) {
                [_imageDict removeAllObjects];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (image) {
                    [self resetLayoutWithImage:image];
                    [_imageDict setObject:image forKey:key];
                }
            });
        });
    }
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    
    UIImage *image = [UIImage imageWithContentsOfFile:urlString];
    [self resetLayoutWithImage:image];
}

- (void)resetLayoutWithImage:(UIImage *)image {
    
    if (image == nil) {
        return;
    }
    
    // 1.显示小图适应屏幕
    _maxScale = MAX(image.size.width / screenWidth, image.size.height / screenHeight);
    CGFloat scaleW = image.size.width / _maxScale;
    CGFloat scaleH = image.size.height / _maxScale;
    
    _scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
    _scrollView.maximumZoomScale = _maxScale;
    _scrollView.minimumZoomScale = 1;
    
    // 2.创建imageView
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [_scrollView addSubview:_imageView];
    }
    _imageView.bounds = CGRectMake(0, 0, scaleW, scaleH);
    _imageView.center = CGPointMake(_scrollView.contentSize.width * 0.5, _scrollView.contentSize.height * 0.5);
    _imageView.image = image;
    
    // 3.默认zoom
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:NO];
}

- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer {
    
    if (_delegate && [_delegate respondsToSelector:@selector(broswerCellSingleTap:)]) {
        [_delegate broswerCellSingleTap:self];
    }
}

- (void)doubleTap:(UIGestureRecognizer*)gestureRecognizer {
    
    if (_scrollView.zoomScale != _scrollView.minimumZoomScale) {
        
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    } else { // 放大
        
        CGPoint center = [gestureRecognizer locationInView:_imageView];
        
        CGRect newRect;
        newRect.size.width = _scrollView.frame.size.width/_scrollView.maximumZoomScale;
        newRect.size.height = _scrollView.frame.size.height/_scrollView.maximumZoomScale;
        newRect.origin.x = center.x-newRect.size.width/2;
        newRect.origin.y = center.y-newRect.size.height/2;
        [_scrollView zoomToRect:newRect animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    if (scrollView.zoomScale == scrollView.minimumZoomScale) {
        CGFloat scaleW = _imageView.image.size.width / _maxScale;
        CGFloat scaleH = _imageView.image.size.height / _maxScale;
        _imageView.bounds = CGRectMake(0, 0, scaleW, scaleH);
    }
    
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    if (_scrollView.frame.size.width > _scrollView.contentSize.width) {
        offsetX = (_scrollView.frame.size.width - _scrollView.contentSize.width) * 0.5;
    }
    
    if (_scrollView.frame.size.height > _scrollView.contentSize.height) {
        offsetY = (_scrollView.frame.size.height - _scrollView.contentSize.height) * 0.5;
    }
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

@end
