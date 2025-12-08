//
//  ModelType.swift
//  UnsplashCloneApp
//
//  Created by HYUN SUNG on 12/8/25.
//

import Foundation
import RxCocoa
import RxSwift

private var streams: [String: Any] = [:]

protocol ModelType: Codable {
    associatedtype Event
}

extension ModelType {
    static var event: PublishSubject<Event> {
        let key = String(describing: self)
        if let stream = streams[key] as? PublishSubject<Event> {
            return stream
        }
        let stream = PublishSubject<Event>()
        streams[key] = stream
        return stream
    }
}

protocol ModelNoneCodableType {
    associatedtype Event
}
extension ModelNoneCodableType {
    static var event: PublishSubject<Event> {
        let key = String(describing: self)
        if let stream = streams[key] as? PublishSubject<Event> {
            return stream
        }
        let stream = PublishSubject<Event>()
        streams[key] = stream
        return stream
    }
}
