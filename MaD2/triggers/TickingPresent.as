package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class TickingPresent extends Trigger
   {
      
      public function TickingPresent()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:b2Body = null;
         super.trigger(param1,param2);
         if(param2.triggerState == 1)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(param2.triggerDuration <= 0)
            {
               param2.triggerDuration = param2.originalTriggerDuration;
               sounds.play("touch1",param1,pixelCenter,1);
            }
            return;
         }
         var _loc3_:b2Body = GameState.objects.spawnObject("C4",pixelCenter.x,pixelCenter.y,bodyAngle,param2.flipped,true);
         var _loc4_:b2Body = GameState.objects.spawnObject("timer",pixelCenter.x,pixelCenter.y - 30,bodyAngle,param2.flipped,true);
         userData(_loc4_.GetUserData()).connected.push(_loc3_);
         userData(_loc4_.GetUserData()).triggerDuration = 90;
         userData(_loc4_.GetUserData()).triggered = true;
         Joints.Distance("objjoint",_loc4_,_loc3_,_loc4_.GetPosition(),_loc3_.GetPosition(),1,1,true);
         var _loc5_:Vector.<b2Body> = Body.Decompose(param1);
         for each(_loc6_ in _loc5_)
         {
            userData(_loc6_.GetUserData()).name = BoxUtils.shapeNameToColour(userData(_loc6_.GetUserData()).name,param2.skin).toString(16);
            userData(_loc6_.GetUserData()).dead = true;
            Body.Disintegrate(_loc6_,"inherit",50,1,1);
         }
         sounds.play("rustle",param1,pixelCenter,Math.random() * 1.5 + 0.5);
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         ud.triggerState = 2;
         ud.triggered = true;
      }
   }
}

