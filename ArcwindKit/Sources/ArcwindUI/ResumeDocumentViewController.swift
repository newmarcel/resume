//
//  ResumeDocumentViewController.swift
//  ArcwindUI
//
//  Created by Marcel Dierkes on 10.02.23.
//

import UIKit
import ArcwindResume

public final class ResumeDocumentViewController: UINavigationController {
    
    // MARK: - Properties
    
    public let resumeController: ResumeController
    
    // MARK: - Life Cycle
    
    public required init(resumeController: ResumeController) {
        self.resumeController = resumeController
        super.init(rootViewController: ResumeSummaryViewController())
    }
    
    public convenience init() {
        self.init(resumeController: .init())
    }
    
    @available(*, unavailable)
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        fatalError("init(navigationBarClass:toolbarClass:) is not supported")
    }
    
    @available(*, unavailable)
    override init(rootViewController: UIViewController) {
        fatalError("init(rootViewController:) is not supported")
    }
    
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) is not supported")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.prefersLargeTitles = true
    }
}

extension UIViewController {
    var resumeDocumentViewController: ResumeDocumentViewController? {
        self.navigationController as? ResumeDocumentViewController
    }
}
