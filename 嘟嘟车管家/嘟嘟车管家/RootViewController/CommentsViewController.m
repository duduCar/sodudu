//
//  CommentsViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/20.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "CommentsViewController.h"

@interface CommentsViewController ()<UITextViewDelegate,UITextFieldDelegate>{
    UILabel * comment_placeholder_label;
    NSInteger star_rating_count;
    UITextView * comment_tv;
    NSString * user_name;
    NSString * price_string;
}

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_label.text = @"我要评论";
    [self setMyViewControllerRightButtonType:MyViewControllerButtonTypeText WihtRightString:@"提交"];
    self.view.backgroundColor = RGBCOLOR(244, 244, 244);
    star_rating_count = 5;
    user_name = @"搜嘟嘟网友";
    price_string = @"100";
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tap];
    [self setup];
}

-(void)viewTap:(UITapGestureRecognizer*)sender{
    [self.view endEditing:YES];
}
-(void)rightButtonTap:(UIButton *)sender{
    if (comment_tv.text.length == 0) {
        [ZTools showMBProgressWithText:@"请输入评论内容" WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
        return;
    }
    if (user_name.length == 0) {
        user_name = @"搜嘟嘟网友";
    }
    if (price_string.length == 0) {
        price_string = @"100";
    }
    
    MBProgressHUD * load_hud = [ZTools showMBProgressWithText:@"提交中..." WihtType:MBProgressHUDModeIndeterminate addToView:self.view isAutoHidden:NO];
    
    NSDictionary * dic = @{@"shopid":_shop_id,@"username":user_name,@"content":comment_tv.text,@"star":[NSString stringWithFormat:@"%ld",(long)star_rating_count*10],@"price":price_string};
    [[ZAPI manager] sendPost:COMMENTS_URL myParams:dic success:^(id data) {
        [load_hud hide:YES];
        NSLog(@"评论---%@",data);
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            [ZTools showMBProgressWithText:[data objectForKey:@"content"] WihtType:MBProgressHUDModeText addToView:self.view isAutoHidden:YES];
            if ([[data objectForKey:@"status"] intValue] == 0) {
                [self disappearWithPOP:YES afterDelay:2.0f];
            }
            
        }
    } failure:^(NSError *error) {
        [load_hud hide:YES];
    }];
}

-(void)setup{
    //背景1
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    UILabel * dianping_label = [ZTools createLabelWithFrame:CGRectMake(10, 10, 40, 30) text:@"评分:" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight font:15];
    [view1 addSubview:dianping_label];
    
    //星星评价
//    FinalStarRatingBar * star_view = [[FinalStarRatingBar alloc] initWithFrame:CGRectMake(dianping_label.right+10, 15, 200, 20) starCount:5];
//    star_view.rating = 5;
//    star_view.ratingChangedBlock = ^(NSUInteger rating){
//        NSLog(@"rating ----   %lu",(unsigned long)rating);
//        star_rating_count = rating;
//    };
    
    DJWStarRatingView * star_view = [[DJWStarRatingView alloc] initWithStarSize:CGSizeMake(24, 24) numberOfStars:5 rating:5 fillColor:RGBCOLOR(253, 180, 90) unfilledColor:[UIColor clearColor] strokeColor:RGBCOLOR(253, 180, 90)];
    star_view.allowsHalfIntegralRatings = NO;
    star_view.top = 13;
    star_view.left = dianping_label.right+10;
    star_view.editable = YES;
    [star_view ratingChangeBlock:^(float rating) {
        if (rating == 0) {
            star_view.rating = 1;
            return ;
        }
        NSLog(@"我勒个擦 ---------   %f",rating);
        star_rating_count = rating;
    }];
    [view1 addSubview:star_view];
    
    
    //线
    UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0, dianping_label.bottom+10, DEVICE_WIDTH, 0.5)];
    line_view.backgroundColor = RGBCOLOR(204, 204, 204);
    [view1 addSubview:line_view];
    //评价
    comment_tv = [[UITextView alloc] initWithFrame:CGRectMake(0, line_view.bottom, DEVICE_WIDTH, 80)];
    comment_tv.delegate = self;
    comment_tv.returnKeyType = UIReturnKeyDone;
    comment_tv.font = [UIFont systemFontOfSize:13];
    [view1 addSubview:comment_tv];
    view1.height = comment_tv.bottom;
    
    comment_placeholder_label = [ZTools createLabelWithFrame:comment_tv.frame text:@"服务是否专业？价格是否合理？您是否满意？\n（点击此处）" textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentCenter font:13];
    comment_placeholder_label.numberOfLines = 0;
    [view1 addSubview:comment_placeholder_label];
    
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.bottom+10, DEVICE_WIDTH, 50)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    
    NSArray * array1 = @[@"姓名:",@"消费:"];
    NSArray * array2 = @[@"搜嘟嘟网友",@"100"];
    for (int i = 0; i < 2; i++) {
        UILabel * tishi_label = [ZTools createLabelWithFrame:CGRectMake(10+DEVICE_WIDTH/2.0f*i, 10, 40, 30) text:array1[i] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentRight font:13];
        [view2 addSubview:tishi_label];
        
        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(tishi_label.right+5, 10, DEVICE_WIDTH/2.f-30-tishi_label.width, 30)];
        textField.tag = 100+i;
        textField.placeholder = array2[i];
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        textField.font = [UIFont systemFontOfSize:13];
        textField.layer.borderColor = RGBCOLOR(166, 166, 166).CGColor;
        textField.layer.borderWidth = 0.5;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        [view2 addSubview:textField];
        if (i == 1) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
}


#pragma mark --- UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    comment_placeholder_label.hidden = YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        comment_placeholder_label.hidden = NO;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark ----  UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 100)//姓名
    {
        user_name = textField.text;
    }else if (textField.tag == 101)//价格
    {
        price_string = textField.text;
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
