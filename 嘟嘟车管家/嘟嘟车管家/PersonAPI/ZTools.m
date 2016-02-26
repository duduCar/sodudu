//
//  ZTools.m
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "ZTools.h"
#import <MAMapKit/MAMapKit.h>

#define IPHONE6_HEIGHT 667.0f
#define IPHONE6_WIDTH 375.0f

@implementation ZTools

#pragma mark - 根据高度按比例适配大小（基于iphone6大小）
+(CGFloat)autoHeightWith:(CGFloat)aHeight{
    return aHeight*DEVICE_HEIGHT/IPHONE6_HEIGHT;
}
#pragma mark - 根据宽度按比例适配大小（基于iphone6大小）
+(CGFloat)autoWidthWith:(CGFloat)aWidth{
    return aWidth*DEVICE_WIDTH/IPHONE6_WIDTH;
}

+(NSString*)getUID{
//    NSString * uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
//    return [ZTools replaceNullString:uid WithReplaceString:@""];
    //张少南
    return @"7660nc7m506P4GWo0r5V5oPzytQfCKDotIgzZJUgxkbNTxQhAMQcnSrMLA3Z7xT5nJV2z58";
}
+(NSString*)getUserName{
    NSString * uid = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME];
    return [ZTools replaceNullString:uid WithReplaceString:@""];
}
+(BOOL)isLogin{
    if ([[ZTools getUID] length] == 0) {
        return NO;
    }else{
        return YES;
    }
}

+(NSString*)getSelectedCity{
    NSString * city = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserCity"];
    if (city.length > 0 && ![city isKindOfClass:[NSNull class]] && [city rangeOfString:@"null"].length == 0) {
        return city;
    }
    return @"";
}
+(NSString*)getDeviceToken{
    NSString * token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"devicePushToken"]];
    if (token.length > 0 && ![token isKindOfClass:[NSNull class]] && [token rangeOfString:@"null"].length == 0) {
        return token;
    }
    return @"";
}
+(void)setSelectedCity:(NSString *)aCity{
    [[NSUserDefaults standardUserDefaults] setObject:aCity forKey:@"UserCity"];
}

+(NSString*)findColumnId:(NSString *)column_name{
    if ([column_name isEqualToString:CAR_BAOXIAN]) {
        return CAR_BAOXIAN_ID;
    }else if ([column_name isEqualToString:CAR_MEIRONG]){
        return CAR_MEIRONG_ID;
    }else if ([column_name isEqualToString:CAR_PEIJIAN]){
        return CAR_PEIJIAN_ID;
    }else if ([column_name isEqualToString:CAR_SSSS]){
        return CAR_SSSS_ID;
    }else if ([column_name isEqualToString:CAR_WEIXIU]){
        return CAR_WEIXIU_ID;
    }else if ([column_name isEqualToString:CAR_XICHE]){
        return CAR_XICHE_ID;
    }else if ([column_name isEqualToString:CAR_ZULIN]){
        return CAR_ZULIN_ID;
    }else {
        return @"0";
    }
}
+(NSString*)findColumnName:(NSString *)column_id{
    if ([column_id isEqualToString:CAR_BAOXIAN_ID]) {
        return CAR_BAOXIAN;
    }else if ([column_id isEqualToString:CAR_MEIRONG_ID]){
        return CAR_MEIRONG;
    }else if ([column_id isEqualToString:CAR_PEIJIAN_ID]){
        return CAR_PEIJIAN;
    }else if ([column_id isEqualToString:CAR_SSSS_ID]){
        return CAR_SSSS;
    }else if ([column_id isEqualToString:CAR_WEIXIU_ID]){
        return CAR_WEIXIU;
    }else if ([column_id isEqualToString:CAR_XICHE_ID]){
        return CAR_XICHE;
    }else if ([column_id isEqualToString:CAR_ZULIN_ID]){
        return CAR_ZULIN;
    }else {
        return @"默认";
    }
}
+(NSString *)findComprehensiveWithName:(NSString*)name{
    if ([name isEqualToString:@"综合"]) {
        return @"default";
    }else if ([name isEqualToString:@"评论"]){
        return @"comments";
    }else if ([name isEqualToString:@"附近"]){
        return @"nearby";
    }
    
    return @"default";
}

///NSDate转换成NSString 已自定义的格式(例：YYYY-MM-dd HH:mm:ss)
+(NSString *)timechangeWithDate:(NSDate *)date WithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    return confromTimespStr;
}
///把当前时间转换成时间戳
+(NSString *)timechangeToDateline
{
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}
///时间戳转换成NSString 已自定义的格式(例：YYYY-MM-dd HH:mm:ss)
+(NSString *)timechangeWithTimestamp:(NSString *)placetime WithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[placetime doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

#pragma mark - 显示提示框
+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text WihtType:(MBProgressHUDMode)theModel addToView:(UIView *)aView isAutoHidden:(BOOL)hidden
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = theModel;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    if (hidden) {
        [hud hide:hidden afterDelay:1.5];
    }
    return hud;
}


#pragma mark - 计算字符串高度
+(CGSize)stringHeightWithFont:(UIFont*)font WithString:(NSString*)string WithWidth:(float)width{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    return retSize;

}

#pragma mark - 统一字体
+(UIFont *)returnaFontWith:(CGFloat)aSize
{
//    return [UIFont fontWithName:DEFAULT_FONT size:aSize];
    return [UIFont systemFontOfSize:aSize];
}

#pragma mark ----   将手机号码中间四位改为*
+(NSString *)returnEncryptionMobileNumWith:(NSString *)num{
    
    if (num.length != 11) {
        return num;
    }
    
    return [num stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}

#pragma mark -----   改变label某些字体颜色
+(NSMutableAttributedString *)labelTextColorWith:(NSString *)label_str Color:(UIColor *)color range:(NSRange)range{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label_str];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    return str;
}

#pragma mark ----  创建UITextField
+(STextField*)createTextFieldWithFrame:(CGRect)frame
                                  font:(float)font
                           placeHolder:(NSString*)placeHolder
                       secureTextEntry:(BOOL)scure{
    STextField * textField = [[STextField alloc] initWithFrame:frame];
    textField.font = [ZTools returnaFontWith:font];
    textField.placeholder = placeHolder;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
    textField.layer.borderWidth = 0.5;
    textField.secureTextEntry = scure;
    
    return textField;
}

+(UIButton*)createButtonWithFrame:(CGRect)frame
                            title:(NSString *)title
                            image:(UIImage*)image{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

+(UILabel *)createLabelWithFrame:(CGRect)frame
                            text:(NSString *)text
                       textColor:(UIColor*)color
                   textAlignment:(NSTextAlignment)textAlignment
                            font:(float)font{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.textAlignment = textAlignment;
    label.font = [ZTools returnaFontWith:font];
    
    return label;
}

+(CityInfo *)findCityInfoWith:(NSString*)name{
    NSArray * array = [CityInfo MR_findByAttribute:@"name" withValue:name];
    NSLog(@"array -----  %@",array);
    if (array.count) {
        CityInfo * info = [array objectAtIndex:0];
        return info;
    }else{
        return nil;
    }
}

+(NSString*)replaceNullString:(NSString*)string WithReplaceString:(NSString*)replace{
    if (string.length != 0 && ![string isKindOfClass:[NSNull class]] && [string rangeOfString:@"null"].length == 0 && ![string isEqualToString:@"<null>"]) {
        return string;
    }
    
    return replace;
}

@end
