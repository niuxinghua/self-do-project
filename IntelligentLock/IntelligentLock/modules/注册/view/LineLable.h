//
//  LineLable.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/17.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didTapLable)(void);
@interface LineLable : UILabel
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,copy)didTapLable tapBlock;
@end
