//
//  SQRNetworkRequest.m
//  SQRCommonToolsProject
//
//  Created by macMini on 2018/5/30.
//  Copyright © 2018年 PR. All rights reserved.
//

#import "SQRNetworkRequest.h"
#import "YYCache.h"
#import "LoginLoseEfficacyView.h"
#import "HMFJSONResponseSerializerWithData.h"
#import <SQRBaseDefineWithFunction/SQRBaseDefine.h>
#import <SQRBaseDefineWithFunction/SQRDataSave.h>

//无网络返回错误状态
#define NOT_NETWORK_ERROR [NSError errorWithDomain:@"com.shequren.SQRNetworking.ErrorDomain" code:-999 userInfo:@{NSLocalizedDescriptionKey:@"无网络"}]

//请求成功处理数据并返回
#define REQUEST_SUCCEED_OPERATION_BLCOK(success)\
\
NSDictionary *dictObj;\
if ([responseObject isKindOfClass:[NSDictionary class]]) {\
if (success)success(responseObject);\
NSLog(@"成功返回 --- URL ： %@ \n %@",urlString,responseObject);\
}else{\
NSString *responseJson = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];\
dictObj = [SQRCommonFunction JsonToDictionary:responseJson];\
if (success)success(dictObj);\
NSLog(@"成功返回 --- URL ： %@ \n %@",urlString,dictObj);\
}\
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];\
[MBProgressHUD hideAllHUDsForView:DEF_Window animated:YES];\


//请求成功判断缓存方式并缓存
#define SAVECACHEWITH_CACHEWAY_MYCHAHE_KEY(cacheWay,myCache,cacheKey)\
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{\
if (cacheWay != IgnoringLocalCacheData) {\
if ([responseObject isKindOfClass:[NSDictionary class]]) {\
[myCache setObject:responseObject forKey:cacheKey];\
}else{\
[myCache setObject:dictObj forKey:cacheKey];\
}\
}\
});

//请求失败打印错误原因并返回
#define REQUEST_FAILURE_BLCOK_ERROR_TASK(fail,error,task)\
if (fail)fail(error,task);\
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];\
[MBProgressHUD hideAllHUDsForView:DEF_Window animated:YES];\
NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;\
NSLog(@"失败返回 --- URL ： %@ \n ---错误码 = %ld  \n ---详细信息 : %@",urlString,responses.statusCode,error);


static AFNetworkReachabilityStatus  networkStatus;

@interface SQRNetworkRequest ()

//记录401的接口，用作刷新token之后比对，按需刷新
@property(nonatomic,strong) NSString *refreshAgainUrl;

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



- (void)removeCacheForUrl:(NSString *)url params:(id)params{
    //缓存，用url拼接参数作为key
    YYCache *myCache = [YYCache cacheWithName:@"SQRCache"];
    NSString *parString = params ? [self dictionaryToJson:params] : @"";
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@", url, parString];
    [myCache removeObjectForKey:cacheKey];
}


- (void)requestWithUrl:(NSString *)urlString
            parameters:(id)parameters
                  type:(NetworkMethod)type
                 isPhp:(BOOL)isPhp
           cachePolicy:(RequestCachePolicy)policy
               success:(NetRequestSuccessBlock)success
                 cache:(NetResponseCache)cache
               failure:(NetRequestFailedBlock)fail
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [MBProgressHUD hideAllHUDsForView:DEF_Window animated:YES];
    });
    
    AFHTTPSessionManager *manager = [self sharedManager];
    
    //判断接口类型，处理不同设置
    NSMutableDictionary *parameterPhp;
    if (isPhp) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        parameterPhp = [NSMutableDictionary dictionaryWithDictionary:parameters];
        if ([SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_Session customKey:nil]) {
            [parameterPhp setObject:[SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_Session customKey:nil] forKey:@"session"];
        }
    }else{
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [HMFJSONResponseSerializerWithData serializer];
        if ([SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_Token customKey:nil]) {
            NSLog(@"token = %@",[SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_Token customKey:nil]);
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer%@",[SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_Token customKey:nil]] forHTTPHeaderField:@"Authorization"];
        }
    }
    
    
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
            
            [manager GET:urlString parameters:isPhp ? parameterPhp : parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                SAVECACHEWITH_CACHEWAY_MYCHAHE_KEY(policy,myCache,cacheKey);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self requestDisposeUrl:urlString parameters:parameters type:type isPhp:isPhp cachePolicy:policy success:success cache:cache failure:fail error:error task:task];
                
            }];
        }
            break;
            
        case POST: {
            
            [manager POST:urlString parameters:isPhp ? parameterPhp : parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                SAVECACHEWITH_CACHEWAY_MYCHAHE_KEY(policy,myCache,cacheKey);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self requestDisposeUrl:urlString parameters:parameters type:type isPhp:isPhp cachePolicy:policy success:success cache:cache failure:fail error:error task:task];
                
            }];
        }
            break;
            
        case PUT: {
            [manager PUT:urlString parameters:isPhp ? parameterPhp : parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self requestDisposeUrl:urlString parameters:parameters type:type isPhp:isPhp cachePolicy:policy success:success cache:cache failure:fail error:error task:task];
                
            }];
        }
            break;
            
        case DELETE: {
            [manager DELETE:urlString parameters:isPhp ? parameterPhp : parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self requestDisposeUrl:urlString parameters:parameters type:type isPhp:isPhp cachePolicy:policy success:success cache:cache failure:fail error:error task:task];
                
            }];
        }
            break;
            
        case PATCH: {
            [manager PATCH:urlString parameters:isPhp ? parameterPhp : parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self requestDisposeUrl:urlString parameters:parameters type:type isPhp:isPhp cachePolicy:policy success:success cache:cache failure:fail error:error task:task];
                
            }];
        }
            break;
            
        default:
            break;
    }
}


//错误处理
- (void)requestDisposeUrl:(NSString *)url
               parameters:(id)parameters
                     type:(NetworkMethod)type
                    isPhp:(BOOL)isPhp
              cachePolicy:(RequestCachePolicy)policy
                  success:(NetRequestSuccessBlock)success
                    cache:(NetResponseCache)cache
                  failure:(NetRequestFailedBlock)fail
                    error:(NSError * _Nonnull)error
                     task:(NSURLSessionDataTask * _Nullable)task {
    
    if (fail)fail(error,task);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
    NSLog(@"失败返回 --- URL ： %@ \n ---错误码 = %ld  \n ---详细信息 : %@",url,responses.statusCode,error);
    
    //针对Java接口token失效401的处理，刷新token重新请求
    if (responses.statusCode == 401 && !isPhp) {
        
        NSString *token = [SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_Token customKey:nil];
        
        if (token.length > 0) {
            
            NSString *refreshToken = [SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_Token_Refresh customKey:nil];
            if (self.tokenRefreshUrl.length > 0 && refreshToken.length > 0) {
                
                [self postWithUrl:self.tokenRefreshUrl
                       parameters:@{@"refresh_token":[SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_Token_Refresh customKey:nil]}
                          success:^(id responseObject) {
                              
                              NSDictionary *dictObj;
                              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                  dictObj = responseObject;
                              }else{
                                  NSString *responseJson = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  dictObj = [SQRCommonFunction JsonToDictionary:responseJson];
                              }
                              
                              if ([dictObj.allKeys containsObject:@"access_token"]) {
                                  NSString *access_token = dictObj[@"access_token"];
                                  if (access_token.length > 0) {
                                      [SQRDataSave saveDataInUserDefaultsWithData:access_token dataEnum:SaveDataEnum_Token customKey:nil];
                                      
                                      if(self.refreshAgainUrl != url) {
                                          self.refreshAgainUrl = url;
                                          [self requestWithUrl:url parameters:parameters type:type isPhp:NO cachePolicy:policy success:success cache:cache failure:fail];
                                      }else{
                                          NSLog(@"--- token已刷新，接口：%@再次请求结果还是401",url);
                                      }
                                  }else{
                                      [[LoginLoseEfficacyView sharedInstance] show];
                                  }
                                  
                              }else{
                                  [[LoginLoseEfficacyView sharedInstance] show];
                              }
                              
                              if ([dictObj.allKeys containsObject:@"refresh_token"]) {
                                  NSString *refresh_token = dictObj[@"refresh_token"];
                                  if (refresh_token.length > 0) {
                                      [SQRDataSave saveDataInUserDefaultsWithData:dictObj[@"refresh_token"] dataEnum:SaveDataEnum_Token_Refresh customKey:nil];
                                  }else{
                                      [[LoginLoseEfficacyView sharedInstance] show];
                                  }
                                  
                              }else{
                                  [[LoginLoseEfficacyView sharedInstance] show];
                              }
                          }
                             fail:^(NSError *error, NSURLSessionDataTask *task) {
                                 
                             }];
            }
            
        }else{
            //未登录状态去登陆
            [[LoginLoseEfficacyView sharedInstance] show];
        }
        return;
    }
}




- (void)getWithUrl:(NSString *)urlString
        parameters:(id)parameters
           success:(NetRequestSuccessBlock)success
              fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:GET isPhp:NO cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}


- (void)postWithUrl:(NSString *)urlString
         parameters:(id)parameters
            success:(NetRequestSuccessBlock)success
               fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:POST isPhp:NO cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}

- (void)putWithUrl:(NSString *)urlString
        parameters:(id)parameters
           success:(NetRequestSuccessBlock)success
              fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:PUT isPhp:NO cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}


- (void)deleteWithUrl:(NSString *)urlString
           parameters:(id)parameters
              success:(NetRequestSuccessBlock)success
                 fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:DELETE isPhp:NO cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}

- (void)patchWithUrl:(NSString *)urlString
          parameters:(id)parameters
             success:(NetRequestSuccessBlock)success
                fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:PATCH isPhp:NO cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}

//PHP专用
- (void)getPhpWithUrl:(NSString *)urlString
           parameters:(id)parameters
              success:(NetRequestSuccessBlock)success
                 fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:GET isPhp:YES cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}

//PHP专用
- (void)postPhpWithUrl:(NSString *)urlString
            parameters:(id)parameters
               success:(NetRequestSuccessBlock)success
                  fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:POST isPhp:YES cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}


- (void)getWithUrl:(NSString *)urlString
        parameters:(id)parameters
       cachePolicy:(RequestCachePolicy)policy
           success:(NetRequestCacheSuccessBlock)success
              fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:GET isPhp:NO cachePolicy:policy success:^(id responseObject) {
        !success ?: success(responseObject, NO);
    } cache:^(id responseObject) {
        !success ?: success(responseObject, YES);
    } failure:fail];
}


- (void)postWithUrl:(NSString *)urlString
         parameters:(id)parameters
        cachePolicy:(RequestCachePolicy)policy
            success:(NetRequestCacheSuccessBlock)success
               fail:(NetRequestFailedBlock)fail
{
    NSLog(@"请求参数：---%@",parameters);
    [self requestWithUrl:urlString parameters:parameters type:POST isPhp:NO cachePolicy:policy success:^(id responseObject) {
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
    
    if ([SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_Token customKey:nil]) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer%@",[SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_Token customKey:nil]] forHTTPHeaderField:@"Authorization"];
    }
    
    if (networkStatus == AFNetworkReachabilityStatusNotReachable) {
        if (fail)fail(NOT_NETWORK_ERROR,nil);
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (imageArray.count == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:[NSData data] name:@"imgs" fileName:fileName mimeType:@"image/jpg"];
        }else{
            // 上传多张图片
            for(int i=0; i<imageArray.count; i++) {
                UIImage *image = imageArray[i];
                NSData *imageData = UIImageJPEGRepresentation(image,1);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg",[NSString stringWithFormat:@"%@.jpg", str],i];
                [formData appendPartWithFileData:imageData name:@"uploadIcon" fileName:fileName mimeType:@"image/jpg"];
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
    
    if ([SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_Token customKey:nil]) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer%@",[SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_Token customKey:nil]] forHTTPHeaderField:@"Authorization"];
    }
    
    if (networkStatus == AFNetworkReachabilityStatusNotReachable) {
        if (fail)fail(NOT_NETWORK_ERROR,nil);
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmss";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
        
        NSData *imageData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:imageData name:@"uploadIcon" fileName:fileName mimeType:@"image/jpg"];
        
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
    
    if (networkStatus == AFNetworkReachabilityStatusNotReachable) {
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

