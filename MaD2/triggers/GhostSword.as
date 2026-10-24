package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GhostSword extends Trigger
   {
      
      public function GhostSword()
      {
         super();
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
         if(param3.name != "ff0000")
         {
            return true;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_ || _loc7_.dead)
         {
            return true;
         }
         if(_loc7_.ghost)
         {
            _loc7_.trigger = new Disintegrate("bigSmoke",20,12);
            _loc7_.triggered = true;
         }
         return true;
      }
   }
}

