//  This file was automatically generated and should not be edited.

import AWSAppSync

public struct CatchUpUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(email: Optional<String?> = nil, nickname: Optional<String?> = nil, profileImagePath: Optional<String?> = nil, gender: Optional<String?> = nil, birthday: Optional<String?> = nil, ageRange: Optional<String?> = nil, phone: Optional<String?> = nil, credit: Optional<Int?> = nil) {
    graphQLMap = ["email": email, "nickname": nickname, "profileImagePath": profileImagePath, "gender": gender, "birthday": birthday, "ageRange": ageRange, "phone": phone, "credit": credit]
  }

  public var email: Optional<String?> {
    get {
      return graphQLMap["email"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var nickname: Optional<String?> {
    get {
      return graphQLMap["nickname"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nickname")
    }
  }

  public var profileImagePath: Optional<String?> {
    get {
      return graphQLMap["profileImagePath"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "profileImagePath")
    }
  }

  public var gender: Optional<String?> {
    get {
      return graphQLMap["gender"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gender")
    }
  }

  public var birthday: Optional<String?> {
    get {
      return graphQLMap["birthday"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "birthday")
    }
  }

  public var ageRange: Optional<String?> {
    get {
      return graphQLMap["ageRange"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ageRange")
    }
  }

  public var phone: Optional<String?> {
    get {
      return graphQLMap["phone"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phone")
    }
  }

  public var credit: Optional<Int?> {
    get {
      return graphQLMap["credit"] as! Optional<Int?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "credit")
    }
  }
}

public struct ContactCreateInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(phone: GraphQLID, nickname: Optional<String?> = nil) {
    graphQLMap = ["phone": phone, "nickname": nickname]
  }

  public var phone: GraphQLID {
    get {
      return graphQLMap["phone"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phone")
    }
  }

  public var nickname: Optional<String?> {
    get {
      return graphQLMap["nickname"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nickname")
    }
  }
}

public struct ContactUpdateInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(nickname: Optional<String?> = nil, profileImagePath: Optional<String?> = nil, latitude: Optional<Double?> = nil, longitude: Optional<Double?> = nil, pushToken: Optional<String?> = nil, osType: Optional<String?> = nil) {
    graphQLMap = ["nickname": nickname, "profileImagePath": profileImagePath, "latitude": latitude, "longitude": longitude, "pushToken": pushToken, "osType": osType]
  }

  public var nickname: Optional<String?> {
    get {
      return graphQLMap["nickname"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nickname")
    }
  }

  public var profileImagePath: Optional<String?> {
    get {
      return graphQLMap["profileImagePath"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "profileImagePath")
    }
  }

  public var latitude: Optional<Double?> {
    get {
      return graphQLMap["latitude"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "latitude")
    }
  }

  public var longitude: Optional<Double?> {
    get {
      return graphQLMap["longitude"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "longitude")
    }
  }

  public var pushToken: Optional<String?> {
    get {
      return graphQLMap["pushToken"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "pushToken")
    }
  }

  public var osType: Optional<String?> {
    get {
      return graphQLMap["osType"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "osType")
    }
  }
}

public struct CatchUpPromiseInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(owner: Optional<String?> = nil, dateTime: Optional<String?> = nil, address: Optional<String?> = nil, latitude: Optional<Double?> = nil, longitude: Optional<Double?> = nil, name: Optional<String?> = nil, contacts: Optional<[String?]?> = nil) {
    graphQLMap = ["owner": owner, "dateTime": dateTime, "address": address, "latitude": latitude, "longitude": longitude, "name": name, "contacts": contacts]
  }

  public var owner: Optional<String?> {
    get {
      return graphQLMap["owner"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "owner")
    }
  }

  public var dateTime: Optional<String?> {
    get {
      return graphQLMap["dateTime"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateTime")
    }
  }

  public var address: Optional<String?> {
    get {
      return graphQLMap["address"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "address")
    }
  }

  public var latitude: Optional<Double?> {
    get {
      return graphQLMap["latitude"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "latitude")
    }
  }

  public var longitude: Optional<Double?> {
    get {
      return graphQLMap["longitude"] as! Optional<Double?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "longitude")
    }
  }

  public var name: Optional<String?> {
    get {
      return graphQLMap["name"] as! Optional<String?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var contacts: Optional<[String?]?> {
    get {
      return graphQLMap["contacts"] as! Optional<[String?]?>
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contacts")
    }
  }
}

public final class ChargeCreditMutation: GraphQLMutation {
  public static let operationString =
    "mutation ChargeCredit($id: ID!, $credit: Int) {\n  chargeCredit(id: $id, credit: $credit) {\n    __typename\n    id\n    email\n    nickname\n    profileImagePath\n    gender\n    birthday\n    ageRange\n    phone\n    credit\n  }\n}"

  public var id: GraphQLID
  public var credit: Int?

  public init(id: GraphQLID, credit: Int? = nil) {
    self.id = id
    self.credit = credit
  }

  public var variables: GraphQLMap? {
    return ["id": id, "credit": credit]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("chargeCredit", arguments: ["id": GraphQLVariable("id"), "credit": GraphQLVariable("credit")], type: .nonNull(.object(ChargeCredit.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(chargeCredit: ChargeCredit) {
      self.init(snapshot: ["__typename": "Mutation", "chargeCredit": chargeCredit.snapshot])
    }

    public var chargeCredit: ChargeCredit {
      get {
        return ChargeCredit(snapshot: snapshot["chargeCredit"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "chargeCredit")
      }
    }

    public struct ChargeCredit: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpUser"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .scalar(String.self)),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("gender", type: .scalar(String.self)),
        GraphQLField("birthday", type: .scalar(String.self)),
        GraphQLField("ageRange", type: .scalar(String.self)),
        GraphQLField("phone", type: .scalar(String.self)),
        GraphQLField("credit", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String? = nil, nickname: String? = nil, profileImagePath: String? = nil, gender: String? = nil, birthday: String? = nil, ageRange: String? = nil, phone: String? = nil, credit: Int? = nil) {
        self.init(snapshot: ["__typename": "CatchUpUser", "id": id, "email": email, "nickname": nickname, "profileImagePath": profileImagePath, "gender": gender, "birthday": birthday, "ageRange": ageRange, "phone": phone, "credit": credit])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
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

      public var phone: String? {
        get {
          return snapshot["phone"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var credit: Int? {
        get {
          return snapshot["credit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "credit")
        }
      }
    }
  }
}

public final class UseCreditMutation: GraphQLMutation {
  public static let operationString =
    "mutation UseCredit($id: ID!) {\n  useCredit(id: $id) {\n    __typename\n    id\n    email\n    nickname\n    profileImagePath\n    gender\n    birthday\n    ageRange\n    phone\n    credit\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("useCredit", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.object(UseCredit.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(useCredit: UseCredit) {
      self.init(snapshot: ["__typename": "Mutation", "useCredit": useCredit.snapshot])
    }

    public var useCredit: UseCredit {
      get {
        return UseCredit(snapshot: snapshot["useCredit"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "useCredit")
      }
    }

    public struct UseCredit: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpUser"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .scalar(String.self)),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("gender", type: .scalar(String.self)),
        GraphQLField("birthday", type: .scalar(String.self)),
        GraphQLField("ageRange", type: .scalar(String.self)),
        GraphQLField("phone", type: .scalar(String.self)),
        GraphQLField("credit", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String? = nil, nickname: String? = nil, profileImagePath: String? = nil, gender: String? = nil, birthday: String? = nil, ageRange: String? = nil, phone: String? = nil, credit: Int? = nil) {
        self.init(snapshot: ["__typename": "CatchUpUser", "id": id, "email": email, "nickname": nickname, "profileImagePath": profileImagePath, "gender": gender, "birthday": birthday, "ageRange": ageRange, "phone": phone, "credit": credit])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
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

      public var phone: String? {
        get {
          return snapshot["phone"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var credit: Int? {
        get {
          return snapshot["credit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "credit")
        }
      }
    }
  }
}

public final class UpdateCatchUpUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateCatchUpUser($id: ID!, $data: CatchUpUserInput) {\n  updateCatchUpUser(id: $id, data: $data) {\n    __typename\n    id\n    email\n    nickname\n    profileImagePath\n    gender\n    birthday\n    ageRange\n    phone\n    credit\n  }\n}"

  public var id: GraphQLID
  public var data: CatchUpUserInput?

  public init(id: GraphQLID, data: CatchUpUserInput? = nil) {
    self.id = id
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["id": id, "data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateCatchUpUser", arguments: ["id": GraphQLVariable("id"), "data": GraphQLVariable("data")], type: .object(UpdateCatchUpUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateCatchUpUser: UpdateCatchUpUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateCatchUpUser": updateCatchUpUser.flatMap { $0.snapshot }])
    }

    public var updateCatchUpUser: UpdateCatchUpUser? {
      get {
        return (snapshot["updateCatchUpUser"] as? Snapshot).flatMap { UpdateCatchUpUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateCatchUpUser")
      }
    }

    public struct UpdateCatchUpUser: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpUser"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .scalar(String.self)),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("gender", type: .scalar(String.self)),
        GraphQLField("birthday", type: .scalar(String.self)),
        GraphQLField("ageRange", type: .scalar(String.self)),
        GraphQLField("phone", type: .scalar(String.self)),
        GraphQLField("credit", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String? = nil, nickname: String? = nil, profileImagePath: String? = nil, gender: String? = nil, birthday: String? = nil, ageRange: String? = nil, phone: String? = nil, credit: Int? = nil) {
        self.init(snapshot: ["__typename": "CatchUpUser", "id": id, "email": email, "nickname": nickname, "profileImagePath": profileImagePath, "gender": gender, "birthday": birthday, "ageRange": ageRange, "phone": phone, "credit": credit])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
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

      public var phone: String? {
        get {
          return snapshot["phone"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var credit: Int? {
        get {
          return snapshot["credit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "credit")
        }
      }
    }
  }
}

public final class CreateCatchUpUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateCatchUpUser($id: ID!, $data: CatchUpUserInput) {\n  createCatchUpUser(id: $id, data: $data) {\n    __typename\n    id\n    email\n    nickname\n    profileImagePath\n    gender\n    birthday\n    ageRange\n    phone\n    credit\n  }\n}"

  public var id: GraphQLID
  public var data: CatchUpUserInput?

  public init(id: GraphQLID, data: CatchUpUserInput? = nil) {
    self.id = id
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["id": id, "data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createCatchUpUser", arguments: ["id": GraphQLVariable("id"), "data": GraphQLVariable("data")], type: .object(CreateCatchUpUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createCatchUpUser: CreateCatchUpUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createCatchUpUser": createCatchUpUser.flatMap { $0.snapshot }])
    }

    public var createCatchUpUser: CreateCatchUpUser? {
      get {
        return (snapshot["createCatchUpUser"] as? Snapshot).flatMap { CreateCatchUpUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createCatchUpUser")
      }
    }

    public struct CreateCatchUpUser: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpUser"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .scalar(String.self)),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("gender", type: .scalar(String.self)),
        GraphQLField("birthday", type: .scalar(String.self)),
        GraphQLField("ageRange", type: .scalar(String.self)),
        GraphQLField("phone", type: .scalar(String.self)),
        GraphQLField("credit", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String? = nil, nickname: String? = nil, profileImagePath: String? = nil, gender: String? = nil, birthday: String? = nil, ageRange: String? = nil, phone: String? = nil, credit: Int? = nil) {
        self.init(snapshot: ["__typename": "CatchUpUser", "id": id, "email": email, "nickname": nickname, "profileImagePath": profileImagePath, "gender": gender, "birthday": birthday, "ageRange": ageRange, "phone": phone, "credit": credit])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
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

      public var phone: String? {
        get {
          return snapshot["phone"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var credit: Int? {
        get {
          return snapshot["credit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "credit")
        }
      }
    }
  }
}

public final class DeleteCatchUpUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteCatchUpUser($id: ID!) {\n  deleteCatchUpUser(id: $id) {\n    __typename\n    id\n    email\n    nickname\n    profileImagePath\n    gender\n    birthday\n    ageRange\n    phone\n    credit\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteCatchUpUser", arguments: ["id": GraphQLVariable("id")], type: .object(DeleteCatchUpUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteCatchUpUser: DeleteCatchUpUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteCatchUpUser": deleteCatchUpUser.flatMap { $0.snapshot }])
    }

    public var deleteCatchUpUser: DeleteCatchUpUser? {
      get {
        return (snapshot["deleteCatchUpUser"] as? Snapshot).flatMap { DeleteCatchUpUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteCatchUpUser")
      }
    }

    public struct DeleteCatchUpUser: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpUser"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .scalar(String.self)),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("gender", type: .scalar(String.self)),
        GraphQLField("birthday", type: .scalar(String.self)),
        GraphQLField("ageRange", type: .scalar(String.self)),
        GraphQLField("phone", type: .scalar(String.self)),
        GraphQLField("credit", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String? = nil, nickname: String? = nil, profileImagePath: String? = nil, gender: String? = nil, birthday: String? = nil, ageRange: String? = nil, phone: String? = nil, credit: Int? = nil) {
        self.init(snapshot: ["__typename": "CatchUpUser", "id": id, "email": email, "nickname": nickname, "profileImagePath": profileImagePath, "gender": gender, "birthday": birthday, "ageRange": ageRange, "phone": phone, "credit": credit])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
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

      public var phone: String? {
        get {
          return snapshot["phone"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var credit: Int? {
        get {
          return snapshot["credit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "credit")
        }
      }
    }
  }
}

public final class CreateCatchUpContactMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateCatchUpContact($contact: ContactCreateInput!) {\n  createCatchUpContact(contact: $contact) {\n    __typename\n    phone\n    nickname\n    profileImagePath\n    latitude\n    longitude\n    pushToken\n    osType\n  }\n}"

  public var contact: ContactCreateInput

  public init(contact: ContactCreateInput) {
    self.contact = contact
  }

  public var variables: GraphQLMap? {
    return ["contact": contact]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createCatchUpContact", arguments: ["contact": GraphQLVariable("contact")], type: .object(CreateCatchUpContact.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createCatchUpContact: CreateCatchUpContact? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createCatchUpContact": createCatchUpContact.flatMap { $0.snapshot }])
    }

    public var createCatchUpContact: CreateCatchUpContact? {
      get {
        return (snapshot["createCatchUpContact"] as? Snapshot).flatMap { CreateCatchUpContact(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createCatchUpContact")
      }
    }

    public struct CreateCatchUpContact: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("pushToken", type: .scalar(String.self)),
        GraphQLField("osType", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(phone: GraphQLID, nickname: String? = nil, profileImagePath: String? = nil, latitude: Double? = nil, longitude: Double? = nil, pushToken: String? = nil, osType: String? = nil) {
        self.init(snapshot: ["__typename": "CatchUpContact", "phone": phone, "nickname": nickname, "profileImagePath": profileImagePath, "latitude": latitude, "longitude": longitude, "pushToken": pushToken, "osType": osType])
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

      public var pushToken: String? {
        get {
          return snapshot["pushToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "pushToken")
        }
      }

      public var osType: String? {
        get {
          return snapshot["osType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "osType")
        }
      }
    }
  }
}

public final class UpdateCatchUpContactMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateCatchUpContact($phone: ID!, $contact: ContactUpdateInput!) {\n  updateCatchUpContact(phone: $phone, contact: $contact) {\n    __typename\n    phone\n    nickname\n    profileImagePath\n    latitude\n    longitude\n    pushToken\n    osType\n  }\n}"

  public var phone: GraphQLID
  public var contact: ContactUpdateInput

  public init(phone: GraphQLID, contact: ContactUpdateInput) {
    self.phone = phone
    self.contact = contact
  }

  public var variables: GraphQLMap? {
    return ["phone": phone, "contact": contact]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateCatchUpContact", arguments: ["phone": GraphQLVariable("phone"), "contact": GraphQLVariable("contact")], type: .object(UpdateCatchUpContact.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateCatchUpContact: UpdateCatchUpContact? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateCatchUpContact": updateCatchUpContact.flatMap { $0.snapshot }])
    }

    public var updateCatchUpContact: UpdateCatchUpContact? {
      get {
        return (snapshot["updateCatchUpContact"] as? Snapshot).flatMap { UpdateCatchUpContact(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateCatchUpContact")
      }
    }

    public struct UpdateCatchUpContact: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("pushToken", type: .scalar(String.self)),
        GraphQLField("osType", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(phone: GraphQLID, nickname: String? = nil, profileImagePath: String? = nil, latitude: Double? = nil, longitude: Double? = nil, pushToken: String? = nil, osType: String? = nil) {
        self.init(snapshot: ["__typename": "CatchUpContact", "phone": phone, "nickname": nickname, "profileImagePath": profileImagePath, "latitude": latitude, "longitude": longitude, "pushToken": pushToken, "osType": osType])
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

      public var pushToken: String? {
        get {
          return snapshot["pushToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "pushToken")
        }
      }

      public var osType: String? {
        get {
          return snapshot["osType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "osType")
        }
      }
    }
  }
}

public final class RelocateCatchUpContactMutation: GraphQLMutation {
  public static let operationString =
    "mutation RelocateCatchUpContact($phone: ID!, $latitude: Float!, $longitude: Float!) {\n  relocateCatchUpContact(phone: $phone, latitude: $latitude, longitude: $longitude) {\n    __typename\n    phone\n    nickname\n    profileImagePath\n    latitude\n    longitude\n    pushToken\n    osType\n  }\n}"

  public var phone: GraphQLID
  public var latitude: Double
  public var longitude: Double

  public init(phone: GraphQLID, latitude: Double, longitude: Double) {
    self.phone = phone
    self.latitude = latitude
    self.longitude = longitude
  }

  public var variables: GraphQLMap? {
    return ["phone": phone, "latitude": latitude, "longitude": longitude]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("relocateCatchUpContact", arguments: ["phone": GraphQLVariable("phone"), "latitude": GraphQLVariable("latitude"), "longitude": GraphQLVariable("longitude")], type: .nonNull(.object(RelocateCatchUpContact.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(relocateCatchUpContact: RelocateCatchUpContact) {
      self.init(snapshot: ["__typename": "Mutation", "relocateCatchUpContact": relocateCatchUpContact.snapshot])
    }

    public var relocateCatchUpContact: RelocateCatchUpContact {
      get {
        return RelocateCatchUpContact(snapshot: snapshot["relocateCatchUpContact"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "relocateCatchUpContact")
      }
    }

    public struct RelocateCatchUpContact: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("pushToken", type: .scalar(String.self)),
        GraphQLField("osType", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(phone: GraphQLID, nickname: String? = nil, profileImagePath: String? = nil, latitude: Double? = nil, longitude: Double? = nil, pushToken: String? = nil, osType: String? = nil) {
        self.init(snapshot: ["__typename": "CatchUpContact", "phone": phone, "nickname": nickname, "profileImagePath": profileImagePath, "latitude": latitude, "longitude": longitude, "pushToken": pushToken, "osType": osType])
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

      public var pushToken: String? {
        get {
          return snapshot["pushToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "pushToken")
        }
      }

      public var osType: String? {
        get {
          return snapshot["osType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "osType")
        }
      }
    }
  }
}

public final class AttachTokenToCatchUpContactMutation: GraphQLMutation {
  public static let operationString =
    "mutation AttachTokenToCatchUpContact($phone: ID!, $pushToken: String!, $osType: String!) {\n  attachTokenToCatchUpContact(phone: $phone, pushToken: $pushToken, osType: $osType) {\n    __typename\n    phone\n    nickname\n    profileImagePath\n    latitude\n    longitude\n    pushToken\n    osType\n  }\n}"

  public var phone: GraphQLID
  public var pushToken: String
  public var osType: String

  public init(phone: GraphQLID, pushToken: String, osType: String) {
    self.phone = phone
    self.pushToken = pushToken
    self.osType = osType
  }

  public var variables: GraphQLMap? {
    return ["phone": phone, "pushToken": pushToken, "osType": osType]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("attachTokenToCatchUpContact", arguments: ["phone": GraphQLVariable("phone"), "pushToken": GraphQLVariable("pushToken"), "osType": GraphQLVariable("osType")], type: .nonNull(.object(AttachTokenToCatchUpContact.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(attachTokenToCatchUpContact: AttachTokenToCatchUpContact) {
      self.init(snapshot: ["__typename": "Mutation", "attachTokenToCatchUpContact": attachTokenToCatchUpContact.snapshot])
    }

    public var attachTokenToCatchUpContact: AttachTokenToCatchUpContact {
      get {
        return AttachTokenToCatchUpContact(snapshot: snapshot["attachTokenToCatchUpContact"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "attachTokenToCatchUpContact")
      }
    }

    public struct AttachTokenToCatchUpContact: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("pushToken", type: .scalar(String.self)),
        GraphQLField("osType", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(phone: GraphQLID, nickname: String? = nil, profileImagePath: String? = nil, latitude: Double? = nil, longitude: Double? = nil, pushToken: String? = nil, osType: String? = nil) {
        self.init(snapshot: ["__typename": "CatchUpContact", "phone": phone, "nickname": nickname, "profileImagePath": profileImagePath, "latitude": latitude, "longitude": longitude, "pushToken": pushToken, "osType": osType])
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

      public var pushToken: String? {
        get {
          return snapshot["pushToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "pushToken")
        }
      }

      public var osType: String? {
        get {
          return snapshot["osType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "osType")
        }
      }
    }
  }
}

public final class CreateCatchUpPromiseMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateCatchUpPromise($data: CatchUpPromiseInput) {\n  createCatchUpPromise(data: $data) {\n    __typename\n    id\n    owner\n    dateTime\n    address\n    latitude\n    longitude\n    name\n    contacts\n  }\n}"

  public var data: CatchUpPromiseInput?

  public init(data: CatchUpPromiseInput? = nil) {
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createCatchUpPromise", arguments: ["data": GraphQLVariable("data")], type: .object(CreateCatchUpPromise.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createCatchUpPromise: CreateCatchUpPromise? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createCatchUpPromise": createCatchUpPromise.flatMap { $0.snapshot }])
    }

    public var createCatchUpPromise: CreateCatchUpPromise? {
      get {
        return (snapshot["createCatchUpPromise"] as? Snapshot).flatMap { CreateCatchUpPromise(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createCatchUpPromise")
      }
    }

    public struct CreateCatchUpPromise: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpPromise"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("owner", type: .scalar(String.self)),
        GraphQLField("dateTime", type: .scalar(String.self)),
        GraphQLField("address", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("contacts", type: .list(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, owner: String? = nil, dateTime: String? = nil, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil, name: String? = nil, contacts: [String?]? = nil) {
        self.init(snapshot: ["__typename": "CatchUpPromise", "id": id, "owner": owner, "dateTime": dateTime, "address": address, "latitude": latitude, "longitude": longitude, "name": name, "contacts": contacts])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public var dateTime: String? {
        get {
          return snapshot["dateTime"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateTime")
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

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var contacts: [String?]? {
        get {
          return snapshot["contacts"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "contacts")
        }
      }
    }
  }
}

public final class DeleteCatchUpPromiseMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteCatchUpPromise($id: ID!) {\n  deleteCatchUpPromise(id: $id) {\n    __typename\n    id\n    owner\n    dateTime\n    address\n    latitude\n    longitude\n    name\n    contacts\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteCatchUpPromise", arguments: ["id": GraphQLVariable("id")], type: .object(DeleteCatchUpPromise.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteCatchUpPromise: DeleteCatchUpPromise? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteCatchUpPromise": deleteCatchUpPromise.flatMap { $0.snapshot }])
    }

    public var deleteCatchUpPromise: DeleteCatchUpPromise? {
      get {
        return (snapshot["deleteCatchUpPromise"] as? Snapshot).flatMap { DeleteCatchUpPromise(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteCatchUpPromise")
      }
    }

    public struct DeleteCatchUpPromise: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpPromise"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("owner", type: .scalar(String.self)),
        GraphQLField("dateTime", type: .scalar(String.self)),
        GraphQLField("address", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("contacts", type: .list(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, owner: String? = nil, dateTime: String? = nil, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil, name: String? = nil, contacts: [String?]? = nil) {
        self.init(snapshot: ["__typename": "CatchUpPromise", "id": id, "owner": owner, "dateTime": dateTime, "address": address, "latitude": latitude, "longitude": longitude, "name": name, "contacts": contacts])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public var dateTime: String? {
        get {
          return snapshot["dateTime"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateTime")
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

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var contacts: [String?]? {
        get {
          return snapshot["contacts"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "contacts")
        }
      }
    }
  }
}

public final class BatchCreateCatchUpContactMutation: GraphQLMutation {
  public static let operationString =
    "mutation BatchCreateCatchUpContact($contacts: [ContactCreateInput]) {\n  batchCreateCatchUpContact(contacts: $contacts) {\n    __typename\n    phone\n    nickname\n    profileImagePath\n    latitude\n    longitude\n    pushToken\n    osType\n  }\n}"

  public var contacts: [ContactCreateInput?]?

  public init(contacts: [ContactCreateInput?]? = nil) {
    self.contacts = contacts
  }

  public var variables: GraphQLMap? {
    return ["contacts": contacts]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("batchCreateCatchUpContact", arguments: ["contacts": GraphQLVariable("contacts")], type: .list(.object(BatchCreateCatchUpContact.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(batchCreateCatchUpContact: [BatchCreateCatchUpContact?]? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "batchCreateCatchUpContact": batchCreateCatchUpContact.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
    }

    public var batchCreateCatchUpContact: [BatchCreateCatchUpContact?]? {
      get {
        return (snapshot["batchCreateCatchUpContact"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { BatchCreateCatchUpContact(snapshot: $0) } } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "batchCreateCatchUpContact")
      }
    }

    public struct BatchCreateCatchUpContact: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("pushToken", type: .scalar(String.self)),
        GraphQLField("osType", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(phone: GraphQLID, nickname: String? = nil, profileImagePath: String? = nil, latitude: Double? = nil, longitude: Double? = nil, pushToken: String? = nil, osType: String? = nil) {
        self.init(snapshot: ["__typename": "CatchUpContact", "phone": phone, "nickname": nickname, "profileImagePath": profileImagePath, "latitude": latitude, "longitude": longitude, "pushToken": pushToken, "osType": osType])
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

      public var pushToken: String? {
        get {
          return snapshot["pushToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "pushToken")
        }
      }

      public var osType: String? {
        get {
          return snapshot["osType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "osType")
        }
      }
    }
  }
}

public final class UpdateCatchUpPromiseMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateCatchUpPromise($id: ID!, $data: CatchUpPromiseInput) {\n  updateCatchUpPromise(id: $id, data: $data) {\n    __typename\n    id\n    owner\n    dateTime\n    address\n    latitude\n    longitude\n    name\n    contacts\n  }\n}"

  public var id: GraphQLID
  public var data: CatchUpPromiseInput?

  public init(id: GraphQLID, data: CatchUpPromiseInput? = nil) {
    self.id = id
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["id": id, "data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateCatchUpPromise", arguments: ["id": GraphQLVariable("id"), "data": GraphQLVariable("data")], type: .object(UpdateCatchUpPromise.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateCatchUpPromise: UpdateCatchUpPromise? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateCatchUpPromise": updateCatchUpPromise.flatMap { $0.snapshot }])
    }

    public var updateCatchUpPromise: UpdateCatchUpPromise? {
      get {
        return (snapshot["updateCatchUpPromise"] as? Snapshot).flatMap { UpdateCatchUpPromise(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateCatchUpPromise")
      }
    }

    public struct UpdateCatchUpPromise: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpPromise"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("owner", type: .scalar(String.self)),
        GraphQLField("dateTime", type: .scalar(String.self)),
        GraphQLField("address", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("contacts", type: .list(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, owner: String? = nil, dateTime: String? = nil, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil, name: String? = nil, contacts: [String?]? = nil) {
        self.init(snapshot: ["__typename": "CatchUpPromise", "id": id, "owner": owner, "dateTime": dateTime, "address": address, "latitude": latitude, "longitude": longitude, "name": name, "contacts": contacts])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public var dateTime: String? {
        get {
          return snapshot["dateTime"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateTime")
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

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var contacts: [String?]? {
        get {
          return snapshot["contacts"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "contacts")
        }
      }
    }
  }
}

public final class AddContactIntoPromiseMutation: GraphQLMutation {
  public static let operationString =
    "mutation AddContactIntoPromise($id: ID!, $phone: String!) {\n  addContactIntoPromise(id: $id, phone: $phone) {\n    __typename\n    id\n    owner\n    dateTime\n    address\n    latitude\n    longitude\n    name\n    contacts\n  }\n}"

  public var id: GraphQLID
  public var phone: String

  public init(id: GraphQLID, phone: String) {
    self.id = id
    self.phone = phone
  }

  public var variables: GraphQLMap? {
    return ["id": id, "phone": phone]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("addContactIntoPromise", arguments: ["id": GraphQLVariable("id"), "phone": GraphQLVariable("phone")], type: .object(AddContactIntoPromise.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(addContactIntoPromise: AddContactIntoPromise? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "addContactIntoPromise": addContactIntoPromise.flatMap { $0.snapshot }])
    }

    public var addContactIntoPromise: AddContactIntoPromise? {
      get {
        return (snapshot["addContactIntoPromise"] as? Snapshot).flatMap { AddContactIntoPromise(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "addContactIntoPromise")
      }
    }

    public struct AddContactIntoPromise: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpPromise"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("owner", type: .scalar(String.self)),
        GraphQLField("dateTime", type: .scalar(String.self)),
        GraphQLField("address", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("contacts", type: .list(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, owner: String? = nil, dateTime: String? = nil, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil, name: String? = nil, contacts: [String?]? = nil) {
        self.init(snapshot: ["__typename": "CatchUpPromise", "id": id, "owner": owner, "dateTime": dateTime, "address": address, "latitude": latitude, "longitude": longitude, "name": name, "contacts": contacts])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public var dateTime: String? {
        get {
          return snapshot["dateTime"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateTime")
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

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var contacts: [String?]? {
        get {
          return snapshot["contacts"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "contacts")
        }
      }
    }
  }
}

public final class RemoveContactIntoPromiseMutation: GraphQLMutation {
  public static let operationString =
    "mutation RemoveContactIntoPromise($id: ID!, $phone: String!) {\n  removeContactIntoPromise(id: $id, phone: $phone) {\n    __typename\n    id\n    owner\n    dateTime\n    address\n    latitude\n    longitude\n    name\n    contacts\n  }\n}"

  public var id: GraphQLID
  public var phone: String

  public init(id: GraphQLID, phone: String) {
    self.id = id
    self.phone = phone
  }

  public var variables: GraphQLMap? {
    return ["id": id, "phone": phone]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("removeContactIntoPromise", arguments: ["id": GraphQLVariable("id"), "phone": GraphQLVariable("phone")], type: .object(RemoveContactIntoPromise.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(removeContactIntoPromise: RemoveContactIntoPromise? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "removeContactIntoPromise": removeContactIntoPromise.flatMap { $0.snapshot }])
    }

    public var removeContactIntoPromise: RemoveContactIntoPromise? {
      get {
        return (snapshot["removeContactIntoPromise"] as? Snapshot).flatMap { RemoveContactIntoPromise(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "removeContactIntoPromise")
      }
    }

    public struct RemoveContactIntoPromise: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpPromise"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("owner", type: .scalar(String.self)),
        GraphQLField("dateTime", type: .scalar(String.self)),
        GraphQLField("address", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("contacts", type: .list(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, owner: String? = nil, dateTime: String? = nil, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil, name: String? = nil, contacts: [String?]? = nil) {
        self.init(snapshot: ["__typename": "CatchUpPromise", "id": id, "owner": owner, "dateTime": dateTime, "address": address, "latitude": latitude, "longitude": longitude, "name": name, "contacts": contacts])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public var dateTime: String? {
        get {
          return snapshot["dateTime"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateTime")
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

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var contacts: [String?]? {
        get {
          return snapshot["contacts"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "contacts")
        }
      }
    }
  }
}

public final class ListCatchUpUserQuery: GraphQLQuery {
  public static let operationString =
    "query ListCatchUpUser($count: Int, $nextToken: String) {\n  listCatchUpUser(count: $count, nextToken: $nextToken) {\n    __typename\n    users {\n      __typename\n      id\n      email\n      nickname\n      profileImagePath\n      gender\n      birthday\n      ageRange\n      phone\n      credit\n    }\n    nextToken\n  }\n}"

  public var count: Int?
  public var nextToken: String?

  public init(count: Int? = nil, nextToken: String? = nil) {
    self.count = count
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["count": count, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listCatchUpUser", arguments: ["count": GraphQLVariable("count"), "nextToken": GraphQLVariable("nextToken")], type: .nonNull(.object(ListCatchUpUser.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listCatchUpUser: ListCatchUpUser) {
      self.init(snapshot: ["__typename": "Query", "listCatchUpUser": listCatchUpUser.snapshot])
    }

    public var listCatchUpUser: ListCatchUpUser {
      get {
        return ListCatchUpUser(snapshot: snapshot["listCatchUpUser"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "listCatchUpUser")
      }
    }

    public struct ListCatchUpUser: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpUserConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("users", type: .nonNull(.list(.nonNull(.object(User.selections))))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(users: [User], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "CatchUpUserConnection", "users": users.map { $0.snapshot }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var users: [User] {
        get {
          return (snapshot["users"] as! [Snapshot]).map { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "users")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["CatchUpUser"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("email", type: .scalar(String.self)),
          GraphQLField("nickname", type: .scalar(String.self)),
          GraphQLField("profileImagePath", type: .scalar(String.self)),
          GraphQLField("gender", type: .scalar(String.self)),
          GraphQLField("birthday", type: .scalar(String.self)),
          GraphQLField("ageRange", type: .scalar(String.self)),
          GraphQLField("phone", type: .scalar(String.self)),
          GraphQLField("credit", type: .scalar(Int.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, email: String? = nil, nickname: String? = nil, profileImagePath: String? = nil, gender: String? = nil, birthday: String? = nil, ageRange: String? = nil, phone: String? = nil, credit: Int? = nil) {
          self.init(snapshot: ["__typename": "CatchUpUser", "id": id, "email": email, "nickname": nickname, "profileImagePath": profileImagePath, "gender": gender, "birthday": birthday, "ageRange": ageRange, "phone": phone, "credit": credit])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
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

        public var phone: String? {
          get {
            return snapshot["phone"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "phone")
          }
        }

        public var credit: Int? {
          get {
            return snapshot["credit"] as? Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "credit")
          }
        }
      }
    }
  }
}

public final class GetCatchUpUserQuery: GraphQLQuery {
  public static let operationString =
    "query GetCatchUpUser($id: ID!) {\n  getCatchUpUser(id: $id) {\n    __typename\n    id\n    email\n    nickname\n    profileImagePath\n    gender\n    birthday\n    ageRange\n    phone\n    credit\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getCatchUpUser", arguments: ["id": GraphQLVariable("id")], type: .object(GetCatchUpUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getCatchUpUser: GetCatchUpUser? = nil) {
      self.init(snapshot: ["__typename": "Query", "getCatchUpUser": getCatchUpUser.flatMap { $0.snapshot }])
    }

    public var getCatchUpUser: GetCatchUpUser? {
      get {
        return (snapshot["getCatchUpUser"] as? Snapshot).flatMap { GetCatchUpUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getCatchUpUser")
      }
    }

    public struct GetCatchUpUser: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpUser"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("email", type: .scalar(String.self)),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("gender", type: .scalar(String.self)),
        GraphQLField("birthday", type: .scalar(String.self)),
        GraphQLField("ageRange", type: .scalar(String.self)),
        GraphQLField("phone", type: .scalar(String.self)),
        GraphQLField("credit", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, email: String? = nil, nickname: String? = nil, profileImagePath: String? = nil, gender: String? = nil, birthday: String? = nil, ageRange: String? = nil, phone: String? = nil, credit: Int? = nil) {
        self.init(snapshot: ["__typename": "CatchUpUser", "id": id, "email": email, "nickname": nickname, "profileImagePath": profileImagePath, "gender": gender, "birthday": birthday, "ageRange": ageRange, "phone": phone, "credit": credit])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
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

      public var phone: String? {
        get {
          return snapshot["phone"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "phone")
        }
      }

      public var credit: Int? {
        get {
          return snapshot["credit"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "credit")
        }
      }
    }
  }
}

public final class GetCatchUpContactQuery: GraphQLQuery {
  public static let operationString =
    "query GetCatchUpContact($phone: ID) {\n  getCatchUpContact(phone: $phone) {\n    __typename\n    phone\n    nickname\n    profileImagePath\n    latitude\n    longitude\n    pushToken\n    osType\n  }\n}"

  public var phone: GraphQLID?

  public init(phone: GraphQLID? = nil) {
    self.phone = phone
  }

  public var variables: GraphQLMap? {
    return ["phone": phone]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getCatchUpContact", arguments: ["phone": GraphQLVariable("phone")], type: .object(GetCatchUpContact.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getCatchUpContact: GetCatchUpContact? = nil) {
      self.init(snapshot: ["__typename": "Query", "getCatchUpContact": getCatchUpContact.flatMap { $0.snapshot }])
    }

    public var getCatchUpContact: GetCatchUpContact? {
      get {
        return (snapshot["getCatchUpContact"] as? Snapshot).flatMap { GetCatchUpContact(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getCatchUpContact")
      }
    }

    public struct GetCatchUpContact: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("pushToken", type: .scalar(String.self)),
        GraphQLField("osType", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(phone: GraphQLID, nickname: String? = nil, profileImagePath: String? = nil, latitude: Double? = nil, longitude: Double? = nil, pushToken: String? = nil, osType: String? = nil) {
        self.init(snapshot: ["__typename": "CatchUpContact", "phone": phone, "nickname": nickname, "profileImagePath": profileImagePath, "latitude": latitude, "longitude": longitude, "pushToken": pushToken, "osType": osType])
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

      public var pushToken: String? {
        get {
          return snapshot["pushToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "pushToken")
        }
      }

      public var osType: String? {
        get {
          return snapshot["osType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "osType")
        }
      }
    }
  }
}

public final class GetCatchUpPromiseQuery: GraphQLQuery {
  public static let operationString =
    "query GetCatchUpPromise($id: ID!) {\n  getCatchUpPromise(id: $id) {\n    __typename\n    id\n    owner\n    dateTime\n    address\n    latitude\n    longitude\n    name\n    contacts\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getCatchUpPromise", arguments: ["id": GraphQLVariable("id")], type: .object(GetCatchUpPromise.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getCatchUpPromise: GetCatchUpPromise? = nil) {
      self.init(snapshot: ["__typename": "Query", "getCatchUpPromise": getCatchUpPromise.flatMap { $0.snapshot }])
    }

    public var getCatchUpPromise: GetCatchUpPromise? {
      get {
        return (snapshot["getCatchUpPromise"] as? Snapshot).flatMap { GetCatchUpPromise(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getCatchUpPromise")
      }
    }

    public struct GetCatchUpPromise: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpPromise"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("owner", type: .scalar(String.self)),
        GraphQLField("dateTime", type: .scalar(String.self)),
        GraphQLField("address", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("contacts", type: .list(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, owner: String? = nil, dateTime: String? = nil, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil, name: String? = nil, contacts: [String?]? = nil) {
        self.init(snapshot: ["__typename": "CatchUpPromise", "id": id, "owner": owner, "dateTime": dateTime, "address": address, "latitude": latitude, "longitude": longitude, "name": name, "contacts": contacts])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public var dateTime: String? {
        get {
          return snapshot["dateTime"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateTime")
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

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var contacts: [String?]? {
        get {
          return snapshot["contacts"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "contacts")
        }
      }
    }
  }
}

public final class CheckAppVersionQuery: GraphQLQuery {
  public static let operationString =
    "query CheckAppVersion($platform: ID!) {\n  checkAppVersion(platform: $platform) {\n    __typename\n    platform\n    major\n    minor\n    revision\n  }\n}"

  public var platform: GraphQLID

  public init(platform: GraphQLID) {
    self.platform = platform
  }

  public var variables: GraphQLMap? {
    return ["platform": platform]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("checkAppVersion", arguments: ["platform": GraphQLVariable("platform")], type: .nonNull(.object(CheckAppVersion.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(checkAppVersion: CheckAppVersion) {
      self.init(snapshot: ["__typename": "Query", "checkAppVersion": checkAppVersion.snapshot])
    }

    public var checkAppVersion: CheckAppVersion {
      get {
        return CheckAppVersion(snapshot: snapshot["checkAppVersion"]! as! Snapshot)
      }
      set {
        snapshot.updateValue(newValue.snapshot, forKey: "checkAppVersion")
      }
    }

    public struct CheckAppVersion: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpVersion"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("platform", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("major", type: .scalar(Int.self)),
        GraphQLField("minor", type: .scalar(Int.self)),
        GraphQLField("revision", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(platform: GraphQLID, major: Int? = nil, minor: Int? = nil, revision: Int? = nil) {
        self.init(snapshot: ["__typename": "CatchUpVersion", "platform": platform, "major": major, "minor": minor, "revision": revision])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var platform: GraphQLID {
        get {
          return snapshot["platform"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "platform")
        }
      }

      public var major: Int? {
        get {
          return snapshot["major"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "major")
        }
      }

      public var minor: Int? {
        get {
          return snapshot["minor"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "minor")
        }
      }

      public var revision: Int? {
        get {
          return snapshot["revision"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "revision")
        }
      }
    }
  }
}

public final class SendPushQuery: GraphQLQuery {
  public static let operationString =
    "query SendPush($token: String!) {\n  sendPush(token: $token)\n}"

  public var token: String

  public init(token: String) {
    self.token = token
  }

  public var variables: GraphQLMap? {
    return ["token": token]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("sendPush", arguments: ["token": GraphQLVariable("token")], type: .scalar(String.self)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(sendPush: String? = nil) {
      self.init(snapshot: ["__typename": "Query", "sendPush": sendPush])
    }

    public var sendPush: String? {
      get {
        return snapshot["sendPush"] as? String
      }
      set {
        snapshot.updateValue(newValue, forKey: "sendPush")
      }
    }
  }
}

public final class BatchGetCatchUpContactsQuery: GraphQLQuery {
  public static let operationString =
    "query BatchGetCatchUpContacts($ids: [ID]) {\n  batchGetCatchUpContacts(ids: $ids) {\n    __typename\n    phone\n    nickname\n    profileImagePath\n    latitude\n    longitude\n    pushToken\n    osType\n  }\n}"

  public var ids: [GraphQLID?]?

  public init(ids: [GraphQLID?]? = nil) {
    self.ids = ids
  }

  public var variables: GraphQLMap? {
    return ["ids": ids]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("batchGetCatchUpContacts", arguments: ["ids": GraphQLVariable("ids")], type: .list(.object(BatchGetCatchUpContact.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(batchGetCatchUpContacts: [BatchGetCatchUpContact?]? = nil) {
      self.init(snapshot: ["__typename": "Query", "batchGetCatchUpContacts": batchGetCatchUpContacts.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
    }

    public var batchGetCatchUpContacts: [BatchGetCatchUpContact?]? {
      get {
        return (snapshot["batchGetCatchUpContacts"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { BatchGetCatchUpContact(snapshot: $0) } } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "batchGetCatchUpContacts")
      }
    }

    public struct BatchGetCatchUpContact: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpContact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("phone", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("nickname", type: .scalar(String.self)),
        GraphQLField("profileImagePath", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("pushToken", type: .scalar(String.self)),
        GraphQLField("osType", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(phone: GraphQLID, nickname: String? = nil, profileImagePath: String? = nil, latitude: Double? = nil, longitude: Double? = nil, pushToken: String? = nil, osType: String? = nil) {
        self.init(snapshot: ["__typename": "CatchUpContact", "phone": phone, "nickname": nickname, "profileImagePath": profileImagePath, "latitude": latitude, "longitude": longitude, "pushToken": pushToken, "osType": osType])
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

      public var pushToken: String? {
        get {
          return snapshot["pushToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "pushToken")
        }
      }

      public var osType: String? {
        get {
          return snapshot["osType"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "osType")
        }
      }
    }
  }
}

public final class ListCatchUpPromisesByContactQuery: GraphQLQuery {
  public static let operationString =
    "query ListCatchUpPromisesByContact($contact: String!) {\n  listCatchUpPromisesByContact(contact: $contact) {\n    __typename\n    id\n    owner\n    dateTime\n    address\n    latitude\n    longitude\n    name\n    contacts\n  }\n}"

  public var contact: String

  public init(contact: String) {
    self.contact = contact
  }

  public var variables: GraphQLMap? {
    return ["contact": contact]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listCatchUpPromisesByContact", arguments: ["contact": GraphQLVariable("contact")], type: .list(.nonNull(.object(ListCatchUpPromisesByContact.selections)))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listCatchUpPromisesByContact: [ListCatchUpPromisesByContact]? = nil) {
      self.init(snapshot: ["__typename": "Query", "listCatchUpPromisesByContact": listCatchUpPromisesByContact.flatMap { $0.map { $0.snapshot } }])
    }

    public var listCatchUpPromisesByContact: [ListCatchUpPromisesByContact]? {
      get {
        return (snapshot["listCatchUpPromisesByContact"] as? [Snapshot]).flatMap { $0.map { ListCatchUpPromisesByContact(snapshot: $0) } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "listCatchUpPromisesByContact")
      }
    }

    public struct ListCatchUpPromisesByContact: GraphQLSelectionSet {
      public static let possibleTypes = ["CatchUpPromise"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("owner", type: .scalar(String.self)),
        GraphQLField("dateTime", type: .scalar(String.self)),
        GraphQLField("address", type: .scalar(String.self)),
        GraphQLField("latitude", type: .scalar(Double.self)),
        GraphQLField("longitude", type: .scalar(Double.self)),
        GraphQLField("name", type: .scalar(String.self)),
        GraphQLField("contacts", type: .list(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, owner: String? = nil, dateTime: String? = nil, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil, name: String? = nil, contacts: [String?]? = nil) {
        self.init(snapshot: ["__typename": "CatchUpPromise", "id": id, "owner": owner, "dateTime": dateTime, "address": address, "latitude": latitude, "longitude": longitude, "name": name, "contacts": contacts])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var owner: String? {
        get {
          return snapshot["owner"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "owner")
        }
      }

      public var dateTime: String? {
        get {
          return snapshot["dateTime"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dateTime")
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

      public var name: String? {
        get {
          return snapshot["name"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var contacts: [String?]? {
        get {
          return snapshot["contacts"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "contacts")
        }
      }
    }
  }
}