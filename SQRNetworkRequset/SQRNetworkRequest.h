//
//  SQRNetworkRequest.h
//  SQRCommonToolsProject
//
//  Created by macMini on 2018/5/30.
//  Copyright © 2018年 PR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, NetworkMethod) {
    GET = 0,
    POST,
    PUT,
    DELETE,
    PATCH
};

typedef NS_ENUM(NSUInteger, RequestCachePolicy) {
    /** 正在刷新中的状态 */
    CacheDataThenLoad = 0,                                                      // 有缓存就先返回缓存，同步请求数据
    IgnoringLocalCacheData,                                                     // 忽略缓存，重新请求
    CacheDataElseLoad,                                                          // 有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    CacheDataDontLoad,                                                          // 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
};

typedef void (^NetRequestSuccessBlock)(id responseObject);                      //成功Block
typedef void (^NetRequestCacheSuccessBlock)(id responseObject, BOOL isCache);   //缓存成功Block
typedef void (^NetRequestFailedBlock)(NSError *error,NSURLSessionDataTask *task);//失败Block
typedef void (^NetRequestProgressBlock)(float progress);                        //进度Block
typedef void (^NetResponseCache)(id responseObject);                            //缓存Block

@interface SQRNetworkRequest : NSObject

/**
 *  单例
 */
+ (SQRNetworkRequest *)sharedInstance;

/**
 *  当前的网络状态
 */
@property (nonatomic, assign) AFNetworkReachabilityStatus AFNetWorkStatus;

/**
 *  Java接口刷新token接口地址
 */
@property (nonatomic, copy) NSString *tokenRefreshUrl;

/**
 *  登录页面实例化对象
 */
@property (nonatomic, strong) UIViewController *loginVc;

/**
 删除缓存
 @param url
 @param params 参数
 */
- (void)removeCacheForUrl:(NSString *)url params:(id)params;

/**
 发起网络请求
 @param urlString Url
 @param parameters 参数
 @param type 请求类型
 @param isPhp 是否是php接口
 @param policy 缓存策略
 @param success 成功Block
 @param cache 缓存Block
 @param fail 失败Block
 */
- (void)requestWithUrl:(NSString *)urlString
            parameters:(id)parameters
                  type:(NetworkMethod)type
                 isPhp:(BOOL)isPhp
           cachePolicy:(RequestCachePolicy)policy
               success:(NetRequestSuccessBlock)success
                 cache:(NetResponseCache)cache
               failure:(NetRequestFailedBlock)fail;

/**
 *  Get形式提交数据
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)getWithUrl:(NSString *)urlString
        parameters:(id)parameters
           success:(NetRequestSuccessBlock)success
              fail:(NetRequestFailedBlock)fail;


/**
 *  Post形式提交数据
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)postWithUrl:(NSString *)urlString
         parameters:(id)parameters
            success:(NetRequestSuccessBlock)success
               fail:(NetRequestFailedBlock)fail;

/**
 *  Put形式提交数据
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)putWithUrl:(NSString *)urlString
        parameters:(id)parameters
           success:(NetRequestSuccessBlock)success
              fail:(NetRequestFailedBlock)fail;

/**
 *  Delete形式提交数据
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)deleteWithUrl:(NSString *)urlString
           parameters:(id)parameters
              success:(NetRequestSuccessBlock)success
                 fail:(NetRequestFailedBlock)fail;

/**
 *  Patch形式提交数据
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)patchWithUrl:(NSString *)urlString
          parameters:(id)parameters
             success:(NetRequestSuccessBlock)success
                fail:(NetRequestFailedBlock)fail;



//PHP专用
- (void)getPhpWithUrl:(NSString *)urlString
           parameters:(id)parameters
              success:(NetRequestSuccessBlock)success
                 fail:(NetRequestFailedBlock)fail;

//PHP专用
- (void)postPhpWithUrl:(NSString *)urlString
            parameters:(id)parameters
               success:(NetRequestSuccessBlock)success
                  fail:(NetRequestFailedBlock)fail;



/**
 *  Get形式提交数据 带缓存策略
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block,缓存也会放在这里
 *  @param fail       失败Block
 *  @param policy     缓存策略Block
 */
- (void)getWithUrl:(NSString *)urlString
        parameters:(id)parameters
       cachePolicy:(RequestCachePolicy)policy
           success:(NetRequestCacheSuccessBlock)success
              fail:(NetRequestFailedBlock)fail;


/**
 *  Post形式提交数据 带缓存策略
 *
 *  @param urlString  Url
 *  @param parameters 参数
 *  @param success    成功Block,缓存也会放在这里
 *  @param fail       失败Block
 *  @param policy     缓存策略Block
 */
- (void)postWithUrl:(NSString *)urlString
         parameters:(id)parameters
        cachePolicy:(RequestCachePolicy)policy
            success:(NetRequestCacheSuccessBlock)success
               fail:(NetRequestFailedBlock)fail;

/**
 *  POST上传图片
 *
 *  @param urlString  上传地址
 *  @param image      图片
 *  @param parameters 参数
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)postUploadImageWithUrl:(NSString *)urlString
                         image:(UIImage *)image
                    parameters:(id)parameters
                      progress:(NetRequestProgressBlock)progress
                       success:(NetRequestSuccessBlock)success
                          fail:(NetRequestFailedBlock)fail;


/**
 *  POST上传图片数组
 *
 *  @param urlString  上传地址
 *  @param imageArray 图片数组
 *  @param parameters 参数
 *  @param progress   进度
 *  @param success    成功
 *  @param fail       失败
 */
- (void)postUploadMultiImageWithUrl:(NSString *)urlString
                         imageArray:(NSArray *)imageArray
                         parameters:(id)parameters
                           progress:(NetRequestProgressBlock)progress
                            success:(NetRequestSuccessBlock)success
                               fail:(NetRequestFailedBlock)fail;

/**
 *  下载文件
 *
 *  @param urlString  Url
 *  @param filePath   文件保存地址
 *  @param success    成功Block
 *  @param fail       失败Block
 */
- (void)downloadFileWithUrl:(NSString *)urlString
                   filePath:(NSURL *)filePath
                    success:(NetRequestSuccessBlock)success
                       fail:(NetRequestFailedBlock)fail;
@end
