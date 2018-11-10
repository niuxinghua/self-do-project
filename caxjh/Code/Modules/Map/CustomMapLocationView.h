//
//  CustomMapLocationView.h
//  caxjh
//
//  Created by niuxinghua on 2018/1/10.
//  Copyright © 2018年 Yingchao Zou. All rights reserved.
//


#import "Const.h"
@interface CustomMapLocationView : BMKAnnotationView


@property (nonatomic,strong)UIImageView *backImageView;



@property (nonatomic,strong)UIImageView *headImageView;

- (void)setHeadImage:(UIImage *)img;

@end
