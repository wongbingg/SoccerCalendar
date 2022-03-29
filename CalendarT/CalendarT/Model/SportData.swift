//
//  SportData.swift
//  CalendarT
//
//  Created by 이원빈 on 2022/02/27.
//

import Foundation
import UIKit

struct SportData: Codable {
    let response:[Response]
}

    struct Response: Codable {
        let fixture:Fixture
        let league:League
        let teams:Teams
    }

        struct Fixture: Codable {
            let date: String
            let timestamp: Int
        }
        struct League: Codable {
            let id: Int
            let name: String
            let logo: String
        }
        struct Teams: Codable {
            let home:Home
            let away:Away
        }

            struct Home: Codable {
                let name: String
                let logo: String
            }
            struct Away: Codable {
                let name: String
                let logo: String
            }
