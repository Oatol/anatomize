package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class MissileToe extends Trigger
   {
      
      public function MissileToe()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:int = 0;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(Math.random() < 0.95)
         {
            return;
         }
         if(param2.triggerDuration > 0)
         {
            return;
         }
         GameState.cutter.ExcludeSingle(param1);
         var _loc3_:Array = GameState.cutter.CustomRaycast(pixelCenter,1000,new b2Vec2(pixelCenter.x,pixelCenter.y + 1),false);
         var _loc4_:Array = [];
         var _loc5_:b2Body = _loc3_[0];
         if(_loc5_)
         {
            param2.triggerDuration = param2.originalTriggerDuration;
            if(_loc5_.IsStatic())
            {
               return;
            }
            if(userData(_loc5_.GetUserData()).name == "tinymissile")
            {
               return;
            }
            _loc6_ = 0;
            while(_loc6_ < 5)
            {
               GameState.objects.addbullet("tinymissile",bodyCenter.x + Math.random() * 4 - 2,bodyCenter.y + 2 * param2.size + Math.random() * 4 - 2,0,1,param2.size,new b2Vec2(0,10),2,param1);
               _loc6_++;
            }
            sounds.play("thumper_shoot",param1,pixelCenter,0.5);
         }
      }
   }
}

