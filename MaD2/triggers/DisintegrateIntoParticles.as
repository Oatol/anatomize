package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class DisintegrateIntoParticles extends Trigger
   {
      
      internal var amount:Number = 5;
      
      internal var particle:String;
      
      public function DisintegrateIntoParticles()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         var _loc3_:Object = ud.ParseTriggerCustom();
         if(_loc3_["amount"])
         {
            this.amount = Number(_loc3_["amount"]);
         }
         if(_loc3_["particle"])
         {
            this.particle = _loc3_["particle"];
         }
         overwrite = false;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         super.trigger(param1,param2);
         if(this.particle)
         {
            _loc3_ = 0;
            while(_loc3_ < Math.random() * 20 + 10)
            {
               BoxUtils.randomParticlesOnBody(body,this.particle);
               _loc3_++;
            }
         }
         ud.dead = true;
         Body.Disintegrate(body,"inherit",100,4,4);
      }
   }
}

