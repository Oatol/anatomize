package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   
   public class DroneClean extends Drone
   {
      
      public function DroneClean()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         super.seek();
         if(targetBody)
         {
            _loc5_ = targetBody.GetPosition();
            _loc6_ = body.GetPosition();
            _loc7_ = _loc5_.x - _loc6_.x;
            _loc8_ = _loc5_.y - _loc6_.y;
            if(_loc7_ * _loc7_ + _loc8_ * _loc8_ < 60)
            {
               fly(_loc7_ * -100,_loc8_ * -100,100);
            }
            else
            {
               targetBody = null;
            }
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc4_]);
            if(Math.random() > 0.8)
            {
               followBody(_loc1_);
               break;
            }
            _loc4_++;
         }
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         var _loc5_:userData = userData(targetBody.GetUserData());
         fly(_loc3_ * 10,_loc4_ * 10,500);
         return true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc10_:String = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         var _loc8_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc8_)
         {
            _loc8_.colorTransform(_loc8_.rect,new ColorTransform(1,1,1,0.9));
         }
         var _loc9_:int = 0;
         while(_loc9_ < Math.random() * 10)
         {
            _loc10_ = "bubbles";
            if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
            {
               _loc10_ = ud.pfx.getParticle();
            }
            GameState.particles.addParticles(param5.x * Physics.scale,param5.y * Physics.scale,1,_loc10_,body.GetLinearVelocity().x * 0.1,body.GetLinearVelocity().y * 0.1,Math.random() * 5,Math.random() * 5);
            _loc9_++;
         }
         if(Math.random() > 0.9)
         {
            state = "seek";
            ud.triggerDuration = ud.originalTriggerDuration;
         }
         return true;
      }
   }
}

