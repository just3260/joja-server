
import Vapor
import JOJACore
import Fluent

extension Fabric {
    func makePublic() throws -> FabricAPIModel.Response {
        FabricAPIModel.Response(
            id: try self.requireID(),
            name: self.name,
            material: self.material,
            cottonMaterial: self.cottonType,
            age: self.age,
            design: self.design,
            color: self.color,
            sn: self.sn,
            price: self.price,
            buy: self.buy,
            stock: self.stock,
            location: self.location,
//            tags: self.tags,
            description: self.description,
            note: self.note,
            imageUrl: self.images,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt,
            log: self.log
        )
    }
    
    func getSerialHeader() -> String {
        age.getSerial() + material.getSerial() + (cottonType == nil ? "0" : cottonType!.getSerial()) + design.getSerial() + color.getSerial()
    }
}

extension FabricAPIModel: Content {
    func asPublic() throws -> FabricAPIModel.Response {
        FabricAPIModel.Response(
            id: id,
            name: name,
            material: material,
            cottonMaterial: cottonMaterial,
            age: age,
            design: design,
            color: color,
            sn: sn,
            price: price,
            buy: buy,
            stock: stock,
            location: location,
//            tags: tags,
            description: description,
            note: note,
            imageUrl: imageUrl,
            createdAt: createdAt,
            updatedAt: updatedAt,
            log: log
        )
    }
}

extension FabricAPIModel {
    init(fabric: Fabric) throws {
        
        try self.init(
            id: fabric.requireID(),
            name: fabric.name,
            material: fabric.material,
            cottonMaterial: fabric.cottonType,
            age: fabric.age,
            design: fabric.design,
            color: fabric.color,
            sn: fabric.sn,
            price: fabric.price,
            buy: fabric.buy,
            stock: fabric.stock,
            location: fabric.location,
//            tags: fabric.tags,
            description: fabric.description,
            note: fabric.note,
            imageUrl: fabric.images,
            createdAt: fabric.createdAt,
            updatedAt: fabric.updatedAt,
            log: fabric.log
        )
    }
}

extension FabricAPIModel.Request {
    func createFabric() throws -> Fabric {
        Fabric(
            name: name,
            material: material,
            cottonType: cottonMaterial,
            age: age,
            design: design,
            color: color,
            sn: age.getSerial() + material.getSerial() + (cottonMaterial == nil ? "0" : cottonMaterial!.getSerial()) + design.getSerial() + color.getSerial(),
            price: price,
            buy: buy,
            stock: stock,
            location: location,
//            tags: tags,
            description: description,
            note: note,
            images: [],
            createdAt: Date(),
            updatedAt: Date(),
            log: "新添購\(buy)碼，放置在\(location.getName())"
        )
    }
}

extension FabricAPIModel.Response: Content {}
