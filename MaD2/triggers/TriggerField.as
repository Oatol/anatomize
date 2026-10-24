package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class TriggerField extends Trigger
   {
      
      public function TriggerField()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc12_:MyLittleParticle = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius,param2.triggerRadius);
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = userData(_loc5_.GetUserData());
            if(param2.connected.indexOf(_loc5_) == -1)
            {
               if(Boolean(_loc4_.trigger && !(_loc4_.trigger is Equip)) && Boolean(!(_loc4_.trigger is TriggerField)) && !_loc4_.triggerLock)
               {
                  _loc4_.triggered = triggerState == 1 ? true : false;
               }
            }
         }
         _loc6_ = param2.triggerRadius * param2.size;
         _loc7_ = "laser";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc7_ = param2.pfx.getParticle();
         }
         var _loc8_:* = Math.random() * 360;
         var _loc9_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc6_,_loc8_);
         var _loc10_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc6_,_loc8_ + (triggerState == 1 ? 10 : -10));
         var _loc11_:Vector.<MyLittleParticle> = GameState.particles.addParticles(_loc9_.x,_loc9_.y,1,_loc7_,_loc10_.x - _loc9_.x + bodyVel.x * 0.1,_loc10_.y - _loc9_.y + bodyVel.y * 0.1,0,0);
         if((Boolean(_loc11_)) && _loc11_.length > 0)
         {
            for each(_loc12_ in _loc11_)
            {
               _loc12_.colour = triggerState == 1 ? uint(4282287963) : uint(4290250770);
            }
         }
      }
   }
}

