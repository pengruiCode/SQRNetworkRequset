//
//  SQRDataSave.m
//  SQRCommonToolsProject
//  本地存储数据
//  Created by macMini on 2018/5/25.
//  Copyright © 2018年 PR. All rights reserved.
//

#import "SQRDataSave.h"


@implementation SQRDataSave


static id _instance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


+ (void)seveDataInUserDefaultsWithData:(id)data dataEnum:(SaveDataNameEnum)dataEnum customKey:(NSString *)customKey {
    if (data) {
        if (customKey) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:customKey];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"%ld",dataEnum]];
        }
    }
}


+ (id)takeOutDataFromDataEnum:(SaveDataNameEnum)dataEnum customKey:(NSString *)customKey {
    if (customKey) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:customKey];
    }else{
        return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld",dataEnum]];
    }
}


+ (void)removeDataFromDataEnum:(SaveDataNameEnum)dataEnum customKey:(NSString *)customKey {
    if (customKey) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:customKey];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%ld",dataEnum]];
    }
}





+ (void)seveDataKeyedUnarchiverInUserDefaultsWithData:(id)data customKey:(NSString *)customKey {
    NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:data];
    [[NSUserDefaults standardUserDefaults] setObject:infoData forKey:customKey];
}


+ (id)takeOutDataKeyedUnarchiverFromCustomKey:(NSString *)customKey {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:customKey]];
}


+ (void)removeDataKeyedUnarchiverFromCustomKey:(NSString *)customKey {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:customKey];
}


@end
