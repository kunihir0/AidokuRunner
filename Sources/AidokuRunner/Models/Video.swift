//
//  Video.swift
//  AidokuRunner
//
//  Created by Aidoku on 10/24/25.
//

import Foundation

public struct Video: Sendable, Hashable, Codable {
    public var url: URL?
    public var format: String
    public var quality: String
    public var subtitles: [Subtitle]?
    public var headers: [String: String]?

    public init(
        url: URL? = nil,
        format: String,
        quality: String,
        subtitles: [Subtitle]? = nil,
        headers: [String: String]? = nil
    ) {
        self.url = url
        self.format = format
        self.quality = quality
        self.subtitles = subtitles
        self.headers = headers
    }
}

public struct Subtitle: Sendable, Hashable, Codable {
    public var url: URL?
    public var language: String
    public var format: String

    public init(url: URL? = nil, language: String, format: String) {
        self.url = url
        self.language = language
        self.format = format
    }
}

// Ensure the Wasm-memory boundary matches this.
struct VideoCodable: Sendable, Hashable, Codable {
    @URLAsString var url: URL?
    var format: String
    var quality: String
    var subtitles: [SubtitleCodable]?
    var headers: [String: String]?

    func into(store: GlobalStore) -> Video? {
        .init(
            url: url,
            format: format,
            quality: quality,
            subtitles: subtitles?.compactMap { $0.into(store: store) },
            headers: headers
        )
    }
}

struct SubtitleCodable: Sendable, Hashable, Codable {
    @URLAsString var url: URL?
    var language: String
    var format: String

    func into(store: GlobalStore) -> Subtitle? {
        .init(
            url: url,
            language: language,
            format: format
        )
    }
}
