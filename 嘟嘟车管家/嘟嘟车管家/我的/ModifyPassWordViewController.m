//
//  ModifyPassWordViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 16/1/19.
//  Copyright © 2016年 soulnear. All rights reserved.
//

#import "ModifyPassWordViewController.h"

@interface ModifyPassWordViewController (){
    /**
     *  旧密码
     */
    STextField * old_pw_tf;
    /**
     *  新密码
     */
    STextField * new_pw_tf;
    /**
     *  重复新密码
     */
    STextField * again_new_pw_tf;
}

@end

@implementation ModifyPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"修改密码";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"提交"];
    
    old_pw_tf = [ZTools createTextFieldWithFrame:CGRectMake(20, 30, DEVICE_WIDTH-40, 35) font:15 placeHolder:@"请输入原始密码" secureTextEntry:YES];
    
    new_pw_tf = [ZTools createTextFieldWithFrame:CGRectMake(20, old_pw_tf.bottom+10, DEVICE_WIDTH-40, 35) font:15 placeHolder:@"请输入新密码" secureTextEntry:YES];
    
    again_new_pw_tf = [ZTools createTextFieldWithFrame:CGRectMake(20, new_pw_tf.bottom+10, DEVICE_WIDTH-40, 35) font:15 placeHolder:@"请再次输入新密码" secureTextEntry:YES];
    
    [self.view addSubview:old_pw_tf];
    [self.view addSubview:new_pw_tf];
    [self.view addSubview:again_new_pw_tf];
    
}
-(void)rightButtonTap:(UIButton *)sender{
    if (old_pw_tf.text.length == 0) {
        [ZTools showMBProgressWithText:@"原始密码不能为空" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }else if (new_pw_tf.text.length == 0) {
        [ZTools showMBProgressWithText:@"新密码不能为空" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }else if (again_new_pw_tf.text.length == 0) {
        [ZTools showMBProgressWithText:@"请确认新密码" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }else if (![new_pw_tf.text isEqualToString:again_new_pw_tf.text]){
        [ZTools showMBProgressWithText:@"输入的新密码不一致" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    
    [self startLoading];
    
    __weak typeof(self)wself = self;
    NSDictionary * dic = @{@"oldpassword":old_pw_tf.text,@"password":new_pw_tf.text,@"token":[ZTools getUID]};
    [[ZAPI manager] sendPost:MODIFY_PASSWORD_URL myParams:dic success:^(id data) {
        [wself endLoading];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[ERROR_CODE] intValue] == 0) {
                [wself.navigationController popViewControllerAnimated:YES];
            }else{
                [ZTools showMBProgressWithText:data[ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
    } failure:^(NSError *error) {
        [wself endLoading];
        [ZTools showMBProgressWithText:@"修改失败" WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
