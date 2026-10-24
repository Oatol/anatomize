package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Saucebottle extends Trigger
   {
      
      public function Saucebottle()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.triggered = false;
            param2.triggerDuration = param2.originalTriggerDuration;
         }
         if(TimeLord.speed < 1 && Math.random() * TimeLord.speed > TimeLord.speed * 0.1)
         {
            return;
         }
         _loc3_ = param2.triggerPos.Copy();
         _loc3_.x += Math.random() * 6 - 3;
         _loc3_.y += Math.random() * 6 - 3;
         _loc3_.Multiply(param2.size);
         var _loc4_:Number = bodyAngle - Math.PI * 0.5;
         var _loc5_:String = "7a2115";
         if(param2.skin.length > 0)
         {
            _loc5_ = BoxUtils.getSkinColour(param2.skin,"7a2115").toString(16);
         }
         while(_loc5_.length < 6)
         {
            _loc5_ = "0" + _loc5_;
         }
         var _loc6_:userData = Properties.objTemp(_loc5_);
         _loc6_.trigger = new Paint();
         _loc6_.triggered = true;
         _loc6_.killOnContact = true;
         _loc6_.projectileName = "pnt";
         var _loc7_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc8_:b2Body = Spawn.circle(pixelCenter.x + _loc7_.x,pixelCenter.y + _loc7_.y,2 * param2.size,_loc6_,[1,1,0]);
         var _loc9_:Number = Math.random() * 4 - 2;
         _loc8_.SetLinearVelocity(new b2Vec2(param2.triggerForce * param2.size * Math.cos(_loc4_) + _loc9_,param2.triggerForce * param2.size * Math.sin(_loc4_) + _loc9_));
         _loc4_ += Math.PI;
      }
   }
}

