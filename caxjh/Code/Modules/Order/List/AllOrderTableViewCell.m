//
//  AllOrderTableViewCell.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/3.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "AllOrderTableViewCell.h"
#import "Masonry.h"
#import "UIColor+EAHexColor.h"
#import<CoreText/CoreText.h>
@implementation AllOrderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHex:@"#fafafa"];
        _titleLable = [[UILabel alloc]init];
        _titleLable.textColor = [UIColor colorWithHex:@"#ff6767"];
        _titleLable.backgroundColor = [UIColor colorWithHex:@"#fef8ec"];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.text = @"视频回放套餐";
        
        
        _descriptionLable = [[UILabel alloc]init];
        [self addSubview:_descriptionLable];
        _descriptionLable.textColor = [UIColor colorWithHex:@"#aaaaaa"];
        _descriptionLable.font = [UIFont systemFontOfSize:13];
        _descriptionLable.backgroundColor = [UIColor whiteColor];
        _descriptionLable.numberOfLines = 0;
        
        _checkBox = [ZZCheckBox checkBoxWithCheckBoxType:CheckBoxTypeSingleCheckBox];
        
        _applyButton = [[UIButton alloc]init];
        _applyButton.frame = CGRectMake(20, 100, 60, 30);
        [_applyButton setTitle:@"分配给" forState:UIControlStateNormal];
        [_applyButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        _applyButton.backgroundColor =  [UIColor colorWithHex:@"#ff6767"];
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _applyButton.layer.cornerRadius = 5;
        _applyButton.layer.masksToBounds = YES;
        [_applyButton addTarget:self action:@selector(tapApplyButton) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_applyButton];

       // _checkBox.dataSource = self;
        
        _bgView = [[UIView alloc]init];
        [self addSubview:_titleLable];
        [self addSubview:_bgView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _buttonList = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)tapApplyButton{
    if (self.tapApply) {
        self.tapApply();
    }
}
-(void)reloadCellWith:(NSString*)parentName
{
    bool flag = false;
    for (UIButton *btn in _buttonList) {
        if ([btn.titleLabel.text isEqualToString:parentName]) {
            flag = YES;
        }
    }
    if (flag) {
        return;
    }
    UIButton *button  = [[UIButton alloc]init];
    [button setTitle:parentName forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:8];
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    [button setBackgroundColor:[UIColor colorWithHex:@"#fef8ec"]];
    [_buttonList addObject:button];
    [button addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self reloadButtonFrame];
}
-(void)deleteButton:(UIButton*)sender
{
    
    for (UIButton *btn in _buttonList) {
        [btn removeFromSuperview];
    }
    [_buttonList removeObject:sender];
    [self setNeedsLayout];
    [self setNeedsDisplay];
    if (self.deselectApply) {
        self.deselectApply(sender.titleLabel.text);
    }
    
}
-(void)setSelectedParentList:(NSMutableArray *)selctList
{
    [self setNeedsLayout];
    for (UIButton *btn in _buttonList) {
        [btn removeFromSuperview];
        [_buttonList removeObject:btn];
    }
    [_buttonList removeAllObjects];
    for (int i=0;i<selctList.count;i++)
    {
        UIButton *button  = [[UIButton alloc]init];
        [button setTitle:selctList[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:8];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button setBackgroundColor:[UIColor colorWithHex:@"#fef8ec"]];
        [_buttonList addObject:button];
        [button addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self reloadButtonFrame];
}
-(void)reloadButtonFrame
{
    
    [self setNeedsLayout];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@40);
    }];
    [_descriptionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLable);
        make.right.equalTo(_titleLable);
        make.top.equalTo(_titleLable.mas_bottom);
        make.height.greaterThanOrEqualTo(@(_lableHeight));
    }];
    [_applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    for (UIButton *btn in _buttonList) {
        [btn removeFromSuperview];
    }
    for (int i=0;i<_buttonList.count;i++)
    {
        UIButton *button  = _buttonList[i];
        button.frame = CGRectMake(100, self.bounds.size.height - 70 + 20*i, 120, 20);
        [self addSubview:button];
    }

}

-(void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    _titleLable.text = [dic objectForKey:@"name"];
    if (![[dic objectForKey:@"content"] isKindOfClass:[NSNull class]]) {
        _descriptionLable.text = [dic objectForKey:@"content"];
    }
    _lableHeight = [self getLabelHeight:[dic objectForKey:@"content"]];
    _checkBox.dataSource = self;
    _checkBox.delegate = self;
    [self setNeedsLayout];
}
-(CGFloat)getLabelHeight:(NSString*)str
{
    if ([str isKindOfClass:[NSNull class]]) {
        return 0;
    }
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGSize maxSize = CGSizeMake(self.frame.size.width - 30, 100);
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height;
    

}
-(void)setSelectedNum:(NSNumber *)selectedNum
{
    _flag = YES;
    [_checkBox selectItemAtIndex:[selectedNum intValue]];
}
#pragma mark - ZZCheckBoxDataSource
-(NSInteger)numberOfRowsInCheckBox:(ZZCheckBox *)checkBox {
    if ([_dic objectForKey:@"contractContractSpec"]) {
        NSArray *array = [_dic objectForKey:@"contractContractSpec"];
        return  [array count];
    }
    return 0;
}

-(UIView *)checkBox:(ZZCheckBox *)checkBox supperViewAtIndex:(NSInteger)index {
    return self;
}

-(CGRect)checkBox:(ZZCheckBox *)checkBox frameAtIndex:(NSInteger)index {
    
    return CGRectMake(15, 50 + _lableHeight + 30 * index, [UIScreen mainScreen].bounds.size.width-30, 30);
}

-(NSAttributedString *)checkBox:(ZZCheckBox *)checkBox titleForCheckBoxAtIndex:(NSInteger)index {
    NSArray *array  = [_dic objectForKey:@"contractContractSpec"];
    NSDictionary *dic1 = [array objectAtIndex:index];
   NSDictionary *dic2 = [dic1 objectForKey:@"duration"];
   // float price;
    NSString *durationName = [dic2 objectForKey:@"name"];
    float priceStr = [[dic1 objectForKey:@"price"] floatValue];
    NSString *memberStr = [NSString stringWithFormat:@"%ld",[[dic1 objectForKey:@"memberCount"] longValue]];

    NSString *str = [NSString stringWithFormat:@"%@ ( %.2f元/%@账户)",durationName,priceStr,memberStr];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:str];
    NSInteger totalLength = [str1 length];
    NSInteger length = [[dic2 objectForKey:@"name"] length];
    [str1 addAttribute:NSForegroundColorAttributeName
     
                 value:[UIColor colorWithHex:@"#ff6767"]
     
                          range:NSMakeRange(length, totalLength-length)];
    return str1;
}

-(UIFont *)checkBox:(ZZCheckBox *)checkBox titleFontForCheckBoxAtIndex:(NSInteger)index {
    return [UIFont systemFontOfSize:15];
}

-(UIColor *)checkBox:(ZZCheckBox *)checkBox titleColorForCheckBoxAtIndex:(NSInteger)index {
    return [UIColor colorWithHex:@"#333333"];
}

-(UIImage *)checkBox:(ZZCheckBox *)checkBox imageForCheckBoxAtIndex:(NSInteger)index forState:(UIControlState)state {
    if (state == UIControlStateNormal) {
        UIImage *image = [UIImage imageNamed:@""];
        return image;
    } else if (state == UIControlStateSelected) {
        UIImage *image = [UIImage imageNamed:@""];
        return image;
    }
    return nil;
}

#pragma mark - ZZCheckBoxDelegate
-(NSArray<NSNumber *> *)defaultSelectedIndexInCheckBox:(ZZCheckBox *)checkBox {
    return @[@1];
}

-(void)checkBox:(ZZCheckBox *)checkBox didDeselectedAtIndex:(NSInteger)index {
    NSArray *array  = [_dic objectForKey:@"contractContractSpec"];
    NSDictionary *dic1 = [array objectAtIndex:index];
    float price = [[dic1 objectForKey:@"price"] floatValue];
    if (self.deselectblock) {
        self.deselectblock([NSNumber numberWithInteger:index],price);
    }
}

-(BOOL)canCancleCheckSingleCheckBox:(ZZCheckBox *)checkBox {
    return YES;
}

-(void)checkBox:(ZZCheckBox *)checkBox didSelectedAtIndex:(NSInteger)index {
    NSArray *array  = [_dic objectForKey:@"contractContractSpec"];
    NSDictionary *dic1 = [array objectAtIndex:index];
    float price = [[dic1 objectForKey:@"price"] floatValue];   if (self.block && !_flag) {
        self.block([NSNumber numberWithInteger:index],price);
    }
    _flag = NO;
}




@end
