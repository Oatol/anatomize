package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Cloner extends Trigger
   {
      
      internal var whichItem:int = 0;
      
      public function Cloner()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:b2Body = null;
         var _loc5_:b2Body = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:userData = null;
         super.trigger(param1,param2);
         if(param2.connected.length == 0)
         {
            return;
         }
         param2.triggerDuration -= TimeLord.speed;
         if(triggerDuration <= 0)
         {
            param2.triggerDuration = param2.originalTriggerDuration;
            if(param2.triggerState == 3 || param2.triggerState == 4)
            {
               param2.triggered = false;
            }
            _loc3_ = 0;
            do
            {
               if(param2.triggerState == 5 || param2.triggerState == 6)
               {
                  this.whichItem = Math.random() * param2.connected.length >> 0;
               }
               else
               {
                  ++this.whichItem;
                  if(this.whichItem > param2.connected.length - 1)
                  {
                     this.whichItem = 0;
                  }
               }
               _loc4_ = param2.connected[this.whichItem];
               _loc3_++;
            }
            while(param2.ignored.indexOf(_loc4_) != -1 && _loc3_ < 10);
            if(!_loc4_)
            {
               return;
            }
            _loc5_ = Body.Clone(_loc4_);
            if(!_loc5_)
            {
               return;
            }
            _loc6_ = new b2Vec2(param2.triggerForce * param2.size * Math.cos(bodyAngle - Vars.PI * 0.5),param2.triggerForce * param2.size * Math.sin(bodyAngle - Vars.PI * 0.5));
            _loc7_ = param2.triggerPos.Copy();
            _loc7_.Multiply(param2.size);
            _loc7_.Multiply(1 / Physics.scale);
            _loc7_ = BoxUtils.rotateVec(_loc7_,bodyAngle);
            _loc7_.Add(bodyCenter);
            _loc5_.SetXForm(_loc7_,bodyAngle);
            _loc5_.SetLinearVelocity(_loc6_);
            _loc8_ = userData(_loc5_.GetUserData());
            if(param2.triggerState == 2 || param2.triggerState == 4)
            {
               _loc8_.saveable = false;
               _loc8_.killOnContact = true;
            }
         }
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         ud.triggerDuration = ud.originalTriggerDuration;
      }
   }
}

