//
//  Settings.swift
//  ArcwindUI
//
//  Created by Marcel Dierkes on 10.02.23.
//

import Foundation

public final class Settings {
    public static let shared: Settings = .init(userDefaults: .standard)
    
    public let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        userDefaults.register(defaults: [
            Keys.isWorkExpanded: true,
            Keys.isEducationExpanded: true,
            Keys.isLanguagesExpanded: true,
        ])
    }
}

public extension Settings {
    var isEducationExpanded: Bool {
        get {
            self.userDefaults.bool(forKey: Keys.isEducationExpanded)
        }
        set {
            self.userDefaults.set(newValue, forKey: Keys.isEducationExpanded)
        }
    }
    
    var isWorkExpanded: Bool {
        get {
            self.userDefaults.bool(forKey: Keys.isWorkExpanded)
        }
        set {
            self.userDefaults.set(newValue, forKey: Keys.isWorkExpanded)
        }
    }
    
    var isLanguagesExpanded: Bool {
        get {
            self.userDefaults.bool(forKey: Keys.isLanguagesExpanded)
        }
        set {
            self.userDefaults.set(newValue, forKey: Keys.isLanguagesExpanded)
        }
    }
    
    var isSkillsExpanded: Bool {
        get {
            self.userDefaults.bool(forKey: Keys.isSkillsExpanded)
        }
        set {
            self.userDefaults.set(newValue, forKey: Keys.isSkillsExpanded)
        }
    }
}

private extension Settings {
    private enum Keys {
        static let isEducationExpanded = "ACWEducationSectionExpanded"
        static let isWorkExpanded = "ACWWorkSectionExpanded"
        static let isLanguagesExpanded = "ACWLanguagesSectionExpanded"
        static let isSkillsExpanded = "ACWSkillsSectionExpanded"
    }
}
