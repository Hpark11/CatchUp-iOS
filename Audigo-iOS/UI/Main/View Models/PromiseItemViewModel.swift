//
//  PromiseViewModel.swift
//  Audigo-iOS
//
//  Created by hPark on 27/10/2018.
//  Copyright © 2018 BlackBurn. All rights reserved.
//

import Foundation

struct PromiseItemViewModel {
  enum State {
    case passedAway
    case minutesLate(for: Int)
    case minutes(for: Int)
    case hours(for: Int)
    case days(for: Int)
  }
  
  private let promise: PromiseItem
  private let dateTime: Date
  private let state: State
  
  private let timeFormat = DateFormatter()
  private let dateFormat = DateFormatter()
  private let dayFormat = DateFormatter()
  
  init(promise: PromiseItem) {
    self.promise = promise
    
    let calendar = Calendar(identifier: .gregorian)
    let timestamp = promise.dateTime.timeInMillis
    dateTime = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
    
    let gap = calendar.dateComponents([.day, .hour, .minute], from: Date(), to: dateTime)
    if let dayGap = gap.day, let hourGap = gap.hour, let minuteGap = gap.minute {
      switch dayGap {
      case 0:
        if hourGap >= 1 {
          state = .hours(for: hourGap)
        } else {
          state = minuteGap > 0 ? .minutes(for: minuteGap) : .minutesLate(for: abs(minuteGap))
        }
      case 1...Int.max:
        state = .days(for: dayGap)
      default:
        state = .passedAway
      }
    } else {
      state = .passedAway
    }
  }
  
  var timeLeftText: String {
    switch state {
    case .passedAway: return "지난 약속"
    case .days(let gap): return "D - \(gap)"
    case .hours(let gap): return "\(gap)시간 전"
    case .minutes(let gap): return "\(gap)분 전"
    case .minutesLate(let gap): return "+\(gap)분"
    }
  }
  
  var timeLeftColor: UIColor {
    switch state {
    case .passedAway: return .stale
    case .days: return .stale
    case .hours: return .warmBlue
    case .minutes: return .darkSkyBlue
    case .minutesLate: return .warmPink
    }
  }
  
  var panelColor: UIColor {
    if case .passedAway = state {
      return .paleSoftGray
    } else {
      return .white
    }
  }
  
  var dateColor: UIColor {
    switch state {
    case .passedAway: return .silver
    case .days: return .darkSoftSkyBlue
    default: return .darkSkyBlue
    }
  }
  
  var isPassedAway: Bool {
    if case .passedAway = state {
      return true
    } else {
      return false
    }
  }
  
  var name: String {
    return promise.name
  }
  
  var address: String {
    return promise.address
  }
  
  var members: [String] {
    return Array(promise.contacts)
  }
  
  var timeText: String {
    timeFormat.dateFormat = "a hh시 mm분"
    return timeFormat.string(from: dateTime)
  }
  
  var dateText: String {
    dateFormat.dateFormat = "dd"
    return dateFormat.string(from: dateTime)
  }
  
  var dayText: String {
    dayFormat.dateFormat = "EEEE"
    return dayFormat.string(from: dateTime)
  }
}
