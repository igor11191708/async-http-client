# Async/await http client using new concurrency model in Swift

Easy and lightweight network layer for creating different set of network requests like GET, POST, PUT, DELETE etc customizable with coders

## Features
- [x] Stand alone package without any dependencies using just Apple's  facilities
- [x] Customizable for different requests schemes from classic **CRUD Rest** to what suits to you
- [x] Customizable in term of session
- [x] Customizable in terms of URLSessionTaskDelegate, URLSessionDelegate
- [x] Based on interfaces not implementations
- [x] Customizable with coders You can easily change format from json to xml or text just changing the coder

## 1. Create
```swift
    let url = URL(string: "http://localhost:3000")
    let http = Http.Proxy(baseURL: url)
```

## 2. Use

### GET
```swift
    try await http.get(path: path)
```        

### POST
```swift
    try await http.post(
                        path: path, 
                        body: data, 
                        query: [("name", "Igor"), ("page","1")], 
                        headers: ["Content-Type": "application/json"])
``` 

### POST with Delegate collecting metrics
```swift
    try await http.post(path: path, taskDelegate: DelegatePickingUpMetrics())
```
                 
### PUT
```swift
    try await http.put(path: path, body: data)
```

### DELETE
```swift
    try await http.delete(path: path)
```

### Custom request

```swift
        public func send<T>(
            with request : URLRequest,
            _ taskDelegate: URLSessionTaskDelegate? = nil) async throws
        -> Http.Response<T> where T : Decodable
```

## Try it in the real environment
### Simple server installation (mocking with NodeJS Express)

To try it in the real environment. I suggest installing the basic NodeJS Express boilerplate. Take a look on the video snippet how easy it is to get it through Webstorm that is accessible for free for a trial period.

[![Server instalation (NodeJS Express)](https://github.com/The-Igor/d3-network-service/blob/main/img/server_install.png)](https://youtu.be/9FPOYHzcE7A)

- Get [**WebStorm Early Access**](https://www.jetbrains.com/webstorm/nextversion)
- Get [**index.js**](https://github.com/The-Igor/d3-network-service/blob/main/js/index.js) file from here and replace it with the one in the boilerplate and launch the server.

### Real SwiftUI example
[d3-rest-combine-swift-example](https://github.com/The-Igor/d3-rest-combine-swift-example)
- Run server *NodeJS Express*
- Run SwiftUI project

## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)
- Go to Product > Build Documentation or **⌃⇧⌘ D**
