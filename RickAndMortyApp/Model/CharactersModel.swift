// MARK: - CharactersModelResponse
struct CharactersModel: Codable {
    let info: Info
    let results: [CharactersResponseResult]

    enum CodingKeys: String, CodingKey {
        case info = "info"
        case results = "results"
    }
}

// MARK: - Info
struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - Result
struct CharactersResponseResult: Codable, Hashable {
    let id: Int
    let name: String
    let status: Status
    let species: Species
    let gender: Gender
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

enum Gender: String, Codable, Hashable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = (try? container.decode(String.self)) ?? ""
        self = Gender(rawValue: raw) ?? .unknown
    }
}

//// MARK: - Location
struct Location: Codable, Hashable {
    let name: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}

enum Species: String, Codable, Hashable {
    case alien = "Alien"
    case human = "Human"
    case mythologicalCreature = "Mythological Creature"
    case unknown = "unknown"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = (try? container.decode(String.self)) ?? ""
        self = Species(rawValue: raw) ?? .unknown
    }
}

enum Status: String, Codable, Hashable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}


