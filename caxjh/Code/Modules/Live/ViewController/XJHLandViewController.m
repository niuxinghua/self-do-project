//
//  XJHLandViewController.m
//  caxjh
//
//  Created by niuxinghua on 2018/1/19.
//  Copyright © 2018年 Yingchao Zou. All rights reserved.
//

#import "XJHLandViewController.h"
#import "UIBarButtonItem+UC.h"
@interface XJHLandViewController ()

@end

@implementation XJHLandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        //[_glView removeFromSuperview];
       // [self dismissViewControllerAnimated:<#(BOOL)#> completion:<#^(void)completion#>];
    }];
    _backscrollView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    _glview.frame = _backscrollView.frame;
    [self.view addSubview:_backscrollView];
    _halfScreenButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.height - 40, self.view.frame.size.width - 40, 30, 30)];
    [_halfScreenButton addTarget:self action:@selector(halfScreen) forControlEvents:UIControlEventTouchUpInside];
    [_halfScreenButton setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
    [self.view addSubview:_halfScreenButton];
    _resumeButton.hidden = YES;
    _resumeButton.center = CGPointMake(_backscrollView.center.x, _backscrollView.center.y);
    _slider.frame = CGRectMake(0, self.view.frame.size.width - 30, self.view.frame.size.height - 120, 20);
  _slider.center = CGPointMake(_slider.center.x, _halfScreenButton.center.y);
    [self.view addSubview:_slider];
    [self.view bringSubviewToFront:_slider];
    _leftLable.frame = CGRectMake(self.view.frame.size.height - 120, self.view.frame.size.width - 30, 60, 20);
     _leftLable.center = CGPointMake(_leftLable.center.x, _halfScreenButton.center.y);
    [self.view addSubview:_leftLable];
}

- (void)halfScreen
{
    
    [self dismissViewControllerAnimated:NO completion:^{
        //[_backscrollView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"doportrit" object:nil];
    }];
    
}
- (BOOL) shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    
    return UIInterfaceOrientationLandscapeLeft;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
