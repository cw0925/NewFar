//
//  NetRequest.h
//  AfarSoftManager
//
//  Created by 陈伟 on 16/5/20.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock) (id responseObject);
typedef void (^FailureBlock) (NSError *error);

typedef void (^SuccessDownloadBlock) (NSURL *path);
typedef void (^DownloadProgressBlock) (NSProgress *progress);

@interface NetRequest : NSObject
//请求
+ (void)sendRequest:(NSString *)url parameters:(NSString *)xml success:(SuccessBlock)success failure:(FailureBlock)failure;
//下载
+ (void)downloadFile:(NSString *)url successDownload:(SuccessDownloadBlock)download;
//上传图片
+ (void)uploadImage:(NSArray *)imageArr withFileName:(NSString *)filename;
//带成功失败的说明
+ (void)uploadImage:(NSArray *)imageArr withFileName:(NSString *)filename success:(SuccessBlock)success failure:(FailureBlock)failure;
@end
