//
//  HMDirectDevViewController.m
//  Demo
//
//  Created by guofeixu on 15/10/10.
//  Copyright © 2015年 guofeixu. All rights reserved.
//

#import "HMDirectDevViewController.h"
#import "HMPlayerViewController.h"
@interface HMDirectDevViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *snTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;

@end

@implementation HMDirectDevViewController

@synthesize ipTextField;
@synthesize portTextField;
@synthesize snTextField;
@synthesize nameTextField;
@synthesize passTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)connectDevice:(UIButton *)sender {
    
    if ([ipTextField.text length]==0||[portTextField.text length]==0||[snTextField.text length]==0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的登录信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    [self performSegueWithIdentifier:@"directPlayerPush" sender:self];
    
    
    
   
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"directPlayerPush"]) {
        
        HMPlayerViewController *playerController = segue.destinationViewController;
        
        playerController.isDirectDevice = YES;
        playerController.ip = ipTextField.text;
        playerController.port = [portTextField.text integerValue];
        playerController.sn = snTextField.text;
        playerController.user = nameTextField.text;
        playerController.pwd = passTextField.text;
    }
}


@end
