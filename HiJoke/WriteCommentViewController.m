//
//  WriteCommentViewController.m
//  HiJoke
//
//  Created by 李志豪 on 10/30/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import "WriteCommentViewController.h"

@interface WriteCommentViewController () <UIAlertViewDelegate>

@end

@implementation WriteCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkOperate = [[NetworkOperate alloc] init];
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

- (IBAction)post_comment_button:(id)sender {
    NSString *comment = self.comment_textarea.text;
    NSString *cookie = [[self.networkOperate getCookies] objectAtIndex:0];
    NSString *session = [[self.networkOperate getCookies] objectAtIndex:1];
    NSMutableDictionary *json = [self.networkOperate write_comment:self.joke_id
                                                           comment:comment
                                                            cookie:cookie
                                                           session:session];
    if ([json objectForKey:@"result"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.alert setMessage:@"发表评论失败"];
        [self presentViewController:self.alert
                           animated:YES
                         completion:nil];
    }
}
@end
