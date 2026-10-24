package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class Tripwire extends Trigger
   {
      
      public function Tripwire()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc9_:b2Body = null;
         var _loc10_:Sprite = null;
         super.trigger(param1,param2);
         var _loc3_:int = 1;
         if(param1.GetUserData().flipped)
         {
            _loc3_ = -1;
         }
         var _loc4_:Number = Math.cos(bodyAngle) * _loc3_;
         var _loc5_:Number = Math.sin(bodyAngle) * _loc3_;
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x - 20 * _loc4_ * param2.size,pixelCenter.y - 20 * _loc5_ * param2.size);
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x - 20.1 * _loc4_ * param2.size,pixelCenter.y - 20.1 * _loc5_ * param2.size);
         var _loc8_:Array = GameState.cutter.CustomRaycast(_loc6_,triggerForce * param2.size,_loc7_,false);
         for each(_loc9_ in param2.connected)
         {
            if(_loc8_[0])
            {
               userData(_loc9_.GetUserData()).triggered = true;
            }
            else
            {
               userData(_loc9_.GetUserData()).triggered = false;
            }
         }
         _loc10_ = new Sprite();
         _loc10_.graphics.lineStyle(1,16711680);
         _loc10_.graphics.moveTo(GraphicUtils.camX(_loc6_.x) + camPos.x,GraphicUtils.camY(_loc6_.y) + camPos.y);
         _loc10_.graphics.lineTo(GraphicUtils.camX(_loc8_[1].x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc8_[1].y * Physics.scale) + camPos.y);
         Main.instance.particlesBMD.draw(_loc10_);
      }
   }
}

