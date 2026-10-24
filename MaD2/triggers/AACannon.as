package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class AACannon extends Firearm
   {
      
      internal var whichBarrel:Number = -0.7;
      
      internal var shots:int = 0;
      
      public function AACannon(param1:b2Body)
      {
         super("AACannon",param1,3,100,20,100,"AA",0.4,1);
         burstAmount = 4;
         _burstDelay = 32;
         chamberTime = 8;
         magazineSize = 40;
         reloadTime = 120;
      }
      
      override public function shoot() : Boolean
      {
         if(super.shoot())
         {
            this.whichBarrel *= -1;
            datPos.y = this.whichBarrel;
            datPosFlipped.y = this.whichBarrel;
            return true;
         }
         return false;
      }
   }
}

