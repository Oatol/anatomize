package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class SoulBow extends Firearm
   {
      
      internal var whichBarrel:Number;
      
      internal var shots:int = 0;
      
      public function SoulBow(param1:b2Body)
      {
         super("AACannon",param1,3,10,20,10,"soularr",1,1);
         this.whichBarrel = -2 * userData(body.GetUserData()).size;
      }
      
      override public function shoot() : Boolean
      {
         if(super.shoot())
         {
            this.whichBarrel += 1 * userData(body.GetUserData()).size;
            datPos.y = this.whichBarrel;
            datPosFlipped.y = this.whichBarrel;
            ++this.shots;
            if(this.shots >= 1)
            {
               this.shots = 0;
               reloadTime = 60;
               reloadDone = 0;
               userData(body.GetUserData()).triggered = false;
               this.whichBarrel = -2 * userData(body.GetUserData()).size;
            }
            else
            {
               reloadTime = 5;
               userData(body.GetUserData()).triggered = true;
            }
            return true;
         }
         return false;
      }
   }
}

