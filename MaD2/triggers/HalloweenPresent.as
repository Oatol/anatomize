package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class HalloweenPresent extends Trigger
   {
      
      public function HalloweenPresent()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:* = ["alarmclock","axe","camera","chainsword","crescent","dragonsword","firespread","gluebottle","huntingrifle","lancer","mjolnir","pulsegun","smg","spikestrip","disclauncher","tacticalsub","tacticalknife","teslagun","chronomancer","toxinpistol","toxinsprayer","utilityknife","pumpkinbasket"];
         Body.Destroy(param1,"present");
         var _loc4_:b2Body = GameState.objects.spawnObject(_loc3_[int(Math.random() * _loc3_.length)],pixelCenter.x,pixelCenter.y,bodyAngle * Vars.toDegrees,Math.random() > 0.5,true);
      }
   }
}

