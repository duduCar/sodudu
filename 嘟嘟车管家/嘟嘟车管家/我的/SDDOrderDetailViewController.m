//
//  SDDOrderDetailViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 16/1/26.
//  Copyright © 2016年 soulnear. All rights reserved.
//

#import "SDDOrderDetailViewController.h"

@interface SDDOrderDetailViewController ()

@end

@implementation SDDOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"订单详情";
    
    
}

#pragma mark ------  网络请求
-(void)getOrderInfo{
    NSDictionary * dic = @{@"id":_order_id,@"token":[ZTools getUID]};
    [[ZAPI manager] sendPost:GET_USER_ORDER_INFO_URL myParams:dic success:^(id data) {
        
    } failure:^(NSError *error) {
        
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
