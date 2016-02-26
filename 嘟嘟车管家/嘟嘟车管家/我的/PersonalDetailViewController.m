//
//  PersonalDetailViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/12/28.
//  Copyright © 2015年 soulnear. All rights reserved.
//

#import "PersonalDetailViewController.h"
#import "ModifyPassWordViewController.h"
#import "SCityPickerView.h"
#import "SAlertView.h"
#import "CarBrandViewController.h"


#define TITLE_INFO @"info"
#define TITLE_CAR_TYPE @"车型"
#define TITLE_MOBILE @"手机号"
#define TITLE_AREA @"地区"
#define TITLE_PASSWORD @"修改密码"


@interface PersonalDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SAlertViewDelegate>{
    UIView * header_view;
    UIImageView * header_imageView;
    UILabel * user_name_label;
    
    
    
    NSString * city_string;
    
    SCityPickerView * city_pickerView;
    
    SAlertView * alertView;
    UITextField * mobile_tf;
}

@property(nonatomic,strong)UITableView * myTableView;
//栏目数据
@property(nonatomic,strong)NSArray * title_array;

@end

@implementation PersonalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _title_array = @[@"",TITLE_CAR_TYPE,TITLE_MOBILE,TITLE_AREA,@"",TITLE_PASSWORD];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
    _myTableView.backgroundColor = DEFAULT_GRAY_BACKGROUND_COLOR;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_myTableView];
    
    [self createSectionView];
}

-(void)createSectionView{
    if (!header_imageView) {
        header_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 70)];
        header_view.backgroundColor = [UIColor whiteColor];
        _myTableView.tableHeaderView = header_view;
        
        header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        [header_view addSubview:header_imageView];
        
        user_name_label = [[UILabel alloc] initWithFrame:CGRectMake(header_imageView.right+5, 15, DEVICE_WIDTH-header_imageView.right - 60, 30)];
        user_name_label.text = [ZTools getUserName];
        user_name_label.font = [UIFont systemFontOfSize:16];
        user_name_label.adjustsFontSizeToFitWidth = YES;
        [header_imageView addSubview:user_name_label];
        
        UIButton * arrow_button = [UIButton buttonWithType:UIButtonTypeCustom];
        arrow_button.userInteractionEnabled = NO;
        arrow_button.frame = CGRectMake(DEVICE_WIDTH-30, 20, 20, 30);
        [arrow_button setImage:[UIImage imageNamed:@"arrow_right_image"] forState:UIControlStateNormal];
        [header_view addSubview:arrow_button];
    }
   
    header_imageView.backgroundColor = [UIColor redColor];
    user_name_label.text = @"越野大笨牛";
}

#pragma mark ------   UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _title_array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * title = _title_array[indexPath.row];
    if ([title isEqualToString:TITLE_INFO]) {
        return 80;
    }else if (title.length==0){
        return 10;
    }else{
        return 40;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSString * title = _title_array[indexPath.row];
    cell.textLabel.text = title;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([title isEqualToString:TITLE_CAR_TYPE]){
        
    }else if ([title isEqualToString:TITLE_MOBILE]){
        cell.detailTextLabel.text = @"186****5163";
    }else if ([title isEqualToString:TITLE_AREA]){
        cell.detailTextLabel.text = city_string;
    }else if (title.length == 0){
        cell.backgroundColor = DEFAULT_GRAY_BACKGROUND_COLOR;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * title = _title_array[indexPath.row];

    if ([title isEqualToString:TITLE_INFO]) {
        
    }else if ([title isEqualToString:TITLE_CAR_TYPE]){
        CarBrandViewController * carVC = [[CarBrandViewController alloc] init];
        [self pushToViewController:carVC withAnimation:YES];
    }else if ([title isEqualToString:TITLE_MOBILE]){
        [self showAlertViewForMobileInput];
    }else if ([title isEqualToString:TITLE_AREA]){
        [self chooseCity];
    }else if ([title isEqualToString:TITLE_PASSWORD]){
        ModifyPassWordViewController * modify = [[ModifyPassWordViewController alloc] init];
        [self pushToViewController:modify withAnimation:YES];
    }
}

#pragma mark ------  弹出输入手机号码框
-(void)showAlertViewForMobileInput{
    alertView = [[SAlertView alloc] initWithTitle:@"提示" WithContentView:nil WithCancelTitle:@"取消" WithDoneTitle:@"确认"];
    alertView.delegate = self;
    [alertView alertShow];
    
    
    mobile_tf = [ZTools createTextFieldWithFrame:CGRectMake(10, 50, alertView.contentView.width-20, 30) font:14 placeHolder:@"请输入手机号码" secureTextEntry:NO];
    mobile_tf.keyboardType = UIKeyboardTypeNumberPad;
    alertView.contentView = mobile_tf;
}

#pragma mark --------  SAlertViewDelegate
-(void)cancelButtonClicked:(UIButton*)sender{
    
}
-(void)doneButtonClicked:(UIButton*)sender{
    if (mobile_tf.text.length != 11) {
        [ZTools showMBProgressWithText:@"请输入正确的手机号码" WihtType:MBProgressHUDModeText addToView:[UIApplication sharedApplication].keyWindow isAutoHidden:YES];
        return;
    }
}

#pragma mark ---- UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField  resignFirstResponder];
    return YES;
}


#pragma mark ___________  选择地区
-(void)chooseCity{
    if (!city_pickerView) {
        city_pickerView = [[SCityPickerView alloc] init];
        [self.view addSubview:city_pickerView];
    }
    
    [city_pickerView pickerShow:YES];
    
    __weak typeof(self)wself = self;
    [city_pickerView returnAreaWithBlock:^(NSString *province, NSString *city) {
        city_string = [NSString stringWithFormat:@"%@ %@",province,city];
        [wself.myTableView reloadData];
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
