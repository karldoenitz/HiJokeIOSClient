//
//  LoginViewController.h
//  HiJoke
//
//  Created by 李志豪 on 10/30/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkOperate.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextInput;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextInput;

@property UIAlertController *alert;

@property NetworkOperate *networkOperate;

- (IBAction)loginButton:(id)sender;

- (IBAction)registerButton:(id)sender;

@end
