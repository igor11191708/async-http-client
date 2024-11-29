# Async/await http client using new concurrency model in Swift

Network layer for running requests like GET, POST, PUT, DELETE etc customizable with coders. There's ability to retry request with different strategies

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswiftuiux%2Fasync-http-client%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/swiftuiux/async-http-client)

## [Documentation(API)](https://swiftpackageindex.com/swiftuiux/async-http-client/main/documentation/async_http_client)
or
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)
- Go to Product > Build Documentation or **⌃⇧⌘ D**

## [SwiftUI example](https://github.com/swiftuiux/async-http-client-example)

## Features
- [x] Multiplatform
- [x] You have fast-track functions to make requests immediately by url or build the infrastructure configuration that suits you
- [x] Stand alone package without any dependencies using just Apple's  facilities
- [x] Set up amount of attempts(retry) with **"Exponential backoff"** or **"Constant backoff"** strategy if request fails. Exponential backoff is a strategy in which you increase the delays between retries. Constant backoff is a strategy when delay between retries is a constant value
- [x] Different strategies to validate URLResponse
- [x] Customizable for different requests schemes from classic **CRUD Rest** to what suits to you
- [x] Customizable in terms of URLSession
- [x] Customizable in terms of URLSessionTaskDelegate, URLSessionDelegate
- [x] Based on interfaces not implementations
- [x] Customizable with coders You can easily change format from json to xml or text just changing the coder

 ![Http requests](https://github.com/swiftuiux/async-http-client-example/blob/main/async-http-client-example/img/image11.gif) 

## Fast track

## 1. Use
```swift
   try await Http.Get.from(url, retry: 5, validate: [.status(200)])
```
```swift
   try await Http.Post.from(url, taskDelegate : TaskDelegate())
```

```swift
   try await Http.Put.from(url, body: data)
```

```swift
   try await Http.Delete.from(url)
```

Fast-track functions return **(Data, URLResponse)** if you need to validate status code you can use **func** *validateStatus* check different strategies **Http.Validate.Status**

```swift
        let (data, response) = try await Http.Get.from(url)
        let rule : Http.Validate.Status = .range(200..<300)
        try validateStatus(response, by: rule)
```

## Extended track

## 1. Create
```swift
    let url = URL(string: "http://localhost:3000")
    let http = Http.Proxy(baseURL: url)
```

### with custom configuration
```swift
      let cfg = Http.Configuration(
                    reader: SomeReader(),
                    writer: SomeWriter(),
                    baseURL: baseURL,
                    session: session)
     let http = Http.Proxy(config: cfg)
```


## 2. Use

### GET
```swift
    try await http.get(path: "users")
```        

### GET with retry
```swift
    try await http.get(path: "users", retry  : 5)
``` 

### GET with validate status code 200..<300
```swift
    try await http.get(path: "users", validate: [.status(.range(200..<300))])
```    

### POST
```swift
    try await http.post(
                        path: "users", 
                        body: data, 
                        query: [("name", "Igor"), ("page","1")], 
                        headers: ["Content-Type": "application/json"])
``` 

### POST with Delegate collecting metrics
```swift
    try await http.post(path: "users", taskDelegate: DelegatePickingUpMetrics())
```
                 
### PUT
```swift
    try await http.put(path: "users", body: data)
```

### DELETE
```swift
    try await http.delete(path: "users")
```

### Custom request

```swift
        public func send<T>(
            with request : URLRequest,
            retry strategy : RetryService.Strategy = .exponential(),
            _ validate : [Http.Validate] = [.status(200)],
            _ taskDelegate: ITaskDelegate? = nil
        ) async throws -> Http.Response<T> where T : Decodable
```

## Retry strategy

This package uses stand alone package providing retry policy. The service creates sequence of the delays (nanoseconds) according to chosen strategy for more details folow the link [retry service](https://github.com/swiftuiux/retry-policy-service) 

| type | description |
| --- | --- |
| constant | The strategy implements constant backoff  |
| exponential [default] | The strategy implements exponential backoff  |

## Validate
Is an array of different rules to check URLResponse.
Currently is implemented for validating status code.

### Status code
| type | description |
| --- | --- |
| const(Int) [default] 200 | Validate by exact value  |
| range(Range<Int>) [default] 200..<300 | Validate by range  |
| predicate(Predicate) | Validate by predicate func if you need some specific processing logic |
| check(ErrorFn) | Check status and return custom error if status is not valid |
#### By range
```swift
    try await http.get(path: path, validate: [.status(.range(200..<300))])
```

#### By predicate
```swift
    let fn : (Int) -> Bool = { status in status == 201 }
    
    try await http.get(path: path, validate: [.status(.predicate(fn))])
```

There's an example [replicate toolkit for swift](https://github.com/swiftuiux/replicate-kit-swift) how to use it with a custom response error format that has different format then the successful response

# The concept

* Proxy is defining a communication layer and responsible for exchanging data with data source. There might be Http proxy, File proxy etc or some flavors REST proxy, LongFile proxy.
* Reader and Writer are used to interpret data.

 ![The concept](https://github.com/swiftuiux/async-http-client/blob/main/img/concept.png) 
 

## Try it in the real environment
### Simple server installation (mocking with NodeJS Express)

To try it in the real environment. I suggest installing the basic NodeJS Express boilerplate. Take a look on the video snippet how easy it is to get it through Webstorm that is accessible for free for a trial period.

[![Server installation (NodeJS Express)](https://github.com/swiftuiux/d3-network-service/blob/main/img/server_install.png)](https://youtu.be/9FPOYHzcE7A)

- Get [**WebStorm Early Access**](https://www.jetbrains.com/webstorm/nextversion)
- Get [**index.js**](https://github.com/swiftuiux/d3-network-service/blob/main/js/index.js) file from here and replace it with the one in the boilerplate and launch the server.


## Used by packages

[Replicate toolkit for swift](https://github.com/swiftuiux/replicate-kit-swift)
