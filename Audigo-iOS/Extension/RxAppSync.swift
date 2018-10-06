//
//  RxAppSync.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import RxSwift
import AWSAppSync

public enum RxAppSyncError: Error {
  case graphQLErrors([GraphQLError])
}

public final class AppSyncReactiveExtensions {
  private let client: AWSAppSyncClient

  fileprivate init(_ client: AWSAppSyncClient) {
    self.client = client
  }

  public func fetch<Query: GraphQLQuery>(
    query: Query,
    cachePolicy: CachePolicy = .returnCacheDataElseFetch,
    queue: DispatchQueue = DispatchQueue.main) -> Maybe<Query.Data> {
    return Maybe.create { maybe in
      let cancellable = self.client.fetch(query: query, cachePolicy: cachePolicy, queue: queue) { result, error in
        if let error = error {
          maybe(.error(error))
        } else if let errors = result?.errors {
          maybe(.error(RxAppSyncError.graphQLErrors(errors)))
        } else if let data = result?.data {
          maybe(.success(data))
        } else {
          maybe(.completed)
        }
      }

      return Disposables.create {
        cancellable.cancel()
      }
    }
  }

  public func watch<Query: GraphQLQuery>(
    query: Query,
    cachePolicy: CachePolicy = .returnCacheDataElseFetch,
    queue: DispatchQueue = DispatchQueue.main) -> Observable<Query.Data> {
    return Observable.create { observer in
      let watcher = self.client.watch(query: query, cachePolicy: cachePolicy, queue: queue) { result, error in
        if let error = error {
          observer.onError(error)
        } else if let errors = result?.errors {
          observer.onError(RxAppSyncError.graphQLErrors(errors))
        } else if let data = result?.data {
          observer.onNext(data)
        }
      }

      return Disposables.create {
        watcher.cancel()
      }
    }
  }
  
  public func perform<Mutation: GraphQLMutation>(mutation: Mutation, queue: DispatchQueue = DispatchQueue.main) -> Maybe<Mutation.Data> {
    return Maybe.create { maybe in
      self.client.perform(mutation: mutation, queue: queue) { result, error in
        if let error = error {
          maybe(.error(error))
        } else if let errors = result?.errors {
          maybe(.error(RxAppSyncError.graphQLErrors(errors)))
        } else if let data = result?.data {
          maybe(.success(data))
        } else {
          maybe(.completed)
        }
      }
      
      return Disposables.create()
    }
  }
}

public extension AWSAppSyncClient {
  var rx: AppSyncReactiveExtensions { return AppSyncReactiveExtensions(self) }
}
