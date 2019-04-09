# XXAlertView
一行代码实现提示，也可根据自己的需求自定义  

<img src="https://raw.githubusercontent.com/kzq5/XXAlertView/master/screenshot/%E6%9C%AA%E5%91%BD%E5%90%8D1.gif" width = 375>
  
一行代码即可实现  

```//显示提示  
[XXAlertView showAlert:title inView:self.view withConfig:[XXAlertViewConfig defaultConfig]];  
```
 
自定义实现
```
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
//自定义提示类型，是成功，提示，失败等
config.alertType = type;

//显示
[XXAlertView showAlert:title inView:[UIApplication sharedApplication].keyWindow withConfig:[XXAlertViewConfig defaultConfig]];
```
