package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class Proximity extends Trigger
   {
      
      public function Proximity()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc7_:b2Body = null;
         var _loc8_:Number = NaN;
         var _loc9_:b2Body = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:Sprite = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         var _loc4_:int = 0;
         var _loc6_:Number = 9000;
         for each(_loc7_ in _loc3_)
         {
            if(param2.connected.indexOf(_loc7_) == -1)
            {
               _loc8_ = BoxUtils.vectorDist(bodyCenter,_loc7_.GetWorldCenter().Copy());
               if(_loc8_ < _loc6_)
               {
                  _loc5_ = _loc7_;
                  _loc6_ = _loc8_;
               }
               _loc4_++;
            }
         }
         if(_loc4_ > 0)
         {
            for each(_loc9_ in param2.connected)
            {
               userData(_loc9_.GetUserData()).triggered = true;
            }
            _loc10_ = bodyCenter;
            _loc11_ = _loc5_.GetWorldCenter().Copy();
            _loc12_ = new Sprite();
            _loc12_.graphics.lineStyle(2,16711680,Math.random());
            _loc12_.graphics.moveTo(GraphicUtils.camX(_loc10_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc10_.y * Physics.scale) + camPos.y);
            _loc12_.graphics.lineTo(GraphicUtils.camX(_loc11_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc11_.y * Physics.scale) + camPos.y);
            Main.instance.particlesBMD.draw(_loc12_);
         }
         else
         {
            for each(_loc9_ in param2.connected)
            {
               userData(_loc9_.GetUserData()).triggered = false;
            }
         }
      }
   }
}

