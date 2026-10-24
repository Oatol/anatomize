package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DeathField extends Trigger
   {
      
      public function DeathField()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:* = undefined;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:Vector.<MyLittleParticle> = null;
         var _loc10_:MyLittleParticle = null;
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerRadius * param2.size;
         var _loc4_:Array = Body.GetAround(param1,_loc3_,_loc3_);
         for each(_loc5_ in _loc4_)
         {
            Body.Disintegrate(_loc5_,"poof",100,0.5,0.5);
         }
         _loc6_ = Math.random() * 360;
         _loc7_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_,_loc6_);
         _loc8_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_,_loc6_ + (Math.random() > 0.5 ? 10 : -10));
         _loc9_ = GameState.particles.addParticles(_loc7_.x,_loc7_.y,1,"laser",_loc8_.x - _loc7_.x + bodyVel.x * 0.1,_loc8_.y - _loc7_.y + bodyVel.y * 0.1,0,0);
         if((Boolean(_loc9_)) && _loc9_.length > 0)
         {
            for each(_loc10_ in _loc9_)
            {
               _loc10_.colour = 4284900966;
            }
         }
      }
   }
}

