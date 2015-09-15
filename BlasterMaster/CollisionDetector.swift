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
        if (contact.bodyA != nil && contact.bodyA.node != nil && contact.bodyB != nil && contact.bodyB.node != nil)
        {
            let node2:SKNode = contact.bodyB.node!
            let node1:SKNode = contact.bodyA.node!
            let name1 = node1.name;
            let name2 = node2.name;
            if ( name1 == "enemy" && name2 == "lasershot")
            {
                enemyHitHandler?(node1,node2)
            }
            else if ( name2 == "lasershot" && name1 == "enemy")
            {
                enemyHitHandler?(node2,node1)
            }
            else if ( name1 == "player" && name2 == "enemy")
            {
                playerHitHandler?(node1,node2)
            }
            else if ( name2 == "enemy" && name1 == "player")
            {
                playerHitHandler?(node2,node1)
            }
            else if ( name1 == "player" && name2 == "enemyshot")
            {
                playerHitHandler?(node1,node2)
            }
            else if ( name2 == "enemyshot" && name1 == "player")
            {
                playerHitHandler?(node2,node1)
            }

        }
    }
    
}