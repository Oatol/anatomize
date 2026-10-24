package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Combustor extends Trigger
   {
      
      public function Combustor()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:int = 0;
         super.trigger(param1,param2);
         if(triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
         }
         if(triggerDuration <= 0)
         {
            _loc3_ = new b2Vec2(0,-10 * param2.size);
            _loc4_ = BoxUtils.rotateVec(_loc3_,bodyAngle);
            _loc5_ = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
            if(Math.abs(param1.GetAngularVelocity()) > 10)
            {
               sounds.play("incendiary",param1,_loc5_);
               _loc6_ = 0;
               while(_loc6_ < 10)
               {
                  GameState.objects.addbullet("flm",(_loc5_.x + (Math.random() * 100 - 50) * param2.size) / Physics.scale,(_loc5_.y + (Math.random() * 100 - 50) * param2.size) / Physics.scale,0,1,1,bodyVel,10,param1);
                  _loc6_++;
               }
               param2.triggerDuration = 60;
            }
         }
      }
   }
}

