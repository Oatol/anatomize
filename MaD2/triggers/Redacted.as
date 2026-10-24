package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class Redacted extends Trigger
   {
      
      public function Redacted()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Sprite = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius,param2.triggerRadius,true);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            if(!_loc5_.graphic.getChildByName("redacted"))
            {
               _loc6_ = _loc4_.GetPosition();
               _loc7_ = GameState.hullHandler.drawHullFilled(_loc5_.hull,_loc6_.x,_loc6_.y,_loc5_.size + Math.random() * 0.2,328965 + GraphicUtils.scalehex(1052688,Math.random()));
               _loc7_.name = "redacted";
               _loc5_.graphic.addChild(_loc7_);
            }
         }
         param2.triggered = false;
      }
   }
}

