//
//  PersonalInfoView.swift
//  ArcwindUI
//
//  Created by Marcel Dierkes on 11.02.23.
//

import SwiftUI
import ArcwindResume

public struct PersonalInfoView: View {
    public let personalInfo: PersonalInfo
    
    public var body: some View {
        let personalInfo = self.personalInfo
        
        List {
            Section {
                PersonalInfoSummaryView(personalInfo: personalInfo, nameIncludesDegree: false)
            }
            Section {
                HStack {
                    Text("Degree")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(personalInfo.degree ?? "—")
                }
                HStack {
                    Text("Location")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(personalInfo.locationName)
                }
                HStack {
                    Text("Birthday")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(personalInfo.birthDate.formatted(.dateTime.year().month().day()))
                    Text("in \(personalInfo.placeOfBirth)")
                        .foregroundColor(.secondary)
                }
            }
            Section {
                HStack {
                    if let url = URL(string: "mailto:" + personalInfo.email) {
                        Link(personalInfo.email, destination: url)
                    }
                    Spacer()
                    Image(systemName: "envelope")
                        .foregroundColor(.accentColor)
                }
            }
            Section {
                ForEach(personalInfo.websiteURLs, id: \.self) { url in
                    HStack {
                        Link(url.absoluteString, destination: url)
                        Spacer()
                        Image(systemName: "safari")
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .font(.body)
        .listStyle(.insetGrouped)
    }
}
