package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DroneSaber extends Drone
   {
      
      public function DroneSaber()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         super.seek();
         var _loc3_:int = 0;
         while(_loc3_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc3_]);
            if(userData(_loc1_.GetUserData()).saveable != false)
            {
               if(userData(_loc1_.GetUserData()).health != 0)
               {
                  if(_loc1_.GetMass() >= 0.1)
                  {
                     if(Math.random() > 0.8)
                     {
                        followBody(_loc1_);
                        break;
                     }
                  }
               }
            }
            _loc3_++;
         }
      }
      
      override protected function follow() : void
      {
         super.follow();
         if(targetBody)
         {
            this.rotateToTarget();
            this.saber();
         }
      }
      
      private function rotateToTarget() : void
      {
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         var _loc5_:Number = Math.atan2(_loc4_,_loc3_) + Math.PI * 0.5;
         var _loc6_:Number = bodyAngle % (Math.PI * 2);
         var _loc7_:Number = _loc5_ - _loc6_;
         if(_loc7_ > 0.1)
         {
            body.ApplyTorque(1000);
         }
         else if(_loc7_ < -0.1)
         {
            body.ApplyTorque(-1000);
         }
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:Number = Math.atan2(_loc1_.y - bodyCenter.y,_loc1_.x - bodyCenter.x);
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(bodyCenter.x,bodyCenter.y,30 / Physics.scale,Vars.toDegrees * _loc2_);
         var _loc4_:b2Vec2 = targetBody.GetPosition();
         var _loc5_:b2Vec2 = body.GetPosition();
         var _loc6_:Number = _loc4_.x - _loc5_.x;
         var _loc7_:Number = _loc4_.y - _loc5_.y;
         var _loc8_:userData = userData(targetBody.GetUserData());
         fly(_loc6_ * 50,_loc7_ * 50,1000);
         this.saber();
         if(Math.random() > 0.9)
         {
            beginSeek();
         }
         return true;
      }
      
      internal function saber() : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc10_:Array = null;
         var _loc11_:b2Body = null;
         var _loc1_:Number = bodyCenter.x * Physics.scale;
         var _loc2_:Number = bodyCenter.y * Physics.scale;
         _loc3_ = BoxUtils.rotateVec(new b2Vec2(0 * ud.size,-35 * ud.size),bodyAngle);
         _loc4_ = BoxUtils.rotateVec(new b2Vec2(0 * ud.size,-135 * ud.size),bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(_loc1_ + _loc3_.x,_loc2_ + _loc3_.y);
         var _loc6_:b2Vec2 = new b2Vec2(_loc1_ + _loc4_.x,_loc2_ + _loc4_.y);
         var _loc7_:Sprite = new Sprite();
         var _loc8_:Vector.<Array> = ud.skin;
         var _loc9_:uint = 16711680;
         if(Boolean(_loc8_) && _loc8_.length > 0)
         {
            _loc9_ = BoxUtils.getSkinColour(_loc8_,"ab1111");
         }
         _loc7_.graphics.lineStyle(4 * ud.size,_loc9_,Math.random() * 0.25 + 0.5);
         _loc7_.graphics.moveTo(GraphicUtils.camX(_loc5_.x) + camPos.x,GraphicUtils.camY(_loc5_.y) + camPos.y);
         _loc7_.graphics.lineTo(GraphicUtils.camX(_loc6_.x) + camPos.x,GraphicUtils.camY(_loc6_.y) + camPos.y);
         Main.instance.particlesBMD.draw(_loc7_);
         if(triggerDuration <= 0)
         {
            _loc10_ = GameState.cutter.CustomRaycast(_loc5_,100 * ud.size,_loc6_,false);
            _loc11_ = _loc10_[0];
            if((Boolean(_loc11_)) && !_loc11_.IsStatic())
            {
               GameState.cutter.ExcludeSingle(body);
               GameState.madeby = "lightsaber";
               GameState.cutter.Cut(1,_loc5_,_loc6_,100 * ud.size,0);
               ud.triggerDuration = 4;
            }
         }
         else
         {
            --ud.triggerDuration;
         }
      }
   }
}

