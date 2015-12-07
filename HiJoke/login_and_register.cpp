//
//  login_and_register.c
//  YumNoteBook
//
//  Created by 李志豪 on 2/28/15.
//  Copyright (c) 2015 李志豪. All rights reserved.
//

#include <iostream>
#include "login_and_register.h"

struct MemoryStruct {
    std::string memory;
    size_t size;
};

static size_t WriteMemoryCallback(char *contents, size_t size, size_t nmemb, struct MemoryStruct *userp)
{
    size_t realsize = size * nmemb;
    userp->memory.append(contents);
    return realsize;
}

curl_slist * get_cookies(CURL *curl)
{
    CURLcode res;
    struct curl_slist *cookies;
    printf("Cookies, curl knows:\n");
    res = curl_easy_getinfo(curl, CURLINFO_COOKIELIST, &cookies);
    if (res != CURLE_OK) {
        fprintf(stderr, "Curl curl_easy_getinfo failed: %s\n", curl_easy_strerror(res));
        exit(1);
    }
    return cookies;
}

// 获取评论
const char *get_comment(char *url)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, chunk);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "libcurl-agent/1.0");
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 5);
        res = curl_easy_perform(curl);
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    return chunk->memory.c_str();
}

// 写评论
const char *write_comment(char *url, char *cookie, char *data)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_COOKIE, cookie);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, chunk);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "libcurl-agent/1.0");
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 5);
        res = curl_easy_perform(curl);
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    return chunk->memory.c_str();
}

// 注册
const char *user_register(char *url, char *usernamepassword)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, usernamepassword);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, chunk);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "libcurl-agent/1.0");
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 5);
        res = curl_easy_perform(curl);
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    return chunk->memory.c_str();
}

// 登录
struct ResultStruct *login(char *url, char *usernamepassword)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();
    curl_slist *cookie;
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, usernamepassword);//"user_name=hello&user_password=world"
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, chunk);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "libcurl-agent/1.0");
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 5);
        res = curl_easy_perform(curl);
        cookie = get_cookies(curl);
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n",curl_easy_strerror(res));
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    struct ResultStruct *rs = new struct ResultStruct;
    if (cookie) {
        rs->cookie_list = cookie->data;
        cookie = cookie->next;
        rs->session_id = cookie->data;
    }
    rs->memory = chunk->memory.c_str();
    return rs;
}
