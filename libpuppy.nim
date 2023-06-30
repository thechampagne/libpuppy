import puppy

type
  puppy_request_t  = object
  puppy_response_t = object
  puppy_header_t   = object
    key  : ptr cchar
    value: ptr cchar

# Default timeout: 60
proc puppy_delete(url: cstring, headers: ptr puppy_header_t, headers_len: csize_t, timeout: cfloat): ptr puppy_response_t {.exportc.} =
  let res = create Response
  var seq: seq[Header] = @[]
  for i in 0 .. headers_len:
    let header = cast[ptr UncheckedArray[puppy_header_t]](headers)[i]
    seq.add(Header(key: $cast[cstring](header.key), value: $cast[cstring](header.value) ))
  res[] = try:
            puppy.delete($url, seq, timeout)
          except CatchableError:
            dealloc res
            return nil
  return cast[ptr puppy_response_t](res)

proc puppy_get(url: cstring, headers: ptr puppy_header_t, headers_len: csize_t, timeout: cfloat): ptr puppy_response_t {.exportc.} =
  let res = create Response
  var seq: seq[Header] = @[]
  for i in 0 .. headers_len:
    let header = cast[ptr UncheckedArray[puppy_header_t]](headers)[i]
    seq.add(Header(key: $cast[cstring](header.key), value: $cast[cstring](header.value) ))
  res[] = try:
            puppy.get($url, seq, timeout)
          except CatchableError:
            dealloc res
            return nil
  return cast[ptr puppy_response_t](res)

# proc puppy_head(url: cstring, headers: ptr puppy_header_t, headers_len: csize_t, timeout: cfloat): ptr puppy_response_t =
#   let res = create Response
#   var seq: seq[Header] = @[]
#   for i in 0 .. headers_len:
#     let header = cast[ptr UncheckedArray[puppy_header_t]](headers)[i]
#     seq.add(Header(key: $cast[cstring](header.key), value: $cast[cstring](header.value) ))
#   res[] = try:
#             puppy.head($url, seq, timeout)
#           except CatchableError:
#             dealloc res
#             return nil
#   return cast[ptr puppy_response_t](res)

proc puppy_patch(url: cstring, headers: ptr puppy_header_t, headers_len: csize_t, body: cstring, timeout: cfloat): ptr puppy_response_t {.exportc.} =
  let res = create Response
  var seq: seq[Header] = @[]
  for i in 0 .. headers_len:
    let header = cast[ptr UncheckedArray[puppy_header_t]](headers)[i]
    seq.add(Header(key: $cast[cstring](header.key), value: $cast[cstring](header.value) ))
  res[] = try:
            puppy.patch($url, seq, $body, timeout)
          except CatchableError:
            dealloc res
            return nil
  return cast[ptr puppy_response_t](res)

proc puppy_post(url: cstring, headers: ptr puppy_header_t, headers_len: csize_t, body: cstring, timeout: cfloat): ptr puppy_response_t {.exportc.} =
  let res = create Response
  var seq: seq[Header] = @[]
  for i in 0 .. headers_len:
    let header = cast[ptr UncheckedArray[puppy_header_t]](headers)[i]
    seq.add(Header(key: $cast[cstring](header.key), value: $cast[cstring](header.value) ))
  res[] = try:
            puppy.post($url, seq, $body, timeout)
          except CatchableError:
            dealloc res
            return nil
  return cast[ptr puppy_response_t](res)

proc puppy_put(url: cstring, headers: ptr puppy_header_t, headers_len: csize_t, body: cstring, timeout: cfloat): ptr puppy_response_t {.exportc.} =
  let res = create Response
  var seq: seq[Header] = @[]
  for i in 0 .. headers_len:
    let header = cast[ptr UncheckedArray[puppy_header_t]](headers)[i]
    seq.add(Header(key: $cast[cstring](header.key), value: $cast[cstring](header.value) ))
  res[] = try:
            puppy.put($url, seq, $body, timeout)
          except CatchableError:
            dealloc res
            return nil
  return cast[ptr puppy_response_t](res)

proc puppy_fetch_str(url: cstring, headers: ptr puppy_header_t, headers_len: csize_t): ptr cchar {.exportc.} =
  var seq: seq[Header] = @[]
  for i in 0 .. headers_len:
    let header = cast[ptr UncheckedArray[puppy_header_t]](headers)[i]
    seq.add(Header(key: $cast[cstring](header.key), value: $cast[cstring](header.value) ))
  let res = try:
            puppy.fetch($url, seq)
          except CatchableError:
            return nil
  var cstr = cast[ptr cchar](alloc((sizeof(cchar) * res.len) + 1))
  copyMem(cstr, cast[pointer](unsafeAddr res), res.len)
  cast[ptr UncheckedArray[cchar]](cstr)[res.len] = '\0'
  return cstr

proc puppy_new_request(url: cstring, verb: cstring, headers: ptr puppy_header_t, headers_len: csize_t, timeout: cfloat): ptr puppy_request_t {.exportc.} =
  let req = create Request
  var seq: seq[Header] = @[]
  for i in 0 .. headers_len:
    let header = cast[ptr UncheckedArray[puppy_header_t]](headers)[i]
    seq.add(Header(key: $cast[cstring](header.key), value: $cast[cstring](header.value) ))
  req[] = try:
            puppy.newRequest($url, $verb, seq, timeout)
          except CatchableError:
            dealloc req
            return nil
  return cast[ptr puppy_request_t](req)

proc puppy_fetch(req: ptr puppy_request_t): ptr puppy_response_t {.exportc.} =
  let req_nim = cast[ptr Request](req)
  let res = create Response
  res[] = try:
            puppy.fetch(req_nim[])
          except CatchableError:
            dealloc res
            return nil
  return cast[ptr puppy_response_t](res)

proc puppy_response_headers(res: ptr puppy_response_t, out_len: ptr csize_t): ptr puppy_header_t {.exportc.} =
  let res_nim = cast[ptr Response](res)
  let headers = res_nim[].headers
  var carray = cast[ptr puppy_header_t](alloc(sizeof(puppy_header_t) * headers.len))
  for i, v in headers:
    let h = cast[Header](v)
    var key = cast[ptr cchar](alloc((sizeof(cchar) * h.key.len) + 1))
    copyMem(key, cast[pointer](unsafeAddr h.key), h.key.len)
    cast[ptr UncheckedArray[cchar]](key)[h.key.len] = '\0'
    var value = cast[ptr cchar](alloc((sizeof(cchar) * h.value.len) + 1))
    copyMem(value, cast[pointer](unsafeAddr h.value), h.value.len)
    cast[ptr UncheckedArray[cchar]](value)[h.value.len] = '\0'
    let header = puppy_header_t(key: key, value: value )
    cast[ptr UncheckedArray[puppy_header_t]](carray)[i] = header
  out_len[] = csize_t(headers.len)
  return carray

proc puppy_response_url(res: ptr puppy_response_t): ptr cchar {.exportc.} =
  let res_nim = cast[ptr Response](res)
  let url = res_nim[].url
  var cstr = cast[ptr cchar](alloc((sizeof(cchar) * url.len) + 1))
  copyMem(cstr, cast[pointer](unsafeAddr url), url.len)
  cast[ptr UncheckedArray[cchar]](cstr)[url.len] = '\0'
  return cstr

proc puppy_response_body(res: ptr puppy_response_t): ptr cchar {.exportc.} =
  let res_nim = cast[ptr Response](res)
  let body = res_nim[].body
  var cstr = cast[ptr cchar](alloc((sizeof(cchar) * body.len) + 1))
  copyMem(cstr, cast[pointer](unsafeAddr body), body.len)
  cast[ptr UncheckedArray[cchar]](cstr)[body.len] = '\0'
  return cstr

proc puppy_response_code(res: ptr puppy_response_t): c_int {.exportc.} =
  let res_nim = cast[ptr Response](res)
  return c_int(res_nim[].code)

proc puppy_request_set_body(req: ptr puppy_request_t, body: cstring) {.exportc.} =
  let req_nim = cast[ptr Request](req)
  req_nim[].body = $body
