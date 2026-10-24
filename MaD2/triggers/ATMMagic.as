package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ATMMagic extends Trigger
   {
      
      public function ATMMagic()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc11_:b2Vec2 = null;
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
         if(param2.connected.length == 0)
         {
            param2.triggered = false;
            return;
         }
         param2.triggerState = 0;
         if(param2.originalTriggerDuration < 10)
         {
            param2.originalTriggerDuration = 10;
         }
         param2.triggerDuration = param2.originalTriggerDuration;
         var _loc3_:b2Body = param2.connected[int(param2.connected.length * Math.random())];
         var _loc4_:String = userData(_loc3_.GetUserData()).name;
         var _loc5_:Item = O.getItem(_loc4_);
         var _loc6_:Array = _loc5_.colours;
         var _loc7_:b2Vec2 = param2.triggerPos.Copy();
         var _loc8_:b2Vec2 = BoxUtils.rotateVec(_loc7_,bodyAngle);
         var _loc9_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc8_.x * param2.size,pixelCenter.y + _loc8_.y * param2.size);
         var _loc10_:b2Body = GameState.objects.spawnObject(_loc4_,-500,-500,0,false,true);
         if(_loc10_)
         {
            userData(_loc10_.GetUserData()).ignored.push(param1);
            _loc10_.SetXForm(new b2Vec2(_loc9_.x / Vars.physScale,_loc9_.y / Vars.physScale),bodyAngle);
            _loc11_ = new b2Vec2(_loc9_.x - pixelCenter.x,_loc9_.y - pixelCenter.y);
            _loc11_.Multiply(-param2.triggerForce * 0.01);
            _loc10_.ApplyForce(_loc11_,_loc10_.GetWorldCenter());
         }
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

