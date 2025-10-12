//
//  Sources.swift
//  DailyQuoteWidget
//
//  Created by Augustė Rulienė on 12/10/2025.
//

import Foundation

struct SourceMetadata: Identifiable {
    let id: UUID
    let title: String
    let author: String
    let fileName: String
    let type: String
}

let allSources: [SourceMetadata] = [
    SourceMetadata(
        id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!,
        title: "Let Them",
        author: "Mel Robbins",
        fileName: "let-them-mel-robbins",
        type: "Book"
    )
]
