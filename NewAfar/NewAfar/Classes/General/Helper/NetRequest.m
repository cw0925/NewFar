//
//  NetRequest.m
//  AfarSoftManager
//
//  Created by 陈伟 on 16/5/20.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "NetRequest.h"
#import "AFNetworking.h"

@interface NetRequest ()

@end

@implementation NetRequest
//post请求
+ (void)sendRequest:(NSString *)url parameters:(NSString *)xml success:(SuccessBlock)success failure:(FailureBlock)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //设置请求体
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            return xml;
        }];
    [manager POST:url parameters:xml headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
//    [manager POST:url parameters:xml progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
}

//下载文件
+ (void)downloadFile:(NSString *)url successDownload:(SuccessDownloadBlock)download
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] progress:^(NSProgress * _Nonnull downloadProgress) {
        //NSLog(@"Progress is %lld", downloadProgress.completedUnitCount)
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 获取Caches目录路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDir = [paths objectAtIndex:0];
        NSString *ringDir = [NSString stringWithFormat:@"%@/file",cachesDir];
        //NSLog(@"ring-:%@",ringDir);
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:ringDir isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:ringDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        /**        区分:fileURLWithPath:与urlWithString:        前者用于网络(AFNetWorking),后者用于(NSURLConnection等系统的数据请求类)        */
        NSArray *arr = [url componentsSeparatedByString:@"/"];
        NSString *path = [NSString stringWithFormat:@"%@/%@",ringDir,[arr lastObject]];
        //返回下载后保存文件的路径
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //主线程
        if (download) {
            download(filePath);
        }
       // NSLog(@"fileParh:%@",filePath);
    }];
    //开始下载
    [task resume];
}
//上传图片
+ (void)uploadImage:(NSArray *)imageArr withFileName:(NSString *)filename
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",@"text/plain",nil];
    
    [manager POST:uploadURL parameters:nil headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传图片
        for (UIImage *image in imageArr) {
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            [formData appendPartWithFileData:data name:@"pic" fileName:filename mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *resData = (NSData *)responseObject;
        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:resData options:0 error:nil];
        NSLog(@"成功：%@",doc);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败：%@",error);
    }];
//    [manager POST:uploadURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        //上传图片
//        for (UIImage *image in imageArr) {
//            NSData *data = UIImageJPEGRepresentation(image, 1.0);
//            [formData appendPartWithFileData:data name:@"pic" fileName:filename mimeType:@"image/jpeg"];
//        }
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSData *resData = (NSData *)responseObject;
//        DDXMLDocument *doc = [[DDXMLDocument alloc]initWithData:resData options:0 error:nil];
//        NSLog(@"成功：%@",doc);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"失败：%@",error);
//    }];
}

//上传图片
+ (void)uploadImage:(NSArray *)imageArr withFileName:(NSString *)filename success:(SuccessBlock)success failure:(FailureBlock)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",@"text/plain",nil];
    
    [manager POST:uploadURL parameters:nil headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传图片
        for (UIImage *image in imageArr) {
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            [formData appendPartWithFileData:data name:@"pic" fileName:filename mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        NSLog(@"成功：%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        NSLog(@"失败：%@",error);
    }];
//    [manager POST:uploadURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        //上传图片
//        for (UIImage *image in imageArr) {
//            NSData *data = UIImageJPEGRepresentation(image, 1.0);
//            [formData appendPartWithFileData:data name:@"pic" fileName:filename mimeType:@"image/jpeg"];
//        }
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//        NSLog(@"成功：%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//        NSLog(@"失败：%@",error);
//    }];
}
@end
