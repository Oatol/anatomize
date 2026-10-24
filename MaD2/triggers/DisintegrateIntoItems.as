package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class DisintegrateIntoItems extends SpawnItems
   {
      
      internal var amount:Number = 5;
      
      internal var particle:String;
      
      public function DisintegrateIntoItems()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         if(customs["amount"])
         {
            this.amount = Number(customs["amount"]);
         }
         if(customs["particle"])
         {
            this.particle = customs["particle"];
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.amount)
         {
            super.trigger(param1,param2);
            _loc3_++;
         }
         if(this.particle)
         {
            _loc3_ = 0;
            while(_loc3_ < Math.random() * 20 + 10)
            {
               BoxUtils.randomParticlesOnBody(body,this.particle);
               _loc3_++;
            }
         }
         if(destroyOriginal)
         {
            ud.dead = true;
            Body.Disintegrate(body,"inherit",100,4,4);
         }
         else
         {
            ud.trigger.reset();
            ud.triggered = false;
            if(ud.trigger is DisintegrateIntoItems)
            {
               ud.trigger = null;
            }
         }
      }
   }
}

