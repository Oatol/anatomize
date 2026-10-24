package triggers
{
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BloodDrop extends Trigger
   {
      
      private var BMD:BitmapData;
      
      private var blood:BitmapData;
      
      private var rect:Rectangle;
      
      public function BloodDrop()
      {
         super();
         if(World.toggleSmoothBlood == 0)
         {
            this.blood = R.getSprite("p_blood");
            this.BMD = Main.instance.particlesBMD;
         }
         else
         {
            if(!R.getSprite("smooth_blood_" + Tweak.bloodColour))
            {
               R.setSprite("smooth_blood_" + Tweak.bloodColour,Main.instance.updateSmoothBloodBMD(Tweak.bloodColour).clone());
            }
            this.blood = R.getSprite("smooth_blood_" + Tweak.bloodColour);
            this.BMD = Main.instance.bloodBMD;
         }
         this.rect = new Rectangle(0,0,this.blood.width,this.blood.height);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param2.triggerDuration += 1;
         if(bodyVel.Length() < 0.5 && param2.triggerDuration > 60 || param2.triggerDuration > 240)
         {
            param2.dead = true;
            return;
         }
         if(bodyVel.Length() > 1)
         {
            this.BMD.copyPixels(this.blood,this.rect,new Point(GraphicUtils.camX(pixelCenter.x) - this.rect.width * 0.5 + camPos.x,GraphicUtils.camY(pixelCenter.y) - this.rect.height * 0.5 + camPos.y),null,null,true);
         }
      }
   }
}

