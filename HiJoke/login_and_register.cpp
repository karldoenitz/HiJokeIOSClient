//
//  login_and_register.c
//  YumNoteBook
//
//  Created by 李志豪 on 2/28/15.
//  Copyright (c) 2015 李志豪. All rights reserved.
//

#include "login_and_register.h"

char *b = new char[10];

static size_t WriteMemoryCallback(char *contents, size_t size, size_t nmemb, struct MemoryStruct *userp)
{
    size_t realsize = size * nmemb;
//    struct MemoryStruct *mem = (struct MemoryStruct *)userp;
    
//    mem->memory = realloc(mem->memory, mem->size + realsize + 1);
    userp->memory = contents;
    if(userp->memory == NULL) {
        /* out of memory! */
        printf("not enough memory (realloc returned NULL)\n");
        return 0;
    }
    
//    memcpy(&(mem->memory[mem->size]), contents, realsize);
//    mem->size += realsize;
//    mem->memory[mem->size] = 0;
    
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

struct ResultStruct *buyongle_login(char *usernamepassword)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    chunk->memory = new char[300];
    /* In windows, this will init the winsock stuff */
    curl_global_init(CURL_GLOBAL_ALL);
    
    /* get a curl handle */
    curl = curl_easy_init();
//    cookie_list->cookie_list = malloc(sizeof(char)*10);
    char *real_cookie;
    if(curl) {
        /* First set the URL that is about to receive our POST. This URL can
         just as well be a https:// URL if that is what should receive the
         data. */
        curl_easy_setopt(curl, CURLOPT_URL, "http://192.168.1.118:8008/rest/user_login");
        /* Now specify the POST data */
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, usernamepassword);//"user_name=hello&user_password=world"
        /* send all data to this function  */
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
        /* we pass our 'chunk' struct to the callback function */
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, chunk);
        /* just to start the cookie engine */
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        /* some servers don't like requests that are made without a user-agent
         field, so we provide one */
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "libcurl-agent/1.0");
        /* Perform the request, res will get the return code */
        res = curl_easy_perform(curl);
        
//        char *cookie = get_cookies(curl);
//        real_cookie = getrealcookie(cookie);
//        real_cookie = get_cookies(curl);
        
        /* Check for errors */
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n",
                    curl_easy_strerror(res));
        /* always cleanup */
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    struct ResultStruct *rs = new struct ResultStruct;
    rs->cookie_list = real_cookie;
    rs->memory = chunk->memory;
//    free(cookie_list->cookie_list);
//    free(cookie_list);
    return rs;
}

void freeResultStruct(struct ResultStruct *rs)
{
    free(rs->cookie_list);
    free(rs->memory);
    free(rs);
}

char *regist(char *usernamepassword)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    chunk->memory = new char[300];
    /* In windows, this will init the winsock stuff */
    curl_global_init(CURL_GLOBAL_ALL);
    
    /* get a curl handle */
    curl = curl_easy_init();
    if(curl) {
        /* First set the URL that is about to receive our POST. This URL can
         just as well be a https:// URL if that is what should receive the
         data. */
        curl_easy_setopt(curl, CURLOPT_URL, "http://192.168.1.118:8008/rest/user_register");
        /* Now specify the POST data */
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, usernamepassword);
        /* send all data to this function  */
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
        /* we pass our 'chunk' struct to the callback function */
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, chunk);
        /* just to start the cookie engine */
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        /* some servers don't like requests that are made without a user-agent
         field, so we provide one */
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "libcurl-agent/1.0");
        /* Perform the request, res will get the return code */
        res = curl_easy_perform(curl);
        /* Check for errors */
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n",
                    curl_easy_strerror(res));
        /* always cleanup */
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    return chunk->memory;
}

char *getrealcookie(char *cookie)
{
    char *realcookie = new char[100];
    int f,g;
    f = g = 0;
    for (int i=0; 1; i++) {
        if (cookie[i]=='\0') {
            break;
        }
        if (cookie[i]=='"') {
            f=i;
            g=i+1;
            continue;
        }
        if (g) {
            realcookie[g-1-f]=cookie[g];
            g++;
        }
        if (cookie[g]=='"') {
            realcookie[g-1-f]='\0';
            break;
        }
    }
    return realcookie;
}

char *getContentTitles(char *user_id, char *cookie)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    chunk->memory = new char[10000];
    /* In windows, this will init the winsock stuff */
    curl_global_init(CURL_GLOBAL_ALL);
    
    /* get a curl handle */
    curl = curl_easy_init();
    if(curl) {
        /* First set the URL that is about to receive our POST. This URL can
         just as well be a https:// URL if that is what should receive the
         data. */
        char *sss = new char[300];
        sprintf(sss, "http://192.168.1.118:8008/rest/user/get_content_title_list?user_id=%s",user_id);
        curl_easy_setopt(curl, CURLOPT_URL, sss);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_COOKIE, cookie);
        /* send all data to this function  */
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
        /* we pass our 'chunk' struct to the callback function */
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, chunk);
        /* just to start the cookie engine */
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        /* some servers don't like requests that are made without a user-agent
         field, so we provide one */
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "libcurl-agent/1.0");
        /* Perform the request, res will get the return code */
        res = curl_easy_perform(curl);
        /* Check for errors */
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n",
                    curl_easy_strerror(res));
        /* always cleanup */
        curl_easy_cleanup(curl);
        delete sss;
//        free(sss);
    }
    curl_global_cleanup();
    return chunk->memory;
}

char *getContent(char *url,char *user_id, char *cookie, char *title, char *contentdate)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    chunk->memory = new char[10000];
    /* In windows, this will init the winsock stuff */
    curl_global_init(CURL_GLOBAL_ALL);
    
    /* get a curl handle */
    curl = curl_easy_init();
    if(curl) {
        /* First set the URL that is about to receive our POST. This URL can
         just as well be a https:// URL if that is what should receive the
         data. */
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_COOKIE, cookie);
        /* send all data to this function  */
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
        /* we pass our 'chunk' struct to the callback function */
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, chunk);
        /* just to start the cookie engine */
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        /* some servers don't like requests that are made without a user-agent
         field, so we provide one */
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "libcurl-agent/1.0");
        /* Perform the request, res will get the return code */
        res = curl_easy_perform(curl);
        /* Check for errors */
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n",
                    curl_easy_strerror(res));
        /* always cleanup */
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
//    printf("%s", chunk.memory);
    return chunk->memory;
}
//--------------------------------------------
char *updateContent(char *cookie, char *data)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    chunk->memory = new char[200];
    /* In windows, this will init the winsock stuff */
    curl_global_init(CURL_GLOBAL_ALL);
    /* get a curl handle */
    curl = curl_easy_init();
    if(curl) {
        /* First set the URL that is about to receive our POST. This URL can
         just as well be a https:// URL if that is what should receive the
         data. */
        curl_easy_setopt(curl, CURLOPT_URL, "http://192.168.1.118:8008/rest/user/update_content");
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_COOKIE, cookie);
        /* send all data to this function  */
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
        /* we pass our 'chunk' struct to the callback function */
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, chunk);
        /* just to start the cookie engine */
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        /* some servers don't like requests that are made without a user-agent
         field, so we provide one */
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "libcurl-agent/1.0");
        /* Perform the request, res will get the return code */
        res = curl_easy_perform(curl);
        /* Check for errors */
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n",
                    curl_easy_strerror(res));
        /* always cleanup */
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    return chunk->memory;
}
//--------------------------------------------
char *addContent(char *cookie, char *data)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    chunk->memory = new char[200];
    /* In windows, this will init the winsock stuff */
    curl_global_init(CURL_GLOBAL_ALL);
    
    /* get a curl handle */
    curl = curl_easy_init();
    if(curl) {
        /* First set the URL that is about to receive our POST. This URL can
         just as well be a https:// URL if that is what should receive the
         data. */
        curl_easy_setopt(curl, CURLOPT_URL, "http://192.168.1.118:8008/rest/user/add_content");
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_COOKIE, cookie);
        /* send all data to this function  */
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
        /* we pass our 'chunk' struct to the callback function */
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, chunk);
        /* just to start the cookie engine */
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        /* some servers don't like requests that are made without a user-agent
         field, so we provide one */
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "libcurl-agent/1.0");
        /* Perform the request, res will get the return code */
        res = curl_easy_perform(curl);
        /* Check for errors */
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n",
                    curl_easy_strerror(res));
        /* always cleanup */
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    return chunk->memory;
}

// 获取评论
char *get_comment(char *url)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    chunk->memory = new char[2000];
    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, chunk);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "");
        curl_easy_setopt(curl, CURLOPT_USERAGENT, "libcurl-agent/1.0");
        res = curl_easy_perform(curl);
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    return chunk->memory;
}

// 写评论
char *write_comment(char *url, char *cookie, char *data)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    chunk->memory = new char[200];
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
        res = curl_easy_perform(curl);
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    return chunk->memory;
}

// 注册
char *user_register(char *url, char *usernamepassword)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    chunk->memory = new char[200];
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
        res = curl_easy_perform(curl);
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    return chunk->memory;
}


// 登录
struct ResultStruct *login(char *url, char *usernamepassword)
{
    CURL *curl;
    CURLcode res;
    struct MemoryStruct *chunk = new struct MemoryStruct;
    chunk->memory = new char[300];
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
        res = curl_easy_perform(curl);
        cookie = get_cookies(curl);
        if(res != CURLE_OK)
            fprintf(stderr, "curl_easy_perform() failed: %s\n",curl_easy_strerror(res));
        curl_easy_cleanup(curl);
    }
    curl_global_cleanup();
    struct ResultStruct *rs = new struct ResultStruct;
    rs->cookie_list = cookie->data;
    cookie = cookie->next;
    rs->session_id = cookie->data;
    rs->memory = chunk->memory;
    return rs;
}
