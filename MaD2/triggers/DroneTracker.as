package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DroneTracker extends Drone
   {
      
      public function DroneTracker()
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
         super.follow();
         if(!targetBody)
         {
            return;
         }
         var _loc1_:b2Vec2 = bodyCenter;
         var _loc2_:b2Vec2 = targetBody.GetWorldCenter().Copy();
         var _loc3_:Number = BoxUtils.vectorDist(_loc1_,_loc2_);
         if(_loc3_ < triggerRadius * 0.5 * ud.size)
         {
            fly((_loc1_.x - _loc2_.x) * 30,(_loc1_.y - _loc2_.y) * 30,0);
         }
         if(_loc3_ > triggerRadius * 2 * ud.size)
         {
            state = "seek";
            return;
         }
         body.SetLinearVelocity(targetBody.GetLinearVelocity().Copy());
         var _loc4_:uint = 13505042;
         var _loc5_:Vector.<Array> = ud.skin;
         if((Boolean(_loc5_)) && _loc5_.length > 0)
         {
            _loc4_ = BoxUtils.getSkinColour(_loc5_,"ce1212");
         }
         if(ud.triggerDuration > ud.originalTriggerDuration)
         {
            ud.triggerDuration = ud.originalTriggerDuration;
         }
         var _loc6_:Sprite = new Sprite();
         _loc6_.graphics.lineStyle(2,_loc4_,0.5 * (ud.triggerDuration / ud.originalTriggerDuration));
         _loc6_.graphics.moveTo(GraphicUtils.camX(_loc1_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc1_.y * Physics.scale) + camPos.y);
         _loc6_.graphics.lineTo(GraphicUtils.camX(_loc2_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc2_.y * Physics.scale) + camPos.y);
         Main.instance.particlesBMD.draw(_loc6_);
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         state = "follow";
         ud.triggerDuration = ud.originalTriggerDuration;
         return true;
      }
   }
}

