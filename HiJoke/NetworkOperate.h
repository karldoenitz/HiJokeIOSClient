//
//  NetworkOperate.h
//  HiJoke
//
//  Created by 李志豪 on 11/4/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <arpa/inet.h>
#import <CommonCrypto/CommonHMAC.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
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

- (NSMutableDictionary *)write_joke:(NSString *)title
                            content:(NSString *)content
                             cookie:(NSString *)cookie
                            session:(NSString *)session;

- (NSMutableDictionary *)get_joke_list:(int)page_number;

//获取cookie
- (NSMutableArray *)getCookies;

//存储cookie
- (void)savecookieToplist:(NSMutableArray *)cookies;

- (void)saveCache:(NSMutableArray *)cache;

- (NSMutableArray *)getCache;

- (BOOL)isConnectInternet;

@end
