package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DronePin extends Drone
   {
      
      public function DronePin()
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
            if(Joints.NumJoints(_loc1_) < 2)
            {
               if(Math.random() > 0.8)
               {
                  followBody(_loc1_);
                  break;
               }
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
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:userData = userData(targetBody.GetUserData());
         var _loc2_:b2Vec2 = targetBody.GetPosition();
         Joints.Pin("bgjoint",targetBody,_loc2_,10000);
         beginSeek();
         return true;
      }
   }
}

