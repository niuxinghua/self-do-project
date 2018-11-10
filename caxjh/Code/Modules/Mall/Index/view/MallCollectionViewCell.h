//
//  MallCollectionViewCell.h
//  caxjh
//
//  Created by niuxinghua on 2017/10/28.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^didTapDetil)(NSDictionary *dic);
@interface MallCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *avatarImageView;
@property (nonatomic,strong)UILabel *firstHeadLable;
@property (nonatomic,strong)UILabel *secondHeadLable;
@property (nonatomic,strong)UILabel *thirdHeadLable;
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,strong)UIButton *detilBtn;
@property (nonatomic,copy)didTapDetil tapDetilBlock;
@end
