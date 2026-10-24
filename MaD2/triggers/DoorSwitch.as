package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DoorSwitch extends Trigger
   {
      
      public function DoorSwitch()
      {
         super();
      }
      
      override public function OnLoadFinished() : void
      {
         super.OnLoadFinished();
         ud.graphic.scaleY = ud.triggered ? -1 : 1;
      }
      
      override public function onTrigger() : void
      {
         super.onTrigger();
         this.flipOn();
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         this.flipOff();
      }
      
      protected function flipOn() : *
      {
         var _loc2_:b2Body = null;
         var _loc4_:userData = null;
         var _loc5_:Number = NaN;
         var _loc6_:b2Vec2 = null;
         if(ud.connected.length == 0)
         {
            return;
         }
         ud.graphic.scaleY = -1;
         var _loc1_:int = int(ud.connected.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = ud.connected[_loc3_];
            if(_loc2_)
            {
               _loc4_ = userData(_loc2_.GetUserData());
               _loc5_ = 0.2;
               if(ud.triggerForce)
               {
                  _loc5_ = ud.triggerForce * 0.01;
               }
               _loc4_.alpha = _loc5_;
               if(triggerState == 0)
               {
                  _loc4_.ghost = true;
               }
               _loc6_ = _loc2_.GetPosition().Copy();
               if(_loc6_.x != 0 || _loc6_.y != 0)
               {
                  _loc2_.SetXForm(new b2Vec2(),_loc2_.GetAngle());
                  _loc2_.SetXForm(_loc6_,_loc2_.GetAngle());
               }
            }
            _loc3_++;
         }
      }
      
      protected function flipOff() : *
      {
         var _loc2_:b2Body = null;
         var _loc4_:userData = null;
         var _loc5_:b2Vec2 = null;
         if(ud.connected.length == 0)
         {
            return;
         }
         ud.graphic.scaleY = 1;
         var _loc1_:int = int(ud.connected.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = ud.connected[_loc3_];
            if(_loc2_)
            {
               _loc4_ = userData(_loc2_.GetUserData());
               if(!_loc4_.invisible)
               {
                  _loc4_.alpha = ud.alpha;
               }
               if(triggerState == 0)
               {
                  _loc4_.ghost = false;
               }
               _loc5_ = _loc2_.GetPosition().Copy();
               if(_loc5_.x != 0 || _loc5_.y != 0)
               {
                  _loc2_.SetXForm(new b2Vec2(),_loc2_.GetAngle());
                  _loc2_.SetXForm(_loc5_,_loc2_.GetAngle());
               }
            }
            _loc3_++;
         }
      }
   }
}

