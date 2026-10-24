package triggers
{
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class DrawStage extends Trigger
   {
      
      private var posX:Number = 0;
      
      private var posY:Number = 0;
      
      private var scale:Number = 0.1;
      
      private var game:Bitmap;
      
      public function DrawStage()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         var _loc3_:Object = ud.ParseTriggerCustom();
         if(_loc3_["posX"])
         {
            this.posX = _loc3_["posX"];
         }
         if(_loc3_["posY"])
         {
            this.posY = _loc3_["posY"];
         }
         if(_loc3_["scale"])
         {
            this.scale = _loc3_["scale"];
         }
         this.game = new Bitmap(new BitmapData(GameState.width * this.scale * ud.size,GameState.height * this.scale * ud.size,false,0));
         ud.graphic.addChild(this.game);
         this.game.x = -this.game.width * 0.5 + this.posX * ud.size;
         this.game.y = -this.game.height * 0.5 + this.posY * ud.size;
         this.game.visible = false;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         this.game.bitmapData.draw(Main.instance.stage,new Matrix(this.scale * param2.size,0,0,this.scale * param2.size,0,0));
      }
      
      override public function onTrigger() : void
      {
         super.onTrigger();
         this.game.visible = true;
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         this.game.visible = false;
      }
   }
}

