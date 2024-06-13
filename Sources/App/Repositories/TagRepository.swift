
import Vapor
import Fluent

protocol TagRepository: Repository {
    func create(_ tag: Tag) async throws
    func delete(id: UUID) async throws
    func find(id: UUID) async throws -> Tag?
    func findTag(name: String) async throws -> Tag?
    func findTags(names: [String]) async throws -> [Tag]
    func findAll() async throws -> [Tag]
}

struct DatabaseTagRepository: TagRepository, DatabaseRepository {
    let database: Database
    
    func create(_ tag: Tag) async throws {
        try await tag.create(on: database)
    }
    
    func delete(id: UUID) async throws {
        try await Tag.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func find(id: UUID) async throws -> Tag? {
        try await Tag.find(id, on: database)
    }
    
    func findTag(name: String) async throws -> Tag? {
        try await Tag.query(on: database).filter(\.$name == name).first()
    }
    
    func findTags(names: [String]) async throws -> [Tag] {
        return try await withThrowingTaskGroup(of: Tag?.self,
                                               returning: [Tag].self,
                                               body: { taskGroup in
            for name in names {
                taskGroup.addTask {
                    try await Tag.query(on: database).filter(\.$name == name).first()
                }
            }
            
            var tags: [Tag] = []
            for try await tag in taskGroup {
                if let tag = tag {
                    tags.append(tag)
                }
            }
            try await taskGroup.waitForAll()
            return tags
        })
    }
    
    func findAll() async throws -> [Tag] {
        try await Tag.query(on: database)
            .all()
    }
}

extension Application.Repositories {
    var tags: TagRepository {
        guard let storage = storage.makeTagRepository else {
            fatalError("TagRepository not configured, use: app.tagRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (TagRepository)) {
        storage.makeTagRepository = make
    }
}
