package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class KinetizerPortable extends Trigger
   {
      
      public function KinetizerPortable()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:int = 1;
         if(param2.flipped)
         {
            _loc3_ = -1;
         }
         for each(_loc4_ in param2.connected)
         {
            if(_loc4_.IsStatic())
            {
               return;
            }
            _loc5_ = new b2Vec2(-_loc3_ * param2.triggerForce * _loc4_.GetMass(),0);
            _loc5_ = BoxUtils.rotateVec(_loc5_,bodyAngle);
            _loc4_.WakeUp();
            _loc4_.ApplyImpulse(_loc5_,_loc4_.GetPosition());
            Body.ThrowItem(userData(_loc4_.GetUserData()),_loc4_.GetPosition().Copy());
         }
         sounds.play("thumper_shoot",param1,pixelCenter,0.5);
         param2.triggered = false;
      }
   }
}

