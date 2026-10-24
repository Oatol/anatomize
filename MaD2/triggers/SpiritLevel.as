package triggers
{
   import Box2D.Dynamics.b2Body;
   import flash.text.TextField;
   
   public class SpiritLevel extends Trigger
   {
      
      private var tf:TextField;
      
      public function SpiritLevel()
      {
         super();
         this.tf = new TextField();
         if(GraphicUtils.hexBrightness(GameState.environment.backgroundColour) < 18000)
         {
            this.tf.textColor = 15658734;
         }
         else
         {
            this.tf.textColor = 1118481;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         this.tf.text = ((bodyAngle * Vars.toDegrees >> 0) % 360).toString() + "°";
         this.tf.x = GraphicUtils.camX(pixelCenter.x) + camPos.x;
         this.tf.y = GraphicUtils.camY(pixelCenter.y - 30) + camPos.y;
         Main.instance.particlesBMD.draw(this.tf,this.tf.transform.matrix);
      }
   }
}

