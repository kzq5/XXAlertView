//
//  ViewController.m
//  XXAlertViewDemo
//
//  Created by kangzhiqiang on 2019/4/9.
//  Copyright © 2019 kangxx. All rights reserved.
//

#import "ViewController.h"
#import "XXAlertView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)successAction:(id)sender {
    [self showWithType:XXAlertViewTypeSuccess withTitle:@"登录成功"];
}
- (IBAction)warningAction:(id)sender {
    [self showWithType:XXAlertViewTypeWarning withTitle:@"密码错误"];
}
- (IBAction)failedAction:(id)sender {
    [self showWithType:XXAlertViewTypeError withTitle:@"登录失败"];
}
- (void)showWithType:(XXAlertViewType)type withTitle:(NSString *)title{
    // 自定义配置
    XXAlertViewConfig *config = [XXAlertViewConfig defaultConfig];
    // 通知样式
    // 自定义背景颜色
    config.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    // 自定义字体大小
    config.textSize = 16.f;
    // 自定义文字颜色
    config.textColor = [UIColor colorWithRed:255/255.0 green:75/255.0 blue:113/255.0 alpha:1.0];
    // 自定义行间距
    config.textLineSpace = 4.f;
    // 自定义悬停时间
    config.duration = 2.f;
    
    config.alertType = type;
    
    //显示
    [XXAlertView showAlert:title inView:[UIApplication sharedApplication].keyWindow withConfig:config];
}
@end
