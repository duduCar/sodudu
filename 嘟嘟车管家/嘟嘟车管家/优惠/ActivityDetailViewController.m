//
//  ActivityDetailViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/12/8.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "ActivityDetailViewController.h"

@interface ActivityDetailViewController (){
    
}


@property(nonatomic,strong)UIScrollView * myScrollView;

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"优惠活动";
    
    
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    [self.view addSubview:_myScrollView];
    
    
    
    
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
