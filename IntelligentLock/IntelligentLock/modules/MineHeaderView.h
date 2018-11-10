//
//  MineHeaderView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/24.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"

typedef void(^didTapAvatarblock)(void);
typedef void(^didTapBarcodeblock)(void);
@interface MineHeaderView : UIView


@property (nonatomic,strong)LoginModel *loginModel;


@property (nonatomic,copy)didTapAvatarblock avatarBlock;

@property (nonatomic,copy)didTapBarcodeblock barcodeBlock;

@end
