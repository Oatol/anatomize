package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DelayedTeleport extends Trigger
   {
      
      private var tpPos:b2Vec2;
      
      internal var dur:Number;
      
      public function DelayedTeleport(param1:Number, param2:b2Vec2)
      {
         super();
         this.dur = param1;
         this.tpPos = param2;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         this.dur -= TimeLord.speed;
         if(this.dur > 0)
         {
            return;
         }
         param1.SetXForm(new b2Vec2(this.tpPos.x / Vars.physScale,this.tpPos.y / Vars.physScale),bodyAngle);
         param2.trigger.reset();
         if(param2.trigger is DelayedTeleport)
         {
            param2.trigger = null;
         }
         param2.justSpawned = false;
      }
   }
}

