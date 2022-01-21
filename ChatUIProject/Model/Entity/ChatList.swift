// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ChatList: Equatable,Codable {
    static func == (lhs: ChatList, rhs: ChatList) -> Bool {
        return lhs.data.count != rhs.data.count ? false : true
    }
    
    let code: Int
    let xsoc: String
    var data: [Chat]
    let version: Int
    let timestamp, message: String
}

// MARK: - Datum
struct Chat: Equatable,Codable {
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.created == rhs.created ? true : false
    }
    
    let created: Date
    let assetData: [AssetDatum]
    let notiJSON: NotiJSON?
    let bodyText: String
    let wsID: WsID
    let clientID: String
    let isOutcome: Bool
    let pinID: String
    let originMsgID: MsgID
    let modified: Modified
    let msgCmtCnt: Int
    let contID, bodyBlockskit: String
    let chatType: ChatType
    let chName: String
    let messageData: [MessageDatum]
    let seq, userID: String
    let contType: ContType
    let backlogData: [JSONAny]
    let userName, msgID: String
    let reactions: [Reaction]
    let bookmarkYn: BookmarkYn
    let attachments: [JSONAny]
    let chID: ChID
    let shareData: JSONNull?
    let ogData: [OgDatum]

    enum CodingKeys: String, CodingKey {
        case created
        case assetData = "asset_data"
        case notiJSON = "noti_json"
        case bodyText = "body_text"
        case wsID = "ws_id"
        case clientID = "client_id"
        case isOutcome = "is_outcome"
        case pinID = "pin_id"
        case originMsgID = "origin_msg_id"
        case modified
        case msgCmtCnt = "msg_cmt_cnt"
        case contID = "cont_id"
        case bodyBlockskit = "body_blockskit"
        case chatType = "chat_type"
        case chName = "ch_name"
        case messageData = "message_data"
        case seq
        case userID = "user_id"
        case contType = "cont_type"
        case backlogData = "backlog_data"
        case userName = "user_name"
        case msgID = "msg_id"
        case reactions
        case bookmarkYn = "bookmark_yn"
        case attachments
        case chID = "ch_id"
        case shareData = "share_data"
        case ogData = "og_data"
    }
}

// MARK: - AssetDatum
struct AssetDatum: Codable {
    let imageY: Int
    let fileName, filePath, assetID: String
    let fileMIME: FileMIME
    let saveLOC: Int
    let created: Date
    let imageX: Int
    let thumbnail: String
    let fileSize: Int
    let userID, mimeType: String

    enum CodingKeys: String, CodingKey {
        case imageY = "image_y"
        case fileName = "file_name"
        case filePath = "file_path"
        case assetID = "asset_id"
        case fileMIME = "file_mime"
        case saveLOC = "save_loc"
        case created
        case imageX = "image_x"
        case thumbnail
        case fileSize = "file_size"
        case userID = "user_id"
        case mimeType = "mime_type"
    }
}

enum FileMIME: String, Codable {
    case image = "image"
    case pres = "pres"
    case video = "video"
}

enum BookmarkYn: String, Codable {
    case n = "N"
}

enum ChID: String, Codable {
    case the57Ldiwwg36L0BpYS = "57ldiwwg36L0bpYS"
}

enum ChatType: String, Codable {
    case sys = "sys"
    case txt = "txt"
}

enum ContType: String, Codable {
    case chat = "chat"
}

// MARK: - MessageDatum
struct MessageDatum: Codable {
    let messageData: [JSONAny]
    let created : Date
    let wsName, chName, blockskitType: String
    let bodyBlockskit, bodyText, userID, pinID: String
    let modified: String
    let backlogData: [JSONAny]
    let msgID: MsgID
    let notiJSON: JSONNull?
    let wsID, chID: String
    let contType: ContType
    let msgCmtCnt: Int
    let clientID, contID, originMsgID: String
    let chatType: ChatType
    let userName: String
    let assetData: [AssetDatum]
    let seq: String
    let ogData: [OgDatum]
    let bookmarkYn: BookmarkYn
    let isOutcome: Bool

    enum CodingKeys: String, CodingKey {
        case messageData = "message_data"
        case created
        case wsName = "ws_name"
        case chName = "ch_name"
        case blockskitType = "BlockskitType"
        case bodyBlockskit = "body_blockskit"
        case bodyText = "body_text"
        case userID = "user_id"
        case pinID = "pin_id"
        case modified
        case backlogData = "backlog_data"
        case msgID = "msg_id"
        case notiJSON = "noti_json"
        case wsID = "ws_id"
        case chID = "ch_id"
        case contType = "cont_type"
        case msgCmtCnt = "msg_cmt_cnt"
        case clientID = "client_id"
        case contID = "cont_id"
        case originMsgID = "origin_msg_id"
        case chatType = "chat_type"
        case userName = "user_name"
        case assetData = "asset_data"
        case seq
        case ogData = "og_data"
        case bookmarkYn = "bookmark_yn"
        case isOutcome = "is_outcome"
    }
}

enum MsgID: String, Codable {
    case empty = ""
    case the211117064760F2OQj8G = "211117064760F2oQj8G"
    case the211125060860Eumvyyn = "211125060860Eumvyyn"
    case the211216063060ThtaFs3 = "211216063060ThtaFs3"
}

// MARK: - OgDatum
struct OgDatum: Codable {
    let ogViedoID: String?
    let ogImage: String
    let ogVideo: String?
    let ogOwner: String?
    let ogThumImage: String?
    let ogURL: String
    let ogType, ogTitle: String
    let ogDescription: String?
    let ogSite: String?

    enum CodingKeys: String, CodingKey {
        case ogViedoID = "ogViedoId"
        case ogImage, ogVideo, ogOwner, ogThumImage
        case ogURL = "ogUrl"
        case ogType, ogTitle, ogDescription, ogSite
    }
}

enum Modified: String, Codable {
    case empty = ""
    case the20211118T111154134842Z = "2021-11-18T11:11:54.134842Z"
    case the20211125T135108091377Z = "2021-11-25T13:51:08.091377Z"
    case the20211128T071103867583Z = "2021-11-28T07:11:03.867583Z"
}

// MARK: - NotiJSON
struct NotiJSON: Codable {
    let notiValues: NotiValues
    let notiTempCode: NotiTempCode

    enum CodingKeys: String, CodingKey {
        case notiValues = "noti_values"
        case notiTempCode = "noti_temp_code"
    }
}

enum NotiTempCode: String, Codable {
    case s010 = "S010"
    case s012 = "S012"
}

// MARK: - NotiValues
struct NotiValues: Codable {
    let userName: String
    let chName: ChName
    let fromUserName: String?

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case chName = "ch_name"
        case fromUserName = "from_user_name"
    }
}

enum ChName: String, Codable {
    case the57Ldiwwg36L0BpYS = "#57ldiwwg36L0bpYS"
}

// MARK: - Reaction
struct Reaction: Codable {
    let users: [String]
    let count: Int
    let value: String
}

enum WsID: String, Codable {
    case the7KYTjHXN98FUutGA = "7kYTjHXN98FUutGA"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
