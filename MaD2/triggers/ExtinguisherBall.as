package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ExtinguisherBall extends Trigger
   {
      
      public function ExtinguisherBall()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(triggerState == 2)
         {
            this.Effect();
            return;
         }
         if(param2.temperature < 100)
         {
            return;
         }
         this.Effect();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!userData(param1.GetUserData()).burning)
         {
            return true;
         }
         ud.triggerState = 2;
         return true;
      }
      
      public function Effect() : *
      {
         var _loc3_:userData = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Body = null;
         Body.Destroy(body,"waterballoon");
         var _loc1_:int = 36 * ud.size >> 0;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = Properties.objTemp("extinguish");
            _loc3_.triggered = true;
            _loc3_.trigger = new Water();
            _loc3_.projectileName = "ext";
            Water(_loc3_.trigger).setParticle("gas");
            _loc4_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,Math.random() * ud.size * 25,_loc2_ * (360 / _loc1_));
            _loc5_ = Spawn.circle(_loc4_.x,_loc4_.y,0.1,_loc3_,[1,1,1]);
            _loc5_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc5_.ApplyImpulse(new b2Vec2((Math.random() * 190 - 59) * _loc5_.GetMass() * ud.size,(Math.random() * 190 - 59) * _loc5_.GetMass() * ud.size),_loc5_.GetPosition());
            _loc2_++;
         }
      }
   }
}

