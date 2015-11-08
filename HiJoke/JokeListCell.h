//
//  JokeListCell.h
//  HiJoke
//
//  Created by 李志豪 on 11/3/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JokeListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property int joke_id;

@end
