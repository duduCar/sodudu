//
//  SDDMineOrderViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 16/1/19.
//  Copyright © 2016年 soulnear. All rights reserved.
//

#import "SDDMineOrderViewController.h"
#import "SDDOrderModel.h"
#import "SDDOrderTableViewCell.h"
#import "SDDOrderDetailViewController.h"

@interface SDDMineOrderViewController ()<SNRefreshDelegate,UITableViewDataSource>{
    
}


@property(nonatomic,strong)NSMutableArray * order_array;
@property(nonatomic,strong)SNRefreshTableView * myTableView;
@end

@implementation SDDMineOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"我的订单";
    
    _order_array = [NSMutableArray array];
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
//    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
    [self loadOrderListData];
}
#pragma mark --------   网络请求
-(void)loadOrderListData{
    __weak typeof(self)wself = self;
    NSDictionary * dic = @{@"token":[ZTools getUID]};
    [[ZAPI manager] sendPost:GET_USER_ORDER_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if (wself.myTableView.pageNum == 1) {
                wself.myTableView.isHaveMoreData = YES;
                [wself.order_array removeAllObjects];
            }
            if ([data[ERROR_CODE] intValue] == 0) {
                NSArray * order_array = data[@"data"][@"orderlist"];
                if (order_array && [order_array isKindOfClass:[NSArray class]]) {
                    for (NSDictionary * obj in order_array) {
                        SDDOrderModel * model = [[SDDOrderModel alloc] initWithDictionary:obj];
                        [wself.order_array addObject:model];
                    }
                    
                    if (order_array.count == 0) {
                        wself.myTableView.isHaveMoreData = NO;
                    }
                }
            }else{
                [ZTools showMBProgressWithText:[data objectForKey:ERROR_INFO] WihtType:MBProgressHUDModeText addToView:wself.view isAutoHidden:YES];
            }
        }
        [wself.myTableView finishReloadigData];

    } failure:^(NSError *error) {
        
    }];
}
#pragma mark —————————————————UITableView—————————————————————————
- (void)loadNewData{
    [self loadOrderListData];
}
- (void)loadMoreData{
    [self loadOrderListData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    SDDOrderModel * model = _order_array[indexPath.row];
    SDDOrderDetailViewController * detail = [[SDDOrderDetailViewController alloc] init];
    detail.order_id = model.id;
    [self pushToViewController:detail withAnimation:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _order_array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    SDDOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SDDOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setInfomationWithOrderModel:_order_array[indexPath.row]];
    
    return cell;
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
