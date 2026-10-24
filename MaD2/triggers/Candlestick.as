package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Candlestick extends Lighter
   {
      
      public function Candlestick(param1:b2Vec2, param2:b2Vec2)
      {
         super(param1,param2);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(Main.instance.comboRequisite && !Main.instance.comboRequisite2)
         {
            Main.instance.comboRequisite2 = true;
            GameState.ui.showTooltip(param2.graphic,"You feel a wind as fair as a whisper...\n\nb...u...f...f...\n...\n",10,8000,200);
         }
      }
      
      override public function OnDelete() : void
      {
         super.OnDelete();
         Main.instance.comboRequisite2 = false;
      }
   }
}

