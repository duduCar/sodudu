//
//  ZTools.h
//  推盟
//
//  Created by joinus on 15/7/29.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STextField.h"
#import "CityInfo.h"

@interface ZTools : NSObject
///根据高度按比例适配大小（基于iphone6大小）
+(CGFloat)autoHeightWith:(CGFloat)aHeight;
///根据宽度按比例适配大小（基于iphone6大小）
+(CGFloat)autoWidthWith:(CGFloat)aWidth;
///获取用户id
+(NSString*)getUID;
///获取用户名
+(NSString*)getUserName;
///判断用户是否登录
+(BOOL)isLogin;

/**
 *获取用户所选城市
 */
+(NSString *)getSelectedCity;
/**
 *  获取DeviceToken
 */
+(NSString*)getDeviceToken;
/**
 *  设置用户所选城市
 */
+(void)setSelectedCity:(NSString*)aCity;
/**
 *  根据服务栏目id查找栏目名称
 *
 *  @param column_id 服务栏目id
 */
+(NSString*)findColumnName:(NSString*)column_id;
/**
 *  根据服务栏目名称查找栏目id
 *
 *  @param column_name 服务栏目名称
 */
+(NSString*)findColumnId:(NSString*)column_name;
/**
 *  根据综合下的某个选项，查找请求该类型数据时传得参数
 */
+(NSString *)findComprehensiveWithName:(NSString*)name;

/**
 * 根据城市名称查找城市类
 */
+(CityInfo *)findCityInfoWith:(NSString*)name;



/**
 *  NSDate转换成NSString 
 *
 *  @param date   目标时间
 *  @param format 自定义返回格式（例：YYYY-MM-dd HH:mm:ss）
 */
+(NSString *)timechangeWithDate:(NSDate *)date WithFormat:(NSString *)format;
/**
 *  NSDate转时间戳
 */
+(NSString *)timechangeToDateline;
/**
 *  时间戳转换成需要格式
 *
 *  @param placetime 时间戳
 *  @param format 自定义返回格式（例：YYYY-MM-dd HH:mm:ss）
 */
+(NSString *)timechangeWithTimestamp:(NSString *)placetime WithFormat:(NSString *)format;

#pragma mark - 显示提示框
+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text WihtType:(MBProgressHUDMode)theModel addToView:(UIView *)aView isAutoHidden:(BOOL)hidden;
/**
 *  根据字体大小  宽度  计算字符串高度
 *
 *  @param font   字符大小
 *  @param string 要处理的字符串
 *  @param width  要显示的宽度
 */
+(CGSize)stringHeightWithFont:(UIFont*)font WithString:(NSString*)string WithWidth:(float)width;
/**
 *  统一字体
 *
 *  @param aSize 字体大小
 */
+(UIFont *)returnaFontWith:(CGFloat)aSize;
/**
 *  将手机号码中间四位改为****
 *
 *  @param num 需要转换的手机号码
 */
+(NSString *)returnEncryptionMobileNumWith:(NSString *)num;
/**
 *  改变label某些字体颜色
 *
 *  @param label_str 目标字符串
 *  @param color     颜色
 *  @param range     位置
 */
+(NSMutableAttributedString *)labelTextColorWith:(NSString *)label_str Color:(UIColor *)color range:(NSRange)range;
/**
 *  创建UITextField
*/
+(STextField*)createTextFieldWithFrame:(CGRect)frame font:(float)font placeHolder:(NSString*)placeHolder secureTextEntry:(BOOL)scure;
/**
 *  创建UIButton
 */

+(UIButton*)createButtonWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage*)image;
/**
 *  创建UILabel
 */

+(UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor*)color textAlignment:(NSTextAlignment)textAlignment font:(float)font;
/**
 *  先判断字符串是否为空，不为空返回字符串本身，为空的返回指定的字符串
 *
 *  @param string  目标字符串
 *  @param replace 被替换的字符串
 */
+(NSString*)replaceNullString:(NSString*)string WithReplaceString:(NSString*)replace;

@end















