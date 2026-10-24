package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DroneOn extends Drone
   {
      
      public function DroneOn()
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
            _loc2_ = userData(_loc1_.GetUserData());
            if(Boolean(!_loc2_.triggered && _loc2_.trigger && !_loc2_.triggerLock && !(_loc2_.trigger is Equip)) && Boolean(!(_loc2_.trigger is Unequip)) && !_loc2_.trigger.temporary)
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
            _loc3_.graphics.lineStyle(2,65280,Math.random());
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
         _loc1_.triggered = true;
         beginSeek();
         return true;
      }
   }
}

