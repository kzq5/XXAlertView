//
//  XXAlertView.h
//  kxx
//
//  Created by kangzhiqiang on 2019/4/9.
//  Copyright © 2019 kxx All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XXAlertViewConfig;

@interface XXAlertView : UIView
+ (XXAlertView *)showAlert:(NSString *)title;

+ (XXAlertView *)showAlert:(NSString *)title inView:(UIView *)showView;

+ (XXAlertView *)showAlert:(NSString *)title inView:(UIView *)showView withConfig:(XXAlertViewConfig *)config;
@end

typedef NS_ENUM(NSInteger, XXAlertViewType){
    XXAlertViewTypeSuccess,
    XXAlertViewTypeError,
    XXAlertViewTypeWarning,
};

@interface XXAlertViewConfig : NSObject


+ (XXAlertViewConfig *)defaultConfig;

/**************************  通知样式 **************************/
/** 通知样式 */
@property (nonatomic, assign) XXAlertViewType alertType;

/**************************  背景颜色 **************************/
/** 通知视图的背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**************************  提示icon **************************/
/** 提示图标 (默认 对号) */
@property (nonatomic, copy) NSString *iconString;

/**************************  字体文字设置 **************************/
/** 文字字体大小 (默认 16) */
@property (nonatomic, assign) CGFloat textSize;
/** 文字行数 (默认 不限制，根据文字多少而定) */
@property (nonatomic, assign) CGFloat textLineNumber;
/** 文字字体颜色 (默认 black) */
@property (nonatomic, strong) UIColor *textColor;
/** 文字的行间距 (默认 2.f) */
@property (nonatomic, assign) CGFloat textLineSpace;
/** 文字图标对齐方式 (默认 居中对齐) */
@property (nonatomic, assign) UIControlContentHorizontalAlignment buttonAlign;

/**************************  动画设置 **************************/
/** 通知视图悬停时间 (默认 1.2) */
@property (nonatomic, assign) CGFloat duration;

@end

NS_ASSUME_NONNULL_END
