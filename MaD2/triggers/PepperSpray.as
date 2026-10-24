package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PepperSpray extends Trigger
   {
      
      public function PepperSpray()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.triggered = false;
            param2.triggerDuration = param2.originalTriggerDuration;
         }
         var _loc3_:Number = bodyAngle * Vars.toDegrees;
         var _loc4_:Vector.<Array> = param2.skin;
         var _loc5_:String = "7F6A00";
         var _loc6_:userData = Properties.objTemp(_loc5_);
         _loc6_.trigger = new ConcussSpray();
         _loc6_.triggered = true;
         _loc6_.killOnContact = true;
         _loc6_.projectileName = "concuss";
         var _loc7_:b2Vec2 = param2.triggerPos.Copy();
         if(param2.flipped)
         {
            _loc7_.x *= -1;
         }
         _loc7_.Multiply(param2.size);
         var _loc8_:Number = bodyAngle;
         var _loc9_:b2Vec2 = BoxUtils.rotateVec(_loc7_,_loc8_);
         var _loc10_:b2Body = Spawn.circle(pixelCenter.x + _loc9_.x,pixelCenter.y + _loc9_.y,2 * param2.size,_loc6_,[1,1,0]);
         var _loc11_:Number = Math.random() * 10 - 5;
         var _loc12_:Number = -param2.triggerForce;
         if(param2.flipped)
         {
            _loc12_ *= -1;
         }
         var _loc13_:b2Vec2 = new b2Vec2(_loc12_ * param2.size * Math.cos(_loc8_) + _loc11_,_loc12_ * param2.size * Math.sin(_loc8_) + _loc11_);
         _loc10_.SetLinearVelocity(_loc13_);
      }
   }
}

