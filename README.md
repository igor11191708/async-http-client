# Async/await http client using new concurrency model in Swift

Network layer for running requests like GET, POST, PUT, DELETE etc customizable with coders. Thre's ability to retry request with exponential backoff strategy if one fails.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fasync-http-client%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/The-Igor/async-http-client)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fasync-http-client%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/The-Igor/async-http-client)

## Features
- [x] Multiplatform
- [x] Stand alone package without any dependencies using just Apple's  facilities
- [x] Set up amount of attempts(retry) with **"Exponential backoff"** or **"Constant backoff"** strategy if request fails. Exponential backoff is a strategy in which you increase the delays between retries. Constant backoff is a strategy when delay between retries is a constant value
- [x] Customizable for different requests schemes from classic **CRUD Rest** to what suits to you
- [x] Customizable in terms of URLSession
- [x] Customizable in terms of URLSessionTaskDelegate, URLSessionDelegate
- [x] Based on interfaces not implementations
- [x] Customizable with coders You can easily change format from json to xml or text just changing the coder

 ![Http requests](https://github.com/The-Igor/async-http-client-example/blob/main/async-http-client-example/img/image11.gif) 

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
    ///   - retry: ``RetryService.Strategy`` Default value .exponential with 5 retry and duration 2.0 sec
    ///   - taskDelegate: A protocol that defines methods that URL session instances call on their delegates to handle task-level events
    public func send<T>(
        with request : URLRequest,
        retry strategy : RetryService.Strategy,
        _ taskDelegate: ITaskDelegate? = nil
    ) async throws -> Http.Response<T> where T : Decodable
```

## Retry strategy

This package uses stand alone package providing retry policy. The service creates sequence of the delays (nanoseconds) according to chosen strategy for more details foloe the link [retry service](https://github.com/The-Igor/retry-policy-service) 

| type | description |
| --- | --- |
| constant | The strategy implements constant backoff  |
| exponential [default] | The strategy implements exponential backoff  |



# The concept

* Proxy is defining a communication layer and responsible for exchanging data with data source. There might be Http proxy, File proxy etc or some flavors REST proxy, LongFile proxy.
* Reader and Writer are used to interpret data.

 ![The concept](https://github.com/The-Igor/async-http-client/blob/main/img/concept.png) 
 

## Try it in the real environment
### Simple server installation (mocking with NodeJS Express)

To try it in the real environment. I suggest installing the basic NodeJS Express boilerplate. Take a look on the video snippet how easy it is to get it through Webstorm that is accessible for free for a trial period.

[![Server instalation (NodeJS Express)](https://github.com/The-Igor/d3-network-service/blob/main/img/server_install.png)](https://youtu.be/9FPOYHzcE7A)

- Get [**WebStorm Early Access**](https://www.jetbrains.com/webstorm/nextversion)
- Get [**index.js**](https://github.com/The-Igor/d3-network-service/blob/main/js/index.js) file from here and replace it with the one in the boilerplate and launch the server.

## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)
- Go to Product > Build Documentation or **⌃⇧⌘ D**

## SwiftUI example for the package

[Async http client example](https://github.com/The-Igor/async-http-client-example)
