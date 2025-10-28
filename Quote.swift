 //
//  Quote.swift
//  DailyQuoteWidget
//
//  Created by Augustė Rulienė on 12/10/2025.
//


import Foundation

struct Quote: Identifiable {
    let id: UUID
    let text: String
    let author: String
    let source: String?
    let sourceId: UUID
    let location: String?
}
