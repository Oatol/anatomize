package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   
   public class BleachAmmoniaBullet extends GenericBullet
   {
      
      public function BleachAmmoniaBullet()
      {
         super("gas");
         trail = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param1.IsSleeping())
         {
            param2.dead = true;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc8_:BitmapData = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.projectile = false;
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_ || !_loc7_.trigger)
         {
            if(_loc7_.name == "wall" || Math.random() > 0.5)
            {
               ud.dead = true;
            }
            return false;
         }
         if(ud.triggerState == 0)
         {
            _loc8_ = BoxUtils.getEffectBMD(param1);
            if(_loc8_)
            {
               _loc8_.colorTransform(_loc8_.rect,new ColorTransform(1,1,1,0.7));
            }
            Body.Damage(param1,2,param5,null,null,false);
         }
         else
         {
            Body.Damage(param1,6,param5,null,null,false);
         }
         if(_loc7_.trigger is BleachAmmoniaBullet && _loc7_.triggerState != ud.triggerState)
         {
            _loc7_.dead = true;
            ud.trigger = new PhosphorusGas(0.5);
            ud.triggerRadius = 50;
            ud.triggerForce = 500;
            ud.triggerLock = false;
            ud.triggered = true;
            ud.triggerLock = true;
         }
         else if(Math.random() > 0.8)
         {
            ud.dead = true;
         }
         return true;
      }
   }
}

