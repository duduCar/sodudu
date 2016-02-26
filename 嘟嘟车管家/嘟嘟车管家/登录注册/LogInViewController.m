//
//  LogInViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/11/30.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "LogInViewController.h"
#import "RegisterViewController.h"

@interface LogInViewController(){
    
}
///用户名
@property(nonatomic,strong)UITextField * user_name_tf;
///密码
@property(nonatomic,strong)UITextField * pass_word_tf;

@end



@implementation LogInViewController

+ (LogInViewController *)sharedManager
{
    static LogInViewController *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"登录";
    self.view.backgroundColor = RGBCOLOR(240, 240, 240);
    
    [self setMyViewControllerLeftButtonType:MyViewControllerButtonTypeText WihtLeftString:@"关闭"];
    
    _user_name_tf = [ZTools createTextFieldWithFrame:CGRectMake(15, 30, DEVICE_WIDTH-30, 35) font:15 placeHolder:@"请输入手机号/用户名" secureTextEntry:NO];
    [self.view addSubview:_user_name_tf];
    
    _pass_word_tf = [ZTools createTextFieldWithFrame:CGRectMake(15, _user_name_tf.bottom+15, DEVICE_WIDTH-30, 35) font:15 placeHolder:@"请输入密码" secureTextEntry:YES];
    [self.view addSubview:_pass_word_tf];
    
    for (int i = 0; i < 2; i++) {
        UIButton * button = [ZTools createButtonWithFrame:CGRectMake(15, _pass_word_tf.bottom+30 + 50*i, DEVICE_WIDTH-30, 35) title:@"" image:nil];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        if (i == 0) {
            [button setTitle:@"登录" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = RGBCOLOR(252, 102, 34);
        }else if (i == 1){
            [button setTitle:@"注册" forState:UIControlStateNormal];
            [button setTitleColor:RGBCOLOR(252, 102, 34) forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
        }
    }
    
    /*第三方登录*/
    UILabel * prompt_label = [ZTools createLabelWithFrame:CGRectMake(15, 270, DEVICE_WIDTH-30, 20) text:@"可以使用以下方式登录" textColor:RGBCOLOR(3, 3, 3) textAlignment:NSTextAlignmentCenter font:15];
    [self.view addSubview:prompt_label];
    
    NSArray * title_array = @[LOGIN_QQ,LOGIN_WECHAT,LOGIN_SINA];
    for (int i = 0; i < 3; i++) {
        UIButton * button = [ZTools createButtonWithFrame:CGRectMake(20 + 60*i, prompt_label.bottom + 10, 50, 30) title:title_array[i] image:nil];
        button.tag = 100 + i;
        button.backgroundColor = [UIColor blackColor];
        [button addTarget:self action:@selector(thirdPartyLogInClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)leftButtonTap:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)thirdPartyLogInClicked:(UIButton *)button{
    NSString * snsName;
    switch (button.tag-100) {
        case 0:
        {
            snsName = UMShareToQQ;
        }
            break;
        case 1:
        {
            snsName = UMShareToWechatSession;
        }
            break;
        case 2:
        {
            snsName = UMShareToSina;
        }
            break;
            
        default:
            break;
    }
    
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsName];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:snsAccount.userName message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            [[UMSocialDataService defaultDataService] requestSnsInformation:snsName  completion:^(UMSocialResponseEntity *response){
                NSLog(@"SnsInformation is %@",response.data);
            }];
        }});
}


#pragma mark -----   登录注册按钮
-(void)buttonClicked:(UIButton *)button{
    if (button.tag == 100)//登录
    {
        [self logInRequest];
    }else if (button.tag == 101)//注册
    {
        RegisterViewController * registerVC = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
}



#pragma mark --------   网络请求
-(void)logInRequest{
    if (_user_name_tf.text.length == 0) {
        [ZTools showMBProgressWithText:@"请输入用户名" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }else if (_pass_word_tf.text.length == 0){
        [ZTools showMBProgressWithText:@"请输入密码" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    
    MBProgressHUD * loading = [ZTools showMBProgressWithText:@"请求中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    NSDictionary * dic = @{@"username":_user_name_tf.text,@"password":_pass_word_tf.text};
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:LOGIN_URL myParams:dic success:^(id data) {
        [loading hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:ERROR_CODE] intValue] == 0) {
                [[NSUserDefaults standardUserDefaults] setObject:data[@"data"][@"token"] forKey:@"user_id"];
                [[NSUserDefaults standardUserDefaults] setObject:wself.user_name_tf.text forKey:USER_NAME];
                [wself dismissViewControllerAnimated:YES completion:nil];
            }else{
                [ZTools showMBProgressWithText:[data objectForKey:ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
    } failure:^(NSError *error) {
        [loading hide:YES];
        [ZTools showMBProgressWithText:@"登录失败，请重试" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
