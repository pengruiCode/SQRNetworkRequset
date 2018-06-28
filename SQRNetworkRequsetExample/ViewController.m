//
//  ViewController.m
//  SQRNetworkRequset
//
//  Created by macMini on 2018/6/11.
//  Copyright © 2018年 PR. All rights reserved.
//

#import "ViewController.h"
#import "SQRNetworkRequest.h"
#import <SQRBaseDefineWithFunction/SQRBaseDefine.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}

- (IBAction)phpRequest:(id)sender {
//    [[SQRNetworkRequest sharedInstance] postWithUrl:@"https://api2.shequren.cn/index.php/api/app3/index_holiday_pic"
//                                         parameters:@{
//                                                      @"session":@"afcd767eab9b4ef45d3daaf715be30f0",
//                                                      @"version":@"3.5.2"
//                                                      } success:^(id responseObject) {
//
//                                                      } fail:^(NSError *error,NSURLSessionDataTask *task) {
//
//                                                      }];
    
//    [[SQRNetworkRequest sharedInstance] postWithUrl:@"http://ex.shoppingyizhan.com/Api/Courier/login"
//                                         parameters:@{
//                                                      @"device_id":@"3261FE1D-5751-4BE1-9C4A-BA331783AC1B",
//                                                      @"password":@"aaaaaa",
//                                                      @"username":@"15686092731"
//                                                      } success:^(id responseObject) {
//
//                                                      } fail:^(NSError *error,NSURLSessionDataTask *task) {
//
//                                                      }];
    
    [[SQRNetworkRequest sharedInstance] postPhpWithUrl:@"https://api2.shequren.cn/index.php/api/app3/login_account"
                                         parameters:@{
                                                      @"device_id":@"54B0EA25-FAAB-4AC0-AAAF-C10ADF12E096",
                                                      @"password":@"qqqqqq",
                                                      @"login_type":@"default",
                                                      @"mobi":@"15686092730",
                                                      @"version":@"3.6.3",
                                                      @"registration_id":@"12345678902"
                                                      } success:^(id responseObject) {
                                                          
                                                      } fail:^(NSError *error,NSURLSessionDataTask *task) {
                                                          
                                                      }];
}

- (IBAction)javaRequest:(id)sender {
    [[SQRNetworkRequest sharedInstance] postWithUrl:@"https://api.shequren.cn/ncs/blogs"
                                         parameters:@{
                                                      @"blogImg":@"",
                                                      @"blogType":@"0",
                                                      @"content":@"Tttt",
                                                      @"headImg":@"http://wx.qlogo.cn/mmhead/qbvaL9taELu7yQPVA43aXa2AnJ12GVyfWyxne2OVzH2H9y7WCXIo0g/0",
                                                      @"nickName":@"WalkingTimeIn",
                                                      @"userId":@"1838"
                                                      } success:^(id responseObject) {

                                                      } fail:^(NSError *error,NSURLSessionDataTask *task) {
                                                          DEF_JAVAERROR_TOAST(error, task, @"发送失败");
                                                      }];
    
//    [[SQRNetworkRequest sharedInstance] requestWithUrl:@"https://api.shequren.cn/ncs/blogs/508/favorite"
//                                            parameters:@{
//                                                         @"nickName":@"WalkingTimeIn",
//                                                         @"userId":@"18381"
//                                                         }
//                                                  type:PUT
//                                           cachePolicy:IgnoringLocalCacheData success:^(id responseObject) {
//
//                                                  } cache:^(id responseObject) {
//
//                                                  } failure:^(NSError *error, NSURLSessionDataTask *task) {
//                                                      DEF_JAVAERROR_TOAST(error, task, @"发送失败");
//                                                  }];
    
    
//    [SQRDataSave saveDataInUserDefaultsWithData:@"AT-266-whQ5BWRUBrYmXe3ETwf4DJEK50ydbgAxCj3" dataEnum:SaveDataEnum_Token customKey:nil];
//
//    [[SQRNetworkRequest sharedInstance] requestWithUrl:@"http://microservice.shoppingyizhan.com/shp/shops/login"
//                                            parameters:nil
//                                                  type:GET
//                                           cachePolicy:IgnoringLocalCacheData success:^(id responseObject) {
//
//                                           } cache:^(id responseObject) {
//
//                                           } failure:^(NSError *error, NSURLSessionDataTask *task) {
//                                               DEF_JAVAERROR_TOAST(error, task, @"发送失败");
//                                           }];
}

@end
