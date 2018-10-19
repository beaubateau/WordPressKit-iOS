import Foundation

extension JSONDecoder {

    static var apiDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.supportMultipleDateFormats
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

extension JSONDecoder.DateDecodingStrategy {
    
    enum DateFormat: String, CaseIterable {
        case noTime = "yyyy-mm-dd"
        case dateWithTime = "yyyy-MM-dd HH:mm:ss"
        case iso8601 = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        var formatter: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = rawValue
            return dateFormatter
        }
    }
    
    static var supportMultipleDateFormats: JSONDecoder.DateDecodingStrategy {
        return JSONDecoder.DateDecodingStrategy.custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            let len = dateStr.count
            var date: Date?

            for format in DateFormat.allCases {
                date = format.formatter.date(from: dateStr)
                if date != nil {
                    break
                }
            }

            if let date = date {
                return date
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode date string \(dateStr)"
                )
            }
        })
    }
}
