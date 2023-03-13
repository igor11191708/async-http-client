# Async/await http client using new concurrency model in Swift

Network layer for running requests like GET, POST, PUT, DELETE etc customizable with coders. There's ability to retry request with different strategies

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fasync-http-client%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/The-Igor/async-http-client)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fasync-http-client%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/The-Igor/async-http-client)

## Features
- [x] Multiplatform
- [x] You have fast-track functions to make requests immediately by url or build the infrastructure configuration that suits you
- [x] Stand alone package without any dependencies using just Apple's  facilities
- [x] Set up amount of attempts(retry) with **"Exponential backoff"** or **"Constant backoff"** strategy if request fails. Exponential backoff is a strategy in which you increase the delays between retries. Constant backoff is a strategy when delay between retries is a constant value
- [x] Different strategies to validate Data or URLResponse
- [x] Customizable for different requests schemes from classic **CRUD Rest** to what suits to you
- [x] Customizable in terms of URLSession
- [x] Customizable in terms of URLSessionTaskDelegate, URLSessionDelegate
- [x] Based on interfaces not implementations
- [x] Customizable with coders You can easily change format from json to xml or text just changing the coder

 ![Http requests](https://github.com/The-Igor/async-http-client-example/blob/main/async-http-client-example/img/image11.gif) 

## Fast track

## 1. Use
```swift
   try await Http.Get.from(url, retry: 5)
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

Fast-track functions return **(Data, URLResponse)** if you need to validate status code you can use check different strategies **Http.Validate.Status**

```swift
        let (data, response) = try await Http.Get.from(url)
        let rule : [Http.Validate.Status] = [.range(200..<300)]
        try validateStatus(response, by: rule)
```

## Extended track

## 1. Create
```swift
    let url = URL(string: "http://localhost:3000")
    let http = Http.Proxy(baseURL: url)
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
        /// Send custom request based on the specific request instance
        /// - Parameters:
        ///   - request: A URL load request that is independent of protocol or URL scheme
        ///   - retry: ``RetryService.Strategy`` strategy Default value .exponential with 5 retry and duration 2.0
        ///   - validate: Set of custom validate fun ``Http.Validate`` For status code like an  example Default value to validate statusCode == 200 You can set up diff combinations check out ``Http.Validate.Status``
        ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
        public func send<T>(
            with request : URLRequest,
            retry strategy : RetryService.Strategy = .exponential(),
            _ validate : [Http.Validate] = [.status(.const(200))],
            _ taskDelegate: ITaskDelegate? = nil
        ) async throws -> Http.Response<T> where T : Decodable
```

## Retry strategy

This package uses stand alone package providing retry policy. The service creates sequence of the delays (nanoseconds) according to chosen strategy for more details foloe the link [retry service](https://github.com/The-Igor/retry-policy-service) 

| type | description |
| --- | --- |
| constant | The strategy implements constant backoff  |
| exponential [default] | The strategy implements exponential backoff  |

## Validate
Is an array of different rules to check Data or URLResponse.
Currently is implemented for status code. You can pass to the validate array different combinations to validate like for status code 200 and 202..<205

### Status code
| type | description |
| --- | --- |
| const(Int) [default] 200 | Validate by exact value  |
| range(Range<Int>) | Validate by range  |
| predicate(Predicate) | Validate by predicate func if you need some specific precessing logic |

#### By range
```swift

    try await http.get(path: path, validate: [.status(.range(200..<300))])

```

#### By predicate
```swift

    let fn : (Int) -> Bool = { status in status == 201 }
    
    try await http.get(path: path, validate: [.status(.predicate(fn))])
```

# The concept

* Proxy is defining a communication layer and responsible for exchanging data with data source. There might be Http proxy, File proxy etc or some flavors REST proxy, LongFile proxy.
* Reader and Writer are used to interpret data.

 ![The concept](https://github.com/The-Igor/async-http-client/blob/main/img/concept.png) 
 

## Try it in the real environment
### Simple server installation (mocking with NodeJS Express)

To try it in the real environment. I suggest installing the basic NodeJS Express boilerplate. Take a look on the video snippet how easy it is to get it through Webstorm that is accessible for free for a trial period.

[![Server installation (NodeJS Express)](https://github.com/The-Igor/d3-network-service/blob/main/img/server_install.png)](https://youtu.be/9FPOYHzcE7A)

- Get [**WebStorm Early Access**](https://www.jetbrains.com/webstorm/nextversion)
- Get [**index.js**](https://github.com/The-Igor/d3-network-service/blob/main/js/index.js) file from here and replace it with the one in the boilerplate and launch the server.

## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)
- Go to Product > Build Documentation or **⌃⇧⌘ D**

## SwiftUI example for the package

[Async http client example](https://github.com/The-Igor/async-http-client-example)

## Used by packages

[Replicate toolkit for swift](https://github.com/The-Igor/replicate-kit-swift)
There's an example how to use it with a custom JSONReader and processing a custom response Error format
