//
//  SQRCommonFunction.h
//  SQRCommonToolsProject
//
//  Created by macMini on 2018/5/25.
//  Copyright © 2018年 PR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SQRCommonFunction : NSObject

@property (nonatomic,strong) UIView *popup;

#pragma mark --- 字符相关

+ (instancetype)sharedInstance;

/*
 *设置字符缩进，行间距
 *
 **/
+ (NSMutableAttributedString *)stringConvertArrStrWithString:(NSString *)str;


/**
 *  单纯改变一句话中的某些字的颜色（一种颜色）
 *  @param color    需要改变成的颜色
 *  @param str 总的字符串
 *  @param subStringArr 需要改变颜色的文字数组(字符串中所有的 相同的字)
 *  @return 生成的富文本
 */
+(NSMutableAttributedString *)changeTextColorWithColor:(UIColor *)color string:(NSString *)str andSubString:(NSArray *)subStringArr;

/**
 *  获取某个字符串中子字符串的位置数组 (字符串中所有的 相同的字)
 *  @param totalString 总的字符串
 *  @param subString   子字符串
 *  @return 位置数组
 */
+ (NSMutableArray *)getRangeWithTotalString:(NSString *)totalString SubString:(NSString *)subString;


/**
 *  改变某些文字的颜色 并单独设置其字体
 *  @param font        设置的字体
 *  @param color       颜色
 *  @param totalString 总的字符串
 *  @param subArray    想要变色的字符数组
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray;


/**
 *  为某些文字下面画线
 *  @param totalString 总的字符串
 *  @param subArray    需要画线的文字数组
 *  @param lineColor   线条的颜色
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)addLinkWithTotalString:(NSString *)totalString andLineColor:(UIColor *)lineColor SubStringArray:(NSArray *)subArray;


/**
 *  替换电话号码中间4位为*
 *  @param mobi 电话号码
 *  @return 替换后的字符
 */
+ (NSString *)hideMobiCenterFourStrWithMobi:(NSString *)mobi;


/**
 *  计算字符串长度，UILabel自适应高度
 *  @param text  需要计算的字符串
 *  @param size  字号大小
 *  @param width 最大宽度
 *  @return 返回大小
 */
+(CGSize)labelText:(NSString *)text fontSize:(float)size width:(CGFloat)width;

#pragma mark --- 图片，颜色相关

/**
 *  为某几个角切圆角
 *  @param view     需要切的视图
 *  @param corners  圆角方向 （例 ：UIRectCornerTopRight | UIRectCornerBottomRight）
 *  @param radius   圆角数值
 */
+ (void)setViewRadiusWithView:(UIView *)view direction:(UIRectCorner)corners radius:(float)radius;


/**
 *  将图片保存到沙盒路径下Image文件夹内
 *  @param image 待保存图片
 *  @return 文件路径
 */
+ (NSString *)saveImageToDocument:(UIImage *)image;


/**
 *  压缩图片尺寸
 *  @param image    带压缩图片
 *  @param viewSize 目标Size
 *  @return UIImage
 */
+ (UIImage *)compressImage:(UIImage *)image withSize:(CGSize)viewSize;


/**
 *  拉伸图片
 *  @param image 图片
 *  @return 返回拉伸后的图片
 */
+ (UIImage *)stretchableImage:(UIImage *)image;


/**
 *  通过手机号码生成固定颜色
 *  @param mobile 手机号码
 *  @return 颜色
 */
+ (UIColor *)getColorWithMobile:(NSString *)mobile;


/**
 *  通过颜色生成图片
 *  @param color color
 *  @return UIImage
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  设置渐变背景色
 *  @param view         要设置的view
 *  @param isVertical   是否是竖直方向
 *  @param stareColor   起始颜色
 *  @param endColor     结束颜色
 *  @param frame        view大小
 */
+ (void)setGradualChangeBackgroundWithView:(UIView *)view isVertical:(BOOL)isVertical startColor:(UIColor *)stareColor endColor:(UIColor *)endColor frame:(CGRect)frame;


/**
 *  设置上传图片指示动画
 *  @param title        提示文字
 */
- (void)setUploadImageAnimationWithTitle:(NSString *)title;

/**
 *  隐藏上传图片指示动画
 */
- (void)hide;


#pragma mark --- 判断相关

/**
 *  判断手机号是否合法
 *  @return 返回YES合法 返回NO不合法
 */

+(BOOL)judgePhoneNumberIsLegal:(NSString *)phoneNumber;


/**
 *  判断字符传中是否包含Emoji表情
 *  @param string 字符创
 *  @return 结果 @{@"isContains":@(BOOL),@"emojiCount":@(NSUInteger)}
 */
+ (NSDictionary *)stringContainsEmoji:(NSString *)string;


/**
 *  判断字符串是否为全中文
 *  @param checkString 待检测字符串
 *  @return 判断返回
 */
+ (BOOL)checkIsChineseString:(NSString *)checkString;


/**
 *  判断字符串是否为空（@"" nil NULL (null)）
 *  @param string 待检测字符串
 *  @return 判断返回
 */
+ (BOOL)isBlankString:(NSString *)string;


/**
 *  验证邮箱
 *  @param email 待检测字符串
 *  @return 判断返回
 */
+ (BOOL)validateEmail:(NSString *)email;


/**
 *  判断是否为全数字
 *  @param str 待检测字符串
 *  @return 判断返回
 */
+ (BOOL)isNumText:(NSString *)str;


/**
 *  判断是否包含空格
 *  @param str 待检测字符串
 *  @return 判断返回
 */
+ (BOOL)isEmpty:(NSString *)str;


/**
 *  判断后一个时间是否是在指定的时间范围内
 *  @param minutes   指定的时间范围，单位分钟
 *  @param date      基准时间
 *  @param otherDate 目标时间
 *  @return 判断返回
 */
+ (BOOL)isLessThanDestMinutes:(double)minutes fromDate:(NSString *)date otherDate:(NSString *)otherDate;


/**
 *  检测银行卡的合法性
 *  @param cardNo 银行卡号
 *  @return 判断返回
 */
+ (BOOL)checkBankCardNo:(NSString *)cardNo;


#pragma mark --- 转化相关

/**
 *  将汉字转化成拼音
 *  @param string 待转换的中文
 *  @return 拼音字符串
 */
+ (NSString *)translateChineseToPinYin:(NSString *)string;



/**
 *  字典转json
 *  @param dic 字典数据
 *  @return NSString
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

/**
 *  json转字典
 *  @param string json
 *  @return NSDictionary
 */
+ (NSDictionary *)JsonToDictionary:(NSString *)string;

/**
 *  Unicode转中文
 *  @param TransformUnicodeString Unicode
 *  @return NSString
 */
+ (NSString *)replaceUnicode:(NSString *)TransformUnicodeString;


/**
 *  字符串md5加密
 */
- (NSString *)encryptMD5WithString:(NSString *)string;

/**
 *  字符串sha1加密
 */
- (NSString *)encryptSha1WithString:(NSString *)string;


#pragma mark --- 获取，创建相关

/**
 *  获取当前最上层显示的vc
 */
+ (UIViewController *)topViewController;



/**
 *  在导航控制链中获取上一级vc
 *  @param selfVc   上一级vcClass
 *  @param classVc  上一级vcClass
 */
+ (UIViewController *)getLastViewControllerWithSelf:(UIViewController *)selfVc andKindClass:(Class)classVc;


#pragma mark --- 功能相关

/**
 *  打电话
 */
+ (void)callTelWithTel:(NSString *)tel;


//冒泡排序
+ (NSMutableArray *)buddleSort:(NSMutableArray *)array;


@end
