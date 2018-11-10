//
//  UIImage+BarCode.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/10.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BarCode)
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 *
 *  @return 生成的高清的UIImage
 */
+ (UIImage *)creatNonInterpolatedUIImageFormCIImage:(NSString *)str withSize:(CGFloat)size;


@end
