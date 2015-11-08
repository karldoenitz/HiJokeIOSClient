//
//  WriteJokeViewController.m
//  HiJoke
//
//  Created by 李志豪 on 10/30/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import "WriteJokeViewController.h"

@interface WriteJokeViewController ()

@end

@implementation WriteJokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    [self.jokeContentTextView.layer setBorderColor: borderColor.CGColor];
    [self.jokeContentTextView.layer setBorderWidth:1];
    [self.jokeContentTextView.layer setCornerRadius:2.0];
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

- (IBAction)pushJokeButton:(id)sender {
    NSString *joke_title = self.jokeTitleTextInput.text;
    NSString *joke_content = self.jokeContentTextView.text;
    if ([joke_title length]<1||[joke_content length]<1) {
        [self.alert setMessage:@"发表段子失败"];
        [self presentViewController:self.alert
                           animated:YES
                         completion:nil];
        return;
    }
    NSArray *cookie_array = [self.networkOperate getCookies];
    NSString *cookie = [cookie_array objectAtIndex:0];
    NSString *session_id = [cookie_array objectAtIndex:1];
    NSMutableDictionary* json = [self.networkOperate write_joke:joke_title
                                                        content:joke_content
                                                         cookie:cookie
                                                        session:session_id];
    if ([json objectForKey:@"result"]) {
        [self.alert setMessage:@"发表段子成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.alert setMessage:@"发表段子失败"];
        [self presentViewController:self.alert
                           animated:YES
                         completion:nil];
    }
}
@end
