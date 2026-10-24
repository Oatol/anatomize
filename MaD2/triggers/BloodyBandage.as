package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BloodyBandage extends Trigger
   {
      
      internal var targetBody:b2Body;
      
      internal var whichBleed:int;
      
      internal var originalBleed:Number;
      
      public function BloodyBandage()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc4_:Array = null;
         var _loc5_:Number = NaN;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(!this.targetBody || userData(this.targetBody.GetUserData()).dead)
         {
            ud.triggered = false;
            return;
         }
         if(ud.triggerState == 0)
         {
            _loc3_ = userData(this.targetBody.GetUserData());
            _loc4_ = _loc3_.bleeding[this.whichBleed];
            this.originalBleed = _loc4_[3];
            _loc3_.bleeding[this.whichBleed][3] = 0;
            _loc5_ = Math.random();
            _loc6_ = b2Vec2(_loc4_[0]);
            _loc7_ = b2Vec2(_loc4_[1]);
            _loc8_ = new b2Vec2(_loc6_.x + _loc7_.x * _loc5_,_loc6_.y + _loc7_.y * _loc5_);
            _loc8_ = this.targetBody.GetWorldPoint(_loc8_);
            body.SetXForm(_loc8_,Math.random() * Vars.PI * 2);
            Joints.Weld("weld",body,this.targetBody,body.GetPosition(),100000);
            ud.triggerState = 1;
         }
         else if(Math.random() > 0.995)
         {
            if(userData(this.targetBody.GetUserData()).bleeding.length >= this.whichBleed)
            {
               userData(this.targetBody.GetUserData()).bleeding[this.whichBleed][3] = this.originalBleed;
               Joints.RemoveAll(body);
               this.targetBody = null;
               this.whichBleed = null;
               this.originalBleed = null;
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_.alive)
         {
            return true;
         }
         if(_loc7_.bleeding.length == 0)
         {
            return true;
         }
         this.whichBleed = int(Math.random() * _loc7_.bleeding.length);
         if(_loc7_.bleeding[this.whichBleed][3] == 0)
         {
            return true;
         }
         ud.triggered = true;
         this.targetBody = param1;
         return true;
      }
   }
}

