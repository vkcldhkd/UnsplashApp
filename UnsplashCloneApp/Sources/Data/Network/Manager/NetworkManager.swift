//
//  NetworkManager.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/5/25.
//

import Foundation
import Alamofire
import RxSwift

final class NetworkManager {
    static private let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return Session(configuration: configuration)
    }()
}

extension NetworkManager {
    static func request(
        method: HTTPMethod,
        parameters: Parameters? = nil,
        url: String,
        headers: HTTPHeaders? = nil
    ) -> Observable<[String: Any]> {
        print("requestURL:\(url)")
        print("requestmethod:\(method)")

        return Observable.create { observer in
            let request = NetworkManager.session
                .request(
                    url,
                    method: method,
                    parameters: parameters,
                    encoding: URLEncoding.default,
                    headers: headers
                )
                .validate()
                .responseData { response in
                    switch response.result {
                    case let .success(data):
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])

                            if let dict = jsonObject as? [String: Any] {
                                // 응답이 Dictionary 형태인 경우
                                observer.onNext(dict)
                                observer.onCompleted()
                            } else if let array = jsonObject as? [[String: Any]],
                                      let first = array.first {
                                // 응답이 Array일 경우 → 첫 번째 Dictionary만 전달
                                observer.onNext(["items": array])
                                observer.onCompleted()
                            } else {
                                // Dictionary도, Dictionary 배열도 아닐 경우
                                let error = NSError(
                                    domain: "NetworkManager",
                                    code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "응답이 Dictionary 또는 Dictionary 배열 형태가 아닙니다."]
                                )
                                observer.onError(error)
                            }
                        } catch {
                            observer.onError(error)
                        }

                    case let .failure(error):
                        observer.onError(error)
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}
