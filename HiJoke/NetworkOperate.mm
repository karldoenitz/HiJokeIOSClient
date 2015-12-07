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
    self.baseurl = @"http://107.191.61.114:8888/%@";
    self.networkTools = [[NetworkTools alloc] init];
    return self;
}

- (NSMutableDictionary *)get_comment:(int)joke_id
{
    NSString *url = [NSString stringWithFormat:@"get-comment/?joke_id=%d", joke_id];
    NSString *request_url = [NSString stringWithFormat:self.baseurl, url];
    const char *json = get_comment((char *)[request_url UTF8String]);
    NSString *result = [NSString stringWithUTF8String:json];
    return [self.networkTools convert_json:result];
}

- (NSMutableDictionary *)regist:(NSString *)username
                       password:(NSString *)password
{
    char *request_url = (char *)[[NSString stringWithFormat:self.baseurl, @"register/"] UTF8String];
    NSString *usernamepassword = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    char *regist_usernamepassword = (char *)[usernamepassword UTF8String];
    const char *json = user_register(request_url, regist_usernamepassword);
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
    const char *json = result->memory;
    NSString *json_result = [NSString stringWithUTF8String:json];
    NSMutableDictionary *response_result = [self.networkTools convert_json:json_result];
    if ([[response_result objectForKey:@"result"] isEqualToString:@"login success"]) {
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
    }
    return response_result;
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
    const char *json = write_comment(url, real_cookie, real_data);
    NSString *json_result = [NSString stringWithUTF8String:json];
    return [self.networkTools convert_json:json_result];
}

- (NSMutableDictionary *)write_joke:(NSString *)title
                            content:(NSString *)content
                             cookie:(NSString *)cookie
                            session:(NSString *)session
{
    NSString *cookie_session = [NSString stringWithFormat:@"usercode=%@;cppcms_session=%@", cookie, session];
    NSString *origin_post_data = [NSString stringWithFormat:@"title=%@&content=%@", title, content];
    NSString *data = [origin_post_data stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *request_url = [NSString stringWithFormat:self.baseurl, @"write-joke"];
    char *post_cookie = (char *)[cookie_session UTF8String];
    char *post_data = (char *)[data UTF8String];
    char *url = (char *)[request_url UTF8String];
    const char *json = write_comment(url, post_cookie, post_data);
    NSString *json_string = [NSString stringWithUTF8String:json];
    return [self.networkTools convert_json:json_string];
}

- (NSMutableDictionary *)get_joke_list:(int)page_number
{
    int start_number = (page_number - 1)*10;
    int length = 10;
    NSString *request_uri = [NSString stringWithFormat:@"jokes?start_index=%d&length=%d", start_number, length];
    NSString *request_url = [NSString stringWithFormat:self.baseurl, request_uri];
    char *url = (char *)[request_url UTF8String];
    const char *json = get_comment(url);
    NSString *json_string = [NSString stringWithUTF8String:json];
    return [self.networkTools convert_json:json_string];
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

//写入缓存
- (void)saveCache:(NSMutableArray *)cache
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistpath = [bundle pathForResource:@"cache_list" ofType:@"plist"];
    [cache writeToFile:plistpath atomically:YES];
}

//读取缓存
- (NSMutableArray *)getCache
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistpath = [bundle pathForResource:@"cache_list" ofType:@"plist"];
    NSMutableArray *cache = [NSMutableArray arrayWithContentsOfFile:plistpath];
    return cache;
}

//判断网络是否连接
- (BOOL)isConnectInternet
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

@end
