//
//  ResumeSummaryViewController.swift
//  ArcwindUI
//
//  Created by Marcel Dierkes on 10.02.23.
//

import UIKit
import SwiftUI
import Combine
import ArcwindResume

public final class ResumeSummaryViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var viewModel: ResumeSummaryViewModel!
    private var cancellableResumeNotificationObserver: Cancellable?
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<ResumeSummaryViewModel.Section, ResumeSummaryViewModel.Item>!
    
    // MARK: - Life Cycle
    
    public required init() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            if sectionIndex != 0 {
                configuration.headerMode = .firstItemInSection
            }
            return .list(using: configuration, layoutEnvironment: environment)
        }
        super.init(collectionViewLayout: layout)
    }
    
    @available(*, unavailable)
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        fatalError("init(collectionViewLayout:) is not supported")
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
        
        self.configureResumeController()
        self.reloadViewModel()
        self.configureDiffableDataSource()
        self.applySnapshot(animated: false)
        
        self.title = NSLocalizedString("Resume", comment: "Resume")
        
        // Enable pull-to-refresh
        self.collectionView.refreshControl = UIRefreshControl(frame: .zero, primaryAction: UIAction { [weak self] _ in
            Task {
                do {
                    _ = try await self?.resumeDocumentViewController?.resumeController.getResume()
                    try await Task.sleep(for: .seconds(1.0))
                    self?.collectionView.refreshControl?.endRefreshing()
                } catch {
                    print("Failed to fetch resume", error)
                }
            }
        })
    }
    
    // MARK: - UICollectionViewDelegate
    
    public override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return self.collectionView(collectionView, shouldSelectItemAt: indexPath)
    }

    public override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let item = self.diffableDataSource.itemIdentifier(for: indexPath) else {
            return false
        }
        
        switch item {
        case .skill, .language: return false
        default: return true
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.diffableDataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        switch item {
        case .personalInfo(let personalInfo):
            let controller = PersonalInfoViewController(personalInfo: personalInfo)
            self.navigationController?.pushViewController(controller, animated: true)
        case .work(let section), .education(let section):
            let controller = SectionViewController(section: section)
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
}

// MARK: - ResumeSummaryViewController + Configuration
private extension ResumeSummaryViewController {
    func configureResumeController() {
        self.cancellableResumeNotificationObserver = self.resumeDocumentViewController?.resumeController.notificationCenter
            .publisher(for: ResumeController.resumeDidChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                self.reloadViewModel()
                self.applySnapshot(animated: true)
            })
    }
    
    func configureDiffableDataSource() {
        typealias Registration = UICollectionView.CellRegistration<UICollectionViewListCell, ResumeSummaryViewModel.Item>
        
        let headerRegistration = Registration { cell, indexPath, item in
            var content = UIListContentConfiguration.prominentInsetGroupedHeader()
            content.text = item.localizedTitle
            cell.contentConfiguration = content
            
            cell.accessories = [
                .outlineDisclosure()
            ]
        }
        let personalInfoRegistration = Registration { cell, indexPath, item in
            guard case .personalInfo(let personalInfo) = item else { return }
            
            cell.contentConfiguration = UIHostingConfiguration {
                PersonalInfoSummaryView(personalInfo: personalInfo)
            }
            cell.accessories = [
                .disclosureIndicator()
            ]
        }
        let workRegistration = Registration { cell, indexPath, item in
            guard case .work(let work) = item else { return }
            
            cell.contentConfiguration = UIHostingConfiguration {
                SectionSummaryView(section: work)
            }
            cell.accessories = [
                .disclosureIndicator()
            ]
        }
        let educationRegistration = Registration { cell, indexPath, item in
            guard case .education(let education) = item else { return }
            
            cell.contentConfiguration = UIHostingConfiguration {
                SectionSummaryView(section: education)
            }
            cell.accessories = [
                .disclosureIndicator()
            ]
        }
        let languageRegistration = Registration { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "globe")
            content.prefersSideBySideTextAndSecondaryText = true
            if case .language(let language) = item {
                content.text = language.name
                content.textProperties.font = .preferredFont(forTextStyle: .body)
                content.textProperties.color = .label
                content.secondaryText = language.level.localizedTitle
                content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
                content.secondaryTextProperties.color = .secondaryLabel
            }
            cell.contentConfiguration = content
        }
        let skillRegistration = Registration { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            content.textProperties.font = .preferredFont(forTextStyle: .body)
            content.textProperties.color = .label
            if case .skill(let skill) = item {
                content.text = skill
            }
            cell.contentConfiguration = content
        }
        let loadingRegistration = UICollectionView.CellRegistration<UICollectionViewCell, ResumeSummaryViewModel.Item> { cell, indexPath, item in
            cell.contentConfiguration = UIHostingConfiguration {
                Group {
                    ProgressView(item.localizedTitle)
                }
                .frame(minHeight: 200.0)
            }
        }
        
        self.diffableDataSource = .init(collectionView: self.collectionView) { collectionView, indexPath, item in
            switch item {
            case .educationHeader, .workHeader, .languagesHeader, .skillsHeader:
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            case .personalInfo:
                return collectionView.dequeueConfiguredReusableCell(using: personalInfoRegistration, for: indexPath, item: item)
            case .education:
                return collectionView.dequeueConfiguredReusableCell(using: educationRegistration, for: indexPath, item: item)
            case .work:
                return collectionView.dequeueConfiguredReusableCell(using: workRegistration, for: indexPath, item: item)
            case .language:
                return collectionView.dequeueConfiguredReusableCell(using: languageRegistration, for: indexPath, item: item)
            case .skill:
                return collectionView.dequeueConfiguredReusableCell(using: skillRegistration, for: indexPath, item: item)
            case .loadingIndicator:
                return collectionView.dequeueConfiguredReusableCell(using: loadingRegistration, for: indexPath, item: item)
            }
        }
        self.diffableDataSource.sectionSnapshotHandlers.willExpandItem = { item in
            let settings = self.viewModel.settings
            switch item {
            case .educationHeader:
                settings.isEducationExpanded = true
            case .workHeader:
                settings.isWorkExpanded = true
            case .languagesHeader:
                settings.isLanguagesExpanded = true
            case .skillsHeader:
                settings.isSkillsExpanded = true
            default:
                break
            }
        }
        self.diffableDataSource.sectionSnapshotHandlers.willCollapseItem = { item in
            let settings = self.viewModel.settings
            switch item {
            case .educationHeader:
                settings.isEducationExpanded = false
            case .workHeader:
                settings.isWorkExpanded = false
            case .languagesHeader:
                settings.isLanguagesExpanded = false
            case .skillsHeader:
                settings.isSkillsExpanded = false
            default:
                break
            }
        }
    }
    
    func applySnapshot(animated: Bool = false) {
        let snapshot = NSDiffableDataSourceSnapshot<ResumeSummaryViewModel.Section, ResumeSummaryViewModel.Item>()
        self.diffableDataSource.apply(snapshot, animatingDifferences: animated)
        
        for section in self.viewModel.sections {
            var snapshot = NSDiffableDataSourceSectionSnapshot<ResumeSummaryViewModel.Item>()
            
            switch section {
            case .personalInfo(let item), .loading(let item):
                snapshot.append([item])
            case .education(isExpanded: let isExpanded, headerItem: let headerItem, items: let items),
                    .work(isExpanded: let isExpanded, headerItem: let headerItem, items: let items),
                    .languages(isExpanded: let isExpanded, headerItem: let headerItem, items: let items),
                    .skills(isExpanded: let isExpanded, headerItem: let headerItem, items: let items):
                snapshot.append([headerItem])
                snapshot.append(items, to: headerItem)
                if isExpanded { snapshot.expand([headerItem]) }
            }
            
            self.diffableDataSource.apply(snapshot, to: section, animatingDifferences: animated)
        }
    }
}

// MARK: - ResumeSummaryViewController + View Model
private extension ResumeSummaryViewController {
    var resume: Resume? {
        self.resumeDocumentViewController?.resumeController.resume
    }
    
    func reloadViewModel() {
        self.viewModel = ResumeSummaryViewModel(resume: self.resume)
    }
}
