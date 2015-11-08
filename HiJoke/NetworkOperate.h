//
//  NetworkOperate.h
//  HiJoke
//
//  Created by 李志豪 on 11/4/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkTools.h"
#import "login_and_register.h"

@interface NetworkOperate : NSObject

@property NSString *baseurl;
@property NetworkTools *networkTools;

- (NSMutableDictionary *)get_comment:(int)joke_id;

- (NSMutableDictionary *)regist:(NSString *)username
                       password:(NSString *)password;

- (NSMutableDictionary *)login:(NSString *)username
                      password:(NSString *)password;

- (NSMutableDictionary *)write_comment:(int)joke_id
                               comment:(NSString *)comment
                                cookie:(NSString *)cookie
                               session:(NSString *)session;

//获取cookie
- (NSMutableArray *)getCookies;

//存储cookie
- (void)savecookieToplist:(NSMutableArray *)cookies;

@end
