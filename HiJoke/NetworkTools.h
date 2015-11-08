//
//  NetworkTools.h
//  HiJoke
//
//  Created by 李志豪 on 11/3/15.
//  Copyright © 2015 李志豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkTools : NSObject

- (NSMutableDictionary *)convert_json:(NSString *)json_string;

@end
