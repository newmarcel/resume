//
//  SectionView.swift
//  ArcwindUI
//
//  Created by Marcel Dierkes on 13.02.23.
//

import UIKit
import SwiftUI
import ArcwindResume

public struct SectionView: View {
    public let section: ArcwindResume.Section
    
    public var body: some View {
        let section = self.section
        Form {
            Section {
                Text(section.localizedDateRange)
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                
                if let title = section.title {
                    Text(title)
                        .font(.title)
                        .foregroundColor(.primary)
                        .listRowSeparator(.hidden)
                    if let secondaryText = section.secondaryText {
                        HStack {
                            Text(secondaryText)
                                .font(.subheadline)
                            Spacer()
                            if let url = section.url {
                                Link(destination: url) {
                                    Image(systemName: "safari")
                                }
                            }
                        }
                    }
                } else {
                    if let secondaryText = section.secondaryText {
                        HStack {
                            Text(secondaryText)
                            Spacer()
                            if let url = section.url {
                                Link(destination: url) {
                                    Image(systemName: "safari")
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
            Section("Tasks") {
                List(section.listedTexts ?? [], id: \.self) { text in
                    HStack {
                        Image(systemName: "arrow.up.forward.square")
                            .foregroundColor(.secondary)
                        Text(text)
                    }
                }
            }
        }
    }
}
