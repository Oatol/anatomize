package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ATM extends Trigger
   {
      
      public function ATM()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
            return;
         }
         if(param2.triggerState != 1)
         {
            return;
         }
         if(Math.random() > 0.5)
         {
            param2.triggerState = 0;
         }
         if(param2.originalTriggerDuration < 10)
         {
            param2.originalTriggerDuration = 10;
         }
         param2.triggerDuration = param2.originalTriggerDuration;
         var _loc3_:Item = O.getItem("moneypack");
         var _loc4_:Array = _loc3_.colours;
         var _loc5_:b2Vec2 = param2.triggerPos.Copy();
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(_loc5_,bodyAngle);
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc6_.x * param2.size,pixelCenter.y + _loc6_.y * param2.size);
         var _loc8_:b2Body = GameState.objects.spawnItem(_loc3_.vertices,[0.1],_loc3_.scale * param2.size,"moneypack",_loc7_.x,_loc7_.y,bodyAngle,_loc4_);
         var _loc9_:b2Vec2 = new b2Vec2(_loc7_.x - pixelCenter.x,_loc7_.y - pixelCenter.y);
         _loc9_.Multiply(-param2.triggerForce * 0.01);
         _loc8_.ApplyForce(_loc9_,_loc8_.GetWorldCenter());
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(userData(param1.GetUserData()).name == "creditcard")
         {
            ud.triggerState = 1;
            ud.triggered = true;
         }
         return true;
      }
   }
}

