package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Drone extends Trigger
   {
      
      protected var ignoreTinyStuff:Boolean = false;
      
      public var allowDroneTargeting:Boolean = false;
      
      public var flightEnabled:Boolean = true;
      
      protected var targetBody:b2Body;
      
      protected var state:String = "seek";
      
      protected var seekbodies:Array = [];
      
      protected var seekX:Number = 40;
      
      protected var seekY:Number = 40;
      
      protected var seekSpin:Number = 20;
      
      protected var followX:Number = 10;
      
      protected var followY:Number = 10;
      
      protected var followSpin:Number = 40;
      
      protected var zerogravity:Boolean = true;
      
      protected var flyChance:* = 1;
      
      protected var forceOffset:b2Vec2 = new b2Vec2();
      
      protected var targetCutBodies:Boolean = false;
      
      protected var velCapX:Number = 5;
      
      protected var velCapY:Number = 5;
      
      internal var ffx:Number = 0;
      
      internal var ffy:Number = 0;
      
      public function Drone()
      {
         super();
      }
      
      protected function seek() : void
      {
         body.WakeUp();
         if(this.flyChance == 1 || Math.random() > this.flyChance)
         {
            this.ffx = Math.random() * this.seekX - this.seekX * 0.5;
            this.ffy = Math.random() * this.seekY - this.seekY * 0.5;
         }
         if(this.zerogravity)
         {
            this.ffy -= Vars.gravity;
         }
         this.fly(this.ffx,this.ffy,this.seekSpin);
         this.seekbodies = Body.GetAround(body,ud.triggerRadius * ud.size,ud.triggerRadius * ud.size,false);
      }
      
      protected function follow() : void
      {
         var _loc5_:b2Vec2 = null;
         body.WakeUp();
         if(!this.targetBody || userData(this.targetBody.GetUserData()).dead || ud.triggerDuration > 180)
         {
            this.beginSeek();
            return;
         }
         var _loc1_:b2Vec2 = this.targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         if(this.flightEnabled)
         {
            _loc5_ = body.GetLinearVelocity();
            body.SetLinearVelocity(new b2Vec2(body.GetLinearVelocity().x * 0.9,body.GetLinearVelocity().y * 0.9));
            body.SetAngularVelocity(body.GetAngularVelocity() * 0.99);
         }
         if(_loc3_ * _loc3_ + _loc4_ * _loc4_ > triggerRadius * ud.size)
         {
            this.fly(_loc3_ * this.followX,_loc4_ * this.followY);
            ud.triggerDuration += TimeLord.speed;
         }
         else
         {
            this.fly(0,0,this.followSpin);
            ud.triggerDuration -= TimeLord.speed;
            if(ud.triggerDuration <= 0)
            {
               this.state = "destroy";
            }
         }
      }
      
      protected function destroy() : Boolean
      {
         if(this.zerogravity)
         {
            this.fly(0,-Vars.gravity * 1.1);
         }
         if(!this.targetBody)
         {
            this.beginSeek();
            return false;
         }
         var _loc1_:userData = userData(this.targetBody.GetUserData());
         if(_loc1_.dead || ud.triggerDuration > 180)
         {
            this.beginSeek();
            return false;
         }
         return true;
      }
      
      protected function fly(param1:Number, param2:Number, param3:Number = 0) : void
      {
         if(!this.flightEnabled)
         {
            return;
         }
         body.ApplyForce(new b2Vec2(param1 * body.GetMass() * TimeLord.speed,param2 * body.GetMass() * TimeLord.speed),new b2Vec2(bodyCenter.x + this.forceOffset.x,bodyCenter.y + this.forceOffset.y));
         body.ApplyTorque((Math.random() * param3 - param3 * 0.5) * body.GetMass() * TimeLord.speed);
         body.SetAngularVelocity(body.GetAngularVelocity() * 0.99);
         var _loc4_:b2Vec2 = body.GetLinearVelocity();
         if(_loc4_.x > this.velCapX)
         {
            _loc4_.x = this.velCapX;
         }
         if(_loc4_.x < -this.velCapX)
         {
            _loc4_.x = -this.velCapX;
         }
         if(_loc4_.y > this.velCapY)
         {
            _loc4_.y = this.velCapY;
         }
         if(_loc4_.y < -this.velCapY)
         {
            _loc4_.y = -this.velCapY;
         }
         body.SetLinearVelocity(_loc4_);
      }
      
      public function flyTo(param1:b2Vec2) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.state == "seek")
         {
            _loc2_ = param1.x - body.GetPosition().x;
            _loc3_ = param1.y - body.GetPosition().y;
            this.fly(_loc2_,_loc3_,0);
         }
      }
      
      protected function beginSeek() : void
      {
         this.targetBody = null;
         this.state = "seek";
         ud.triggerDuration = ud.originalTriggerDuration;
      }
      
      public function followBody(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!this.allowDroneTargeting && _loc2_.trigger is Drone)
         {
            return;
         }
         if(this.ignoreTinyStuff && param1.GetMass() < 0.1)
         {
            return;
         }
         var _loc3_:Array = ["dronelauncher","dronecontroller","scaredrone","dronetrapper","speakerparanoid","speakersinister"];
         if(_loc3_.indexOf(_loc2_.name) != -1)
         {
            return;
         }
         if(ud.connected.indexOf(param1) != -1)
         {
            return;
         }
         this.targetBody = param1;
         this.state = "follow";
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(this.state == "seek")
         {
            this.seek();
         }
         else if(this.state == "follow")
         {
            this.follow();
         }
         else if(this.state == "destroy")
         {
            this.destroy();
         }
      }
   }
}

