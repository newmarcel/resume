//
//  SectionSummaryView.swift
//  ArcwindUI
//
//  Created by Marcel Dierkes on 10.02.23.
//

import SwiftUI
import ArcwindResume

struct SectionSummaryView: View {
    let section: ArcwindResume.Section
    
    var body: some View {
        let section = self.section
        
        VStack(alignment: .leading, spacing: 4.0) {
            Text(section.localizedDateRange)
                .font(.caption)
                .foregroundColor(.accentColor)
            
            if let title = section.title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                if let secondaryText = section.secondaryText {
                    Text(secondaryText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                if let secondaryText = section.secondaryText {
                    Text(secondaryText)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

extension ArcwindResume.Section {
    var localizedDateRange: String {
        let formatStyle: Date.FormatStyle = {
            switch self.dateDisplayStyle {
            case .year:
                return .dateTime.year()
            case .monthAndYear:
                return .dateTime.year().month(.abbreviated)
            }
        }()
        
        let fromDateString = self.fromDate.formatted(formatStyle)
        let toDateString = {
            if let toDate = self.toDate {
                return toDate.formatted(formatStyle)
            } else {
                return NSLocalizedString("Today", comment: "Today")
            }
        }()
        return "\(fromDateString) – \(toDateString)"
    }
}
