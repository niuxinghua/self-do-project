//
//  UserMangeMentTableViewCell.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "UserMangeMentTableViewCell.h"
#import "Const.h"
@interface UserMangeMentTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UILabel *nameLable;

@property (nonatomic,strong)UILabel *accountLable;

@property (nonatomic,strong)UILabel *rightLable;

@property (nonatomic,strong)UILabel *timeLable;

@property (nonatomic,strong)UIView *lineView;

@property (nonatomic,strong)UIImageView *iconImageView;


@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataList;

@property (nonatomic,strong)UIButton *modifyButton;

@property (nonatomic,strong)UIButton *deleteButton;

@end


@implementation UserMangeMentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.nameLable];
        [self addSubview:self.rightLable];
        [self addSubview:self.timeLable];
        [self addSubview:self.tableView];
        [self addSubview:self.modifyButton];
        [self addSubview:self.deleteButton];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = UICOLOR_HEX(0xeff3ec);
        _nameLable.textColor = [UIColor colorWithRed:67/255.0 green:80/255.0 blue:38/255.0 alpha:1.0];
        _dataList = [[NSMutableArray alloc]init];
    }
    
    return self;
    
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.with.equalTo(@20);
        make.top.equalTo(self.mas_top).offset(30);
        make.left.equalTo(self.mas_left).offset (10);
    }];
    
    CGFloat offsetw = 10;
    CGFloat offsetH = 30;
    if (_isSub) {
        offsetw = 30;
        offsetH = 10;
        _nameLable.textColor = [UIColor grayColor];
    }
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@120);
        make.top.equalTo(self.mas_top).offset(offsetH);
        make.left.equalTo(self.iconImageView.mas_right).offset(offsetw);
    }];
    
//    [_modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_nameLable.mas_right).offset(5);
//        make.centerY.equalTo(_nameLable.mas_centerY);
//        make.width.equalTo(@60);
//        make.height.equalTo(@20);
//    }];
    
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(_nameLable.mas_centerY);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    [_modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_deleteButton.mas_left).offset(-10);
        make.centerY.equalTo(_nameLable.mas_centerY);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
    
    CGFloat tableHeight = 0;
    if (_dataList.count) {
        tableHeight = _dataList.count * 60;
    }
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@(tableHeight));
        make.top.equalTo(self.mas_top).offset(80);
    }];
    
}
#pragma mark - UI getters


- (UIButton *)modifyButton
{
    if (!_modifyButton) {
        _modifyButton = [[UIButton alloc]init];
        [_modifyButton setTitle:[kMultiTool getMultiLanByKey:@"modify"] forState:UIControlStateNormal];
        [_modifyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_modifyButton addTarget:self action:@selector(modifyMethod) forControlEvents:UIControlEventTouchUpInside];
        _modifyButton.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    
    return _modifyButton;
}
- (void)modifyMethod
{
    
        if (_isSub) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyuser" object:_dic];
        }else{
            if (self.modifyBlock) {
            self.modifyBlock([_dic objectForKey:@"tid"]);
            }
            
        }
        
    
    
}
- (void)deleteMethod
{
   
        if (_isSub) {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteuser" object:_dic];
        }else{
             if (self.deleteBlock) {
            self.deleteBlock([_dic objectForKey:@"tid"]);
             }
        }
    
    
}
- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc]init];
        [_deleteButton setTitle:[kMultiTool getMultiLanByKey:@"shanchu"] forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteMethod) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    
    return _deleteButton;
}

- (UILabel *)nameLable


{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.textColor = UICOLOR_HEX(0x336130);
        // _nameLable.text = @"测试1";
        _nameLable.font = [UIFont systemFontOfSize:10];
        _nameLable.textAlignment = NSTextAlignmentLeft;
    }
    
    return _nameLable;
    
    
}

- (UILabel *)accountLable


{
    if (!_accountLable) {
        _accountLable = [[UILabel alloc]init];
        _accountLable.textColor = [UIColor grayColor];
        //  _accountLable.text = @"测试2";
        _accountLable.textAlignment = NSTextAlignmentCenter;
        _accountLable.font = [UIFont systemFontOfSize:8];
    }
    
    return _accountLable;
    
    
}

- (UILabel *)rightLable


{
    if (!_rightLable) {
        _rightLable = [[UILabel alloc]init];
        _rightLable.textColor = [UIColor grayColor];
        //  _rightLable.text = @"测试3";
        _rightLable.textAlignment = NSTextAlignmentCenter;
        _rightLable.font = [UIFont systemFontOfSize:10];
    }
    
    return _rightLable;
    
    
}

- (UILabel *)timeLable


{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]init];
        _timeLable.textColor = [UIColor grayColor];
        _timeLable.textAlignment = NSTextAlignmentCenter;
        _timeLable.font = [UIFont systemFontOfSize:10];
        _timeLable.numberOfLines = 0;
    }
    
    return _timeLable;
    
    
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        [_iconImageView setImage:[UIImage imageNamed:@"manageuser"]];
    }
    
    return _iconImageView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[UserMangeMentTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

- (void)setDic:(NSDictionary *)dic
{
    
    _dic = dic;
    if (!_isSub){
        NSLog(@"%@",dic);
        _nameLable.text = [dic objectForKey:@"tag"];
        _dataList = [dic objectForKey:@"list"];
    }
    else{
        _nameLable.text = [dic objectForKey:@"note"];
    }
    [self setNeedsLayout];
    [_tableView reloadData];
}
- (void)setIsSub:(BOOL)isSub
{
    _isSub = isSub;
    if (_isSub) {
        _iconImageView.hidden = YES;
    }
    
}
#pragma mark -tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

#pragma mark-datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataList.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserMangeMentTableViewCell* cell=[[UserMangeMentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.isSub = YES;
    cell.dic = [_dataList objectAtIndex:[indexPath row]];
// 删除一个用户
//        cell.deleteBlock = ^(NSString *tagId) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteuser" object:_dic];
//        };
//        cell.modifyBlock = ^(NSString *tagId) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyuser" object:_dic];
//        };
    return cell;
    
}


@end
