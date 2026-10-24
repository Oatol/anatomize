package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DroneBuild extends Drone
   {
      
      public function DroneBuild()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         super.seek();
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration > 0)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc3_]);
            if(!_loc1_.IsStatic())
            {
               followBody(_loc1_);
               state = "destroy";
               break;
            }
            _loc3_++;
         }
      }
      
      override protected function follow() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:Sprite = null;
         super.follow();
         if(targetBody)
         {
            _loc1_ = bodyCenter;
            _loc2_ = targetBody.GetWorldCenter().Copy();
            _loc3_ = new Sprite();
            _loc3_.graphics.lineStyle(2,11184810,Math.random());
            _loc3_.graphics.moveTo(GraphicUtils.camX(_loc1_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc1_.y * Physics.scale) + camPos.y);
            _loc3_.graphics.lineTo(GraphicUtils.camX(_loc2_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc2_.y * Physics.scale) + camPos.y);
            Main.instance.particlesBMD.draw(_loc3_);
         }
      }
      
      override protected function destroy() : Boolean
      {
         var _loc11_:b2Vec2 = null;
         var _loc12_:b2Body = null;
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:userData = userData(targetBody.GetUserData());
         var _loc2_:b2Vec2 = targetBody.GetPosition();
         var _loc3_:b2Vec2 = body.GetPosition();
         var _loc4_:Number = targetBody.GetLinearVelocity().x * 0.1;
         var _loc5_:Number = targetBody.GetLinearVelocity().y * 0.1;
         var _loc6_:Number = _loc2_.x * Physics.scale + _loc4_;
         var _loc7_:Number = _loc2_.y * Physics.scale + _loc5_;
         var _loc8_:uint = 9260047;
         var _loc9_:Vector.<Array> = ud.skin;
         if((Boolean(_loc9_)) && _loc9_.length > 0)
         {
            _loc8_ = BoxUtils.getSkinColour(_loc9_,"8d4c0f");
         }
         var _loc10_:int = 0;
         while(_loc10_ < 10)
         {
            _loc11_ = GeneralUtils.pointOnCircle(_loc6_,_loc7_,50,_loc10_ * 36);
            _loc12_ = GameState.objects.spawnItem(O.getItem("simpletrapezoid").vertices,[0],0.1,"built",_loc11_.x,_loc11_.y,Math.PI * 0.5 + _loc10_ * 36 * Vars.toRadians,[_loc8_.toString(16)]);
            userData(_loc12_.GetUserData()).trigger = new DelayedKill(_loc10_ + 50);
            userData(_loc12_.GetUserData()).triggered = true;
            userData(_loc12_.GetUserData()).saveable = false;
            userData(_loc12_.GetUserData()).ignore = "dronebuilder";
            userData(_loc12_.GetUserData()).triggerLock = true;
            _loc10_++;
         }
         beginSeek();
         return true;
      }
   }
}

