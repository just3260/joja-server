
import Fluent
import Vapor
import JOJACore

final class Fabric: Model, Content, @unchecked Sendable {
    
    static let schema = Keys.schema
    
    @ID(key: .id)
    var id: UUID?
    
    @OptionalField(key: Keys.name)
    var name: String?
    
    @Group(key: Keys.component)
    var component: Component
    
    @Field(key: Keys.sn)
    var sn: String
    
    @Field(key: Keys.price)
    var price: Int
    
//    @Field(key: Keys.buy)
//    var buy: Int
    
    @Field(key: Keys.stock)
    var stock: Int
    
//    @Enum(key: Keys.location)
//    var location: TypeAPIModel.Location
    
    @Siblings(through: FabricStorage.self, from: \.$fabric, to: \.$storage)
    public var storages: [Storage]
    
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
    
    init(id: UUID? = nil, name: String?, component: Component, sn: String, price: Int, /*buy: Int,*/ stock: Int, /*storage: TypeAPIModel.Location,*/ description: String?, note: String?, images: [String], log: String?) {
        self.id = id
        self.name = name
        self.component = component
        self.sn = sn
        self.price = price
//        self.buy = buy
        self.stock = stock
//        self.storage = storage
        self.description = description
        self.note = note
        self.images = images
        self.log = log
    }
}

extension Fabric {
    final class Component: Fields, @unchecked Sendable {
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
        
        init() {}
        
        init(material: TypeAPIModel.Material, cottonType: TypeAPIModel.CottonMaterial?, age: TypeAPIModel.Age, design: TypeAPIModel.Design, color: TypeAPIModel.Color) {
            self.material = material
            self.cottonType = cottonType
            self.age = age
            self.design = design
            self.color = color
        }
    }
}

extension Fabric {
    enum Keys {
        static let schema = "fabrics"
        
        static let name: FieldKey = .name
        static let component: FieldKey = .component
        static let material: FieldKey = .material
        static let cottonType: FieldKey = .cottonType
        static let age: FieldKey = .age
        static let design: FieldKey = .design
        static let color: FieldKey = .color
        static let sn: FieldKey = .sn
        static let price: FieldKey = .price
//        static let buy: FieldKey = .buy
        static let stock: FieldKey = .stock
//        static let storages: FieldKey = .storages
        static let count: FieldKey = .count
        static let location: FieldKey = .location
        static let description: FieldKey = .description
        static let note: FieldKey = .note
        static let images: FieldKey = .images
        static let createdAt: FieldKey = .createdAt
        static let updatedAt: FieldKey = .updatedAt
        static let log: FieldKey = .log
        
        static let componentMaterial: FieldKey = .componentMaterial
        static let componentCottonType: FieldKey = .componentCottonType
        static let componentAge: FieldKey = .componentAge
        static let componentDesign: FieldKey = .componentDesign
        static let componentColor: FieldKey = .componentColor
    }
}
