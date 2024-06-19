
import Vapor
import JOJACore
import Fluent

extension Fabric {
    func makePublic() throws -> FabricAPIModel.Response {
        FabricAPIModel.Response(
            id: try self.requireID(),
            name: self.name,
            component: try self.component.makeComponent(),
            sn: self.sn,
            price: self.price,
            buy: self.buy,
            stock: self.stock,
            location: self.location,
            tags: self.tags.map({$0.name}),
            description: self.description,
            note: self.note,
            imageUrl: self.images,
            createdAt: self.createdAt,
            updatedAt: self.updatedAt,
            log: self.log
        )
    }
}

extension Fabric.Component {
    func makeComponent() throws -> FabricAPIModel.Component {
        FabricAPIModel.Component(
            material: material,
            cottonMaterial: cottonType,
            age: age,
            design: design,
            color: color
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
            component: component,
            sn: sn,
            price: price,
            buy: buy,
            stock: stock,
            location: location,
            tags: tags,
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
            component: fabric.component.makeComponent(),
            sn: fabric.sn,
            price: fabric.price,
            buy: fabric.buy,
            stock: fabric.stock,
            location: fabric.location,
            tags: fabric.tags.map({$0.name}),
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
            component: try component.createComponent(),
            sn: component.getSerialHeader(),
            price: price,
            buy: buy,
            stock: stock,
            location: location,
            description: description,
            note: note,
            images: [],
            log: "新添購\(buy)碼，放置在\(location.getName())"
        )
    }
}

extension FabricAPIModel.Component: Content {
    func createComponent() throws -> Fabric.Component {
        Fabric.Component(
            material: material,
            cottonType: cottonMaterial,
            age: age,
            design: design,
            color: color
        )
    }
    
    func getSerialHeader() -> String {
        age.getSerial() + material.getSerial() + (cottonMaterial == nil ? "0" : cottonMaterial!.getSerial()) + design.getSerial() + color.getSerial()
    }
}

extension FabricAPIModel.Response: Content {}
