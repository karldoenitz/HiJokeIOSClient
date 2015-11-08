//
//  WriteJokeViewController.h
//  HiJoke
//
//  Created by 李志豪 on 10/30/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkOperate.h"

@interface WriteJokeViewController : UIViewController

@property NetworkOperate *networkOperate;

@property UIAlertController *alert;

@property (weak, nonatomic) IBOutlet UITextField *jokeTitleTextInput;

@property (weak, nonatomic) IBOutlet UITextView *jokeContentTextView;

- (IBAction)pushJokeButton:(id)sender;

@end
