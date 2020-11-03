//
//  Profile.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 30/10/20.
//

import Foundation

// MARK: - Profile
struct Profile: Codable {
    let name, userName: String?
    let img: String?

    enum CodingKeys: String, CodingKey {
        case name
        case userName = "user_name"
        case img
    }
}

// MARK: Profile convenience initializers and mutators

extension Profile {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Profile.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        name: String?? = nil,
        userName: String?? = nil,
        img: String?? = nil
    ) -> Profile {
        return Profile(
            name: name ?? self.name,
            userName: userName ?? self.userName,
            img: img ?? self.img
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
