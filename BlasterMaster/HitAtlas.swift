// ---------------------------------------
// Sprite definitions for 'HitAtlas'
// Generated with TexturePacker 3.9.4
//
// http://www.codeandweb.com/texturepacker
// ---------------------------------------

import SpriteKit


class HitAtlas {

    // sprite names
    let LASERBLUE08 = "laserBlue08"
    let LASERBLUE09 = "laserBlue09"
    let LASERBLUE10 = "laserBlue10"
    let LASERBLUE11 = "laserBlue11"


    // load texture atlas
    let textureAtlas = SKTextureAtlas(named: "HitAtlas")


    // individual texture objects
    func laserBlue08() -> SKTexture { return textureAtlas.textureNamed(LASERBLUE08) }
    func laserBlue09() -> SKTexture { return textureAtlas.textureNamed(LASERBLUE09) }
    func laserBlue10() -> SKTexture { return textureAtlas.textureNamed(LASERBLUE10) }
    func laserBlue11() -> SKTexture { return textureAtlas.textureNamed(LASERBLUE11) }


    // texture arrays for animations
    func laserBlue() -> [SKTexture] {
        return [
            laserBlue08(),
            laserBlue09(),
            laserBlue10(),
            laserBlue11()
        ]
    }


}
