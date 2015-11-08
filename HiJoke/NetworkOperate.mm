//
//  NetworkOperate.m
//  HiJoke
//
//  Created by 李志豪 on 11/4/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import "NetworkOperate.h"

@implementation NetworkOperate

- (id)init
{
    self.baseurl = @"http://192.168.1.102:8888/%@";
    self.networkTools = [[NetworkTools alloc] init];
    return self;
}

- (NSMutableDictionary *)get_comment:(int)joke_id
{
    NSString *url = [NSString stringWithFormat:@"get-comment/?joke_id=%d", joke_id];
    NSString *request_url = [NSString stringWithFormat:self.baseurl, url];
    char *json = get_comment((char *)[request_url UTF8String]);
    NSString *result = [NSString stringWithUTF8String:json];
    return [self.networkTools convert_json:result];
}

- (NSMutableDictionary *)regist:(NSString *)username
                       password:(NSString *)password
{
    char *request_url = (char *)[[NSString stringWithFormat:self.baseurl, @"register/"] UTF8String];
    NSString *usernamepassword = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    char *regist_usernamepassword = (char *)[usernamepassword UTF8String];
    char *json = user_register(request_url, regist_usernamepassword);
    NSString *result = [NSString stringWithUTF8String:json];
    NSMutableDictionary *dictionary = [self.networkTools convert_json:result];
    return dictionary;
}

- (NSMutableDictionary *)login:(NSString *)username
                      password:(NSString *)password
{
    char *request_url = (char *)[[NSString stringWithFormat:self.baseurl, @"login/"] UTF8String];
    NSString *usernamepassword = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    char *login_usernamepassword = (char *)[usernamepassword UTF8String];
    struct ResultStruct *result = login(request_url, login_usernamepassword);
    char *cookie = result->cookie_list;
    char *session_id = result->session_id;
    NSString *response_cookie = [NSString stringWithUTF8String:cookie];
    NSString *cppcms_session = [NSString stringWithUTF8String:session_id];
    NSArray *cookie_array = [response_cookie componentsSeparatedByString:@"\t"];
    NSArray *cppcms_session_array = [cppcms_session componentsSeparatedByString:@"\t"];
    int cppcms_session_index = (int)[cppcms_session_array count]-1;
    int index = (int)[cookie_array count]-1;
    NSString *real_cookie = [cookie_array objectAtIndex:index];
    NSString *cppcms_session_id = [cppcms_session_array objectAtIndex:cppcms_session_index];
    NSMutableArray *cookie_mutable_array = [[NSMutableArray alloc] init];
    [cookie_mutable_array addObject:real_cookie];
    [cookie_mutable_array addObject:cppcms_session_id];
    [self savecookieToplist:cookie_mutable_array];
    char *json = result->memory;
    NSString *json_result = [NSString stringWithUTF8String:json];
    return [self.networkTools convert_json:json_result];
}

- (NSMutableDictionary *)write_comment:(int)joke_id
                               comment:(NSString *)comment
                                cookie:(NSString *)cookie
                               session:(NSString *)session
{
    NSString *post_cookie = [NSString stringWithFormat:@"usercode=%@;cppcms_session=%@", cookie, session];
    NSString *request_url = [NSString stringWithFormat:self.baseurl, @"write-comment"];
    NSString *comment_encode = [comment stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *data = [NSString stringWithFormat:@"comment=%@&joke_id=%d", comment_encode, joke_id];
    char *url = (char *)[request_url UTF8String];
    char *real_cookie = (char *)[post_cookie UTF8String];
    char *real_data = (char *)[data UTF8String];
    char *json = write_comment(url, real_cookie, real_data);
    NSString *json_result = [NSString stringWithUTF8String:json];
    return [self.networkTools convert_json:json_result];
}

//从plist中取出cookie
- (NSMutableArray *)getCookies
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistpath = [bundle pathForResource:@"cookie_list" ofType:@"plist"];
    NSMutableArray *cookies = [NSMutableArray arrayWithContentsOfFile:plistpath];
    return cookies;
}

//向plist中写入cookie
- (void)savecookieToplist:(NSMutableArray *)cookies
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistpath = [bundle pathForResource:@"cookie_list" ofType:@"plist"];
    [cookies writeToFile:plistpath atomically:YES];
}

@end