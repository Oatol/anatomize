package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class ChiliPepper extends Trigger
   {
      
      public function ChiliPepper()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return true;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_.alive)
         {
            return true;
         }
         if(!_loc7_ || _loc7_.resistFlame)
         {
            return true;
         }
         if(!(_loc7_.trigger is Napalmed))
         {
            _loc7_.trigger = new Napalmed();
            _loc7_.triggerDuration = 300;
            _loc7_.triggered = true;
            sounds.play("incendiary",body,pixelCenter,1,false);
         }
         return true;
      }
   }
}

