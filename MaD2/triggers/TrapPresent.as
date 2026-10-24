package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class TrapPresent extends Trigger
   {
      
      public function TrapPresent()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Vector.<b2Body> = Body.Decompose(param1);
         for each(_loc4_ in _loc3_)
         {
            userData(_loc4_.GetUserData()).name = BoxUtils.shapeNameToColour(userData(_loc4_.GetUserData()).name,param2.skin).toString(16);
            userData(_loc4_.GetUserData()).dead = true;
            Body.Disintegrate(_loc4_,"inherit",50,1,1);
         }
         sounds.play("rustle",param1,pixelCenter,Math.random() * 1.5 + 0.5);
         for each(_loc5_ in param2.connected)
         {
            userData(_loc5_.GetUserData()).triggered = true;
         }
      }
   }
}

