//
//  StreamersAPIService.swift
//  ChessStreamersSwiftUI
//
//  Created by Sebastian Strus on 2022-08-23.
//

import Foundation
import Combine

class StreamersAPIService {
    fileprivate static var _shared: StreamersAPIService!
    public static var shared: StreamersAPIService {
        get {
            if _shared == nil {
                _shared = StreamersAPIService()
            }

            return _shared
        }
    }

    public static func getStreamers() -> AnyPublisher<[String:[Streamer]], Error>{
        let url = "\(Properties.environment.rawValue)/pub/streamers"
        return makeRequest(method: .get, url: url)
    }

    // MARK: - Http requests
    private struct HttpResponse<T> {
        let value: T
        let response: URLResponse
    }

    private enum HttpMethod : String {
        case post = "POST"
        case get = "GET"
        case delete = "DELETE"
        case put = "PUT"
    }

    private static func makeRequest<Response: Decodable>(method: HttpMethod,
                                                         url: String, body: Data? = nil,
                                                         headers: [String : String]? = nil,
                                                         responseHandler: ((URLSession.DataTaskPublisher.Output) -> HttpResponse<Response>)? = nil) -> AnyPublisher<Response, Error> {
        if let url = URL(string: url)  {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            if let body = body {
                request.httpBody = body
            }
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            if let headers = headers {
                for (key,value) in headers {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            return StreamersAPIService.request(request, responseHandler: responseHandler)
                .map(\.value)
                .eraseToAnyPublisher()
        } else {
            return Result.failure(GeneralError.unknown).publisher.eraseToAnyPublisher()
        }
    }

    private static func request<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder(), responseHandler: ((URLSession.DataTaskPublisher.Output) -> HttpResponse<T>)? = nil) -> AnyPublisher<HttpResponse<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> HttpResponse<T> in
                if let handler = responseHandler {
                    return handler(result)
                }
                let value = try decoder.decode(T.self, from: result.data)
                return HttpResponse(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private static func makeSubjectRequest<Response: Decodable>(method: HttpMethod,
                                                         url: String, body: Data? = nil,
                                                         headers: [String : String]? = nil,
                                                         responseHandler: ((URLSession.DataTaskPublisher.Output) -> HttpResponse<Response>)? = nil,
                                                         subject: PassthroughSubject<Response, Error>) {
        if let url = URL(string: url)  {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            if let body = body {
                request.httpBody = body
            }
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            if let headers = headers {
                for (key,value) in headers {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
        } else {
            subject.send(completion: .failure(GeneralError.invalidAddress))
        }
    }

    private static func error<Response: Codable>(_ error: Error) -> AnyPublisher<Response, Error> {
        return Result.failure(error).publisher.eraseToAnyPublisher()
    }
}

//extension HTTPURLResponse {
//
//    var isSuccess: Bool {
//        200...299 ~= self.statusCode
//    }
//
//    var error : Error {
//        switch statusCode {
//        case 401:
//            return GeneralError.unknown
//        default:
//            return GeneralError.unknown
//        }
//    }
//
//}
