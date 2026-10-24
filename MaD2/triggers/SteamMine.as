package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SteamMine extends Trigger
   {
      
      public function SteamMine()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var windPos:b2Vec2;
         var proxbodies:Array;
         var body:b2Body = param1;
         var ud:userData = param2;
         super.trigger(body,ud);
         windPos = BoxUtils.rotateVec(ud.triggerPos.Copy(),bodyAngle);
         windPos.Add(pixelCenter);
         proxbodies = Body.GetAroundPoint(windPos,ud.triggerRadius * ud.size,ud.triggerRadius * ud.size,false);
         if(proxbodies.length > 1)
         {
            ud.triggerLock = false;
            ud.trigger = new JetGoblet(0.5 * ud.triggerForce,1.4 * ud.triggerForce,12);
            ud.triggerDuration = 0;
            ud.trigger.untriggerFunc = function():*
            {
               ud.trigger = new SteamMine();
               ud.triggered = true;
               ud.triggerLock = true;
            };
         }
      }
   }
}

