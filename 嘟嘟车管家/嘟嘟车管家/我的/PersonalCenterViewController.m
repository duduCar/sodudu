//
//  PersonalCenterViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/12/1.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalModel.h"
#import "PersonalDetailViewController.h"
#import "SDDMineOrderViewController.h"
#import "SDDMineCommentsViewController.h"

#define MINE_INFOMATION @""

#define MINE_ORDER @"我的订单"
#define MINE_COMMENTS @"我的评论"

#define MINE_FEEDBACK @"意见反馈"
#define MINE_ABOUT @"关于我们"

#define MINE_LOGOUT @"退出"


@interface PersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate>{
    ///头视图
    UIView * header_view;
    ///用户头像
    UIImageView * header_imageView;
    //用户名
    UILabel * user_name_label;
    ///用户所选车型
    UILabel * user_car_type_label;
}

@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)NSArray * data_array;

@property(nonatomic,strong)NSArray * image_array;
/**
 *  用户信息
 */
@property(nonatomic,strong)PersonalModel * personal_info;
@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"我的";
    self.view.backgroundColor = DEFAULT_GRAY_BACKGROUND_COLOR;
    
    _data_array = @[@"",MINE_ORDER,MINE_COMMENTS,@"",MINE_FEEDBACK,MINE_ABOUT];
    _image_array = @[@"",@"iconfont_dingdan",@"iconfont_pinglun",@"",@"iconfont_yijianfankui",@"iconfont_guanyu"];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64-44) style:UITableViewStylePlain];
    _myTableView.backgroundColor = DEFAULT_GRAY_BACKGROUND_COLOR;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _myTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_myTableView];
    
    [self createSectionView];
    if ([ZTools isLogin]) {
        [self loadUserInfomation];
    }
}
#pragma mark -----   网络请求
-(void)loadUserInfomation{
    if (![ZTools isLogin]) {
        return;
    }
    __weak typeof(self)wself = self;
    [[ZAPI manager] sendPost:GET_USER_INFOMATION_URL myParams:@{@"token":[ZTools getUID]} success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([[data objectForKey:ERROR_CODE] intValue] == 0) {
                wself.personal_info = [[PersonalModel alloc] initWithDictionary:data[@"data"][@"userinfo"]];
                [wself createSectionView];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -----    创建头图
-(void)createSectionView{
    if (!header_view) {
        header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 60)];
        header_view.backgroundColor = [UIColor whiteColor];
        _myTableView.tableHeaderView = header_view;
        
        UITapGestureRecognizer * user_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfoDetailViewController:)];
        [header_view addGestureRecognizer:user_tap];
        
        header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, header_view.height-10, header_view.height-10)];
        [header_view addSubview:header_imageView];
        
        //用户名
        user_name_label = [ZTools createLabelWithFrame:CGRectMake(header_imageView.right+10, 5, DEVICE_WIDTH-header_imageView.right-15, 20) text:@"越野大笨牛" textColor:RGBCOLOR(3, 3, 3) textAlignment:NSTextAlignmentLeft font:15];
        [header_view addSubview:user_name_label];
        //用户车型
        user_car_type_label = [ZTools createLabelWithFrame:CGRectMake(header_imageView.right+10, user_name_label.bottom+5, DEVICE_WIDTH-header_imageView.right-15, 20) text:@"奥迪（进口）-奥迪A8" textColor:RGBCOLOR(189, 189, 189) textAlignment:NSTextAlignmentLeft font:13];
        [header_view addSubview:user_car_type_label];
        
        header_imageView.backgroundColor = [UIColor redColor];
        
        UIButton * arrow_button = [UIButton buttonWithType:UIButtonTypeCustom];
        arrow_button.frame = CGRectMake(DEVICE_WIDTH-30, 15, 20, 20);
        [arrow_button setImage:[UIImage imageNamed:@"arrow_right_image"] forState:UIControlStateNormal];
        [header_view addSubview:arrow_button];
    }
    
    if (![ZTools isLogin]) {
        user_name_label.text = @"点击登录";
        user_car_type_label.text = @"未设置车型";
    }else{
        user_name_label.text = _personal_info.username;
        user_car_type_label.text = _personal_info.carinfo;
    }
}

#pragma mark ---------  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * title = _data_array[indexPath.row];
    if (title.length) {
        return 44;
    }else{
        return 20;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString * title = _data_array[indexPath.row];
    NSString * image_name = _image_array[indexPath.row];
    
    if (title.length) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = title;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.imageView.image = [UIImage imageNamed:image_name];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.backgroundColor = RGBCOLOR(242, 242, 242);
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * title = _data_array[indexPath.row];
    if ([title isEqualToString:MINE_ORDER]) {
        SDDMineOrderViewController * orderVC = [[SDDMineOrderViewController alloc] init];
        [self pushToViewController:orderVC withAnimation:YES];
    }else if ([title isEqualToString:MINE_COMMENTS]){
        SDDMineCommentsViewController * commentsVC = [[SDDMineCommentsViewController alloc] init];
        [self pushToViewController:commentsVC withAnimation:YES];
    }else if ([title isEqualToString:MINE_FEEDBACK]){
        [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
    }else if ([title isEqualToString:MINE_ABOUT]){
        
    }
}
#pragma mark ------   跳转到用户信息详情页面
-(void)showUserInfoDetailViewController:(UITapGestureRecognizer*)sender{
    if ([ZTools isLogin]) {
        PersonalDetailViewController * detail = [[PersonalDetailViewController alloc] init];
        [self pushToViewController:detail withAnimation:YES];
    }else{
        [self login];
    }
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
