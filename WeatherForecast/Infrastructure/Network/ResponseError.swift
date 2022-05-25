//
//  ResponseError.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import Foundation

class ResponseError: NSError, Codable {
    public let errorCode: Int
    public let localizedMessage: String
        
    enum ErrorKeys: String, CodingKey {
        case errorCode = "cod"
        case localizedMessage = "message"
    }
    
    required init(from decoder: Swift.Decoder) throws {
        let container = try decoder.container(keyedBy: ErrorKeys.self)
        let errorCodeString = try container.decode(String.self, forKey: .errorCode)
        self.errorCode = Int(errorCodeString) ?? Int.min
        self.localizedMessage = try container.decode(String.self, forKey: .localizedMessage)
        super.init(domain: "NAB", code: self.errorCode, userInfo: [NSLocalizedDescriptionKey : self.localizedMessage])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
