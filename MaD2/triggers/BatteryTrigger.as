package triggers
{
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class BatteryTrigger extends Trigger
   {
      
      private var decals:Sprite;
      
      public function BatteryTrigger()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         param2.alive = true;
         param2.bloodColour = 16754176;
         if(Boolean(param2.skin) && param2.skin.length > 0)
         {
            param2.bloodColour = BoxUtils.getSkinColour(param2.skin,"ffa600");
         }
         super.init(param1,param2);
         param2.maxhealth = 300;
         param2.health = 300;
         param2.triggered = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         super.trigger(param1,param2);
         if(!this.decals)
         {
            this.decals = param2.graphic.getChildByName("decals") as Sprite;
         }
         this.decals.alpha = param2.health / param2.maxhealth;
         if(param2.health <= 0)
         {
            param2.triggered = false;
            return;
         }
         for each(_loc3_ in param2.connected)
         {
            if(_loc3_.IsStatic())
            {
               return;
            }
            userData(_loc3_.GetUserData()).triggered = true;
            --param2.health;
            if(param2.health <= 0)
            {
               break;
            }
         }
      }
   }
}

