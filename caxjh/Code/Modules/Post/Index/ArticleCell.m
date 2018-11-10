//
//  ArticleCell.m
//  caxjh
//
//  Created by niuxinghua on 2017/8/30.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "ArticleCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIColor+EAHexColor.h"
@implementation ArticleCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _textLable1 = [[UILabel alloc]init];
        _textLable1.font = [UIFont systemFontOfSize:17];
        _avatarImageView = [[UIImageView alloc]init];
        _timeLable = [[UILabel alloc]init];
        _textLable1.textColor = [UIColor colorWithHex:@"#333333"];
        _timeLable.textColor = [UIColor colorWithHex:@"#aaaaaa"];
         _timeLable.font = [UIFont systemFontOfSize:12];
        _missingLable = [[UILabel alloc]init];
        _missingLable.textColor = [UIColor colorWithHex:@"#6b6b6b"];
        _missingLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:_textLable1];
        [self addSubview:_timeLable];
        [self addSubview:_avatarImageView];
        [self addSubview:_missingLable];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@75);
        make.width.equalTo(@75);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_textLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@30);
    }];
    
    [self.missingLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_textLable1.mas_left);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.height.equalTo(@30);
        make.width.equalTo(_textLable1.mas_width);
        make.left.equalTo(self.textLable1.mas_left);
    }];
}
-(void)bindData:(NSDictionary *)dic
{
    if ([dic objectForKey:@"createTime"] && ![[dic objectForKey:@"createTime"] isKindOfClass:[NSNull class]]) {
        NSString *dateString = [self cStringFromTimestamp:[[dic objectForKey:@"createTime"] longValue]/1000];
         [_timeLable setText:dateString];
    }
    _textLable1.text = [dic objectForKey:@"name"];
    //[_avatarImageView sd_setImageWithURL:[dic objectForKey:@"image"]];
    if (_type == ArticleTypeVIP) {
        [_avatarImageView sd_setImageWithURL:[dic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"默认图-热门文章"]];
    }else if (_type == ArticleTypeLost){
         [_avatarImageView sd_setImageWithURL:[dic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"missingplaceholder"]];
    }else if (_type == ArticleTypeDonate)
    {
         [_avatarImageView sd_setImageWithURL:[dic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"donateplaceholder"]];
    }else if (_type == ArticleTypeParent)
    {
         [_avatarImageView sd_setImageWithURL:[dic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"parentplaceholder"]];
    }else if (_type == ArticleTypeSafety)
    {
         [_avatarImageView sd_setImageWithURL:[dic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"knowledgeplaceholder"]];
    }else if (_type == ArticleTypeSearch)
    {
        [_avatarImageView sd_setImageWithURL:[dic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"searchplaceholder"]]; 
    }
    _dataDic = dic;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setType:(ArticleType)type
{
    _type = type;
    if (type != ArticleTypeLost) {
        _missingLable.hidden = YES;
        return;
    }
    NSString *sex;
    if ([[_dataDic objectForKey:@"childSex"]isEqualToString:@"female"]) {
        sex = @"女";
    }else{
        sex = @"男";
    }
    NSString *home = [_dataDic objectForKey:@"homePath"];
    int age =(int) [[_dataDic objectForKey:@"childAge"] longValue];
    NSString *detil = [NSString stringWithFormat:@"%@ | %d岁  | %@ ",sex,age,home];
    _missingLable.text = detil;
}
-(NSString *)cStringFromTimestamp:(long)timestamp{
    //时间戳转时间的方法
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}
@end
