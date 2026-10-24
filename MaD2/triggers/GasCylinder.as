package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GasCylinder extends Trigger
   {
      
      internal var bleeding:Array = [];
      
      public function GasCylinder()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:Array = null;
         super.trigger(param1,param2);
         if(param2.health > 0)
         {
            if(param2.health <= 0)
            {
               param2.triggered = false;
            }
            for each(_loc5_ in this.bleeding)
            {
               _loc4_ = BoxUtils.rotateVec(_loc5_[3],bodyAngle);
               _loc3_ = param1.GetWorldPoint(_loc5_[0]);
               param1.ApplyForce(new b2Vec2(_loc4_.x * -500,_loc4_.y * -500),_loc3_);
               if(Math.random() > 0.9)
               {
                  GameState.particles.addParticles(_loc3_.x * Physics.scale,_loc3_.y * Physics.scale,1,"air",_loc4_.x * 5,_loc4_.y * 5,2,2);
               }
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!param2.sharp && userData(param1.GetUserData()).name.indexOf("bullet") == -1)
         {
            return true;
         }
         var _loc7_:Array = [];
         _loc7_[0] = _loc7_[1] = body.GetLocalPoint(param5);
         _loc7_[2] = 1;
         _loc7_[3] = BoxUtils.rotateVec(param6,-bodyAngle);
         this.bleeding.push(_loc7_);
         ud.triggered = true;
         return true;
      }
   }
}

