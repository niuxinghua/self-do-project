//
//  XJHStuffAvatarTableViewCell.m
//  caxjh
//
//  Created by Yingchao Zou on 03/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHStuffAvatarTableViewCell.h"

@interface XJHStuffAvatarTableViewCell ()

@property (nonatomic, readwrite, strong) UILabel *theLabel;

@end

@implementation XJHStuffAvatarTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self.contentView addSubview:self.theImageView];
    [self.contentView addSubview:self.theLabel];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.theImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60);
        make.left.equalTo(@15);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.theLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
}



- (UIImageView *)theImageView {
    if (!_theImageView) {
        _theImageView = [[UIImageView alloc] init];
        _theImageView.layer.cornerRadius = 30.0;
        _theImageView.layer.masksToBounds = YES;
    }
    return _theImageView;
}

- (UILabel *)theLabel {
    if (!_theLabel) {
        _theLabel = [[UILabel alloc] init];
        _theLabel.textColor = [UIColor colorWithHex:@"#e1e1e1"];
        _theLabel.text = @"更改头像";
    }
    return _theLabel;
}

@end
