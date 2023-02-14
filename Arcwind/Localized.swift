//
//  Localized.swift
//  Arcwind
//
//  Created by Marcel Dierkes on 13.02.23.
//

import Foundation

// Contains all localized strings from related packages until the
// Xcode tooling around localization export/import has improved.
enum Localized {
    static let native = NSLocalizedString("Native", comment: "Native")
    static let basic = NSLocalizedString("Basic", comment: "Basic")
    static let fluent = NSLocalizedString("Fluent", comment: "Fluent")
    
    static let resume = NSLocalizedString("Resume", comment: "Resume")
    static let today = NSLocalizedString("Today", comment: "Today")
    static let tasks = NSLocalizedString("Tasks", comment: "Tasks")
    
    static let education = NSLocalizedString("Education", comment: "Education")
    static let work = NSLocalizedString("Work", comment: "Work")
    static let languages = NSLocalizedString("Languages", comment: "Languages")
    static let skills = NSLocalizedString("Skills", comment: "Skills")
    static let loading = NSLocalizedString("Loading…", comment: "Loading…")
}
