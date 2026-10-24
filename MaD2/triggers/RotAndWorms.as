package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class RotAndWorms extends Spectrus
   {
      
      public function RotAndWorms()
      {
         super(16711935,true);
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         aliveOnly = true;
         skinny = uint("0x" + ud.triggerColour);
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc3_:int = 0;
         while(_loc3_ < Math.random() * 5 + 1)
         {
            _loc5_ = BoxUtils.randomPointOnBody(param1);
            Body.BlightEffect(param1,_loc5_,ud.triggerColour,ud.skin);
            _loc3_++;
         }
         var _loc4_:uint = skinny;
         if(Boolean(ud.skin) && ud.skin.length > 0)
         {
            _loc4_ = BoxUtils.getSkinColour(ud.skin,ud.triggerColour);
         }
         userData(param1.GetUserData()).bloodColour = _loc4_;
         Body.Worm(param1);
         super.OnSharp(param1);
      }
   }
}

