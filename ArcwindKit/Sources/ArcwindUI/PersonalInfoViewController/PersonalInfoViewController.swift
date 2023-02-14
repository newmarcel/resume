//
//  PersonalInfoViewController.swift
//  ArcwindUI
//
//  Created by Marcel Dierkes on 11.02.23.
//

import SwiftUI
import ArcwindResume

public final class PersonalInfoViewController: UIHostingController<PersonalInfoView> {
    public required init(personalInfo: PersonalInfo) {
        super.init(rootView: PersonalInfoView(personalInfo: personalInfo))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}
