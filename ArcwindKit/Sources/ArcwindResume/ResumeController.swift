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
    
    public private(set) var resume: Resume? {
        didSet {
            DispatchQueue.main.async {
                self.notificationCenter.post(name: Self.resumeDidChangeNotification, object: self.resume)
            }
        }
    }
    
    public let urlSession: URLSession
    public let notificationCenter: NotificationCenter
    
    // MARK: - Life Cycle
    
    public init(urlSession: URLSession = .shared, notificationCenter: NotificationCenter = .default, performInitialRequest: Bool = true) {
        self.urlSession = urlSession
        self.notificationCenter = notificationCenter
        
        if performInitialRequest {
            self.getResume(completion: nil)
        }
    }
    
    deinit {
        self.urlSession.invalidateAndCancel()
    }
    
    // MARK: - Request
    
    /// Requests a resume.
    /// - Note: The most recent successfully requested resume is available via the `resume` property.
    /// - Parameter completion: A completion handler with either a resume or an error
    public func getResume(completion: ((Result<Resume, Error>) -> Void)?) {
        let request = URLRequest(url: Configuration.resumeURL)
        let task = self.urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error {
                    completion?(.failure(error))
                    return
                }
                if let data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let resume = try decoder.decode(Resume.self, from: data)
                        
                        // Populate the resume property for easy access
                        self.resume = resume
                        
                        completion?(.success(resume))
                    } catch {
                        completion?(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    // MARK: -
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
