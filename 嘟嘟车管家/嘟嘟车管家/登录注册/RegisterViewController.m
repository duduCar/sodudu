//
//  RegisterViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/12/2.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController (){
    
}

///用户名
@property(nonatomic,strong)UITextField * user_name_tf;
///密码
@property(nonatomic,strong)UITextField * pass_word_tf;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"注册";
    
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
            [button setTitle:@"注册" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = RGBCOLOR(252, 102, 34);
        }else if (i == 1){
            [button setTitle:@"登录" forState:UIControlStateNormal];
            [button setTitleColor:RGBCOLOR(252, 102, 34) forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
        }
    }
}

#pragma mark ------   注册登录
-(void)buttonClicked:(UIButton*)button{
    if (button.tag == 100)//注册
    {
        [self registerRequest];
    }else if(button.tag == 101)//登录
    {
        
    }
}


#pragma mark _______________  网络请求
-(void)registerRequest{
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
    [[ZAPI manager] sendPost:REGISTER_URL myParams:dic success:^(id data) {
        [loading hide:YES];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:ERROR_CODE] intValue] == 0) {
                [ZTools showMBProgressWithText:@"注册成功" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:NO];
                [[NSUserDefaults standardUserDefaults] setObject:data[@"data"][@"token"] forKey:@"user_id"];
                NSLog(@"uid -----   %@",data[@"data"][@"token"]);
                [wself disappearWithPOP:NO afterDelay:1.5];
            }else{
                [ZTools showMBProgressWithText:[data objectForKey:ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:NO];
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
