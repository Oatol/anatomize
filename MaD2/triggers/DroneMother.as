package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DroneMother extends Drone
   {
      
      internal var children:int = 0;
      
      public function DroneMother()
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
               if(userData(_loc1_.GetUserData()).name != "dronechild")
               {
                  followBody(_loc1_);
                  state = "destroy";
                  break;
               }
            }
            _loc3_++;
         }
         if(this.children < 4 && Math.random() > 0.98)
         {
            this.spawn();
         }
      }
      
      override protected function follow() : void
      {
         if(!targetBody || !targetBody.GetUserData())
         {
            beginSeek();
            return;
         }
         if(userData(targetBody.GetUserData()).dead)
         {
            beginSeek();
            return;
         }
         if(ud.triggerDuration > 0)
         {
            ud.triggerDuration -= TimeLord.speed;
         }
         fly(0,-Vars.gravity,40);
         if(ud.triggerDuration > 0)
         {
            return;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         var _loc5_:userData = userData(targetBody.GetUserData());
         fly(_loc3_ * 250,_loc4_ * 250,1000);
         if(_loc3_ * _loc3_ + _loc4_ * _loc4_ < 20)
         {
            state = "destroy";
         }
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         if(Math.random() > 0.9)
         {
            beginSeek();
         }
         else
         {
            state = "follow";
         }
         return true;
      }
      
      internal function spawn() : void
      {
         var _loc1_:Vector.<Array> = ud.skin;
         var _loc2_:Item = O.getItem("dronechild");
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,50,Math.random() * 360);
         var _loc4_:b2Body = GameState.objects.spawnItem(_loc2_.vertices,[0.1],_loc2_.scale,"dronechild",_loc3_.x,_loc3_.y,0,_loc2_.colours,"none",_loc1_);
         var _loc5_:DroneChild = new DroneChild();
         _loc5_.mother = body;
         var _loc6_:userData = userData(_loc4_.GetUserData());
         _loc6_.trigger = _loc5_;
         _loc6_.triggered = true;
         _loc6_.triggerDuration = Math.random() * 2400 + 600;
         _loc6_.saveable = false;
         _loc6_.ignore = "dronemother";
         _loc6_.triggerLock = true;
         _loc6_.connected.push(body);
         ud.connected.push(_loc4_);
         ++this.children;
      }
      
      public function Aggro(param1:b2Body) : *
      {
         targetBody = param1;
         state = "follow";
         this.RIP();
      }
      
      public function RIP() : void
      {
         --this.children;
      }
   }
}

