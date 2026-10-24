package triggers
{
   import Box2D.Collision.b2ContactPoint;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ConveyorBelt extends Trigger
   {
      
      internal var bodies:Vector.<b2Body>;
      
      public function ConveyorBelt()
      {
         super();
         this.bodies = new Vector.<b2Body>();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Body = null;
         super.trigger(param1,param2);
         --param2.triggerDuration;
         if(param2.triggerDuration > 0)
         {
            _loc4_ = 1;
            if(param2.flipped)
            {
               _loc4_ = -1;
            }
            _loc5_ = bodyAngle + Vars.PI;
            _loc6_ = new b2Vec2(param2.triggerForce * Math.cos(_loc5_) * param2.size * _loc4_,param2.triggerForce * Math.sin(_loc5_) * param2.size * _loc4_);
            _loc7_ = bodyVel.Copy();
            for each(_loc8_ in this.bodies)
            {
               if(bodyVel.x > _loc6_.x)
               {
                  --_loc7_.x;
               }
               else if(bodyVel.x < _loc6_.x)
               {
                  _loc7_.x += 1;
               }
               if(bodyVel.y > _loc6_.y)
               {
                  --_loc7_.y;
               }
               else if(bodyVel.y < _loc6_.y)
               {
                  _loc7_.y += 1;
               }
               _loc8_.SetLinearVelocity(_loc6_);
            }
            param1.SetLinearVelocity(new b2Vec2());
         }
         else
         {
            this.bodies = new Vector.<b2Body>();
         }
      }
      
      override public function onTrigger() : void
      {
         body.WakeUp();
         body.ApplyForce(new b2Vec2(0,-1),bodyCenter);
      }
      
      public function Add(param1:b2Body) : void
      {
         if(userData(param1.GetUserData()).trigger is ConveyorBelt)
         {
            return;
         }
         var _loc2_:int = this.bodies.indexOf(param1);
         if(_loc2_ == -1)
         {
            this.bodies.push(param1);
         }
      }
      
      override public function OnCollisionEnd(param1:b2Body, param2:b2ContactPoint) : void
      {
         super.OnCollisionEnd(param1,param2);
         var _loc3_:int = this.bodies.indexOf(param1);
         if(_loc3_ != -1)
         {
            this.bodies.splice(_loc3_,1);
         }
      }
   }
}

