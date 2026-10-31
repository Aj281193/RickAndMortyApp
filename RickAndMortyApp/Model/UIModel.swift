import Foundation

struct UIModel {
    let id: Int
    let name: String
    let image: String
    let episode: [String]
    let status: String
    let species: String
    let gender: String
    let location: String
}


extension UIModel {
    
    init(from character: CharactersResponseResult) {
        self.id = character.id
        self.name = character.name
        self.image = character.image
        self.episode = character.episode
        self.status = character.status.rawValue
        self.species = character.species.rawValue
        self.gender = character.gender.rawValue
        self.location = character.location.name
    }

    static func map(from characters: [CharactersResponseResult]) -> [UIModel] {
        characters.map { UIModel(from: $0) }
    }
}
