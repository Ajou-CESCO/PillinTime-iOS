//
//  String+.swift
//  PillinTime-iOS
//
//  Created by Jae Hyun Lee on 4/9/24.
//

import Foundation

extension String {
    
    /// 서버에서 들어온 Date String을 Date 타입으로 반환하는 메서드
    private func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("toDate() convert error")
            return Date()
        }
    }
    
    /// 한글만 입력 가능하게 제한하는 메서드
    func hasCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ\\s]$", options: .caseInsensitive)
            if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) != nil {
                return true
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        return false
    }
    
    func containsConsecutiveSubstring(_ substring: String) -> Bool {
        let substringLength = substring.count
        let stringLength = count

        if substringLength > stringLength {
            return false
        }

        for i in 0...(stringLength - substringLength) {
            let startIndex = index(self.startIndex, offsetBy: i)
            let endIndex = index(self.startIndex, offsetBy: i + substringLength)
            let range = startIndex..<endIndex

            if self[range] == substring {
                return true
            }
        }

        return false
    }
    
    /// 글자별 줄바꿈 메서드
    /// Reference: https://woozoobro.medium.com/swiftui-%EA%B8%80%EC%9E%90%EB%B3%84-%EC%A4%84%EB%B0%94%EA%BF%88%ED%95%98%EA%B8%B0-6bb4c33f7d9d
    func splitCharacter() -> String {
        return self.split(separator: "").joined(separator: "\u{200B}")
    }
}
