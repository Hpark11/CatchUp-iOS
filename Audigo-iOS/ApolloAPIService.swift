//  This file was automatically generated and should not be edited.

import Apollo

public final class AddPromiseMutation: GraphQLMutation {
  public static let operationString =
    "mutation AddPromise($owner: String, $name: String, $address: String, $latitude: Float, $longitude: Float, $pockets: [String]) {\n  addPromise(owner: $owner, name: $name, address: $address, latitude: $latitude, longitude: $longitude, pockets: $pockets) {\n    __typename\n    id\n    name\n    address\n    latitude\n    longitude\n    timestamp\n    pockets {\n      __typename\n      nickname\n      token\n      profileImagePath\n      phone\n    }\n  }\n}"

  public var owner: String?
  public var name: String?
  public var address: String?
  public var latitude: Double?
  public var longitude: Double?
  public var pockets: [String?]?

  public init(owner: String? = nil, name: String? = nil, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil, pockets: [String?]? = nil) {
    self.owner = owner
    self.name = name
    self.address = address
    self.latitude = latitude
    self.longitude = longitude
    self.pockets = pockets
  }

  public var variables: GraphQLMap? {
    return ["owner": owner, "name": name, "address": address, "latitude": latitude, "longitude": longitude, "pockets": pockets]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("addPromise", arguments: ["owner": GraphQLVariable("owner"), "name": GraphQLVariable("name"), "address": GraphQLVariable("address"), "latitude": GraphQLVariable("latitude"), "longitude": GraphQLVariable("longitude"), "pockets": GraphQLVariable("pockets")], type: .object(AddPromise.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(addPromise: AddPromise? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "addPromise": addPromise.flatMap { $0.snapshot }])
    }

    public var addPromise: AddPromise? {
      get {
        return (snapshot["addPromise"] as? Snapshot).flatMap { AddPromise(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "addPromise")
      }
    }

    public struct AddPromise: GraphQLSelectionSet {
      public static let possibleTypes = ["PromiseType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .scalar(GraphQLID.self)),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("address", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("pockets", type: .list(.object(Pocket.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID? = nil, name: String? = nil, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil, timestamp: String? = nil, pockets: [Pocket?]? = nil) {
        self.init(snapshot: ["__typename": "PromiseType", "id": id, "name": name, "address": address, "latitude": latitude, "longitude": longitude, "timestamp": timestamp, "pockets": pockets.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return snapshot["id"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var address: String? {
        get {
          return snapshot["address"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "address")
        }
      }

      public var latitude: Double? {
        get {
          return snapshot["latitude"] as? Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "latitude")
        }
      }

      public var longitude: Double? {
        get {
          return snapshot["longitude"] as? Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "longitude")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var pockets: [Pocket?]? {
        get {
          return (snapshot["pockets"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Pocket(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "pockets")
        }
      }

      public struct Pocket: GraphQLSelectionSet {
        public static let possibleTypes = ["PocketType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nickname", type: .scalar(String.self)),
          GraphQLField("token", type: .scalar(String.self)),
          GraphQLField("profileImagePath", type: .scalar(String.self)),
          GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nickname: String? = nil, token: String? = nil, profileImagePath: String? = nil, phone: GraphQLID) {
          self.init(snapshot: ["__typename": "PocketType", "nickname": nickname, "token": token, "profileImagePath": profileImagePath, "phone": phone])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nickname: String? {
          get {
            return snapshot["nickname"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nickname")
          }
        }

        public var token: String? {
          get {
            return snapshot["token"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "token")
          }
        }

        public var profileImagePath: String? {
          get {
            return snapshot["profileImagePath"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "profileImagePath")
          }
        }

        public var phone: GraphQLID {
          get {
            return snapshot["phone"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "phone")
          }
        }
      }
    }
  }
}

public final class DeletePromiseByIdMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeletePromiseById($id: ID, $timestamp: String) {\n  deletePromise(id: $id, timestamp: $timestamp) {\n    __typename\n    id\n    timestamp\n  }\n}"

  public var id: GraphQLID?
  public var timestamp: String?

  public init(id: GraphQLID? = nil, timestamp: String? = nil) {
    self.id = id
    self.timestamp = timestamp
  }

  public var variables: GraphQLMap? {
    return ["id": id, "timestamp": timestamp]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deletePromise", arguments: ["id": GraphQLVariable("id"), "timestamp": GraphQLVariable("timestamp")], type: .object(DeletePromise.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deletePromise: DeletePromise? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deletePromise": deletePromise.flatMap { $0.snapshot }])
    }

    public var deletePromise: DeletePromise? {
      get {
        return (snapshot["deletePromise"] as? Snapshot).flatMap { DeletePromise(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deletePromise")
      }
    }

    public struct DeletePromise: GraphQLSelectionSet {
      public static let possibleTypes = ["PromiseType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .scalar(GraphQLID.self)),
        GraphQLField("timestamp", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID? = nil, timestamp: String? = nil) {
        self.init(snapshot: ["__typename": "PromiseType", "id": id, "timestamp": timestamp])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return snapshot["id"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }
    }
  }
}

public final class GetPromiseQuery: GraphQLQuery {
  public static let operationString =
    "query GetPromise($id: ID!) {\n  promise(id: $id) {\n    __typename\n    id\n    address\n    timestamp\n    latitude\n    longitude\n    name\n    pockets {\n      __typename\n      phone\n      latitude\n      longitude\n      token\n      profileImagePath\n      nickname\n    }\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["RootQueryType"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("promise", arguments: ["id": GraphQLVariable("id")], type: .object(Promise.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(promise: Promise? = nil) {
      self.init(snapshot: ["__typename": "RootQueryType", "promise": promise.flatMap { $0.snapshot }])
    }

    public var promise: Promise? {
      get {
        return (snapshot["promise"] as? Snapshot).flatMap { Promise(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "promise")
      }
    }

    public struct Promise: GraphQLSelectionSet {
      public static let possibleTypes = ["PromiseType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .scalar(GraphQLID.self)),
        GraphQLField("address", type: .scalar(String.self)),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("pockets", type: .list(.object(Pocket.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID? = nil, address: String? = nil, timestamp: String? = nil, latitude: Double? = nil, longitude: Double? = nil, name: String? = nil, pockets: [Pocket?]? = nil) {
        self.init(snapshot: ["__typename": "PromiseType", "id": id, "address": address, "timestamp": timestamp, "latitude": latitude, "longitude": longitude, "name": name, "pockets": pockets.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return snapshot["id"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var address: String? {
        get {
          return snapshot["address"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "address")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var latitude: Double? {
        get {
          return snapshot["latitude"] as? Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "latitude")
        }
      }

      public var longitude: Double? {
        get {
          return snapshot["longitude"] as? Double
        }
        set {
          snapshot.updateValue(newValue, forKey: "longitude")
        }
      }

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var pockets: [Pocket?]? {
        get {
          return (snapshot["pockets"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Pocket(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "pockets")
        }
      }

      public struct Pocket: GraphQLSelectionSet {
        public static let possibleTypes = ["PocketType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("latitude", type: .scalar(Double.self)),
          GraphQLField("longitude", type: .scalar(Double.self)),
          GraphQLField("token", type: .scalar(String.self)),
          GraphQLField("profileImagePath", type: .scalar(String.self)),
          GraphQLField("nickname", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(phone: GraphQLID, latitude: Double? = nil, longitude: Double? = nil, token: String? = nil, profileImagePath: String? = nil, nickname: String? = nil) {
          self.init(snapshot: ["__typename": "PocketType", "phone": phone, "latitude": latitude, "longitude": longitude, "token": token, "profileImagePath": profileImagePath, "nickname": nickname])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var phone: GraphQLID {
          get {
            return snapshot["phone"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "phone")
          }
        }

        public var latitude: Double? {
          get {
            return snapshot["latitude"] as? Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        public var longitude: Double? {
          get {
            return snapshot["longitude"] as? Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "longitude")
          }
        }

        public var token: String? {
          get {
            return snapshot["token"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "token")
          }
        }

        public var profileImagePath: String? {
          get {
            return snapshot["profileImagePath"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "profileImagePath")
          }
        }

        public var nickname: String? {
          get {
            return snapshot["nickname"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nickname")
          }
        }
      }
    }
  }
}

public final class GetUserWithPromisesQuery: GraphQLQuery {
  public static let operationString =
    "query GetUserWithPromises($id: ID!) {\n  user(id: $id) {\n    __typename\n    email\n    nickname\n    profileImagePath\n    gender\n    birthday\n    ageRange\n    pocket {\n      __typename\n      phone\n      token\n      profileImagePath\n      nickname\n      promiseList {\n        __typename\n        id\n        address\n        timestamp\n        latitude\n        longitude\n        name\n        pockets {\n          __typename\n          phone\n          token\n          profileImagePath\n          nickname\n        }\n      }\n    }\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["RootQueryType"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("user", arguments: ["id": GraphQLVariable("id")], type: .object(User.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(user: User? = nil) {
      self.init(snapshot: ["__typename": "RootQueryType", "user": user.flatMap { $0.snapshot }])
    }

    public var user: User? {
      get {
        return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "user")
      }
    }

    public struct User: GraphQLSelectionSet {
      public static let possibleTypes = ["UserType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("email", type: .scalar(String.self)),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("gender", type: .scalar(String.self)),
        GraphQLField("birthday", type: .scalar(String.self)),
        GraphQLField("ageRange", type: .scalar(String.self)),
        GraphQLField("pocket", type: .nonNull(.object(Pocket.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(email: String? = nil, nickname: String? = nil, profileImagePath: String? = nil, gender: String? = nil, birthday: String? = nil, ageRange: String? = nil, pocket: Pocket) {
        self.init(snapshot: ["__typename": "UserType", "email": email, "nickname": nickname, "profileImagePath": profileImagePath, "gender": gender, "birthday": birthday, "ageRange": ageRange, "pocket": pocket.snapshot])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var email: String? {
        get {
          return snapshot["email"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "email")
        }
      }

      public var nickname: String? {
        get {
          return snapshot["nickname"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nickname")
        }
      }

      public var profileImagePath: String? {
        get {
          return snapshot["profileImagePath"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "profileImagePath")
        }
      }

      public var gender: String? {
        get {
          return snapshot["gender"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "gender")
        }
      }

      public var birthday: String? {
        get {
          return snapshot["birthday"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "birthday")
        }
      }

      public var ageRange: String? {
        get {
          return snapshot["ageRange"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "ageRange")
        }
      }

      public var pocket: Pocket {
        get {
          return Pocket(snapshot: snapshot["pocket"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "pocket")
        }
      }

      public struct Pocket: GraphQLSelectionSet {
        public static let possibleTypes = ["PocketType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("token", type: .scalar(String.self)),
          GraphQLField("profileImagePath", type: .scalar(String.self)),
          GraphQLField("nickname", type: .scalar(String.self)),
          GraphQLField("promiseList", type: .list(.object(PromiseList.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(phone: GraphQLID, token: String? = nil, profileImagePath: String? = nil, nickname: String? = nil, promiseList: [PromiseList?]? = nil) {
          self.init(snapshot: ["__typename": "PocketType", "phone": phone, "token": token, "profileImagePath": profileImagePath, "nickname": nickname, "promiseList": promiseList.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var phone: GraphQLID {
          get {
            return snapshot["phone"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "phone")
          }
        }

        public var token: String? {
          get {
            return snapshot["token"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "token")
          }
        }

        public var profileImagePath: String? {
          get {
            return snapshot["profileImagePath"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "profileImagePath")
          }
        }

        public var nickname: String? {
          get {
            return snapshot["nickname"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nickname")
          }
        }

        public var promiseList: [PromiseList?]? {
          get {
            return (snapshot["promiseList"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { PromiseList(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "promiseList")
          }
        }

        public struct PromiseList: GraphQLSelectionSet {
          public static let possibleTypes = ["PromiseType"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("address", type: .scalar(String.self)),
            GraphQLField("timestamp", type: .scalar(String.self)),
            GraphQLField("latitude", type: .scalar(Double.self)),
            GraphQLField("longitude", type: .scalar(Double.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("pockets", type: .list(.object(Pocket.selections))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID? = nil, address: String? = nil, timestamp: String? = nil, latitude: Double? = nil, longitude: Double? = nil, name: String? = nil, pockets: [Pocket?]? = nil) {
            self.init(snapshot: ["__typename": "PromiseType", "id": id, "address": address, "timestamp": timestamp, "latitude": latitude, "longitude": longitude, "name": name, "pockets": pockets.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID? {
            get {
              return snapshot["id"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var address: String? {
            get {
              return snapshot["address"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "address")
            }
          }

          public var timestamp: String? {
            get {
              return snapshot["timestamp"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "timestamp")
            }
          }

          public var latitude: Double? {
            get {
              return snapshot["latitude"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "latitude")
            }
          }

          public var longitude: Double? {
            get {
              return snapshot["longitude"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "longitude")
            }
          }

          public var name: String? {
            get {
              return snapshot["name"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var pockets: [Pocket?]? {
            get {
              return (snapshot["pockets"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Pocket(snapshot: $0) } } }
            }
            set {
              snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "pockets")
            }
          }

          public struct Pocket: GraphQLSelectionSet {
            public static let possibleTypes = ["PocketType"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("token", type: .scalar(String.self)),
              GraphQLField("profileImagePath", type: .scalar(String.self)),
              GraphQLField("nickname", type: .scalar(String.self)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(phone: GraphQLID, token: String? = nil, profileImagePath: String? = nil, nickname: String? = nil) {
              self.init(snapshot: ["__typename": "PocketType", "phone": phone, "token": token, "profileImagePath": profileImagePath, "nickname": nickname])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var phone: GraphQLID {
              get {
                return snapshot["phone"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "phone")
              }
            }

            public var token: String? {
              get {
                return snapshot["token"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "token")
              }
            }

            public var profileImagePath: String? {
              get {
                return snapshot["profileImagePath"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "profileImagePath")
              }
            }

            public var nickname: String? {
              get {
                return snapshot["nickname"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "nickname")
              }
            }
          }
        }
      }
    }
  }
}

public final class UpsertUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpsertUser($id: ID!, $email: String, $nickname: String, $gender: String, $birthday: String, $ageRange: String, $profileImagePath: String, $phone: String!) {\n  upsertUser(id: $id, email: $email, nickname: $nickname, gender: $gender, birthday: $birthday, ageRange: $ageRange, profileImagePath: $profileImagePath, phone: $phone) {\n    __typename\n    pocket {\n      __typename\n      latitude\n      longitude\n      token\n      profileImagePath\n      phone\n      promiseList {\n        __typename\n        id\n        address\n        timestamp\n        latitude\n        longitude\n        name\n        pockets {\n          __typename\n          phone\n          token\n          profileImagePath\n          nickname\n        }\n      }\n    }\n  }\n}"

  public var id: GraphQLID
  public var email: String?
  public var nickname: String?
  public var gender: String?
  public var birthday: String?
  public var ageRange: String?
  public var profileImagePath: String?
  public var phone: String

  public init(id: GraphQLID, email: String? = nil, nickname: String? = nil, gender: String? = nil, birthday: String? = nil, ageRange: String? = nil, profileImagePath: String? = nil, phone: String) {
    self.id = id
    self.email = email
    self.nickname = nickname
    self.gender = gender
    self.birthday = birthday
    self.ageRange = ageRange
    self.profileImagePath = profileImagePath
    self.phone = phone
  }

  public var variables: GraphQLMap? {
    return ["id": id, "email": email, "nickname": nickname, "gender": gender, "birthday": birthday, "ageRange": ageRange, "profileImagePath": profileImagePath, "phone": phone]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("upsertUser", arguments: ["id": GraphQLVariable("id"), "email": GraphQLVariable("email"), "nickname": GraphQLVariable("nickname"), "gender": GraphQLVariable("gender"), "birthday": GraphQLVariable("birthday"), "ageRange": GraphQLVariable("ageRange"), "profileImagePath": GraphQLVariable("profileImagePath"), "phone": GraphQLVariable("phone")], type: .object(UpsertUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(upsertUser: UpsertUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "upsertUser": upsertUser.flatMap { $0.snapshot }])
    }

    public var upsertUser: UpsertUser? {
      get {
        return (snapshot["upsertUser"] as? Snapshot).flatMap { UpsertUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "upsertUser")
      }
    }

    public struct UpsertUser: GraphQLSelectionSet {
      public static let possibleTypes = ["UserType"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("pocket", type: .nonNull(.object(Pocket.selections))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(pocket: Pocket) {
        self.init(snapshot: ["__typename": "UserType", "pocket": pocket.snapshot])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var pocket: Pocket {
        get {
          return Pocket(snapshot: snapshot["pocket"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "pocket")
        }
      }

      public struct Pocket: GraphQLSelectionSet {
        public static let possibleTypes = ["PocketType"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("latitude", type: .scalar(Double.self)),
          GraphQLField("longitude", type: .scalar(Double.self)),
          GraphQLField("token", type: .scalar(String.self)),
          GraphQLField("profileImagePath", type: .scalar(String.self)),
          GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("promiseList", type: .list(.object(PromiseList.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(latitude: Double? = nil, longitude: Double? = nil, token: String? = nil, profileImagePath: String? = nil, phone: GraphQLID, promiseList: [PromiseList?]? = nil) {
          self.init(snapshot: ["__typename": "PocketType", "latitude": latitude, "longitude": longitude, "token": token, "profileImagePath": profileImagePath, "phone": phone, "promiseList": promiseList.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var latitude: Double? {
          get {
            return snapshot["latitude"] as? Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "latitude")
          }
        }

        public var longitude: Double? {
          get {
            return snapshot["longitude"] as? Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "longitude")
          }
        }

        public var token: String? {
          get {
            return snapshot["token"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "token")
          }
        }

        public var profileImagePath: String? {
          get {
            return snapshot["profileImagePath"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "profileImagePath")
          }
        }

        public var phone: GraphQLID {
          get {
            return snapshot["phone"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "phone")
          }
        }

        public var promiseList: [PromiseList?]? {
          get {
            return (snapshot["promiseList"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { PromiseList(snapshot: $0) } } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "promiseList")
          }
        }

        public struct PromiseList: GraphQLSelectionSet {
          public static let possibleTypes = ["PromiseType"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("address", type: .scalar(String.self)),
            GraphQLField("timestamp", type: .scalar(String.self)),
            GraphQLField("latitude", type: .scalar(Double.self)),
            GraphQLField("longitude", type: .scalar(Double.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("pockets", type: .list(.object(Pocket.selections))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID? = nil, address: String? = nil, timestamp: String? = nil, latitude: Double? = nil, longitude: Double? = nil, name: String? = nil, pockets: [Pocket?]? = nil) {
            self.init(snapshot: ["__typename": "PromiseType", "id": id, "address": address, "timestamp": timestamp, "latitude": latitude, "longitude": longitude, "name": name, "pockets": pockets.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID? {
            get {
              return snapshot["id"] as? GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var address: String? {
            get {
              return snapshot["address"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "address")
            }
          }

          public var timestamp: String? {
            get {
              return snapshot["timestamp"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "timestamp")
            }
          }

          public var latitude: Double? {
            get {
              return snapshot["latitude"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "latitude")
            }
          }

          public var longitude: Double? {
            get {
              return snapshot["longitude"] as? Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "longitude")
            }
          }

          public var name: String? {
            get {
              return snapshot["name"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "name")
            }
          }

          public var pockets: [Pocket?]? {
            get {
              return (snapshot["pockets"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Pocket(snapshot: $0) } } }
            }
            set {
              snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "pockets")
            }
          }

          public struct Pocket: GraphQLSelectionSet {
            public static let possibleTypes = ["PocketType"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("token", type: .scalar(String.self)),
              GraphQLField("profileImagePath", type: .scalar(String.self)),
              GraphQLField("nickname", type: .scalar(String.self)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(phone: GraphQLID, token: String? = nil, profileImagePath: String? = nil, nickname: String? = nil) {
              self.init(snapshot: ["__typename": "PocketType", "phone": phone, "token": token, "profileImagePath": profileImagePath, "nickname": nickname])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var phone: GraphQLID {
              get {
                return snapshot["phone"]! as! GraphQLID
              }
              set {
                snapshot.updateValue(newValue, forKey: "phone")
              }
            }

            public var token: String? {
              get {
                return snapshot["token"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "token")
              }
            }

            public var profileImagePath: String? {
              get {
                return snapshot["profileImagePath"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "profileImagePath")
              }
            }

            public var nickname: String? {
              get {
                return snapshot["nickname"] as? String
              }
              set {
                snapshot.updateValue(newValue, forKey: "nickname")
              }
            }
          }
        }
      }
    }
  }
}