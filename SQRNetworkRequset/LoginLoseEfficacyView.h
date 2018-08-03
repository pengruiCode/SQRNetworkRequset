//
//  LoginLoseEfficacyView.h
//  SQRNetworkRequset
//
//  Created by macMini on 2018/7/4.
//  Copyright © 2018年 PR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginLoseEfficacyView : UIView

@property (nonatomic,weak) IBOutlet UIView *popView;
@property (nonatomic,weak) IBOutlet UILabel *titleLb;
@property (nonatomic,weak) IBOutlet UIButton *loginBtn;
@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,strong) void (^pushLoginBlcok)(void);

+ (LoginLoseEfficacyView *)sharedInstance;

- (void)show;

- (IBAction)hide;

@end
