package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Syringe extends Trigger
   {
      
      public function Syringe()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc9_:String = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = bodyCenter;
         var _loc4_:Number = Math.cos(bodyAngle + Math.PI / 2);
         var _loc5_:Number = Math.sin(bodyAngle + Math.PI / 2);
         var _loc6_:Number = _loc3_.x * Physics.scale;
         var _loc7_:Number = _loc3_.y * Physics.scale;
         var _loc8_:b2Vec2 = new b2Vec2(_loc6_ - 25 * param2.size * _loc4_,_loc7_ - 25 * param2.size * _loc5_);
         if(param2.health > 0)
         {
            if(param2.connected.length == 1)
            {
               userData(param2.connected[0].GetUserData()).health = userData(param2.connected[0].GetUserData()).health + param2.size;
               param2.health -= param2.size;
               if(Math.random() > 0.75)
               {
                  _loc9_ = "heal";
                  if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
                  {
                     _loc9_ = param2.pfx.getParticle();
                  }
                  GameState.particles.addParticles(_loc8_.x + Math.random() * 30 - 15,_loc8_.y + Math.random() * 30 - 15,1,_loc9_,bodyVel.x * 0.2,-2 + bodyVel.y * 0.2,1,1);
               }
            }
            else
            {
               --param2.health;
               GameState.particles.addParticles(_loc8_.x,_loc8_.y,1,"blood",-_loc4_ * 4,-_loc5_ * 4,1,1);
            }
            if(param2.health <= 0)
            {
               param2.triggered = false;
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!param3.sticky)
         {
            return false;
         }
         if(!userData(param1.GetUserData()).alive)
         {
            return false;
         }
         if(ud.connected.indexOf(param1) == -1)
         {
            ud.connected.push(param1);
         }
         return true;
      }
   }
}

