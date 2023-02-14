//
//  Resume.swift
//  ArcwindResume
//
//  Created by Marcel Dierkes on 09.02.23.
//

import Foundation

public struct Resume: Codable, Hashable {
    public let personalInfo: PersonalInfo
    
    public let eductionSections: [Section]
    public let workSections: [Section]
    
    public let languages: [Language]
    public let skills: [String]
}

public struct PersonalInfo: Hashable, Codable {
    public let givenName: String
    public let familyName: String
    public let degree: String?
    
    public var title: String? = nil
    public let locationName: String
    
    public let photoData: Data?
    
    public let birthDate: Date
    public let placeOfBirth: String
    
    public let email: String
    public let websiteURLs: [URL]
}

public struct Section: Hashable, Codable {
    public enum DateDisplayStyle: Codable {
        case year
        case monthAndYear
    }
    
    public let fromDate: Date
    public let toDate: Date?
    public var dateDisplayStyle: DateDisplayStyle = .year
    
    public var title: String?
    public var url: URL? = nil
    
    public var secondaryText: String? = nil
    public var listedTexts: [String]? = nil
}

public struct Language: Hashable, Codable {
    public enum Level: Codable {
        case native
        case basic
        case fluent
    }
    
    public let level: Level
    public let name: String
    public let locale: Locale
}

public extension PersonalInfo {
    var localizedTitle: String {
        let name = "\(self.givenName) \(self.familyName)"
        if let degree = self.degree {
            return "\(name), \(degree)"
        }
        return name
    }
    
    var localizedName: String {
        "\(self.givenName) \(self.familyName)"
    }
}

public extension Language.Level {
    var localizedTitle: String {
        switch self {
        case .native: return NSLocalizedString("Native", comment: "Native")
        case .basic: return NSLocalizedString("Basic", comment: "Basic")
        case .fluent: return NSLocalizedString("Fluent", comment: "Fluent")
        }
    }
}
