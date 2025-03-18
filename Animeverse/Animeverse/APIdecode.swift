struct VerifyResponse: Decodable {
    let status: Bool
    let message: String
}


struct PasswordResetResponse: Decodable {
    let status: Bool
    let message: String
}






struct Event: Identifiable, Decodable {
    let id: Int
    let title: String
    let description: String
    let event_date: String
    let priority: String
}

struct EventResponse: Decodable {
    let status: Bool
    let message: String
    let data: [Event]
}

struct QuoteResponse: Decodable {
    let status: Bool
    let message: String
    let data: QuoteData
}

struct QuoteData: Decodable {
    let quote: String
    let author: String
}


struct APIResponse: Codable {
    let status: Bool
    let message: String
}


struct GenericResponse: Decodable {
    let status: Bool
    let message: String
}


struct JournalResponse: Decodable {
    let status: Bool
    let message: String
    let data: [JournalEntry]?
}

struct JournalEntry: Decodable {
    let id: Int
    let mood: String
    let data: String
    let date: String
}


struct JournalAPIResponse: Codable {
    let status: Bool
    let message: String
    let data: [MoodEntry]
}

struct MoodEntry: Codable {
    let id: Int
    let mood: String
    let data: String
    let date: String
}
