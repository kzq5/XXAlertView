//
//  XXAlertView.h
//  kxx
//
//  Created by kangzhiqiang on 2019/4/9.
//  Copyright © 2019 kxx All rights reserved.
//

#import "XXAlertView.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width


typedef NS_ENUM(NSInteger,UIButtonImageLayoutType) {
    // image在左，label在右,如下图
    //***********************
    //*       🐰 文字       *
    //***********************
    UIButtonImageLayoutImageLeft,
    // image在右，label在左,如下图
    //***********************
    //*       文字 🐰       *
    //***********************
    UIButtonImageLayoutImageRight,
    // image在上，label在下,如下图
    //***********************
    //*          🐰        *
    //*         文字        *
    //***********************
    UIButtonImageLayoutImagetTop,
    // image在下，label在上,如下图
    //***********************
    //*         文字        *
    //*         🐰         *
    //***********************
    UIButtonImageLayoutImageBottom,
    // image在左，label在中,如下图
    //***********************
    //*  🐰     文字        *
    //***********************
    UIButtonImageLayoutImageLeftDepend,
    // 恢复默认无图片状态,如下图
    //***********************
    //*         文字        *
    //***********************
    UIButtonImageLayoutImageNoImage,
};

@implementation UIButton (XXImageTitleStyle)

- (void)xx_layoutButtonWithEdgeInsetsStyle:(UIButtonImageLayoutType)style
                        imageTitleSpace:(CGFloat)space
{
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case UIButtonImageLayoutImagetTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case UIButtonImageLayoutImageLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case UIButtonImageLayoutImageLeftDepend:
        {
            
            CGFloat pading = self.frame.size.width-imageWith-labelWidth;
            imageEdgeInsets = UIEdgeInsetsMake(0, -pading/2.0+space, 0, pading/2.0-space);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith/2.0, 0, imageWith/2.0);
        }
            break;
        case UIButtonImageLayoutImageBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case UIButtonImageLayoutImageRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        case UIButtonImageLayoutImageNoImage:
        {
            //            imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            //            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}
@end


@interface XXAlertView()<CAAnimationDelegate>

/** mainView */
@property (nonatomic, strong) UIView *mainView;
/** imageButton */
@property (nonatomic, strong) UIButton *imageButton;
/** config */
@property (nonatomic, strong) XXAlertViewConfig *config;

/** title */
@property (nonatomic, copy) NSString *title;
/** inView */
@property (nonatomic, strong) UIView *inView;
@end
@implementation XXAlertView

CGFloat text_Padding = 15.f;
CGFloat image_Margin = 8.f;
CGFloat bottom_Margin = 8.f;
CGFloat icon_Width = 30.f;

+ (XXAlertView *)showAlert:(NSString *)title{
    return [self showAlert:title inView:[UIApplication sharedApplication].keyWindow];
}

+ (XXAlertView *)showAlert:(NSString *)title inView:(UIView *)showView{
    return [self showAlert:title inView:[UIApplication sharedApplication].keyWindow withConfig:[XXAlertViewConfig defaultConfig]];
}

+ (XXAlertView *)showAlert:(NSString *)title inView:(UIView *)inView withConfig:(XXAlertViewConfig *)config{
    if (!config) {
        config = [XXAlertViewConfig defaultConfig];
    }
    if (!inView) {
        inView = [UIApplication sharedApplication].keyWindow;
    }
    return [[self alloc] initWithTitle:title inView:inView config:config];
}

- (XXAlertView *)initWithTitle:(NSString *)title inView:(UIView *)inView config:(XXAlertViewConfig *)config{
    if (self = [super init]) {
        self.title = title;
        self.config = config;
        self.inView = inView;
        
        //初始化UI
        [self initUI];
        
        //初始化动画
        [self initAnimation];
    }
    return self;
}

#pragma mark - 初始化动画
- (void)initAnimation {
    CGPoint fromPoint = self.mainView.center;
    fromPoint.y = -self.mainView.frame.size.height;
    CGPoint oldPoint = self.mainView.center;
    
    
    if (@available(iOS 9.0, *)) {
        CFTimeInterval settlingDuratoin = 0.f;
        
        CABasicAnimation *fillAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        fillAnim.fromValue = [NSValue valueWithCGPoint:fromPoint];
        fillAnim.toValue = [NSValue valueWithCGPoint:oldPoint];
        fillAnim.removedOnCompletion = NO;
        fillAnim.fillMode = kCAFillModeForwards;
        fillAnim.duration = 0.3;
        [self.mainView.layer addAnimation:fillAnim forKey:nil];
        
        settlingDuratoin = 0.3;
        
        CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        basicAnim.duration = 0.25;
        basicAnim.beginTime = CACurrentMediaTime() + settlingDuratoin+ self.config.duration;
        
        basicAnim.fromValue = [NSValue valueWithCGPoint:oldPoint];
        basicAnim.toValue = [NSValue valueWithCGPoint:fromPoint];
        basicAnim.removedOnCompletion = NO;
        basicAnim.fillMode = kCAFillModeForwards;
        basicAnim.delegate = self;
        [self.mainView.layer addAnimation:basicAnim forKey:nil];
        
    }
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self removeNoiifyViewFromSuperview];
}

#pragma mark - 删除视图
- (void)removeNoiifyViewFromSuperview {
    [self removeFromSuperview];
}

#pragma mark - 初始化UI
- (void)initUI {
    [self.inView addSubview:self];
    
    CGFloat padding = 0.f;

    CGFloat mainViewX = padding;
    CGFloat mainViewW = kScreenWidth - mainViewX * 2;
    CGFloat mainViewY = padding;
    CGFloat mainViewH = 0;
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(mainViewX, mainViewY, mainViewW, mainViewH)];
    self.mainView.backgroundColor = self.config.backgroundColor;
    [self addSubview:self.mainView];
    
    
    
    UIFont *titleFont = [UIFont systemFontOfSize:self.config.textSize];
    if (@available(iOS 8.2, *)) {
        titleFont = [UIFont systemFontOfSize:self.config.textSize weight:UIFontWeightMedium];
    }
    
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineSpacing = self.config.textLineSpace;
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:self.title attributes:@{
                                                                                                   NSFontAttributeName: titleFont,
                                                                                                   NSParagraphStyleAttributeName: ps,
                                                                                                   NSForegroundColorAttributeName:   self.config.textColor                                   }];
    
    _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageButton setAttributedTitle:attr forState:UIControlStateNormal];
    [_imageButton setImage:[UIImage imageNamed:self.config.iconString] forState:UIControlStateNormal];
    _imageButton.titleLabel.numberOfLines = self.config.textLineNumber;
    _imageButton.titleLabel.font = titleFont;
    [self.mainView addSubview:_imageButton];
    CGFloat titleLW = self.mainView.frame.size.width - text_Padding * 2;
    CGFloat titleLH = [self getHeightForString:self.title font:titleFont andWidth:titleLW - icon_Width - image_Margin];
    CGFloat titleLY = [self getStatusHeight];
    _imageButton.frame  =CGRectMake(text_Padding, titleLY, titleLW, titleLH > 44?titleLH:44);
    
    CGRect mainViewFrame = self.mainView.frame;
    mainViewFrame.size.height = CGRectGetMaxY(_imageButton.frame)+(titleLH >25?bottom_Margin:0);
    self.mainView.frame = mainViewFrame;
    [_imageButton xx_layoutButtonWithEdgeInsetsStyle:UIButtonImageLayoutImageLeft imageTitleSpace:image_Margin];
    [_imageButton setContentHorizontalAlignment:self.config.buttonAlign];
}

#pragma mark - 获取状态栏高度
- (CGFloat)getStatusHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

#pragma mark - 根据宽度计算高度
- (CGFloat)getHeightForString:(NSString *)value font:(UIFont *)font andWidth:(CGFloat)width {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = self.config.textLineSpace;
    CGRect rect = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:@{
                                                NSFontAttributeName: font,
                                                NSParagraphStyleAttributeName: paragraphStyle,
                                                }
                                      context:nil];
    return rect.size.height;
}

@end


@implementation XXAlertViewConfig

+ (XXAlertViewConfig *)defaultConfig {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        //初始化配置
        [self initDefaultConfig];
    }
    return self;
}

#pragma mark - 初始化配置
- (void)initDefaultConfig {
    self.alertType = XXAlertViewTypeSuccess;

    self.textSize = 16.f;
    self.textLineSpace = 2.f;
    self.textColor = [UIColor grayColor];
    self.textLineNumber = 0;
    self.buttonAlign = UIControlContentHorizontalAlignmentCenter;
    
    self.duration = 1.2f;
    
    self.iconString = @"warning";
}
- (void)setAlertType:(XXAlertViewType)alertType{
    _alertType = alertType;
    switch (alertType) {
        case XXAlertViewTypeSuccess:
            [self configAlertWithTitleColor:[UIColor grayColor] withIcon:@"success"];
            break;
            
        case XXAlertViewTypeError:
            [self configAlertWithTitleColor:[UIColor grayColor] withIcon:@"warning"];
            break;
        case XXAlertViewTypeWarning:
            [self configAlertWithTitleColor:[UIColor grayColor] withIcon:@"warning"];
            break;
        default:
            break;
    }
}
- (void)configAlertWithTitleColor:(UIColor *)titleColor withIcon:(NSString *)icon{
    self.textColor = titleColor;
    self.iconString = icon;
}
@end


