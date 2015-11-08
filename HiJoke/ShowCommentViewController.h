//
//  ShowCommentViewController.h
//  HiJoke
//
//  Created by 李志豪 on 11/3/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkOperate.h"
#import "CommentCell.h"
#import "WriteCommentViewController.h"
#import "LoginViewController.h"

@interface ShowCommentViewController : UIViewController

- (IBAction)writeCommentButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@property NetworkOperate *networkOperate;

@property WriteCommentViewController *writeCommentViewController;

@property LoginViewController *loginViewController;

@property int jokeID;

@end
