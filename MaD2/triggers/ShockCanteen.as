package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ShockCanteen extends Trigger
   {
      
      internal var upperAngle:Number;
      
      internal var lowerAngle:Number;
      
      internal var dripSpeed:Number;
      
      public function ShockCanteen(param1:Number = 60, param2:Number = 300, param3:Number = 0.5)
      {
         super();
         this.upperAngle = param2;
         this.lowerAngle = param1;
         this.dripSpeed = 1 - param3;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(Math.random() > this.dripSpeed)
         {
            _loc3_ = bodyAngle * Vars.toDegrees % 360;
            if(param2.flipped)
            {
               _loc3_ *= -1;
            }
            if(_loc3_ < 0 && _loc3_ < this.lowerAngle && _loc3_ > -360 + this.upperAngle || _loc3_ > 0 && _loc3_ > this.upperAngle && _loc3_ < 360 + this.lowerAngle)
            {
               if(param2.flipped)
               {
                  _loc4_ = -1;
               }
               else
               {
                  _loc4_ = 1;
               }
               _loc5_ = BoxUtils.rotateVec(new b2Vec2(param2.size * triggerPos.x * _loc4_,param2.size * triggerPos.y),bodyAngle);
               GameState.objects.addbullet("zap1",(pixelCenter.x + _loc5_.x) / Physics.scale,(pixelCenter.y + _loc5_.y) / Physics.scale,_loc3_,1,1,_loc5_,0,param1);
            }
         }
      }
   }
}

