
import Fluent
import Vapor
import JOJACore

final class Types: Content {
    
    // Where to Know Type
    struct CreateWhereFromType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.WhereToKnow.getKey())
                .case(TypeAPIModel.WhereToKnow.passBy.rawValue)
                .case(TypeAPIModel.WhereToKnow.fb.rawValue)
                .case(TypeAPIModel.WhereToKnow.ig.rawValue)
                .case(TypeAPIModel.WhereToKnow.market.rawValue)
                .case(TypeAPIModel.WhereToKnow.search.rawValue)
                .case(TypeAPIModel.WhereToKnow.friend.rawValue)
                .case(TypeAPIModel.WhereToKnow.pinkoi.rawValue)
                .case(TypeAPIModel.WhereToKnow.eslite.rawValue)
                .case(TypeAPIModel.WhereToKnow.qsquare.rawValue)
                .case(TypeAPIModel.WhereToKnow.jccac.rawValue)
                .case(TypeAPIModel.WhereToKnow.goyound.rawValue)
                .case(TypeAPIModel.WhereToKnow.treasureHill.rawValue)
                .case(TypeAPIModel.WhereToKnow.consignmentShop.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(TypeAPIModel.WhereToKnow.getKey())
                .delete()
        }
    }
    
    
    // Brand Type
    struct CreateBrandType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.Brand.getKey())
                .case(TypeAPIModel.Brand.joja.rawValue)
                .case(TypeAPIModel.Brand.yuu.rawValue)
                .case(TypeAPIModel.Brand.shishi.rawValue)
                .case(TypeAPIModel.Brand.mount.rawValue)
                .case(TypeAPIModel.Brand.vingt_six.rawValue)
                .case(TypeAPIModel.Brand.y_art.rawValue)
                .case(TypeAPIModel.Brand.childhood.rawValue)
                .case(TypeAPIModel.Brand.giants_tiedye.rawValue)
                .case(TypeAPIModel.Brand.n_trail.rawValue)
                .case(TypeAPIModel.Brand.japan_socks.rawValue)
                .case(TypeAPIModel.Brand.josie_personal.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(TypeAPIModel.Brand.getKey())
                .delete()
        }
    }
    
    
    // Employee Type
    struct CreateEmployeeType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.Employee.getKey())
                .case(TypeAPIModel.Employee.josie.rawValue)
                .case(TypeAPIModel.Employee.jn.rawValue)
                .case(TypeAPIModel.Employee.yo_ya.rawValue)
                .case(TypeAPIModel.Employee.yuu.rawValue)
                .case(TypeAPIModel.Employee.yi_fan.rawValue)
                .case(TypeAPIModel.Employee.andrew.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(TypeAPIModel.Employee.getKey())
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
                .schema(TypeAPIModel.Goods.getKey())
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
                .schema(TypeAPIModel.OtherGoods.getKey())
                .delete()
        }
    }
    
    
    // Material Type
    struct CreateMaterialType: AsyncMigration {
        func prepare(on database: Database) async throws {
            _ = try await database.enum(TypeAPIModel.Material.getKey())
                .case(TypeAPIModel.Material.cotton_wash.rawValue)
                .case(TypeAPIModel.Material.cotton_bubble.rawValue)
                .case(TypeAPIModel.Material.calico_cotton.rawValue)
                .case(TypeAPIModel.Material.calico_new.rawValue)
                .case(TypeAPIModel.Material.calico_old.rawValue)
                .case(TypeAPIModel.Material.wool_old.rawValue)
                .case(TypeAPIModel.Material.wool.rawValue)
                .case(TypeAPIModel.Material.flannel.rawValue)
                .case(TypeAPIModel.Material.flannel_old.rawValue)
                .case(TypeAPIModel.Material.suit.rawValue)
                .case(TypeAPIModel.Material.linen_old.rawValue)
                .case(TypeAPIModel.Material.linen_new.rawValue)
                .case(TypeAPIModel.Material.synthetic_fiber_old.rawValue)
                .case(TypeAPIModel.Material.synthetic_fiber_new.rawValue)
                .case(TypeAPIModel.Material.headbands_opaque.rawValue)
                .case(TypeAPIModel.Material.headbands_translucent.rawValue)
                .case(TypeAPIModel.Material.silk.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(TypeAPIModel.Material.getKey())
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
                .schema(TypeAPIModel.Transaction.getKey())
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
                .case(TypeAPIModel.Color.grey.rawValue)
                .case(TypeAPIModel.Color.gold.rawValue)
                .case(TypeAPIModel.Color.silvery.rawValue)
                .case(TypeAPIModel.Color.multi_color.rawValue)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database
                .schema(TypeAPIModel.Color.getKey())
                .delete()
        }
    }
}
