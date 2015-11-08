//
//  CommentCell.h
//  HiJoke
//
//  Created by 李志豪 on 11/5/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UITextView *comment;

@end
