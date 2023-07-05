#ifndef __PUPPY_H__
#define __PUPPY_H__

#include <stddef.h>

typedef struct puppy_request_t puppy_request_t;
typedef struct puppy_response_t puppy_response_t;

typedef struct puppy_header_t {
  char* key;
  char* value;
} puppy_header_t;

#ifdef __cplusplus
extern "C" {
#endif

extern puppy_response_t* puppy_delete(const char* url, const puppy_header_t* headers, size_t headers_len, float timeout);
  
extern puppy_response_t* puppy_get(const char* url, const puppy_header_t* headers, size_t headers_len, float timeout);

extern puppy_response_t* puppy_patch(const char* url, const puppy_header_t* headers, size_t headers_len, const char* body, float timeout);
  
extern puppy_response_t* puppy_post(const char* url, const puppy_header_t* headers, size_t headers_len, const char* body, float timeout);

extern puppy_response_t* puppy_put(const char* url, const puppy_header_t* headers, size_t headers_len, const char* body, float timeout);

extern char* puppy_fetch_str(const char* url, const puppy_header_t* headers, size_t headers_len);

extern puppy_request_t* puppy_new_request(const char* url, const puppy_header_t* headers, size_t headers_len, float timeout);

extern puppy_response_t* puppy_fetch(puppy_request_t* req);

extern puppy_header_t* puppy_response_headers(puppy_response_t* res, size_t* out_len);

extern char* puppy_response_url(puppy_response_t* res);

extern char* puppy_response_body(puppy_response_t* res);

extern int puppy_response_code(puppy_response_t* res);

extern void puppy_request_set_body(puppy_request_t* req, const char* body);

extern void puppy_request_destroy(puppy_request_t* req);

extern void puppy_response_destroy(puppy_response_t* res);

extern void puppy_headers_destroy(puppy_header_t* headers, size_t headers_len);

#ifdef __cplusplus
}
#endif

#endif // __PUPPY_H__
