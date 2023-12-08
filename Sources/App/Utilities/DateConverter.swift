
import Foundation

class DateConverter {
    enum YearMode: Int {
        case CE
        case ROC
    }
    
    static let shared = DateConverter()
    
    let cachedDateFormattersQueue = DispatchQueue(label: "com.joja.date.formatter.queue")
        
    private var cachedDateFormatters = [String : DateFormatter]()
    
    fileprivate static var yearsBetweenROCandCE = 1911
    
    private func cachedDateFormatter(withFormat format: String) -> DateFormatter {
        return cachedDateFormattersQueue.sync {
            let key = format
            if let cachedFormatter = cachedDateFormatters[key] {
                return cachedFormatter
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = format
            
            cachedDateFormatters[key] = dateFormatter
            
            return dateFormatter
        }
    }
    
    func slashDateFormat(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = cachedDateFormatter(withFormat: "yyyy/MM/dd")
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func dashStringFormat(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = cachedDateFormatter(withFormat: "yyyy-MM-dd")
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func slashDateFormat(_ date: String) -> Date? {
        let dateFormatter = cachedDateFormatter(withFormat: "yyyy/MM/dd")
        return dateFormatter.date(from: date)
    }
    
    func dashDateFormat(_ date: String) -> Date? {
        let dateFormatter = cachedDateFormatter(withFormat: "yyyy-MM-dd")
        return dateFormatter.date(from: date)
    }
    
    func slashTimeFormat(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = cachedDateFormatter(withFormat: "yyyy/MM/dd HH:mm")
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func dashTimeFormat(_ string: String) -> Date? {
        if let date = cachedDateFormatter(withFormat: "yyyy-MM-dd HH:mm:ss").date(from: string) {
            return date
        }
        return nil
    }
    
    func dashTimeStringFormat(_ date: Date?) -> String {
        if let date = date {
            let dateFormatter = cachedDateFormatter(withFormat: "yyyy-MM-dd HH:mm:ss")
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    func dateFromROC(_ date: String?) -> Date {
        if let date = date, date.count == 7 {
            let year = date.prefix(3)
            let monthStart = date.index(date.startIndex, offsetBy: 3)
            let monthEnd = date.index(monthStart, offsetBy: 2)
            let month = date[monthStart ..< monthEnd]
            let day = date.suffix(2)
            let ceYear = DateConverter.CEyearFromROC(Int(year) ?? 0)
            let dateStr = "\(ceYear)" + month + day
            
            let dateFormatter = cachedDateFormatter(withFormat: "yyyyMMdd")
//            let dateFormatter = DateFormatter()
//            dateFormatter.timeZone = .current
//            dateFormatter.dateFormat = "yyyyMMdd"
            let date = dateFormatter.date(from: dateStr)
            
            return date ?? Date.init()
        }
        return Date.init()
    }
    
//    func removeTime(from date: Date) -> Date? {
//        let dateFormatter = cachedDateFormatter(withFormat: "yyyy/MM/dd")
//        return dateFormatter.date(from: dateFormatter.string(from: date))
//    }
    
    class func CEyearFromROC(_ year: Int) -> Int {
        return year + yearsBetweenROCandCE
    }
    
    class func ROCYearFromCE(_ year: Int) -> Int {
        return year - yearsBetweenROCandCE
    }
    
    class func date(year: Int, month: Int, day: Int, yearMode: YearMode = .CE) -> Date {
        let year = (yearMode == .CE) ? year : year + yearsBetweenROCandCE
        return Calendar(identifier: Calendar.Identifier.gregorian).date(from: DateComponents(year: year, month: month, day: day)) ?? Date(timeIntervalSince1970: 0)
    }
    
    class func dateBefore(years: Int, from date: Date = Date()) -> Date {
        return Calendar(identifier: Calendar.Identifier.gregorian).date(byAdding: DateComponents(year:-years, month:0, day:0), to: date) ?? Date(timeIntervalSince1970: 0)
    }
    
    class func CE8digits(_ date: Date?) -> String {
        if let date = date {
            let dateComponents = Calendar(identifier: Calendar.Identifier.gregorian).dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
            return String(format: "%04d%02d%02d", dateComponents.year ?? 0, dateComponents.month ?? 0, dateComponents.day ?? 0)
        }
        return ""
    }
    
    class func ROC7digits(_ date: Date?) -> String {
        if let date = date {
            let dateComponents = Calendar(identifier: Calendar.Identifier.gregorian).dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
            return String(format: "%03d%02d%02d", DateConverter.ROCYearFromCE(dateComponents.year ?? yearsBetweenROCandCE), dateComponents.month ?? 0, dateComponents.day ?? 0)
        }
        return ""
    }
    
    class func slashFormatROC(_ date: Date?) -> String {
        if let date = date {
            let dateComponents = Calendar(identifier: Calendar.Identifier.gregorian).dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day], from: date)
            return String(format: "%d/%02d/%02d", DateConverter.ROCYearFromCE(dateComponents.year ?? yearsBetweenROCandCE), dateComponents.month ?? 0, dateComponents.day ?? 0)
        }
        return ""
    }
}
