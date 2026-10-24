package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Torch extends Trigger
   {
      
      public function Torch()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         _loc3_.Multiply(param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         _loc4_.Add(pixelCenter);
         _loc4_.x += (Math.random() * param2.triggerRadius - param2.triggerRadius * 0.5) * param2.size;
         _loc4_.y += (Math.random() * param2.triggerRadius - param2.triggerRadius * 0.5) * param2.size;
         var _loc5_:String = "fire2";
         var _loc6_:String = "fire3";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc5_ = param2.pfx.getParticle();
            _loc6_ = param2.pfx.getParticle();
         }
         GameState.particles.addParticles(_loc4_.x,_loc4_.y,1,_loc5_,bodyVel.x * 0.2,bodyVel.y * 0.2,1,1);
         GameState.particles.addParticles(_loc4_.x,_loc4_.y,1,_loc6_,bodyVel.x * 0.2,bodyVel.y * 0.2,1,1);
         var _loc7_:Array = Body.GetAroundPoint(_loc4_,param2.triggerRadius,param2.triggerRadius,false);
         for each(_loc8_ in _loc7_)
         {
            if(_loc8_ != param1)
            {
               userData(_loc8_.GetUserData()).temperature = userData(_loc8_.GetUserData()).temperature + 2 * param2.size;
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:b2Vec2 = ud.triggerPos.Copy();
         _loc7_.Multiply(ud.size / Physics.scale);
         var _loc8_:b2Vec2 = BoxUtils.rotateVec(_loc7_,bodyAngle);
         _loc8_.Add(bodyCenter);
         var _loc9_:userData = userData(param1.GetUserData());
         if(_loc9_)
         {
            if(Boolean(_loc9_.triggered) && Boolean(_loc9_.trigger) && (_loc9_.trigger is Torch || _loc9_.trigger is Lighter))
            {
               ud.triggered = true;
            }
            else if(Boolean(_loc9_.trigger) && _loc9_.trigger is Bomb)
            {
               _loc9_.triggered = true;
            }
            else if(_loc9_.name.substr(0,6) == "bullet")
            {
               ud.triggered = true;
               return true;
            }
         }
         if(ud.triggerContact == 0 && ud.triggerCollide == 0)
         {
            return false;
         }
         ud.triggered = true;
         return true;
      }
   }
}

