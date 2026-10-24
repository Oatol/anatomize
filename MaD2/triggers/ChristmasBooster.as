package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ChristmasBooster extends TradingBooster
   {
      
      public function ChristmasBooster()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         ratios = [0.95,0.83,0.63,0.31];
         if(param2.triggerState == 1)
         {
            if(b2Vec2(param1.GetPosition()).y * Physics.scale > 400)
            {
               param2.ignore = "";
               param2.triggerState = 2;
               param2.triggered = false;
            }
            return;
         }
         var _loc3_:Array = [];
         _loc3_.push("That was tasty! Here\'s a little something for your troubles.");
         _loc3_.push("You know, I spend 364 days of the year playing TCGs. Here\'s a pack on me.");
         _loc3_.push("Hope you find a Legendary item!");
         _loc3_.push("There\'s always room for cookies.");
         _loc3_.push("I hope this card pack is as legendary as that cookie.");
         _loc3_.push("Nom nom nom!");
         _loc3_.push("Hope the card pack tastes as good as the cookie did. Errr...");
         _loc3_.push("Can I have another?");
         _loc3_.push("That was perfectly moist! Here are some cards for your troubles.");
         _loc3_.push("1 cookie = 1 pack. Simple.");
         _loc3_.push("I\'ve only eaten " + int(Math.random() * 9000 + 2).toString() + " cookies today. One more won\'t hurt.");
         _loc3_.push("Keep \'em coming and I\'ll keep the packs coming! Trade!");
         _loc3_.push("A worthy trade!");
         _loc3_.push("I have too many of these packs lying around so I\'m trading them for cookies.");
         var _loc4_:String = _loc3_[int(Math.random() * _loc3_.length)];
         GameState.ui.showTooltip(param2.graphic,"There\'s a note attached that reads:\n\n\'" + _loc4_ + "\'\n-S\n\n\n",10,8000,300);
         var _loc5_:Vector.<Array> = new Vector.<Array>();
         _loc5_.push(["9b8360","932022"]);
         _loc5_.push(["59482b","f8e7e2"]);
         _loc5_.push(["47391f","f8e7e2"]);
         _loc5_.push(["666666","7c0e10"]);
         var _loc6_:Vector.<Array> = GameState.objects.spawnSkin.slice();
         GameState.objects.spawnSkin = _loc5_;
         super.trigger(param1,param2);
         GameState.objects.spawnSkin = _loc6_;
      }
   }
}

