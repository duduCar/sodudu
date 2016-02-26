//
//  SDDMineCommentsViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 16/1/25.
//  Copyright © 2016年 soulnear. All rights reserved.
//

#import "SDDMineCommentsViewController.h"
#import "SDDCommentsModel.h"
#import "SDDCommentsTableViewCell.h"
#import "SellerDetailViewController.h"

@interface SDDMineCommentsViewController ()<SNRefreshDelegate,UITableViewDataSource>{
    
}

@property(nonatomic,strong)SNRefreshTableView * myTableView;
@property(nonatomic,strong)NSMutableArray * data_array;

@end

@implementation SDDMineCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"我的评论";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"删除"];
    
    _data_array = [NSMutableArray array];
    
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    [self loadMineComments];
}

-(void)rightButtonTap:(UIButton *)sender{
    
}

#pragma mark ----  网络请求
-(void)loadMineComments{
    //张少南
    NSDictionary * dic = @{@"token":[ZTools getUID]};
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:GET_USER_COMMENTS_URL myParams:dic success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if (wself.myTableView.pageNum == 1) {
                wself.myTableView.isHaveMoreData = YES;
                [wself.data_array removeAllObjects];
            }
            if ([data[ERROR_CODE] intValue] == 0) {
                NSArray * array = [[data objectForKey:@"data"] objectForKey:@"commentlist"];
                if (array && [array isKindOfClass:[NSArray class]]) {
                    if (array.count == 0) {
                        wself.myTableView.isHaveMoreData = NO;
                    }
                    for (NSDictionary * item in array) {
                        SDDCommentsModel * model = [[SDDCommentsModel alloc] initWithDictionary:item];
                        [wself.data_array addObject:model];
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

#pragma mark ------  UITableViewdataSource ----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    SDDCommentsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SDDCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell setInfomationWithCommentsModel:_data_array[indexPath.row]];
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //这里执行删除操作
    }
}

#pragma mark --------  SNRefreshTableViewDelegate
- (void)loadNewData{
    [self loadMineComments];
}
- (void)loadMoreData{
    [self loadMineComments];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    SDDCommentsModel * model = _data_array[indexPath.row];
    SellerDetailViewController * detailVC = [[SellerDetailViewController alloc] init];
    detailVC.shop_id = model.shopid;
    [self pushToViewController:detailVC withAnimation:YES];
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    SDDCommentsModel * model = _data_array[indexPath.row];
    CGSize content_size = [ZTools stringHeightWithFont:[UIFont systemFontOfSize:13] WithString:model.content WithWidth:DEVICE_WIDTH-20];
    return 65 + content_size.height;
}

-(UITableViewCellEditingStyle)refreshtableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
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
