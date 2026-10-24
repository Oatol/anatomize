package
{
   import Box2D.Collision.Shapes.b2FilterData;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2ContactFilter;
   import triggers.ArmourBoot;
   
   public class CustomContactFilter extends b2ContactFilter
   {
      
      public var cutInclude:Vector.<b2Body> = new Vector.<b2Body>();
      
      public var cutExclude:Vector.<b2Body> = new Vector.<b2Body>();
      
      public var shrapnel:Boolean = false;
      
      public function CustomContactFilter()
      {
         super();
      }
      
      override public function ShouldCollide(param1:b2Shape, param2:b2Shape) : Boolean
      {
         var _loc3_:b2Body = param1.GetBody();
         var _loc4_:b2Body = param2.GetBody();
         if(!_loc3_ || !_loc4_)
         {
            return false;
         }
         var _loc5_:userData = userData(_loc3_.GetUserData());
         var _loc6_:userData = userData(_loc4_.GetUserData());
         var _loc7_:String = _loc5_.name;
         var _loc8_:String = _loc6_.name;
         if(_loc5_.dead || _loc6_.dead)
         {
            return false;
         }
         if(_loc5_.projectile && _loc6_.projectile && !_loc5_.saveable && !_loc6_.saveable)
         {
            return false;
         }
         if(Boolean(_loc5_.armour) && Boolean(_loc6_.armour))
         {
            return false;
         }
         if(_loc5_.justSpawned || _loc6_.justSpawned)
         {
            return false;
         }
         if(_loc5_.ignore == "projectiles" && _loc6_.projectile)
         {
            return false;
         }
         if(_loc6_.ignore == "projectiles" && _loc5_.projectile)
         {
            return false;
         }
         if(_loc5_.ignore == "!projectiles" && !_loc6_.projectile)
         {
            return false;
         }
         if(_loc6_.ignore == "!projectiles" && !_loc5_.projectile)
         {
            return false;
         }
         if(_loc5_.ignore == "!walls" && _loc6_.name != "wall")
         {
            return false;
         }
         if(_loc6_.ignore == "!walls" && _loc5_.name != "wall")
         {
            return false;
         }
         if(_loc5_.projectileGhost && _loc6_.projectile)
         {
            return false;
         }
         if(_loc6_.projectileGhost && _loc5_.projectile)
         {
            return false;
         }
         if(_loc5_.ignored.indexOf(_loc4_) != -1)
         {
            return false;
         }
         if(_loc6_.ignored.indexOf(_loc3_) != -1)
         {
            return false;
         }
         if(_loc5_.ignore == "dolls" && _loc6_.name.indexOf("doll") != -1)
         {
            return false;
         }
         if(_loc6_.ignore == "dolls" && _loc5_.name.indexOf("doll") != -1)
         {
            return false;
         }
         if(_loc5_.ignore == _loc6_.name)
         {
            return false;
         }
         if(_loc6_.ignore == _loc5_.name)
         {
            return false;
         }
         var _loc9_:Boolean = GameState.environment.defaultBodies.indexOf(_loc3_) != -1;
         var _loc10_:Boolean = GameState.environment.defaultBodies.indexOf(_loc4_) != -1;
         if(_loc5_.wallGhost && (_loc10_ || _loc8_ == "wall"))
         {
            return false;
         }
         if(_loc6_.wallGhost && (_loc9_ || _loc7_ == "wall"))
         {
            return false;
         }
         if(Boolean(_loc5_.armour && _loc5_.armour.attachedBody) && Boolean(_loc5_.armour is ArmourBoot) && _loc4_.IsStatic())
         {
            return false;
         }
         if(Boolean(_loc6_.armour && _loc6_.armour.attachedBody) && Boolean(_loc6_.armour is ArmourBoot) && _loc3_.IsStatic())
         {
            return false;
         }
         if(_loc7_ == "wall")
         {
            return true;
         }
         if(_loc8_ == "wall")
         {
            return true;
         }
         if(_loc5_.group >= 900)
         {
            return false;
         }
         if(_loc6_.group >= 900)
         {
            return false;
         }
         if(_loc5_.group <= -900)
         {
            return false;
         }
         if(_loc6_.group <= -900)
         {
            return false;
         }
         if(_loc5_.ghost || _loc6_.ghost)
         {
            if(_loc5_.ghostCollide && _loc6_.ghost)
            {
               if(_loc6_.density <= 0)
               {
                  return false;
               }
               return true;
            }
            if(_loc6_.ghostCollide && _loc5_.ghost)
            {
               if(_loc5_.density <= 0)
               {
                  return false;
               }
               return true;
            }
            return false;
         }
         if(_loc5_.group < 0 || _loc6_.group < 0)
         {
            return _loc5_.group != -_loc6_.group;
         }
         if(_loc5_.group > 0 || _loc6_.group > 0)
         {
            return _loc5_.group == _loc6_.group;
         }
         if(_loc5_.armour)
         {
            if(_loc6_.alive && _loc5_.armour.collideWithDolls)
            {
               return true;
            }
            if(!_loc6_.armourCollide)
            {
               return false;
            }
         }
         if(_loc6_.armour)
         {
            if(_loc5_.alive && _loc6_.armour.collideWithDolls)
            {
               return true;
            }
            if(!_loc5_.armourCollide)
            {
               return false;
            }
         }
         if(Boolean(_loc5_.armour) && _loc6_.alive)
         {
            return false;
         }
         if(Boolean(_loc6_.armour) && _loc5_.alive)
         {
            return false;
         }
         if(this.shrapnel && _loc5_.hasBeenCut && _loc6_.hasBeenCut)
         {
            return false;
         }
         if(_loc7_ == "blooddrop" && _loc8_ == "blooddrop")
         {
            return false;
         }
         if(_loc5_.id == 9999 && _loc6_.id == 9999)
         {
            return false;
         }
         if(_loc7_ == "blooddrop" && (isNaN(_loc5_.triggerDuration) || _loc5_.triggerDuration < 6))
         {
            return false;
         }
         if(_loc8_ == "blooddrop" && (isNaN(_loc6_.triggerDuration) || _loc6_.triggerDuration < 6))
         {
            return false;
         }
         if(_loc7_ == "bullet_fla" && _loc8_ == "bullet_fla")
         {
            return false;
         }
         if(_loc7_ == "clustershrapnel" && _loc8_ == "clustershrapnel")
         {
            return false;
         }
         if(_loc7_ == "snarebullet" && _loc8_ == "snarebullet")
         {
            return false;
         }
         if(_loc7_ == "stasis" && _loc8_ == "stasis")
         {
            return false;
         }
         if(_loc7_ == "bluntprojectile" && _loc8_ == "bluntprojectile")
         {
            return false;
         }
         var _loc11_:b2FilterData = param1.GetFilterData();
         var _loc12_:b2FilterData = param2.GetFilterData();
         if(_loc11_.groupIndex == _loc12_.groupIndex && _loc11_.groupIndex != 0)
         {
            return _loc11_.groupIndex > 0;
         }
         return (_loc11_.maskBits & _loc12_.categoryBits) != 0 && (_loc11_.categoryBits & _loc12_.maskBits) != 0;
      }
      
      override public function RayCollide(param1:*, param2:b2Shape) : Boolean
      {
         if(this.cutInclude.length > 0 && this.cutInclude.indexOf(param2.GetBody()) == -1)
         {
            return false;
         }
         if(this.cutExclude.length > 0 && this.cutExclude.indexOf(param2.GetBody()) != -1)
         {
            return false;
         }
         var _loc3_:String = GameState.madeby;
         var _loc4_:userData = userData(param2.GetBody().GetUserData());
         if(_loc4_.ghost && _loc3_ != "customraycast_equip")
         {
            return false;
         }
         if(_loc4_.name == "blooddrop")
         {
            return false;
         }
         if(_loc3_ == "customraycast_normal")
         {
            return true;
         }
         if(_loc3_ == "customraycast_static")
         {
            if(param2.GetBody().IsStatic())
            {
               return false;
            }
         }
         else if(_loc3_ == "customraycast_laser")
         {
            if(!param2.GetBody().IsStatic())
            {
               return false;
            }
         }
         else if(_loc3_ == "customraycast_equip")
         {
            if(_loc4_.name == "doll_hand")
            {
               return false;
            }
         }
         else if(_loc3_ == "customraycast_turret")
         {
            if(_loc4_.name == "bullet_pis")
            {
               return false;
            }
         }
         else if(_loc3_ == "bullet")
         {
            if(_loc4_.name.substr(0,6) == "bullet")
            {
               return false;
            }
         }
         return super.RayCollide(param1,param2);
      }
   }
}

