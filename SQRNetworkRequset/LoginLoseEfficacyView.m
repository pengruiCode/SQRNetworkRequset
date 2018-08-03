//
//  LoginLoseEfficacyView.m
//  SQRNetworkRequset
//
//  Created by macMini on 2018/7/4.
//  Copyright © 2018年 PR. All rights reserved.
//

#import "LoginLoseEfficacyView.h"
#import "SQRNetworkRequest.h"
#import <SQRBaseDefineWithFunction/SQRBaseDefine.h>
#import <SQRBaseDefineWithFunction/SQRDataSave.h>

@implementation LoginLoseEfficacyView

+ (LoginLoseEfficacyView *)sharedInstance {
    static LoginLoseEfficacyView *loginLoseEfficacyView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        loginLoseEfficacyView = [[self alloc] init];
    });
    return loginLoseEfficacyView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREENH_HEIGHT)]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"LoginLoseEfficacyView" owner:nil options:nil].firstObject;
        [self setFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREENH_HEIGHT)];
        if ([SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_MasterColor customKey:nil]) {
            NSNumber *num = [SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_MasterColor customKey:nil];
            [_loginBtn setBackgroundColor:DEF_HEXColor(num.intValue)];
            _titleLb.textColor = DEF_HEXColor(num.intValue);
        }
    }
    return self;
}


- (IBAction)pushLogin {
    [self hide];
    if ([SQRNetworkRequest sharedInstance].loginVc) {
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[SQRNetworkRequest sharedInstance].loginVc];
        NSNumber *num = [SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_MasterColor customKey:nil];
        nav.navigationBar.barTintColor = num ? DEF_HEXColor(num.intValue) : [UIColor lightGrayColor];
        nav.navigationBar.tintColor = [UIColor whiteColor];
        nav.navigationItem.title = @"登录";
        [[SQRCommonFunction topViewController] presentViewController:nav animated:YES completion:^{
            [[UIApplication sharedApplication].keyWindow.rootViewController removeFromParentViewController];
        }];
    }
}


- (void)show {
    
    if ([SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_MasterColor customKey:nil]) {
        NSNumber *num = [SQRDataSave takeOutDataFromDataEnum:SaveDataEnum_MasterColor customKey:nil];
        [_loginBtn setBackgroundColor:DEF_HEXColor(num.intValue)];
        _titleLb.textColor = DEF_HEXColor(num.intValue);
    }
    
    if (!self.isShow) {
        [DEF_Window addSubview:self];
        self.backgroundColor = [UIColor clearColor];
        self.isShow = YES;
        [_popView.layer setValue:@(0) forKeyPath:@"transform.scale"];
        DEF_WeakSelf(self);
        [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             self.backgroundColor = DEF_RGBAColor(85, 85, 85, 0.4);
                             [weakself.popView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                             
                         } completion:nil];
    }
}


- (IBAction)hide {
    self.isShow = NO;
    DEF_WeakSelf(self);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        weakself.popView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
