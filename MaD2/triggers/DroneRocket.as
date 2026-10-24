package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DroneRocket extends Drone
   {
      
      public function DroneRocket()
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
            if(userData(_loc1_.GetUserData()).saveable == false)
            {
               return;
            }
            if(Math.random() > 0.8)
            {
               followBody(_loc1_);
               break;
            }
            _loc3_++;
         }
      }
      
      override protected function follow() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<Array> = null;
         var _loc6_:uint = 0;
         var _loc7_:Sprite = null;
         super.follow();
         if(targetBody)
         {
            _loc1_ = bodyCenter;
            _loc2_ = targetBody.GetWorldCenter().Copy();
            _loc3_ = _loc1_.x - _loc2_.x;
            _loc4_ = _loc1_.y - _loc2_.y;
            if(_loc3_ * _loc3_ + _loc4_ * _loc4_ < triggerRadius * 0.5 * ud.size)
            {
               fly(_loc3_ * 10,_loc4_ * 10,0);
            }
            _loc5_ = ud.skin;
            _loc6_ = 10031377;
            if(Boolean(_loc5_) && _loc5_.length > 0)
            {
               _loc6_ = BoxUtils.getSkinColour(_loc5_,"991111");
            }
            _loc7_ = new Sprite();
            _loc7_.graphics.lineStyle(2,_loc6_,Math.random());
            _loc7_.graphics.drawCircle(GraphicUtils.camX(pixelCenter.x) + camPos.x,GraphicUtils.camY(pixelCenter.y) + camPos.y,Math.random() * 10);
            Main.instance.particlesBMD.draw(_loc7_);
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
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(bodyCenter.x,bodyCenter.y,30 * ud.size / Physics.scale,Vars.toDegrees * _loc2_);
         GameState.objects.addbullet("aut",_loc3_.x,_loc3_.y,_loc2_,1,1,new b2Vec2(10 * (_loc1_.x - _loc3_.x),10 * (_loc1_.y - _loc3_.y)),10,body);
         beginSeek();
         return true;
      }
   }
}

