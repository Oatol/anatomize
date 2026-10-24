package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import environment.Environment;
   
   public class ElectroSphere extends Trigger
   {
      
      internal var burst:int = 0;
      
      public function ElectroSphere()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerDuration <= 0)
         {
            this.teleport();
            param2.triggerDuration = param2.originalTriggerDuration;
            param1.SetLinearVelocity(new b2Vec2());
            ++this.burst;
            if(this.burst > 6)
            {
               this.burst = 0;
               param2.triggerDuration = param2.originalTriggerDuration * 15;
            }
         }
         --param2.triggerDuration;
      }
      
      private function teleport() : void
      {
         var _loc1_:Number = 500;
         if(ud.triggerRadius)
         {
            _loc1_ = ud.triggerRadius;
         }
         var _loc2_:b2Vec2 = new b2Vec2(pixelCenter.x + Math.random() * (Math.random() * _loc1_ - _loc1_ * 0.5),pixelCenter.y + Math.random() * (Math.random() * _loc1_ - _loc1_ * 0.5));
         var _loc3_:Environment = GameState.environment;
         var _loc4_:int = 0;
         while(_loc4_ < 10 && (_loc2_.x < _loc3_.borderLeft || _loc2_.x > _loc3_.borderRight))
         {
            _loc2_.x = pixelCenter.x + (Math.random() * 500 - 250);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < 10 && (_loc2_.y < -_loc3_.borderTop + GameState.height || _loc2_.y > GameState.height))
         {
            _loc2_.y = pixelCenter.y + (Math.random() * 500 - 250);
            _loc4_++;
         }
         _loc2_.Multiply(1 / Physics.scale);
         var _loc5_:b2Vec2 = new b2Vec2(body.GetPosition().x - _loc2_.x,body.GetPosition().y - _loc2_.y);
         _loc5_.Multiply(10);
         BoxUtils.randomSlopeParticles("shock",new b2Vec2(_loc2_.x * Physics.scale,_loc2_.y * Physics.scale),pixelCenter);
         body.SetXForm(_loc2_,Math.random() * Math.PI * 2);
         body.SetLinearVelocity(_loc5_);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         Body.Damage(param1,Math.random() * 48 + 12,new b2Vec2(),new b2Vec2(),new b2Vec2(),false);
         return true;
      }
   }
}

