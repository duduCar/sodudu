//
//  CarBrandViewController.m
//  嘟嘟车管家
//
//  Created by joinus on 16/1/19.
//  Copyright © 2016年 soulnear. All rights reserved.
//

#import "CarBrandViewController.h"
#import "CarBrandModel.h"

@interface CarBrandViewController (){
    
}

@property(nonatomic,strong)NSMutableArray * brand_array;

@end

@implementation CarBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title_label.text = @"品牌";
    
    _brand_array = [NSMutableArray array];
    
    
    [self loadCarBrandData];
}

-(void)loadCarBrandData{
    __weak typeof(self) wself = self;
    [[ZAPI manager] sendGet:GET_CAR_BRAND_URL success:^(id data) {
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSArray * brand_array = [[data objectForKey:@"data"] objectForKey:@"carbrand"];
            if (brand_array && [brand_array isKindOfClass:[NSArray class]]) {
                for (NSDictionary * item in brand_array) {
                    CarBrandModel * model = [[CarBrandModel alloc] initWithDictionary:item];
                    [wself.brand_array addObject:model];
                }
            }
        }
    } failure:^(NSError *error) {
        
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
