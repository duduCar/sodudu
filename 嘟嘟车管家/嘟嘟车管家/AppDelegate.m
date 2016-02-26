//
//  AppDelegate.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/21.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "ServiceViewController.h"
#import "PreferentialActivitiesViewController.h"
#import "PersonalCenterViewController.h"
#import "SellerListViewController.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define UMENG_KEY @"5632312b67e58eee52002d64"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    ///高德地图
    [MAMapServices sharedServices].apiKey = @"8495b9c6c03000bdd8da2d91c52ebee9";
    
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"CoreData2.sqlite"];    
    
    [MobClick setLogEnabled:YES];
    
    //友盟
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:@"Web"];
    [UMessage startWithAppkey:UMENG_KEY launchOptions:launchOptions];
    [UMFeedback setAppkey:UMENG_KEY];
    [UMSocialData setAppKey:UMENG_KEY];
    //微信
    [UMSocialWechatHandler setWXAppId:@"wxd284cc789b8ca1c2" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:WEBSITE];
    //新浪
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //qq
    [UMSocialQQHandler setQQWithAppId:@"1104953288" appKey:@"hVZ9KPhNgbGUBH6M" url:WEBSITE];
    
    [self registerForRemoteNotification];
    
    
    
    
    /*加底部导航
     RootViewController * rootVC = [[RootViewController alloc] init];
    rootVC.tabBarItem.title=@"首页";
    rootVC.tabBarItem.image=[UIImage imageNamed:@"iconfont_unselected_shouye"];
    UINavigationController * navc1 = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    
    SellerListViewController * serviceVC=[[SellerListViewController alloc]init];
    serviceVC.tabBarItem.title=@"服务";
    serviceVC.column_id = @"2828";
    serviceVC.tabBarItem.image=[UIImage imageNamed:@"iconfont_unselected_qiche"];
    UINavigationController * navc2 = [[UINavigationController alloc] initWithRootViewController:serviceVC];

    
    PreferentialActivitiesViewController * ActivityVC=[[PreferentialActivitiesViewController alloc]init];
    ActivityVC.tabBarItem.title=@"优惠";
    ActivityVC.tabBarItem.image=[UIImage imageNamed:@"iconfont_unselected_youhui"];
    UINavigationController * navc3 = [[UINavigationController alloc] initWithRootViewController:ActivityVC];

    
    PersonalCenterViewController * personalVC=[[PersonalCenterViewController alloc]init];
    personalVC.tabBarItem.title=@"我的";
    personalVC.tabBarItem.image=[UIImage imageNamed:@"iconfont_unselected_wode"];
    UINavigationController * navc4 = [[UINavigationController alloc] initWithRootViewController:personalVC];

    
    UITabBarController *tb=[[UITabBarController alloc]init];
    //设置控制器为Window的根控制器
    tb.viewControllers = @[navc1,navc2,navc3,navc4];
    tb.tabBar.tintColor = RGBCOLOR(252, 102, 34);
    self.window.rootViewController=tb;
    */
    
    //不加底部导航
     RootViewController * rootVC = [[RootViewController alloc] init];
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = navc;
    

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)registerForRemoteNotification {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
#endif
    //for log
    [UMessage setLogEnabled:YES];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *string_pushtoken=[NSString stringWithFormat:@"%@",deviceToken];
    
    while ([string_pushtoken rangeOfString:@"<"].length||[string_pushtoken rangeOfString:@">"].length||[string_pushtoken rangeOfString:@" "].length) {
        string_pushtoken=[string_pushtoken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        string_pushtoken=[string_pushtoken stringByReplacingOccurrencesOfString:@">" withString:@""];
        string_pushtoken=[string_pushtoken stringByReplacingOccurrencesOfString:@" " withString:@""];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:string_pushtoken forKey:@"devicePushToken"];
    NSLog(@"deviceToken ----   %@",string_pushtoken);
    [UMessage registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}



- (void)applicationWillResignActive:(UIApplication *)application {

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}


@end
