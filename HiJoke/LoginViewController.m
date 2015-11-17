//
//  LoginViewController.m
//  HiJoke
//
//  Created by 李志豪 on 10/30/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UIAlertViewDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.networkOperate = [[NetworkOperate alloc] init];
    self.alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                     message:@"xxxxxxx"
                                              preferredStyle:UIAlertControllerStyleAlert];
    [self.alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action) {
                                                     [self.alert dismissViewControllerAnimated:YES completion:nil];
                                                 }]];
    [self.alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                   style:UIAlertActionStyleCancel
                                                 handler:^(UIAlertAction *action) {
                                                     [self.alert dismissViewControllerAnimated:YES completion:nil];
                                                 }]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButton:(id)sender {
    NSString *username = self.usernameTextInput.text;
    NSString *password = self.passwordTextInput.text;
    NSMutableDictionary * result = [self.networkOperate login:username
                                                     password:password];
    if ([[result objectForKey:@"result"] isEqualToString:@"login success"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.alert setMessage:@"登录失败！"];
        [self presentViewController:self.alert
                           animated:YES
                         completion:nil];
    }
}

- (IBAction)registerButton:(id)sender {
    NSString *username = self.usernameTextInput.text;
    NSString *password = self.passwordTextInput.text;
    NSMutableDictionary * result = [self.networkOperate regist:username
                                                      password:password];
    if ([username length]<1||[password length]<1) {
        [self.alert setMessage:[result objectForKey:@"用户名或密码不能为空！"]];
    }else{
        [self.alert setMessage:[result objectForKey:@"reason"]];
    }
    [self presentViewController:self.alert
                       animated:YES
                     completion:nil];
}
@end
