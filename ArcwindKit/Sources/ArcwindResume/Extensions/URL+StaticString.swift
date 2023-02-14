//
//  URL+StaticString.swift
//  ArcwindResume
//
//  Created by Marcel Dierkes on 10.02.23.
//

import Foundation

extension URL {
    init(_ staticString: String) {
        guard let url = URL(string: staticString) else {
            fatalError("Invalid static URL string")
        }
        self = url
    }
}
