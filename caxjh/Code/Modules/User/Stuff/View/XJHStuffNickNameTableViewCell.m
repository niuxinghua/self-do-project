//
//  XJHStuffNickNameTableViewCell.m
//  caxjh
//
//  Created by Yingchao Zou on 03/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHStuffNickNameTableViewCell.h"

@implementation XJHStuffNickNameTableViewCell

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
    
    [self.contentView addSubview:self.theLeftLabel];
    [self.contentView addSubview:self.theRightLabel];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.theLeftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [self.theRightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
}

- (UILabel *)theLeftLabel {
    if (!_theLeftLabel) {
        _theLeftLabel = [[UILabel alloc] init];
        _theLeftLabel.textColor = [UIColor colorWithHex:@"#333333"];
    }
    return _theLeftLabel;
}

- (UILabel *)theRightLabel {
    if (!_theRightLabel) {
        _theRightLabel = [[UILabel alloc] init];
        
    }
    return _theRightLabel;
}

@end
