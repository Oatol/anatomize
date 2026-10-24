package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DroneToxic extends Drone
   {
      
      public function DroneToxic()
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
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:Vector.<Array> = null;
         var _loc4_:uint = 0;
         var _loc5_:Sprite = null;
         super.follow();
         if(targetBody)
         {
            _loc1_ = bodyCenter;
            _loc2_ = targetBody.GetWorldCenter().Copy();
            _loc3_ = ud.skin;
            _loc4_ = 1392139;
            if(Boolean(_loc3_) && _loc3_.length > 0)
            {
               _loc4_ = BoxUtils.getSkinColour(_loc3_,"153e0b");
            }
            _loc5_ = new Sprite();
            _loc5_.graphics.lineStyle(2,_loc4_,Math.random());
            _loc5_.graphics.drawCircle(GraphicUtils.camX(pixelCenter.x) + camPos.x,GraphicUtils.camY(pixelCenter.y) + camPos.y,Math.random() * 10 * Main.instance.cam.scaleX);
            Main.instance.particlesBMD.draw(_loc5_);
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
         GameState.objects.addbullet("tox",_loc3_.x,_loc3_.y,_loc2_,3,1,new b2Vec2(4 * (_loc1_.x - _loc3_.x),4 * (_loc1_.y - _loc3_.y)),30,body);
         beginSeek();
         return true;
      }
   }
}

