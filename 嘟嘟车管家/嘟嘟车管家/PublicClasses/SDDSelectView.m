//
//  SDDSelectView.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/20.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "SDDSelectView.h"
#import "CityModel.h"

@interface SDDSelectView ()<UITableViewDataSource,UITableViewDelegate>{
    
}

@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)NSMutableArray * data_array;
@end

@implementation SDDSelectView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self setup];
    }
    
    return self;
}

-(void)setup{
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 0) style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_myTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data_array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = _data_array[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (sdd_column_block) {

        sdd_column_block(_data_array[indexPath.row]);
    }
}

-(void)setType:(int)type{
    _data_array = [NSMutableArray array];
    switch (type) {
        case 0:
        {
            NSArray * array = [CityInfo MR_findAll];
            for (CityInfo * info in array) {
                [_data_array addObject:info.listname];
            }
        }
            break;
        case 1:
        {
            [_data_array addObjectsFromArray:@[@"洗车",@"维修保养",@"配件车饰",@"汽车美容",@"汽车保险",@"4S店",@"汽车租赁"]];
        }
            break;
        case 2:
        {
            [_data_array addObjectsFromArray:@[@"综合",@"评论",@"附近"]];
        }
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.height = _data_array.count*44;
        if (_data_array.count*44 > DEVICE_HEIGHT-64-44) {
            self.height = DEVICE_HEIGHT - 64 - 44;
        }
        _myTableView.height = self.height;
    } completion:^(BOOL finished) {
        
    }];
    
    [_myTableView reloadData];
}

-(void)selectedColumn:(SDDSelectViewBlock)block{
    sdd_column_block = block;
}

-(NSString*)findCityNameWithListName:(NSString*)listname{
    NSArray * array = [CityInfo MR_findByAttribute:@"listname" withValue:listname];
    if (array.count) {
        CityInfo * info = [array objectAtIndex:0];
        return info.name;
    }else{
        return @"";
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
