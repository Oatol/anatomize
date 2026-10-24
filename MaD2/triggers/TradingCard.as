package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class TradingCard extends Trigger
   {
      
      private var _item:String;
      
      private var _seed:int = 0;
      
      private var rarity:int = 0;
      
      public var ratios:Array = [0.99,0.95,0.85,0.6];
      
      public function TradingCard()
      {
         super();
         this._seed = Math.random() * 9000;
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         if(Boolean(this._item) && Boolean(this._seed))
         {
            this.save();
         }
      }
      
      private function random(param1:Number) : Number
      {
         param1 = (param1 * 9301 + 49297) % 233280;
         return param1 / 233280;
      }
      
      override public function OnLoadCustom() : void
      {
         super.OnLoadCustom();
         var _loc1_:String = ud.triggerCustom;
         var _loc2_:Array = _loc1_.split("&");
         if(_loc2_.length == 0)
         {
            this.item = ud.triggerCustom;
         }
         else
         {
            this._item = _loc2_[0];
            if(_loc2_[2])
            {
               this.ratios = _loc2_[2].split("_");
            }
            this.seed = int(_loc2_[1]);
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         TradingCardUI.Style(this.item,this.rarity,this.seed);
         param2.triggered = false;
      }
      
      public function get item() : String
      {
         return this._item;
      }
      
      public function set item(param1:String) : void
      {
         this._item = param1;
         this.save();
      }
      
      public function get seed() : int
      {
         return this._seed;
      }
      
      public function set seed(param1:int) : void
      {
         this._seed = param1;
         var _loc2_:Number = this.random(this._seed);
         if(_loc2_ > this.ratios[0])
         {
            this.rarity = 4;
         }
         else if(_loc2_ > this.ratios[1])
         {
            this.rarity = 3;
         }
         else if(_loc2_ > this.ratios[2])
         {
            this.rarity = 2;
         }
         else if(_loc2_ > this.ratios[3])
         {
            this.rarity = 1;
         }
         else
         {
            this.rarity = 0;
         }
         this.save();
      }
      
      private function save() : void
      {
         if(ud)
         {
            if(this._item)
            {
               if(this._seed)
               {
                  ud.triggerCustom = this._item + "&" + this._seed.toString() + "&" + this.ratios.join("_");
               }
            }
         }
      }
   }
}

