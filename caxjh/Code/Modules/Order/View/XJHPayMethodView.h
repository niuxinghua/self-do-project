//
//  XJHPayMethodView.h
//  caxjh
//
//  Created by Yingchao Zou on 07/09/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHBaseView.h"

@protocol XJHPayMethodViewDelegate <NSObject>

// 1 支付宝
// 2 微信
- (void)confirmWithMethod:(NSUInteger)method;

@end

@interface XJHPayMethodView : XJHBaseView

@property (nonatomic, readwrite, weak) id<XJHPayMethodViewDelegate> delegate;

@end
