//
//  SectionViewController.swift
//  ArcwindUI
//
//  Created by Marcel Dierkes on 13.02.23.
//

import UIKit
import SwiftUI
import ArcwindResume

public final class SectionViewController: UIHostingController<SectionView> {
    public required init(section: ArcwindResume.Section) {
        super.init(rootView: SectionView(section: section))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}
