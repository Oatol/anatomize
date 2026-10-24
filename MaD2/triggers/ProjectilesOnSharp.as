package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ProjectilesOnSharp extends ProjectilesWhen
   {
      
      public function ProjectilesOnSharp()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         ud.triggerDuration = 0;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(ud.triggerDuration > 0)
         {
            return;
         }
         ud.triggerDuration = ud.originalTriggerDuration;
         spawn = true;
      }
   }
}

