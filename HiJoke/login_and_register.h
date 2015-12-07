//
//  login_and_register.h
//  YumNoteBook
//
//  Created by 李志豪 on 2/28/15.
//  Copyright (c) 2015 李志豪. All rights reserved.
//

#ifndef __YumNoteBook__login_and_register__
#define __YumNoteBook__login_and_register__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "curl.h"

struct ResultStruct {
    char *memory;
    char *cookie_list;
    char *session_id;
};

struct MemoryStruct {
    char *memory;
    size_t size;
};

struct ResultStruct *login(char *url, char *usernamepassword);
char *get_comment(char *url);
char *user_register(char *url, char *usernamepassword);
char *write_comment(char *url, char *cookie, char *data);

#endif /* defined(__YumNoteBook__login_and_register__) */
