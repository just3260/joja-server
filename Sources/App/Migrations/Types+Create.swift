
import Fluent
import Vapor
import JOJACore

final class Types: Content {
    
    // Where to Know Type
    struct CreateWhereFromType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.WhereToKnow.getKey())
                .case(TypeAPIModel.WhereToKnow.taipei.rawValue)
                .case(TypeAPIModel.WhereToKnow.tainan.rawValue)
                .case(TypeAPIModel.WhereToKnow.fb.rawValue)
                .case(TypeAPIModel.WhereToKnow.ig.rawValue)
                .case(TypeAPIModel.WhereToKnow.market.rawValue)
                .case(TypeAPIModel.WhereToKnow.search.rawValue)
                .case(TypeAPIModel.WhereToKnow.friend.rawValue)
                .case(TypeAPIModel.WhereToKnow.pinkoi.rawValue)
                .case(TypeAPIModel.WhereToKnow.eslite.rawValue)
                .case(TypeAPIModel.WhereToKnow.qsquare.rawValue)
                .case(TypeAPIModel.WhereToKnow.jccac.rawValue)
                .case(TypeAPIModel.WhereToKnow.goyoung.rawValue)
                .case(TypeAPIModel.WhereToKnow.treasureHill.rawValue)
                .case(TypeAPIModel.WhereToKnow.consignmentShop.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .enum(TypeAPIModel.WhereToKnow.getKey())
                .delete()
        }
    }
    
    
    // Brand Type
    struct CreateBrandType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.Brand.getKey())
                .case(TypeAPIModel.Brand.joja.rawValue)
                .case(TypeAPIModel.Brand.yuu.rawValue)
                .case(TypeAPIModel.Brand.how_fan.rawValue)
                .case(TypeAPIModel.Brand.marco.rawValue)
                .case(TypeAPIModel.Brand.st_light.rawValue)
                .case(TypeAPIModel.Brand.vingt_six.rawValue)
                .case(TypeAPIModel.Brand.shishi.rawValue)
                .case(TypeAPIModel.Brand.mount.rawValue)
                .case(TypeAPIModel.Brand.giants_tiedye.rawValue)
                .case(TypeAPIModel.Brand.n_trail.rawValue)
                .case(TypeAPIModel.Brand.feat_yuu.rawValue)
                .case(TypeAPIModel.Brand.feat_howfan.rawValue)
                .case(TypeAPIModel.Brand.feat_y_art.rawValue)
                .case(TypeAPIModel.Brand.feat_childhood.rawValue)
                .case(TypeAPIModel.Brand.japan_socks.rawValue)
                .case(TypeAPIModel.Brand.josie_personal.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .enum(TypeAPIModel.Brand.getKey())
                .delete()
        }
    }
    
    
    // Employee Type
    struct CreateEmployeeType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.Employee.getKey())
                .case(TypeAPIModel.Employee.josie.rawValue)
                .case(TypeAPIModel.Employee.jn.rawValue)
                .case(TypeAPIModel.Employee.yuu.rawValue)
                .case(TypeAPIModel.Employee.yi_fan.rawValue)
                .case(TypeAPIModel.Employee.mini.rawValue)
                .case(TypeAPIModel.Employee.jiajie.rawValue)
                .case(TypeAPIModel.Employee.tian.rawValue)
                .case(TypeAPIModel.Employee.du.rawValue)
                .case(TypeAPIModel.Employee.xing.rawValue)
                .case(TypeAPIModel.Employee.andrew.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .enum(TypeAPIModel.Employee.getKey())
                .delete()
        }
    }
    
    
    // Goods Type
    struct CreateGoodsType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.Goods.getKey())
                .case(TypeAPIModel.Goods.beret.rawValue)
                .case(TypeAPIModel.Goods.newsboy.rawValue)
                .case(TypeAPIModel.Goods.bucket_hat.rawValue)
                .case(TypeAPIModel.Goods.sun.rawValue)
                .case(TypeAPIModel.Goods.flower.rawValue)
                .case(TypeAPIModel.Goods.lady.rawValue)
                .case(TypeAPIModel.Goods.flat_small.rawValue)
                .case(TypeAPIModel.Goods.flat_big.rawValue)
                .case(TypeAPIModel.Goods.scarf_short.rawValue)
                .case(TypeAPIModel.Goods.scarf_long.rawValue)
                .case(TypeAPIModel.Goods.square_small.rawValue)
                .case(TypeAPIModel.Goods.square_big.rawValue)
                .case(TypeAPIModel.Goods.headbands_narrow.rawValue)
                .case(TypeAPIModel.Goods.headbands_wide.rawValue)
                .case(TypeAPIModel.Goods.clip_earrings.rawValue)
                .case(TypeAPIModel.Goods.clip_ring.rawValue)
                .case(TypeAPIModel.Goods.ring.rawValue)
                .case(TypeAPIModel.Goods.pin.rawValue)
                .case(TypeAPIModel.Goods.bucket_Bag.rawValue)
                .case(TypeAPIModel.Goods.tote_bag.rawValue)
                .case(TypeAPIModel.Goods.bag_frame.rawValue)
                .case(TypeAPIModel.Goods.skirt.rawValue)
                .case(TypeAPIModel.Goods.other.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .enum(TypeAPIModel.Goods.getKey())
                .delete()
        }
    }
    
    
    // Other Brand's Goods Type
    struct CreateOtherGoodsType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.OtherGoods.getKey())
                .case(TypeAPIModel.OtherGoods.clip_earrings.rawValue)
                .case(TypeAPIModel.OtherGoods.pin_earrings.rawValue)
                .case(TypeAPIModel.OtherGoods.mask_chain.rawValue)
                .case(TypeAPIModel.OtherGoods.necklace.rawValue)
                .case(TypeAPIModel.OtherGoods.bracelet.rawValue)
                .case(TypeAPIModel.OtherGoods.pin.rawValue)
                .case(TypeAPIModel.OtherGoods.ring.rawValue)
                .case(TypeAPIModel.OtherGoods.other.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .enum(TypeAPIModel.OtherGoods.getKey())
                .delete()
        }
    }
    
    
    // Material Type
    struct CreateMaterialType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.Material.getKey())
                .case(TypeAPIModel.Material.cotton.rawValue)
                .case(TypeAPIModel.Material.linen.rawValue)
                .case(TypeAPIModel.Material.velvet.rawValue)
                .case(TypeAPIModel.Material.wool.rawValue)
                .case(TypeAPIModel.Material.synthetic_fiber.rawValue)
                .case(TypeAPIModel.Material.denim.rawValue)
                .case(TypeAPIModel.Material.suit.rawValue)
                .case(TypeAPIModel.Material.silk.rawValue)
                .case(TypeAPIModel.Material.chiffon.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .enum(TypeAPIModel.Material.getKey())
                .delete()
        }
    }
    
    // Cotton Material Type
    struct CreateCottonMaterialType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.CottonMaterial.getKey())
                .case(TypeAPIModel.CottonMaterial.thin_bubble.rawValue)
                .case(TypeAPIModel.CottonMaterial.thick_bubble.rawValue)
                .case(TypeAPIModel.CottonMaterial.wash.rawValue)
                .case(TypeAPIModel.CottonMaterial.wrinkle_wash.rawValue)
                .case(TypeAPIModel.CottonMaterial.grey.rawValue)
                .case(TypeAPIModel.CottonMaterial.thin_canvas.rawValue)
                .case(TypeAPIModel.CottonMaterial.thick_canvas.rawValue)
                .case(TypeAPIModel.CottonMaterial.japan_plain.rawValue)
                .case(TypeAPIModel.CottonMaterial.japan_print.rawValue)
                .case(TypeAPIModel.CottonMaterial.calico.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .enum(TypeAPIModel.CottonMaterial.getKey())
                .delete()
        }
    }
    
    // Age Type
    struct CreateAgeType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.Age.getKey())
                .case(TypeAPIModel.Age.new.rawValue)
                .case(TypeAPIModel.Age.old.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .enum(TypeAPIModel.Age.getKey())
                .delete()
        }
    }
    
    
    // Transaction Type
    struct CreateTransactionType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.Transaction.getKey())
                .case(TypeAPIModel.Transaction.cash.rawValue)
                .case(TypeAPIModel.Transaction.remittance.rawValue)
                .case(TypeAPIModel.Transaction.jkos_pay.rawValue)
                .case(TypeAPIModel.Transaction.credit_card.rawValue)
                .case(TypeAPIModel.Transaction.apply_pay.rawValue)
                .case(TypeAPIModel.Transaction.google_pay.rawValue)
                .case(TypeAPIModel.Transaction.line_pay.rawValue)
                .case(TypeAPIModel.Transaction.insto.rawValue)
                .case(TypeAPIModel.Transaction.insto_foreign.rawValue)
                .case(TypeAPIModel.Transaction.ali_pay.rawValue)
                .case(TypeAPIModel.Transaction.payme.rawValue)
                .case(TypeAPIModel.Transaction.wechat.rawValue)
                .case(TypeAPIModel.Transaction.stimulus_voucher.rawValue)
                .case(TypeAPIModel.Transaction.coupons.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .enum(TypeAPIModel.Transaction.getKey())
                .delete()
        }
    }
    
    
    // Color Type
    struct CreateColorType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.Color.getKey())
                .case(TypeAPIModel.Color.red.rawValue)
                .case(TypeAPIModel.Color.orange.rawValue)
                .case(TypeAPIModel.Color.yellow.rawValue)
                .case(TypeAPIModel.Color.green.rawValue)
                .case(TypeAPIModel.Color.blue.rawValue)
                .case(TypeAPIModel.Color.purple.rawValue)
                .case(TypeAPIModel.Color.pink.rawValue)
                .case(TypeAPIModel.Color.peach.rawValue)
                .case(TypeAPIModel.Color.brown.rawValue)
                .case(TypeAPIModel.Color.black.rawValue)
                .case(TypeAPIModel.Color.white.rawValue)
                .case(TypeAPIModel.Color.beige.rawValue)
                .case(TypeAPIModel.Color.grey.rawValue)
                .case(TypeAPIModel.Color.gold.rawValue)
                .case(TypeAPIModel.Color.silvery.rawValue)
                .case(TypeAPIModel.Color.multi_color.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .enum(TypeAPIModel.Color.getKey())
                .delete()
        }
    }
    
    
    // Design Type
    struct CreateDesignType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.Design.getKey())
                .case(TypeAPIModel.Design.plain.rawValue)
                .case(TypeAPIModel.Design.gradation.rawValue)
                .case(TypeAPIModel.Design.block.rawValue)
                .case(TypeAPIModel.Design.geometry.rawValue)
                .case(TypeAPIModel.Design.stripe.rawValue)
                .case(TypeAPIModel.Design.dot.rawValue)
                .case(TypeAPIModel.Design.plaid.rawValue)
                .case(TypeAPIModel.Design.paisley.rawValue)
                .case(TypeAPIModel.Design.totem.rawValue)
                .case(TypeAPIModel.Design.graffiti.rawValue)
                .case(TypeAPIModel.Design.painting.rawValue)
                .case(TypeAPIModel.Design.watercolor.rawValue)
                .case(TypeAPIModel.Design.plant.rawValue)
                .case(TypeAPIModel.Design.animal.rawValue)
                .case(TypeAPIModel.Design.festival.rawValue)
                .case(TypeAPIModel.Design.pop.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .enum(TypeAPIModel.Design.getKey())
                .delete()
        }
    }
    
    // Location Type
    struct CreateLocationType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.Location.getKey())
                .case(TypeAPIModel.Location.chifeng.rawValue)
                .case(TypeAPIModel.Location.chifengStorage.rawValue)
                .case(TypeAPIModel.Location.taipeiHome.rawValue)
                .case(TypeAPIModel.Location.tainan.rawValue)
                .case(TypeAPIModel.Location.daxi.rawValue)
                .case(TypeAPIModel.Location.aunt.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .enum(TypeAPIModel.Location.getKey())
                .delete()
        }
    }
}
