import Foundation
import SpriteKit

class CollisionDetector : NSObject, SKPhysicsContactDelegate {
    
    var enemyHitHandler : EnemyHitHandler?
    var playerHitHandler : PlayerHitHandler?
    
    init(g:EnemyHitHandler,e:PlayerHitHandler) {
        enemyHitHandler = g
        playerHitHandler = e
    }
    
    func didBeginContact(contact:SKPhysicsContact){
        if (contact.bodyA.node != nil && contact.bodyB.node != nil)  {
            let node2:SKNode = contact.bodyB.node!
            let node1:SKNode = contact.bodyA.node!
            let name1 = node1.name;
            let name2 = node2.name;
            if ( name1 == Enemy.SpriteName() && name2 == LaserShot.SpriteName())
            {
                enemyHitHandler?(node1,node2)
            }
            else if ( name2 == LaserShot.SpriteName() && name1 == Enemy.SpriteName())
            {
                enemyHitHandler?(node2,node1)
            }
            else if ( name1 == SpaceShip.SpriteName() && name2 == Enemy.SpriteName())
            {
                playerHitHandler?(node1,node2,contact.contactPoint)
            }
            else if ( name2 == Enemy.SpriteName() && name1 == SpaceShip.SpriteName())
            {
                playerHitHandler?(node2,node1,contact.contactPoint)
            }
            else if ( name1 == SpaceShip.SpriteName() && name2 == EnemyShot.SpriteName())
            {
                playerHitHandler?(node1,node2,contact.contactPoint)
            }
            else if ( name2 == EnemyShot.SpriteName() && name1 == SpaceShip.SpriteName())
            {
                playerHitHandler?(node2,node1,contact.contactPoint)
            }

        }
    }
    
}