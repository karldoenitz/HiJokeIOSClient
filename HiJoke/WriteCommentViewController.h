//
//  WriteCommentViewController.h
//  HiJoke
//
//  Created by 李志豪 on 10/30/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkOperate.h"

@interface WriteCommentViewController : UIViewController

@property NetworkOperate *networkOperate;

@property UIAlertController *alert;

@property int joke_id;

@property (weak, nonatomic) IBOutlet UITextView *comment_textarea;

- (IBAction)post_comment_button:(id)sender;

@end
