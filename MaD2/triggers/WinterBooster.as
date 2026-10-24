package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class WinterBooster extends TradingBooster
   {
      
      public function WinterBooster()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         ratios = [0.85,0.7,0.55,0.2];
         openParticle = "snow";
         var _loc3_:Vector.<Array> = new Vector.<Array>();
         _loc3_.push(["9b8360","932022"]);
         _loc3_.push(["59482b","f8e7e2"]);
         _loc3_.push(["47391f","f8e7e2"]);
         _loc3_.push(["666666","7c0e10"]);
         var _loc4_:Vector.<Array> = GameState.objects.spawnSkin.slice();
         GameState.objects.spawnSkin = _loc3_;
         super.trigger(param1,param2);
         GameState.objects.spawnSkin = _loc4_;
      }
   }
}

