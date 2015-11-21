//
//  ShowCommentViewController.m
//  HiJoke
//
//  Created by 李志豪 on 11/3/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import "ShowCommentViewController.h"

#define cellID @"tableViewCellID"

@interface ShowCommentViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    NSMutableDictionary *comment_data;
}
@end

@implementation ShowCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.networkOperate = [[NetworkOperate alloc] init];
    comment_data = [self.networkOperate get_comment:self.jokeID];
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    self.commentTableView.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
    [self.commentTableView registerNib:[UINib nibWithNibName:@"CommentCell"
                                                      bundle:nil]
                forCellReuseIdentifier:cellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//tableview一共几行
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[comment_data objectForKey:@"comments"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

//每一个cell
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.username.text = [[comment_data objectForKey:@"comments"][indexPath.row] objectForKey:@"username"];
    cell.comment.text = [[comment_data objectForKey:@"comments"][indexPath.row] objectForKey:@"comment"];
    cell.layer.borderWidth = 10;
    cell.layer.borderColor = [[UIColor colorWithRed:236.0/255
                                              green:236.0/255
                                               blue:236.0/255
                                              alpha:1.0] CGColor];
    return cell;
}

- (IBAction)writeCommentButton:(id)sender {
    BOOL is_login = NO;
    if ([[self.networkOperate getCookies] count] > 0) {
        is_login = YES;
    }
    if (is_login) {
        self.writeCommentViewController=[[UIStoryboard storyboardWithName:@"Main"
                                                                bundle:nil]instantiateViewControllerWithIdentifier:@"WriteCommentViewController"];
        self.writeCommentViewController.joke_id = self.jokeID;
        [self.navigationController pushViewController:self.writeCommentViewController
                                             animated:YES];
    }else{
        self.loginViewController=[[UIStoryboard storyboardWithName:@"Main"
                                                            bundle:nil]instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:self.loginViewController
                                             animated:YES];
    }
}
@end
