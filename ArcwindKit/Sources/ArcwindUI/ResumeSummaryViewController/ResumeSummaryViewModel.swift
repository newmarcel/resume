//
//  ResumeSummaryViewModel.swift
//  ArcwindUI
//
//  Created by Marcel Dierkes on 10.02.23.
//

import UIKit
import ArcwindResume

final class ResumeSummaryViewModel {
    
    // MARK: - Types
    
    enum Section: Hashable {
        case personalInfo(Item)
        case work(isExpanded: Bool, headerItem: Item, items: [Item])
        case education(isExpanded: Bool, headerItem: Item, items: [Item])
        case languages(isExpanded: Bool, headerItem: Item, items: [Item])
        case skills(isExpanded: Bool, headerItem: Item, items: [Item])
        case loading(Item)
    }
    
    enum Item: Hashable {
        case personalInfo(PersonalInfo)
        
        case educationHeader
        case education(ArcwindResume.Section)
        
        case workHeader
        case work(ArcwindResume.Section)
        
        case languagesHeader
        case language(Language)
        
        case skillsHeader
        case skill(String)
        
        case loadingIndicator
    }
    
    // MARK: - Properties
    
    let resume: Resume?
    let settings: Settings
    
    var sections: [Section] = []
    
    // MARK: - Life Cycle
    
    required init(resume: Resume?, settings: Settings = .shared) {
        self.resume = resume
        self.settings = settings
        
        self.reloadSections()
    }
}

extension ResumeSummaryViewModel {
    func reloadSections() {
        guard let resume = self.resume else {
            self.sections = [.loading(.loadingIndicator)]
            return
        }
        
        let settings = self.settings
        
        let sections: [Section] = [
            .personalInfo(.personalInfo(resume.personalInfo)),
            .work(
                isExpanded: settings.isWorkExpanded,
                headerItem: .workHeader,
                items: resume.workSections
                    .sorted(by: { $0.toDate ?? Date() > $1.toDate ?? Date() })
                    .map(Item.work(_:))
            ),
            .education(
                isExpanded: settings.isEducationExpanded,
                headerItem: .educationHeader,
                items: resume.eductionSections
                    .sorted(by: { $0.toDate ?? Date() > $1.toDate ?? Date() })
                    .map(Item.education(_:))
            ),
            .languages(
                isExpanded: settings.isLanguagesExpanded,
                headerItem: .languagesHeader,
                items: resume.languages.map(Item.language(_:))
            ),
            .skills(
                isExpanded: settings.isSkillsExpanded,
                headerItem: .skillsHeader,
                items: resume.skills.map(Item.skill(_:))
            )
        ]
        self.sections = sections
    }
}

extension ResumeSummaryViewModel.Item {
    var localizedTitle: String {
        switch self {
        case .personalInfo:
            return ""
        case .educationHeader, .education:
            return NSLocalizedString("Education", comment: "Education")
        case .workHeader, .work:
            return NSLocalizedString("Work", comment: "Work")
        case .languagesHeader, .language:
            return NSLocalizedString("Languages", comment: "Languages")
        case .skillsHeader:
            return NSLocalizedString("Skills", comment: "Skills")
        case .skill(let skill):
            return skill
        case .loadingIndicator:
            return NSLocalizedString("Loading…", comment: "Loading…")
        }
    }
}
