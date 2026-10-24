package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class SilverStopwatch extends Trigger
   {
      
      internal var armCounter:Number = 0;
      
      public function SilverStopwatch()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc10_:b2Body = null;
         var _loc11_:userData = null;
         var _loc12_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(param2.connected.length == 0)
         {
            return;
         }
         if(TimeLord.speed != 1 && Math.random() * TimeLord.speed < TimeLord.speed * 0.1)
         {
            return;
         }
         this.armCounter -= TimeLord.speed * 2;
         var _loc3_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(-4 * param2.size,-4 * param2.size),bodyAngle);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(4 * param2.size,4 * param2.size),bodyAngle);
         var _loc5_:Number = 1 - this.armCounter / 360;
         var _loc6_:Sprite = new Sprite();
         var _loc7_:uint = BoxUtils.getSkinColour(param2.skin,"71797f");
         if(_loc7_ == 16711935)
         {
            _loc7_ = 7436671;
         }
         var _loc8_:b2Vec2 = GeneralUtils.pointOnCircle(0,0,6 * param2.size,360 * _loc5_ - 90);
         _loc6_.graphics.lineStyle(3,_loc7_);
         _loc6_.graphics.moveTo(GraphicUtils.camX(pixelCenter.x) + camPos.x,GraphicUtils.camY(pixelCenter.y) + camPos.y);
         _loc6_.graphics.lineTo(GraphicUtils.camX(pixelCenter.x) + _loc8_.x + camPos.x,GraphicUtils.camY(pixelCenter.y) + _loc8_.y + camPos.y);
         Main.instance.particlesBMD.draw(_loc6_);
         var _loc9_:Number = 1 + param2.triggerForce * 0.01;
         if(_loc9_ < 0)
         {
            _loc9_ = 0;
         }
         for each(_loc10_ in param2.connected)
         {
            _loc11_ = userData(_loc10_.GetUserData());
            _loc12_ = _loc10_.GetLinearVelocity().Copy();
            if(_loc12_.Length() >= 5)
            {
               _loc12_.Multiply(0.5 + 0.5 * _loc9_);
               _loc10_.SetLinearVelocity(_loc12_);
               _loc10_.SetAngularVelocity(_loc10_.GetAngularVelocity() * _loc9_);
               _loc10_.ApplyForce(new b2Vec2(0,-Vars.gravity * _loc10_.GetMass() * (1 - _loc9_)),_loc10_.GetWorldCenter());
            }
         }
      }
   }
}

