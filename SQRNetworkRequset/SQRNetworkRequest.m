//
//  SQRNetworkRequest.m
//  SQRCommonToolsProject
//
//  Created by macMini on 2018/5/30.
//  Copyright © 2018年 PR. All rights reserved.
//

#import "SQRNetworkRequest.h"
#import "YYCache.h"
#import <SQRBaseDefineWithFunction/SQRBaseDefine.h>
@class SQRBaseDefine;
//无网络返回错误状态
#define NOT_NETWORK_ERROR [NSError errorWithDomain:@"com.shequren.SQRNetworking.ErrorDomain" code:-999 userInfo:@{NSLocalizedDescriptionKey:@"无网络"}]

//请求成功处理数据并返回
#define REQUEST_SUCCEED_OPERATION_BLCOK(success)\
\
NSString *responseJson = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];\
NSDictionary *dictObj = [SQRCommonFunction JsonToDictionary:responseJson];\
if (success)success(dictObj);\
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];\
NSLog(@"成功返回 --- URL ： %@ \n %@",urlString,dictObj);

//请求成功判断缓存方式并缓存
#define SAVECACHEWITH_CACHEWAY_MYCHAHE_KEY(cacheWay,myCache,cacheKey)\
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{\
    if (cacheWay != IgnoringLocalCacheData) {\
        [myCache setObject:dictObj forKey:cacheKey];\
    }\
});

//请求失败打印错误原因并返回
#define REQUEST_FAILURE_BLCOK_ERROR_TASK(fail,error,task)\
if (fail)fail(error,task);\
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];\
NSLog(@"失败返回 --- URL ： %@ \n 错误码 = %@",urlString,error);


static AFNetworkReachabilityStatus  networkStatus;

@interface SQRNetworkRequest ()

@end

@implementation SQRNetworkRequest

+ (SQRNetworkRequest *)sharedInstance {
    static SQRNetworkRequest *netRequest = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        netRequest = [[self alloc] init];
    });
    [self checkNetworkStatus];
    return netRequest;
}

- (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                  @"text/html",
                                                                                  @"text/json",
                                                                                  @"text/plain",
                                                                                  @"text/javascript",
                                                                                  @"text/xml",
                                                                                  @"image/*",
                                                                                  @"application/octet-stream",
                                                                                  @"application/zip"]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 10;
    });
    return manager;
}



#pragma mark --- 检查网络
+ (void)checkNetworkStatus {
    networkStatus = AFNetworkReachabilityStatusUnknown;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                // 未知网络
                networkStatus = AFNetworkReachabilityStatusUnknown;
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                // 没有网络
                networkStatus = AFNetworkReachabilityStatusNotReachable;
                DEF_Toast(@"没有网络");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                // 手机自带网络,移动流量
                networkStatus = AFNetworkReachabilityStatusReachableViaWWAN;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                // WIFI
                networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
            }
        }
    }];
    
}



//字典转json
- (NSString *)dictionaryToJson:(id)object {
    NSString *jsonString = [[NSString alloc]init];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range2];
    return mutStr;
}



- (void)requestWithUrl:(NSString *)urlString
            parameters:(id)parameters
                  type:(NetworkMethod)type
           cachePolicy:(RequestCachePolicy)policy
               success:(NetRequestSuccessBlock)success
                 cache:(NetResponseCache)cache
               failure:(NetRequestFailedBlock)fail
{
    AFHTTPSessionManager *manager = [self sharedManager];
    
    if (networkStatus == AFNetworkReachabilityStatusNotReachable) {
        if (fail)fail(NOT_NETWORK_ERROR,nil);
        return;
    }
    
    NSLog(@"发起请求 --- URL ： %@",urlString);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //缓存，用url拼接参数作为key
    YYCache *myCache = [YYCache cacheWithName:@"SQRCache"];
    NSString *parString = parameters ? [self dictionaryToJson:parameters] : @"";
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@", urlString, parString];
    
    if (cache) {
        //获取缓存
        id object = [myCache objectForKey:cacheKey];
        switch (policy) {
                
                //先返回缓存，同时请求
            case CacheDataThenLoad: {
                if (object)cache(object);
                break;
            }
                
                //忽略本地缓存直接请求
            case IgnoringLocalCacheData: {
                break;
            }
                
                //有缓存就返回缓存，没有就请求
            case CacheDataElseLoad: {
                if (object) {
                    cache(object);
                    return ;
                }
                break;
            }
                
                //有缓存就返回缓存,从不请求（用于没有网络）
            case CacheDataDontLoad: {
                if (object)cache(object);
                return ;
            }
            default: {
                break;
            }
        }
    }
    
    
    switch (type) {
        case GET: {
            [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                SAVECACHEWITH_CACHEWAY_MYCHAHE_KEY(policy,myCache,cacheKey);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                REQUEST_FAILURE_BLCOK_ERROR_TASK(fail,error,task);
                
            }];
        }
            break;
            
        case POST: {
            [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                SAVECACHEWITH_CACHEWAY_MYCHAHE_KEY(policy,myCache,cacheKey);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                REQUEST_FAILURE_BLCOK_ERROR_TASK(fail,error,task);
                
            }];
        }
            break;
            
        case PUT: {
            [manager PUT:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                REQUEST_FAILURE_BLCOK_ERROR_TASK(fail,error,task);
                
            }];
        }
            break;
            
        case DELETE: {
            [manager DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                REQUEST_FAILURE_BLCOK_ERROR_TASK(fail,error,task);
                
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)getWithUrl:(NSString *)urlString
        parameters:(id)parameters
           success:(NetRequestSuccessBlock)success
              fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:GET cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}


- (void)postWithUrl:(NSString *)urlString
         parameters:(id)parameters
            success:(NetRequestSuccessBlock)success
               fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:POST cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}


- (void)postWithUrl:(NSString *)urlString
         parameters:(id)parameters
        cachePolicy:(RequestCachePolicy)policy
            success:(NetRequestCacheSuccessBlock)success
               fail:(NetRequestFailedBlock)fail
{
    NSLog(@"请求参数：---%@",parameters);
    [self requestWithUrl:urlString parameters:parameters type:POST cachePolicy:policy success:^(id responseObject) {
        !success ?: success(responseObject, NO);
    } cache:^(id responseObject) {
        !success ?: success(responseObject, YES);
    } failure:fail];
}


- (void)getWithUrl:(NSString *)urlString
        parameters:(id)parameters
       cachePolicy:(RequestCachePolicy)policy
           success:(NetRequestCacheSuccessBlock)success
              fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:GET cachePolicy:policy success:^(id responseObject) {
        !success ?: success(responseObject, NO);
    } cache:^(id responseObject) {
        !success ?: success(responseObject, YES);
    } failure:fail];
}


- (void)postUploadMultiImageWithUrl:(NSString *)urlString
                         imageArray:(NSArray *)imageArray
                         parameters:(id)parameters
                           progress:(NetRequestProgressBlock)progress
                            success:(NetRequestSuccessBlock)success
                               fail:(NetRequestFailedBlock)fail
{
    
    AFHTTPSessionManager *manager = [self sharedManager];
    
    if (self.AFNetWorkStatus == AFNetworkReachabilityStatusNotReachable) {
        if (fail)fail(NOT_NETWORK_ERROR,nil);
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (imageArray.count == 0) {
            [formData appendPartWithFileData:[NSData data] name:@"imgs" fileName:@"" mimeType:@"image/png"];
        }else{
            // 上传多张图片
            for(int i=0; i<imageArray.count; i++) {
                UIImage *image = imageArray[i];
                NSData *imageData = UIImagePNGRepresentation(image);
                NSString *fileName = [NSString stringWithFormat:@"evaluationImage%d.png",i];
                [formData appendPartWithFileData:imageData name:@"imgs" fileName:fileName mimeType:@"image/png"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress)progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        REQUEST_SUCCEED_OPERATION_BLCOK(success);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        REQUEST_FAILURE_BLCOK_ERROR_TASK(fail,error,task);
        
    }];
}



- (void)postUploadImageWithUrl:(NSString *)urlString
                         image:(UIImage *)image
                    parameters:(id)parameters
                      progress:(NetRequestProgressBlock)progress
                       success:(NetRequestSuccessBlock)success
                          fail:(NetRequestFailedBlock)fail
{
    AFHTTPSessionManager *manager = [self sharedManager];
    
    if (self.AFNetWorkStatus == AFNetworkReachabilityStatusNotReachable) {
        if (fail)fail(NOT_NETWORK_ERROR,nil);
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"tmp.png" mimeType:@"multipart/form-data"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress)progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        REQUEST_SUCCEED_OPERATION_BLCOK(success);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        REQUEST_FAILURE_BLCOK_ERROR_TASK(fail,error,task);
        
    }];
}




- (AFURLSessionManager *)sharedDownloadManager {
    static AFURLSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"DownloadPatch"];
        manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    });
    return manager;
}


- (void)downloadFileWithUrl:(NSString *)urlString
                   filePath:(NSURL *)filePath
                    success:(NetRequestSuccessBlock)success
                       fail:(NetRequestFailedBlock)fail
{
    AFURLSessionManager *manager = [self sharedDownloadManager];
    
    if (self.AFNetWorkStatus == AFNetworkReachabilityStatusNotReachable) {
        if (fail)fail(NOT_NETWORK_ERROR,nil);
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"补丁下载%.1f%%", downloadProgress.fractionCompleted*100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return filePath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (success) {
            success(filePath);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [downloadTask resume];
}


@end
