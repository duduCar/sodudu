//
//  SCityPickerView.m
//  嘟嘟车管家
//
//  Created by joinus on 16/1/26.
//  Copyright © 2016年 soulnear. All rights reserved.
//

#import "SCityPickerView.h"

@interface SCityPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSMutableArray * area_array;
    int _flagRow;
    int _flagRow1;
    NSString * s_provance;
    NSString * s_city;
}

@property(nonatomic,strong)UIPickerView * myPickerView;
@property(nonatomic,strong)UIToolbar * myToolbar;

@end

@implementation SCityPickerView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 260);
        s_provance = @"北京市";
        s_city = @"东城区";
        [self setup];
    }
    return self;
}

-(void)setup{
    
    __weak typeof(self)bself = self;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        area_array = [[NSMutableArray alloc] initWithContentsOfFile:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            [bself.myPickerView reloadAllComponents];
        });
    });

    
    _myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, DEVICE_WIDTH, 216)];
    _myPickerView.dataSource = self;
    _myPickerView.delegate = self;
    [self addSubview:_myPickerView];
    
    _myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
    [self addSubview:_myToolbar];
    
    UIBarButtonItem * cancel_button = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked)];
    UIBarButtonItem * space_button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * done_button = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClicked)];

    [_myToolbar setItems:@[cancel_button,space_button,done_button]];
}


-(void)returnAreaWithBlock:(SCityPickerViewBlock)block{
    cityPickerViewBlock = block;
}
#pragma mark - 取消
-(void)cancelButtonClicked{
    [self pickerShow:NO];
}
#pragma mark -- 选中
-(void)doneButtonClicked{
    [self pickerShow:NO];
    cityPickerViewBlock(s_provance,s_city);
}

#pragma mark ---  弹出消失视图
-(void)pickerShow:(BOOL)show{
    [UIView animateWithDuration:0.35 animations:^{
        self.top = DEVICE_HEIGHT - (show?self.height:0);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark --------   UIPickerViewDelegate ------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return area_array.count;
        
    } else if (component == 1) {
        NSArray * cities = area_array[_flagRow][@"Cities"];
        return cities.count;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0)
    {
        return area_array[row][@"State"];
        
    } else if (component == 1)
    {
        NSString * _str2 = area_array[_flagRow][@"Cities"][row][@"city"];
        
        return _str2;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _flagRow = (int)row;
        [pickerView selectRow:0 inComponent:1 animated:YES];
        _flagRow1 = 0;
    } else if (component == 1)
    {
        _flagRow1 = (int)row;
    }
    
    s_provance = area_array[_flagRow][@"State"];
    
    if ([area_array[_flagRow][@"Cities"] count] > _flagRow1) {
        NSString * city = area_array[_flagRow][@"Cities"][_flagRow1][@"city"];
        if ([city isEqualToString:@"市区县"]) {
            city = @"";
        }
        s_city = city;
    }else{
        s_city = @"";
    }
    
    [pickerView reloadAllComponents];
}


@end





