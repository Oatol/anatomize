package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BeeStaff extends Trigger
   {
      
      private var targetbody:b2Body;
      
      public function BeeStaff()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:Number = NaN;
         var _loc10_:b2Vec2 = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:b2Vec2 = null;
         var _loc15_:userData = null;
         var _loc16_:b2Body = null;
         var _loc17_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(param2.triggerState == 0)
         {
            _loc3_ = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
            _loc4_ = [];
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               if(userData(b2Body(_loc3_[_loc5_]).GetUserData()).name != "beepod")
               {
                  _loc4_.push(_loc3_[_loc5_]);
               }
               _loc5_++;
            }
            _loc6_ = 0;
            this.targetbody = _loc4_[Math.random() * _loc4_.length >> 0];
            if(this.targetbody)
            {
               param2.triggerState = 1;
               param2.triggerDuration = param2.originalTriggerDuration;
            }
         }
         if(param2.triggerState == 1)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(param2.triggerDuration <= 0)
            {
               param2.triggerState = 0;
            }
            if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.1)
            {
               _loc7_ = param2.triggerPos.Copy();
               _loc8_ = BoxUtils.rotateVec(_loc7_,bodyAngle);
               _loc9_ = param2.triggerRadius * param2.size;
               _loc10_ = new b2Vec2(pixelCenter.x + _loc8_.x,pixelCenter.y + _loc8_.y);
               _loc11_ = this.targetbody.GetPosition().x * Physics.scale;
               _loc12_ = this.targetbody.GetPosition().y * Physics.scale;
               _loc13_ = Math.atan2(_loc10_.y - _loc12_,_loc10_.x - _loc11_);
               _loc14_ = GeneralUtils.pointOnCircle(_loc10_.x,_loc10_.y,20 * param2.size,180 + _loc13_ * Vars.toDegrees + (Math.random() * 30 - 15));
               _loc15_ = Properties.objectProperties("beepod");
               _loc15_.trigger = new Bee();
               _loc15_.name = "beepod";
               _loc15_.triggered = true;
               _loc16_ = Spawn.circle(_loc14_.x,_loc14_.y,1,_loc15_,[1,1,1]);
               _loc17_ = new b2Vec2((_loc14_.x - this.targetbody.GetPosition().x * Physics.scale) * -0.002,(_loc14_.y - this.targetbody.GetPosition().y * Physics.scale) * -0.002);
               _loc16_.ApplyImpulse(_loc17_,_loc16_.GetPosition());
            }
         }
      }
   }
}

