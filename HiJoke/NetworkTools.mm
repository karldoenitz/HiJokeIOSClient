//
//  NetworkTools.m
//  HiJoke
//
//  Created by 李志豪 on 11/3/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import "NetworkTools.h"

@implementation NetworkTools

-(NSMutableDictionary *)convert_json:(NSString *)json_string
{
    NSError *error;
    NSData *json_data = [json_string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *json_dict = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingMutableContainers error:&error];
    return json_dict;
}

@end
