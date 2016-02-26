//
//  MyWebViewController.m
//  推盟
//
//  Created by joinus on 15/8/11.
//  Copyright (c) 2015年 joinus. All rights reserved.
//

#import "MyWebViewController.h"

@interface MyWebViewController ()<UIWebViewDelegate>
{
    
}

@property(nonatomic,strong)UIWebView * myWebView;

@end

@implementation MyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = _title_string;
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64)];
    _myWebView.delegate = self;
    _myWebView.scalesPageToFit = YES;
    [self.view addSubview:_myWebView];
    
    [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_myURL]]];
    
    [self startLoading];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self endLoading];
    if (_title_string.length== 0 || [_title_string isKindOfClass:[NSArray class]]) {
        self.title_label.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self endLoading];
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
