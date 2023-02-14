//
//  PersonalInfoSummaryView.swift
//  ArcwindUI
//
//  Created by Marcel Dierkes on 10.02.23.
//

import SwiftUI
import ArcwindResume

struct PersonalInfoSummaryView: View {
    let personalInfo: PersonalInfo
    var nameIncludesDegree: Bool = true
    
    var body: some View {
        let personalInfo = self.personalInfo
        HStack {
            Image(systemName: "person.circle")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.accentColor)
                .font(.system(size: 44.0, weight: .thin))
            VStack(alignment: .leading, spacing: 4.0) {
                if self.nameIncludesDegree {
                    Text(personalInfo.localizedTitle)
                        .font(.headline)
                } else {
                    Text(personalInfo.localizedName)
                        .font(.headline)
                }
                if let title = personalInfo.title {
                    Text(title)
                        .font(.subheadline)
                }
            }
        }
    }
}
