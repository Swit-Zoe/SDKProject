// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct BodyBlockSkit: Codable {
    let type: String
    let elements: [Elements]
}

// MARK: - WelcomeElement
struct Elements: Codable {
    let type: String
    let elements: [TextElements]
}

// MARK: - ElementElementClass
struct TextElements: Codable {
    let type: RichType
    let userID, content, name,url: String?
    let styles : Styles?

    enum CodingKeys: String, CodingKey {
        case type
        case userID = "user_id"
        case content, name, url, styles
    }
}

enum RichType: String, Codable {
    case text = "rt_text"
    case mention = "rt_mention"
    case link = "rt_link"
    case emoji = "rt_emoji"
}


struct Styles: Codable {
    let bold: Bool?
    let code: Bool?
    let italic: Bool?
    let strike: Bool?
}
