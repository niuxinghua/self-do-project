//
//  MapPlaceHolder.h
//  caxjh
//
//  Created by niuxinghua on 2017/11/24.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^didTapBind)(void);
@interface MapPlaceHolder : UIView
@property (nonatomic,copy)didTapBind bindBlock;
@end
