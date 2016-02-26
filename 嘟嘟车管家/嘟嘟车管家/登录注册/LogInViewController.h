//
//  LogInViewController.h
//  嘟嘟车管家
//
//  Created by joinus on 15/11/30.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "MyViewController.h"

#define LOGIN_QQ @"QQ"
#define LOGIN_WECHAT @"微信"
#define LOGIN_SINA @"新浪"

@interface LogInViewController : MyViewController{
    
}

+ (LogInViewController *)sharedManager;//单例模式

@end
