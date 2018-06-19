//
//  SQRBaseDefine.h
//  SQRCommonToolsProject
//
//  Created by macMini on 2018/5/25.
//  Copyright © 2018年 PR. All rights reserved.
//

#ifndef SQRBaseDefine_h
#define SQRBaseDefine_h
#import "SQRCommonFunction.h"
#import "SQRDataSave.h"
#import "SQRDateFunction.h"
#import "SQRSystemApiFunction.h"
#import "UILabel+FlickerNumber.h"
#import "UIView+Frame.h"
#import "UIView+Tap.h"
#import <Toast/UIView+Toast.h>
#import <MBProgressHUD/MBProgressHUD.h>

//打印信息
//#define NSLog(FORMAT, ...) nil;
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


//需要横屏或者竖屏，获取屏幕宽度与高度
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上

#define DEF_SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define DEF_SCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define DEF_SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)

#else

#define DEF_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define DEF_SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DEF_SCREEN_SIZE [UIScreen mainScreen].bounds.size


#endif

//全屏frame
#define DEF_SCREEN_FRAME (CGRectMake(0, 0 ,DEF_SCREEN_WIDTH,DEF_SCREENH_HEIGHT))

//获取通知中心
#define DEF_NotificationCenter [NSNotificationCenter defaultCenter]

//设置随机颜色
#define DEF_RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

//设置RGB颜色/设置RGBA颜色
#define DEF_RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DEF_RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
#define DEF_HEXColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DEF_HEXColorA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
// clear背景颜色


//最上层vc跳转（Push）
#define DEF_PushToViewController(ViewController) \
ViewController.hidesBottomBarWhenPushed = YES;\
[[LKCommonTools topViewController].navigationController pushViewController:ViewController animated:YES]

//最上层vc跳转（Present）
#define DEF_PresentToViewController(ViewController) \
ViewController.hidesBottomBarWhenPushed = YES;\
[[LKCommonTools topViewController] presentViewController:ViewController animated:YES completion:nil]

//最上层vc返回
#define DEF_PopToViewController \
[[LKCommonTools topViewController].navigationController popViewControllerAnimated:YES]

//设置原生tableviewcell的image大小
#define DEF_CELL_IMAGEVIEW_SIZE(Width,Height)\
\
CGSize itemSize = CGSizeMake(Width, Height);\
UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);\
CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);\
[cell.imageView.image drawInRect:imageRect];\
cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();\
UIGraphicsEndImageContext();


//弱引用/强引用
#define DEF_WeakSelf(type)  __weak typeof(type) weak##type = type;
#define DEF_StrongSelf(type)  __strong typeof(type) type = weak##type;


//设置 view 圆角和边框
#define DEF_ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]


//由角度转换弧度 由弧度转换角度
#define DEF_DegreesToRadian(x) (M_PI * (x) / 180.0)
#define DEF_RadianToDegrees(radian) (radian*180.0)/(M_PI)


//设置加载提示框（第三方框架：Toast）
#define DEF_Toast(str)\
\
CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];\
[DEF_Window  makeToast:str duration:1.0 position:CSToastPositionBottom style:style];\
DEF_Window.userInteractionEnabled = NO; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
DEF_Window.userInteractionEnabled = YES;\
});\


// 加载
#define DEF_ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
// 收起加载
#define DEF_HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
// 设置加载
#define DEF_NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x

//keyWindow
#define DEF_Window [UIApplication sharedApplication].keyWindow


//设置加载提示框（第三方框架：MBProgressHUD）
#define DEF_ShowHUDAndActivity(str)  DEF_BackView;\
MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:DEF_Window animated:YES]; \
hud.mode = MBProgressHUDModeIndeterminate; \
hud.color = DEF_RGBColor(222.0, 224.0, 226.0); \
hud.activityIndicatorColor = [UIColor blackColor]; \
hud.labelColor = DEF_RGBColor(64.0, 64.0, 64.0); \
hud.labelFont = [UIFont systemFontOfSize:13]; \
if (str && str.length > 0) {    \
hud.labelText = str;\
} else {    \
hud.labelText = @"  加载中...  ";  \
}   \

//隐藏提示框（第三方框架：MBProgressHUD）
#define DEF_HiddenMBHUD [MBProgressHUD hideHUDForView:DEF_Window animated:YES];


//在java接口请求失败的时候快速处理错误提示
#define DEF_JAVAERROR_TOAST(error,task,showText)\
if (task) {\
    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;\
    if (responses.statusCode == 404 || responses.statusCode == 500) {\
        DEF_Toast(showText);\
    }else{\
        if([error userInfo][@"body"]){\
            NSDictionary *userInfo = [SQRCommonFunction JsonToDictionary:[error userInfo][@"body"]];\
            DEF_Toast(userInfo[@"message"]);\
        }\
    }\
}else{\
    DEF_Toast(@"暂无网络，请切换网络重试");\
}



//获取图片资源
#define DEF_GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//获取当前语言
#define DEF_CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//NSUserdefault存取
#define DEF_SaveUserDefault(obj, key) [[NSUserDefaults standardUserDefaults] setValue:obj forKey:key];
#define DEF_GetUserDefault(key) [[NSUserDefaults standardUserDefaults] objectForKey:key];

//使用 ARC 和 MRC
#if __has_feature(objc_arc)
// ARC
#else
// MRC
#endif

//判断当前的iPhone设备/系统版本
//判断是否为iPhone
#define DEF_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define DEF_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是否为ipod
#define DEF_IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

// 判断是否为 iPhone 5SE
#define DEF_iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f

// 判断是否为iPhone 6/6s
#define DEF_iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f

// 判断是否为iPhone 6Plus/6sPlus
#define DEF_iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f

// 判断是否是iPhone X
#define DEF_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


// 状态栏高度
#define DEF_STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)

// 导航栏高度
#define DEF_NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)

// tabBar高度
#define DEF_TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)


//获取系统版本
#define DEF_IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//判断 iOS 8 或更高的系统版本
#define DEF_IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//沙盒目录文件
//获取temp
#define DEF_PathTemp NSTemporaryDirectory()

//获取沙盒 Document
#define DEF_PathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache
#define DEF_PathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//GCD 的宏定义
//GCD - 一次性执行
#define DEF_DISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

//GCD - 在Main线程上运行
#define DEF_DISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//GCD - 开启异步线程
#define DEF_DISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

//网络提示符 （状态栏）
//是否开启网络标示符
#define DEF_ShowSystemNetworkActivityIndicator [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]
#define DEF_HidenSystemNetworkActivityIndicator [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO]

//隐藏键盘
#define DEF_HidenKeyboard [[[UIApplication sharedApplication] keyWindow] endEditing:YES]


#endif /* SQRBaseDefine_h */
