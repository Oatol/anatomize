package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Hailstorm extends Trigger
   {
      
      internal var targetBody:b2Body;
      
      public function Hailstorm()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:userData = null;
         var _loc6_:b2Body = null;
         var _loc7_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(triggerState == 2)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(param2.triggerDuration <= 0)
            {
               param2.triggerState = 1;
            }
            _loc3_ = this.targetBody.GetPosition().Copy();
            _loc3_.Multiply(Physics.scale);
            _loc4_ = GeneralUtils.pointOnCircle(_loc3_.x,_loc3_.y,param2.triggerRadius,Math.random() * 360);
            _loc5_ = Properties.objTemp("hail");
            _loc5_.trigger = new HailBullet();
            _loc5_.triggered = true;
            _loc5_.ignore = "hailstorm";
            _loc5_.killOnContact = true;
            _loc5_.projectileName = "hail";
            _loc6_ = Spawn.circle(_loc4_.x,_loc4_.y,0.1,_loc5_,[1,1,1]);
            _loc7_ = new b2Vec2(_loc3_.x - _loc4_.x,_loc3_.y - _loc4_.y);
            _loc7_.Multiply(0.0001);
            _loc6_.ApplyForce(_loc7_,_loc6_.GetWorldCenter());
         }
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(param1.IsStatic())
         {
            return;
         }
         if(triggerState == 1)
         {
            ud.triggerState = 2;
            ud.triggerDuration = ud.originalTriggerDuration;
            this.targetBody = param1;
         }
      }
   }
}

