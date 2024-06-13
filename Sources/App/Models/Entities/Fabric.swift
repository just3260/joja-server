
import Fluent
import Vapor
import JOJACore

final class Fabric: Model, Content, @unchecked Sendable {
    
    static let schema = Keys.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @OptionalField(key: Keys.name)
    var name: String?
    
    @Enum(key: Keys.material)
    var material: TypeAPIModel.Material
    
    @OptionalEnum(key: Keys.cottonType)
    var cottonType: TypeAPIModel.CottonMaterial?
    
    @Enum(key: Keys.age)
    var age: TypeAPIModel.Age
    
    @Enum(key: Keys.design)
    var design: TypeAPIModel.Design
    
    @Enum(key: Keys.color)
    var color: TypeAPIModel.Color
    
    @Field(key: Keys.sn)
    var sn: String
    
    @Field(key: Keys.price)
    var price: Int
    
    @Field(key: Keys.buy)
    var buy: Int
    
    @Field(key: Keys.stock)
    var stock: Int
    
    @Enum(key: Keys.location)
    var location: TypeAPIModel.Location
    
//    @Group(key: Keys.stores)
//    var stores: Store
    
    @Siblings(through: FabricTag.self, from: \.$fabric, to: \.$tag)
    public var tags: [Tag]
    
    @OptionalField(key: Keys.description)
    var description: String?
    
    @OptionalField(key: Keys.note)
    var note: String?
    
    @Field(key: Keys.images)
    var images: [String]
    
    @Timestamp(key: Keys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: Keys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @OptionalField(key: Keys.log)
    var log: String?
    
    init() {}
    
    init(id: UUID? = nil, name: String?, material: TypeAPIModel.Material, cottonType: TypeAPIModel.CottonMaterial?, age: TypeAPIModel.Age, design: TypeAPIModel.Design, color: TypeAPIModel.Color, sn: String, price: Int, buy: Int, stock: Int, location: TypeAPIModel.Location, description: String?, note: String?, images: [String], log: String?) {
        self.id = id
        self.name = name
        self.material = material
        self.cottonType = cottonType
        self.age = age
        self.design = design
        self.color = color
        self.sn = sn
        self.price = price
        self.buy = buy
        self.stock = stock
        self.location = location
        self.description = description
        self.note = note
        self.images = images
        self.log = log
    }
}

extension Fabric {
    final class Component: Fields {
        
    }
    
    final class Store: Fields {
        @Field(key: Keys.count)
        var count: Int
        
        @Enum(key: Keys.location)
        var location: TypeAPIModel.Location
    }
}

extension Fabric {
    enum Keys {
        static let schema = "fabrics"
        
        static let name: FieldKey = .name
        static let material: FieldKey = .material
        static let cottonType: FieldKey = .cottonType
        static let age: FieldKey = .age
        static let design: FieldKey = .design
        static let color: FieldKey = .color
        static let sn: FieldKey = .sn
        static let price: FieldKey = .price
        static let buy: FieldKey = .buy
        static let stock: FieldKey = .stock
        static let stores: FieldKey = .stores
        static let count: FieldKey = .count
        static let location: FieldKey = .location
        static let description: FieldKey = .description
        static let note: FieldKey = .note
        static let images: FieldKey = .images
        static let createdAt: FieldKey = .createdAt
        static let updatedAt: FieldKey = .updatedAt
        static let log: FieldKey = .log
        
        
    }
}
