package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class TradingBooster extends Trigger
   {
      
      public var items:String;
      
      protected var ratios:Array = [0.99,0.95,0.85,0.6];
      
      protected var itemPool:Array;
      
      protected var openParticle:String = "star";
      
      public function TradingBooster()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         var _loc4_:int = 0;
         super.init(param1,param2);
         if(param2.triggerCustom)
         {
            this.items = param2.triggerCustom;
            return;
         }
         this.items = "";
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            if(this.itemPool)
            {
               this.items = this.items + O.names.indexOf(this.itemPool[int(Math.random() * this.itemPool.length)]) + "x";
            }
            else
            {
               _loc4_ = Math.random() * O.names.length;
               while(Main.instance.customNames.indexOf(O.names[_loc4_]) != -1)
               {
                  _loc4_ = Math.random() * O.names.length;
               }
               this.items = this.items + int(_loc4_) + "x";
            }
            _loc3_++;
         }
         this.items = this.items.substr(0,-1);
         param2.triggerCustom = this.items;
      }
      
      override public function OnLoadCustom() : void
      {
         super.OnLoadCustom();
         this.items = ud.triggerCustom;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc8_:int = 0;
         super.trigger(param1,param2);
         param2.dead = true;
         Body.Disintegrate(param1,this.openParticle,20,10,2);
         var _loc3_:Number = pixelCenter.x - 50;
         var _loc4_:Number = pixelCenter.y - 10;
         var _loc6_:Array = this.items.split("x");
         var _loc7_:int = 0;
         _loc8_ = 0;
         while(_loc8_ < 5)
         {
            _loc7_ += int(_loc6_[_loc8_]);
            _loc7_ += _loc7_;
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ < 5)
         {
            _loc5_ = GameState.objects.delayedSpawnObject("tradingcard",_loc3_,_loc4_,0,false,true,GameState.objects.spawnSkin);
            if(_loc5_)
            {
               TradingCard(userData(_loc5_.GetUserData()).trigger).ratios = this.ratios;
               TradingCard(userData(_loc5_.GetUserData()).trigger).item = O.names[int(_loc6_[_loc8_])];
               TradingCard(userData(_loc5_.GetUserData()).trigger).seed = _loc7_ + _loc8_ * _loc8_ * _loc8_;
            }
            _loc3_ += 25;
            _loc8_++;
         }
      }
   }
}

