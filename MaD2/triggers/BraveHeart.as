package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BraveHeart extends Trigger
   {
      
      internal var attachedBody:b2Body;
      
      public function BraveHeart()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         if(!this.attachedBody)
         {
            return;
         }
         if(Math.random() < 0.9)
         {
            return;
         }
         var _loc3_:Array = BoxUtils.selectCompound(this.attachedBody);
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = userData(_loc5_.GetUserData());
            if(_loc4_.burning)
            {
               if(!ud.triggerForce)
               {
                  ud.triggerForce = 250;
               }
               _loc4_.health += ud.triggerForce;
            }
            else
            {
               _loc4_.temperature += Math.random() * 10;
            }
         }
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         var _loc3_:b2Body = null;
         this.attachedBody = param1;
         for each(_loc3_ in BoxUtils.selectCompound(this.attachedBody))
         {
            userData(_loc3_.GetUserData()).resistConcuss = true;
         }
         return super.OnJoint(param1,param2);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!param3.sharp)
         {
            return true;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         _loc7_.ignition = 100;
         _loc7_.temperature += 50;
         _loc7_.conductivity = 0.01;
         return true;
      }
   }
}

