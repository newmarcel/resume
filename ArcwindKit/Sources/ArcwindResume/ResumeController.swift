//
//  ResumeController.swift
//  ArcwindResume
//
//  Created by Marcel Dierkes on 13.02.23.
//

import Foundation

public final class ResumeController {
    
    // MARK: - Class Properties
    
    public static let resumeDidChangeNotification: Notification.Name = .init("ArcwindResumeDidChangeNotification")
    
    // MARK: - Properties
    
    public private(set) var resume: Resume?
    
    public let urlSession: URLSession
    public let notificationCenter: NotificationCenter
    
    // MARK: - Life Cycle
    
    public init(urlSession: URLSession = .shared, notificationCenter: NotificationCenter = .default, performInitialRequest: Bool = true) {
        self.urlSession = urlSession
        self.notificationCenter = notificationCenter
        
        if performInitialRequest {
            Task {
                _ = try? await self.getResume()
            }
        }
    }
    
    deinit {
        self.urlSession.invalidateAndCancel()
    }
    
    // MARK: - Request
    
    /// Requests a resume
    /// - Note: The most recent successfully requested resume is available via the `resume` property.
    /// - Returns: A resume
    public func getResume() async throws -> Resume {
        let (data, _) = try await self.urlSession.data(from: Configuration.resumeURL)
        
        let decoder = JSONDecoder()
        let resume = try decoder.decode(Resume.self, from: data)
        
        // Cache the resume
        Task {
            await self.updateResume(resume)
        }
        
        return resume
    }
    
    // MARK: -
}

private extension ResumeController {
    @MainActor
    func updateResume(_ resume: Resume?) async {
        self.resume = resume
        self.notificationCenter.post(name: Self.resumeDidChangeNotification, object: resume)
    }
}

private extension ResumeController {
    enum Configuration {
        static let baseURL = URL("https://marcel-dierkes.info/")
        static let fileExtension = "json"
        static let languages = ["en", "de"]
        
        static func filePath(for locale: Locale = .current) -> String {
            let languageIdentifier = locale.language.languageCode?.identifier ?? "en"
            let fileName = self.languages.contains(languageIdentifier) ? languageIdentifier : self.languages[0]
            
            return "cv/\(fileName).\(self.fileExtension)"
        }
        
        static var resumeURL: URL {
            guard let url = URL(string: self.filePath(), relativeTo: self.baseURL) else {
                fatalError("Failed to create resume URL")
            }
            return url
        }
    }
}
