package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class DronerBullet extends GenericBullet
   {
      
      public function DronerBullet()
      {
         super("drone");
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.dead = true;
         var _loc7_:userData = param1.GetUserData() as userData;
         if(_loc7_.resistDroning)
         {
            return true;
         }
         if(_loc7_.trigger is DronerBullet)
         {
            return false;
         }
         var _loc8_:Array = [DroneClean,DroneExplosive,DroneLaser,DroneHammer,DroneRocket,DroneToxic,DronePin,DronePaint];
         var _loc9_:Class = getDefinitionByName(getQualifiedClassName(_loc8_[_loc8_.length * Math.random() >> 0])) as Class;
         _loc7_.trigger = new _loc9_();
         _loc7_.triggered = true;
         _loc7_.triggerRadius = 100;
         _loc7_.triggerDuration = 50;
         return true;
      }
   }
}

