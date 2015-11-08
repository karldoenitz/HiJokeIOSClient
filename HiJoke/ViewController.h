//
//  ViewController.h
//  HiJoke
//
//  Created by 李志豪 on 10/30/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADViewController.h"
#import "LoginViewController.h"
#import "WriteJokeViewController.h"
#import "JokeListCell.h"
#import "NetworkOperate.h"
#import "ShowCommentViewController.h"

@interface ViewController : UIViewController
{
    NSArray *alldata;
    NSArray *allsubdata;
}

@property (weak, nonatomic) IBOutlet UIWebView *adWebview;

@property (nonatomic, strong) ADViewController *aDViewController;

@property (nonatomic, strong) LoginViewController *loginViewController;

@property (nonatomic, strong) WriteJokeViewController *writeJokeViewController;

@property (nonatomic, strong) ShowCommentViewController *showCommentVewController;

@property (nonatomic, strong) NetworkOperate *networkOperator;

- (IBAction)writeJokeButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *jokeList;

@end

