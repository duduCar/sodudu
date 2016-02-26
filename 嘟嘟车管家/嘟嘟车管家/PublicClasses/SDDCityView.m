//
//  SDDCityView.m
//  嘟嘟车管家
//
//  Created by joinus on 15/10/18.
//  Copyright (c) 2015年 soulnear. All rights reserved.
//

#import "SDDCityView.h"
#import "CityInfo.h"


@interface SDDCityView ()<UITableViewDataSource,UITableViewDelegate>{
    
}

@property(nonatomic,strong)UITableView * myTableView;
///索引
@property(nonatomic,strong)NSMutableArray * indexes_array;

@property(nonatomic,strong)NSMutableArray * section_array;

@end

@implementation SDDCityView

-(id)initWithFrame:(CGRect)frame WithLocal:(NSString*)location WithOther:(NSMutableArray*)other{
    self = [super initWithFrame:frame];
    if (self) {
        _location_city = location;
        _city_array = [NSMutableArray arrayWithArray:other];
        
        [self setup];
    }
    return self;
}
-(void)setup{
    
    _section_array = [NSMutableArray array];
    _indexes_array = [NSMutableArray array];

    for (CityInfo * info in _city_array) {
        ///索引字母
        NSString * section_title = [info.listname substringToIndex:1];
        if (![_indexes_array containsObject:section_title]) {
            [_indexes_array addObject:section_title];
        }
    }
    
    [_indexes_array sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    for (int i = 0; i < _indexes_array.count; i++) {
        NSString * title = _indexes_array[i];
        NSMutableArray * array = [NSMutableArray array];
        for (CityInfo * info in _city_array) {
            NSString * section_title = [info.listname substringToIndex:1];

            if ([title isEqualToString:section_title]) {
                [array addObject:info];
            }
        }
        [_section_array addObject:array];
    }
    
    
    self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64);
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    _myTableView.backgroundColor = RGBCOLOR(245, 245, 245);
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_myTableView];
}

-(void)selectedCity:(SDDCityViewBlock)block{
    myBlock = block;
}

-(void)setLocal:(NSString*)local Cities:(NSMutableArray*)citys{
    _location_city = local;
    _city_array = [NSMutableArray arrayWithArray:citys];
    for (CityInfo * model in citys) {
        if ([model.name isEqualToString:_location_city]) {
            int index = (int)[citys indexOfObject:model];
            [_city_array removeObjectAtIndex:index];
        }
    }
    [_myTableView reloadData];
}


#pragma mark ------  UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _indexes_array.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return [_section_array[section-1] count];
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.section == 0) {
        cell.textLabel.text = _location_city;
    }else{
        CityInfo * model = _section_array[indexPath.section-1][indexPath.row];
        cell.textLabel.text = model.name;
    }
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * section_label = [ZTools createLabelWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 40) text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:15];
    section_label.backgroundColor = RGBCOLOR(245, 245, 245);
    if (section == 0) {
        section_label.text = [NSString stringWithFormat:@"  %@",@"当前定位城市"];
    }else{
        section_label.text = [NSString stringWithFormat:@"  %@",_indexes_array[section-1]];
    }
    
    return section_label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.section == 0) {
        myBlock(_location_city,@"");
    }else{
        CityInfo * model = [[_section_array objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row];
        myBlock(model.name,model.id);
    }
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [NSArray arrayWithArray:_indexes_array];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
