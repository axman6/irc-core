#ifndef GLIRC_API
#define GLIRC_API

#include <stdlib.h>

enum message_code {
        NORMAL_MESSAGE = 0,
        ERROR_MESSAGE  = 1
};

enum process_result {
        PASS_MESSAGE = 0,
        DROP_MESSAGE = 1
};

struct glirc_string {
        const char *str;
        size_t len;
};

struct glirc_message {
        struct glirc_string network;
        struct glirc_string prefix_nick;
        struct glirc_string prefix_user;
        struct glirc_string prefix_host;
        struct glirc_string command;
        struct glirc_string *params;
        size_t params_n;
        struct glirc_string *tagkeys;
        struct glirc_string *tagvals;
        size_t tags_n;
};

struct glirc_command {
        struct glirc_string *params;
        size_t params_n;
};

typedef void *start_type         (void *glirc, const char *path);
typedef void stop_type           (void *glirc, void *S);
typedef enum process_result process_message_type(void *glirc, void *S, const struct glirc_message *);
typedef void process_command_type(void *glirc, void *S, const struct glirc_command *);

struct glirc_extension {
        char *name;
        int major_version, minor_version;
        start_type           *start;
        stop_type            *stop;
        process_message_type *process_message;
        process_command_type *process_command;
};

int glirc_send_message(void *glirc, const struct glirc_message *);
int glirc_print(void *glirc, enum message_code, struct glirc_string msg);
char ** glirc_list_networks(void *glirc);
char ** glirc_list_channels(void *glirc, struct glirc_string network);
char ** glirc_list_channel_users(void *glirc, struct glirc_string network, struct glirc_string channel);
char * glirc_my_nick(void *glirc, struct glirc_string network);
void glirc_mark_seen(void *glirc, struct glirc_string network, struct glirc_string channel);
void glirc_clear_window(void *glirc, struct glirc_string network, struct glirc_string channel);
int glirc_identifier_cmp(struct glirc_string s, struct glirc_string t);

#endif
