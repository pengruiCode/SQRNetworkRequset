//
//  SQRSystemApiFunction.h
//  SQRCommonToolsProject
//
//  Created by macMini on 2018/5/25.
//  Copyright © 2018年 PR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQRSystemApiFunction : NSObject


/**
 * 接收网络状态的通知
 */
extern NSString *const KConnectStateNoti;

/**
 * 实时监测网络状态
 */
+ (void)getConnectionModeRealTime;

/**
 *
 *  获取当前网络连接方式
 *
 *  @return 连接方式
 */
+ (NSInteger)getConnectionMode;

/**
 *
 *  获取操作系统版本号
 *
 *  @return 版本号
 */
+ (NSString *)getOperatingSystemVersion;

/**
 *
 *  获取当前APP版本号
 *
 *  @return 版本号
 */
+ (NSString *)getAppVersion;

/**
 *
 *  获取设备名称
 *
 *  @return 设备名
 */
+ (NSString *)getDeviceName;

/**
 *
 *  获取手机运营商
 *
 *  @return 连接方式
 */
+ (NSString *)getMobileOperator;

/**
 *
 *  获取手机设备号
 *
 *  @return UUID
 */
+ (NSString *)getDeviceID;

@end
