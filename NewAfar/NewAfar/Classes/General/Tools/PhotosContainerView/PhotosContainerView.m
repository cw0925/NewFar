//
//  PhotosContainerView.m
//  SDAutoLayoutDemo
//
//  Created by gsd on 16/5/13.
//  Copyright © 2016年 gsd. All rights reserved.
//

#import "PhotosContainerView.h"
#import "UIView+SDAutoLayout.h"

#import "SDPhotoBrowser.h"

@interface PhotosContainerView ()<SDPhotoBrowserDelegate>

@end

@implementation PhotosContainerView
{
    NSMutableArray *_imageViewsArray;
}

- (instancetype)initWithMaxItemsCount:(NSInteger)count
{
    if (self = [super init]) {
        self.maxItemsCount = count;
    }
    return self;
}

- (void)setPhotoNamesArray:(NSArray *)photoNamesArray
{
    _photoNamesArray = photoNamesArray;
    
    if (!_imageViewsArray) {
        _imageViewsArray = [NSMutableArray new];
    }
    
    int needsToAddItemsCount = (int)(_photoNamesArray.count - _imageViewsArray.count);
    
    if (needsToAddItemsCount > 0) {
        for (int i = 0; i < needsToAddItemsCount; i++) {
            UIImageView *imageView = [UIImageView new];
            [self addSubview:imageView];
            [_imageViewsArray addObject:imageView];
        }
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    
    [_imageViewsArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        if (idx < _photoNamesArray.count) {
            imageView.hidden = NO;
            imageView.sd_layout.autoHeightRatio(1);
            //imageView.image = [UIImage imageNamed:_photoNamesArray[idx]];
            NSString *tp = _photoNamesArray[idx];
            [imageView sd_setImageWithURL:[NSURL URLWithString:tp] placeholderImage:[UIImage imageNamed:@"no_img"]];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:tp] placeholderImage:[UIImage imageNamed:@"no_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if (image && cacheType == SDImageCacheTypeNone) {
//                    CATransition *transition = [CATransition animation];
//                    transition.type = kCATransitionFade;
//                    transition.duration = 0.3;
//                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                    [imageView.layer addAnimation:transition forKey:nil];
//                }
//            }];

            //为图片添加点击手势
            imageView.tag = idx;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:gesture];
            
            
            [temp addObject:imageView];
        } else {
            [imageView sd_clearAutoLayoutSettings];
            imageView.hidden = YES;
        }
    }];
    
    [self setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:3 verticalMargin:10 horizontalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
}
- (void)imageClick:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.photoNamesArray.count;
    browser.delegate = self;
    [browser show];
}
#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.photoNamesArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}

@end
