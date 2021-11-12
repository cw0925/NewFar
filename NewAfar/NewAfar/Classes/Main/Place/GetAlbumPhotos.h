//
//  GetAlbumPhotos.h
//  NewAfar
//
//  Created by cw on 16/10/11.
//  Copyright © 2016年 afarsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetAlbumPhotos : NSObject

+ (instancetype)defaultGetAlbumPhotos;
//获得所有相簿的原图
- (NSArray *)getOriginalImages;
//获得所有相簿中的缩略图
- (NSArray *)getThumbnailImages;
//获得制定尺寸的图片
- (NSArray *)getImages:(CGSize)size;
@end
