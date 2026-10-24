package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class Gun extends Trigger
   {
      
      public var firearm:Firearm;
      
      public var customFunc:Function;
      
      public function Gun(param1:Firearm)
      {
         super();
         this.firearm = param1;
         if(Boolean(param1.body) && Boolean(param1.body.GetUserData()))
         {
            this.init(param1.body,param1.body.GetUserData());
         }
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         this.firearm.shoot();
      }
      
      override public function OnLoadCustom() : void
      {
         super.OnLoadCustom();
         if(Boolean(this.customFunc))
         {
            this.customFunc();
         }
      }
   }
}

