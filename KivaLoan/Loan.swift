//
//  Loan.swift
//  KivaLoan
//
//  Created by M78的星际人士 on 5/19/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

struct LoanDataStore: Codable {
    var loans: [Loan]
}

struct Loan: Codable {
    var name: String
    var country: String
    var use: String
    var amount: Int

    enum CodingKeys: String, CodingKey {
        case name
        case use
        case amount = "loan_amount"
        case country = "location"
    }

    enum LocationKeys: CodingKey {
        case country
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.amount = try values.decode(Int.self, forKey: .amount)
        self.name = try values.decode(String.self, forKey: .name)
        self.use = try values.decode(String.self, forKey: .use)

        let location = try values.nestedContainer(keyedBy: LocationKeys.self, forKey: .country)
        self.country = try location.decode(String.self, forKey: .country)
    }

}
