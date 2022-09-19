

import Foundation

struct DKBlog: Decodable {
    let documents: [DKDocument]
}


struct DKDocument: Decodable{
    let title: String?
    let name: String?
    let thumbnail: String?
    let datetime: Date?
    
    enum CodingKeys: String, CodingKey{
        case title, thumbnail, datetime
        case name = "blogname"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
        self.name = try container.decode(String.self, forKey: .name)
        
       // self.datetime = try container.decode(Date.self, forKey: .datetime)
        self.datetime = Date.parse(container, key: .datetime)
    }
}

extension Date {
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? values.decode(String.self, forKey: key),
              let date = from(dateString: dateString) else{
            return nil
        }
        return date
    }
    
    static func from(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy=MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        if let date = dateFormatter.date(from:dateString){
            return date
        }
        
        return nil
    }
}
