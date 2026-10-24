package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SquashHammer extends Trigger
   {
      
      public function SquashHammer()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = new b2Vec2(0,-15 * param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         if(param2.triggerRadius > 10)
         {
            _loc6_ = param2.triggerRadius * 0.05;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = "acid";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc8_ = param2.pfx.getParticle();
               }
               _loc9_ = GeneralUtils.pointOnCircle(_loc5_.x,_loc5_.y,triggerRadius * 0.5,Math.random() * 360);
               GameState.particles.addParticles(_loc9_.x,_loc9_.y,1,_loc8_,(_loc5_.x - _loc9_.x) * -0.1 + bodyVel.x * 0.1,(_loc5_.y - _loc9_.y) * -0.1 + bodyVel.y * 0.1,1,100);
               _loc7_++;
            }
         }
         if(param2.triggerRadius < 0)
         {
            param2.triggerRadius += TimeLord.speed;
         }
         if(param2.triggerRadius > 0)
         {
            param2.triggerRadius += TimeLord.speed;
            param2.triggerRadius *= 1 + 0.2 * TimeLord.speed;
            this.Effect();
         }
         if(param2.triggerRadius > triggerForce)
         {
            param2.triggerRadius = -60;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param3.name != "C29D70")
         {
            return true;
         }
         if(ud.triggerRadius != 0)
         {
            return true;
         }
         ud.triggerRadius = 1;
         ud.triggered = true;
         return true;
      }
      
      public function Effect() : void
      {
         var _loc4_:* = undefined;
         var _loc5_:userData = null;
         var _loc1_:b2Vec2 = pixelCenter;
         var _loc2_:Number = ud.triggerRadius * ud.size;
         var _loc3_:Array = Body.GetAroundPoint(_loc1_,_loc2_,_loc2_,false);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ != body)
            {
               _loc4_.WakeUp();
               _loc5_ = userData(_loc4_.GetUserData());
               _loc5_.trigger = new ModifyGravity(_loc2_);
               _loc5_.triggerDuration = 10;
               _loc5_.triggered = true;
            }
         }
      }
   }
}

