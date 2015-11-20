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
    int current_page;
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
    if ([self.networkOperator isConnectInternet]) {
        __unsafe_unretained UITableView *tableView = self.jokeList;
        tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            current_page = 1;
            NSMutableDictionary *dict = [self.networkOperator get_joke_list:current_page];
            alldata = [dict objectForKey:@"jokes"];
            if (alldata!=nil&&[alldata count]>0) {
                [self.networkOperator saveCache:alldata];
            }else{
                alldata = [self.networkOperator getCache];
            }
            [self.jokeList reloadData];
            [tableView.mj_header endRefreshing];
        }];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            current_page += 1;
            NSMutableDictionary *dict = [self.networkOperator get_joke_list:current_page];
            if ([dict objectForKey:@"jokes"]) {
                NSMutableArray *new_data = [dict objectForKey:@"jokes"];
                [alldata addObjectsFromArray:new_data];
                [self.jokeList reloadData];
            }
            [tableView.mj_footer endRefreshing];
        }];
        current_page = 1;
        NSMutableDictionary *dict = [self.networkOperator get_joke_list:current_page];
        alldata = [dict objectForKey:@"jokes"];
        if (alldata!=nil&&[alldata count]>0) {
            [self.networkOperator saveCache:alldata];
        }else{
            alldata = [self.networkOperator getCache];
        }
    }else{
        alldata = [self.networkOperator getCache];
    }
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
    float height=120;
    CGRect labelRect = [[alldata[indexPath.row] objectForKey:@"content"]
                        boundingRectWithSize:CGSizeMake(tableView.frame.size.width-16, 0)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{
                                     NSFontAttributeName : [UIFont systemFontOfSize:14]
                                     }
                        context:nil];
    
    height=height+labelRect.size.height+30;
    
    return height;
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
