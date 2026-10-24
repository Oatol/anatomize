package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class DroneLauncher extends Firearm
   {
      
      public var drone:int = 0;
      
      public var drones:Vector.<b2Body>;
      
      public function DroneLauncher(param1:b2Body)
      {
         super("dronelauncher",param1,120,60,200,5,"drone",1,1);
         this.drones = new Vector.<b2Body>();
      }
      
      override public function shoot() : Boolean
      {
         var _loc1_:userData = null;
         if(super.shoot())
         {
            if(this.drones.length > 3)
            {
               _loc1_ = userData(this.drones[0].GetUserData());
               if(!_loc1_.dead)
               {
                  _loc1_.trigger = new TempProjectile();
                  _loc1_.triggered = true;
               }
               this.drones.shift();
            }
            return true;
         }
         return false;
      }
   }
}

