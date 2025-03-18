
import Foundation

// MARK: - AnimeDetailModel
struct AnimeDetailModel: Codable {
    let status, message: String
    let data: DataClass

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let animeID: Int
    let animeName: String
    let totalEpisodes: Int
    let genres: String
    let rating: String
    let description: String
    let episodes: [EpisodeData]
    enum CodingKeys: String, CodingKey {
        case animeID = "anime_id"
        case animeName = "anime_name"
        case totalEpisodes = "total_episodes"
        case genres, episodes, description, rating
    }
}

// MARK: - Episode
struct EpisodeData: Codable {
    let episodeNumber: Int
    let title: String
    let type: TypeEnum

    enum CodingKeys: String, CodingKey {
        case episodeNumber = "episode_number"
        case title, type
    }
}

enum TypeEnum: String, Codable {
    case canon = "canon"
    case filler = "filler"
    case mixedCannonFiller = "Mixed cannon/Filler"
    case mixedCannonFillerss = "Mixed cannon/Fillerss"
    case mixedCanonFiller = "Mixed canon/Filler"
}
