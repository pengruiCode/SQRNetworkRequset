//
//  SQRDataSave.h
//  SQRCommonToolsProject
//
//  Created by macMini on 2018/5/25.
//  Copyright © 2018年 PR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SaveDataNameEnum) {
    //默认标识，在使用自定义key时使用
    SaveDataEnum_Default = 0,
    //用户标识(php)
    SaveDataEnum_Session,
    //用户标识(java)
    SaveDataEnum_Token,
    //用户ID
    SaveDataEnum_UserId,
    //用户昵称
    SaveDataEnum_UserName,
    //用户电话
    SaveDataEnum_UserMobi,
    //用户注册时间
    SaveDataEnum_UserRegisterTime,
    //用户类型
    SaveDataEnum_UserType,
    //登录所用账号
    SaveDataEnum_LoginAccount,
    //app当前版本号
    SaveDataEnum_AppVersion,
    //导航主色调(在跳转或设置rootvc的时候存在本地，因为三端主色调不一致)
    SaveDataEnum_MasterColor,
    //极光推送注册ID
    SaveDataEnum_PushRegisterId,
    //当前位置 存入字典。结构为 dict:{@"lon":@"108.865644",@"lat":@"34.245529",@"city":@"029"}
    SaveDataEnum_LocationDict
};

@interface SQRDataSave : NSObject

#pragma mark --- 存储一般类型数据到偏好设置

/**
 *  将数据存入偏好设置
 *  @param   data       数据
 *  @param   dataEnum   数据类型（将转化为数字作为key）
 *  @param   customKey  数据名称（在本类提供的枚举不能满足需求的时候使用自定义key来存取）
 */
+ (void)saveDataInUserDefaultsWithData:(id)data dataEnum:(SaveDataNameEnum)dataEnum customKey:(NSString *)customKey;

/**
 *  从偏好设置获取本地保存的数据
 *  @param   dataEnum   数据名称
 *  @param   customKey  数据名称（在本类提供的枚举不能满足需求的时候使用自定义key来存取）
 *  @return             具体数据
 */
+ (id)takeOutDataFromDataEnum:(SaveDataNameEnum)dataEnum customKey:(NSString *)customKey;

/**
 *  从偏好设置删除数据
 *  @param   dataEnum   数据名称
 *  @param   customKey  数据名称（在本类提供的枚举不能满足需求的时候使用自定义key来删除）
 */
+ (void)removeDataFromDataEnum:(SaveDataNameEnum)dataEnum customKey:(NSString *)customKey;



#pragma mark --- 存储自定义对象到偏好设置

/**
 *  将自定义数据类型存入偏好设置 （自定义对象需要实现解归档协议）
 *  @param   data       数据
 *  @param   customKey  数据名称（自定义key来存取）
 */
+ (void)saveDataKeyedUnarchiverInUserDefaultsWithData:(id)data customKey:(NSString *)customKey;

/**
 *  从偏好设置获取本地保存的数据
 *  @param   customKey  数据名称（自定义key来存取）
 *  @return             具体数据
 */
+ (id)takeOutDataKeyedUnarchiverFromCustomKey:(NSString *)customKey;

/**
 *  从偏好设置删除数据
 *  @param   customKey  数据名称（使用自定义key来删除）
 */
+ (void)removeDataKeyedUnarchiverFromCustomKey:(NSString *)customKey;



@end
