//
//  ViewController.m
//  HiJoke
//
//  Created by 李志豪 on 10/30/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import "ViewController.h"

#define cellID @"tableViewCellID"

@interface ViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    UITapGestureRecognizer *clickWebView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://img3.redocn.com/20090928/20090928_5aa73bd615472047f14f1gJS0R2DKrFo.jpg"]];
    [self.adWebview loadRequest:request];
    self.adWebview.scrollView.contentInset = UIEdgeInsetsMake(-1.5*self.navigationController.navigationBar.frame.size.height, 0, 0, 0);
    clickWebView = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                          action:@selector(turnWebview)];
    clickWebView.delegate = self;
    [self.adWebview addGestureRecognizer:clickWebView];
    self.jokeList.delegate = self;
    self.jokeList.dataSource = self;
    [self.jokeList registerNib:[UINib nibWithNibName:@"JokeListCell"
                                              bundle:nil]
        forCellReuseIdentifier:cellID];
    [self.jokeList.layer setBackgroundColor:[[UIColor colorWithRed:236.0/255
                                                             green:236.0/255
                                                              blue:236.0/255
                                                             alpha:1.0] CGColor]];
    self.networkOperator = [[NetworkOperate alloc] init];
    alldata = @[
    @{@"comment_count":@0,@"content":@"我去年买了个登山包",@"id":@20,@"title":@"测试"},
    @{@"comment_count":@0,@"content":@"我去年买了个登山包",@"id":@16,@"title":@"测试"},
    @{@"comment_count":@0,@"content":@"我去年买了个登山包",@"id":@15,@"title":@"测试"},
    @{@"comment_count":@0,@"content":@"乌云龙",@"id":@14,@"title":@"你是谁"},
    @{@"comment_count":@0,@"content":@"world",@"id":@13,@"title":@"hello"},
    @{@"comment_count":@0,@"content":@"内容10",@"id":@10,@"title":@"标题10"},
    @{@"comment_count":@0,@"content":@"内容9",@"id":@9,@"title":@"标题9"},
    @{@"comment_count":@1,@"content":@"内容7",@"id":@7,@"title":@"标题7"},
    @{@"comment_count":@11,@"content":@"内容6",@"id":@6,@"title":@"标题6"},
    @{@"comment_count":@0,@"content":@"内容5",@"id":@5,@"title":@"标题5"}
    ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 跳转到webview广告页面
- (void)turnWebview
{
    self.aDViewController=[[UIStoryboard storyboardWithName:@"Main"
                                                     bundle:nil]instantiateViewControllerWithIdentifier:@"ADViewController"];
    [self.navigationController pushViewController:self.aDViewController
                                         animated:YES];
}

// 跳转到评论页面
- (void)turnCommentView:(id)button
{
    UIButton *clicked = (UIButton *) button;
    self.showCommentVewController = [[UIStoryboard storyboardWithName:@"Main"
                                                               bundle:nil] instantiateViewControllerWithIdentifier:@"ShowCommentViewController"];
    self.showCommentVewController.jokeID = (int)clicked.tag;
    [self.navigationController pushViewController:self.showCommentVewController
                                         animated:YES];
}

// 判断是否点击webview
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == clickWebView)
    {
        return YES;
    }
    return NO;
}

- (IBAction)writeJokeButton:(id)sender {
    BOOL is_login = NO;
    if ([[self.networkOperator getCookies] count] > 0) {
        is_login = YES;
    }
    if (is_login) {
        self.writeJokeViewController=[[UIStoryboard storyboardWithName:@"Main"
                                                                bundle:nil]instantiateViewControllerWithIdentifier:@"WriteJokeViewController"];
        [self.navigationController pushViewController:self.writeJokeViewController
                                             animated:YES];
    }else{
        self.loginViewController=[[UIStoryboard storyboardWithName:@"Main"
                                                            bundle:nil]instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:self.loginViewController
                                             animated:YES];
    }
}

//tableview一共几行
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return alldata.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

//每一个cell
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JokeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = [alldata[indexPath.row] objectForKey:@"title"];
    cell.content.text = [alldata[indexPath.row] objectForKey:@"content"];
    int jokeID = (int)[[alldata[indexPath.row] objectForKey:@"id"] integerValue];
    cell.joke_id = jokeID;
    NSString *buttonTitle = [NSString stringWithFormat:@"共%@条评论>>", [alldata[indexPath.row] objectForKey:@"comment_count"]];
    [cell.commentButton setTitle:buttonTitle
                        forState:UIControlStateNormal];
    cell.commentButton.tag = jokeID;
    [cell.commentButton addTarget:self
                           action:@selector(turnCommentView:)
                 forControlEvents:UIControlEventTouchDown];
    cell.layer.borderWidth = 10;
    cell.layer.borderColor = [[UIColor colorWithRed:236.0/255
                                              green:236.0/255
                                               blue:236.0/255
                                              alpha:1.0] CGColor];
    return cell;
}
@end
