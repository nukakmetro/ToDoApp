//
//  Month.swift
//  ToDoApp
//
//  Created by surexnx on 30.08.2024.
//

enum Month: Int {
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december

    func monthName() -> String {
        switch self {
        case .january:
            return "Январь"
        case .february:
            return "Февраль"
        case .march:
            return "Март"
        case .april:
            return "Апрель"
        case .may:
            return "Май"
        case .june:
            return "Июнь"
        case .july:
            return "Июль"
        case .august:
            return "Август"
        case .september:
            return "Сентябрь"
        case .october:
            return "Октябрь"
        case .november:
            return "Ноябрь"
        case .december:
            return "Декабрь"
        }
    }
}
