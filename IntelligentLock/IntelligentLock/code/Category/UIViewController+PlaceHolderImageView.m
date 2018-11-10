//
//  UIViewController+PlaceHolderImageView.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/12.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "UIViewController+PlaceHolderImageView.h"
static NSString *steKeyPlaceImageView = @"KPLACEIMAGEVIEW";
@implementation UIViewController (PlaceHolderImageView)
-(void)setPlaceImageView:(UIImageView *)placeImageView
{
     objc_setAssociatedObject(self, &steKeyPlaceImageView, placeImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImageView *)placeImageView
{
 return objc_getAssociatedObject(self, &steKeyPlaceImageView);
}
-(void)shownormalEmptyImageView
{
    if (!self.placeImageView) {
        self.placeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.placeImageView.center = CGPointMake(self.view.center.x, self.view.center.y);
        self.placeImageView.image = [UIImage imageNamed:@"nodata"];
        [self.view addSubview:self.placeImageView];
    }
    [self.view bringSubviewToFront:self.placeImageView];
    self.placeImageView.hidden = NO;
}
-(void)hidePlaceHolderImageView
{
    self.placeImageView.hidden = YES;
}
-(void)showEmptyImageViewAtY:(CGFloat)y
{
    if (!self.placeImageView) {
        self.placeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.placeImageView.center = CGPointMake(self.view.center.x, y);
        self.placeImageView.image = [UIImage imageNamed:@"nodata"];
        [self.view addSubview:self.placeImageView];
    }
    [self.view bringSubviewToFront:self.placeImageView];
    self.placeImageView.hidden = NO;

}
@end
