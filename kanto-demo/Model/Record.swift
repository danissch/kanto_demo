//
//  Record.swift
//  kanto-demo
//
//  Created by Daniel Durán Schutz on 30/10/20.
//

import Foundation

// MARK: - Record
struct Record: Codable {
    let profile: Profile?
    let recordDescription: String?
    let recordVideo: String?
    let previewImg: String?

    enum CodingKeys: String, CodingKey {
        case profile
        case recordDescription = "description"
        case recordVideo = "record_video"
        case previewImg = "preview_img"
    }
}

// MARK: Record convenience initializers and mutators

extension Record {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Record.self, from: data)
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
        profile: Profile?? = nil,
        recordDescription: String?? = nil,
        recordVideo: String?? = nil,
        previewImg: String?? = nil
    ) -> Record {
        return Record(
            profile: profile ?? self.profile,
            recordDescription: recordDescription ?? self.recordDescription,
            recordVideo: recordVideo ?? self.recordVideo,
            previewImg: previewImg ?? self.previewImg
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
