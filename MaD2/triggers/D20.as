package triggers
{
   import Box2D.Collision.b2ContactPoint;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class D20 extends Trigger
   {
      
      private var tf:TextField;
      
      public function D20()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.tf = new TextField();
         this.tf.width = 64;
         this.tf.height = 64;
         var _loc3_:TextFormat = new TextFormat(Tweak.FONT);
         _loc3_.align = TextFormatAlign.CENTER;
         _loc3_.size = 24;
         _loc3_.color = 16777215;
         this.tf.defaultTextFormat = _loc3_;
         this.tf.setTextFormat(_loc3_);
         this.tf.filters = [new GlowFilter(0,1,4,4,10)];
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         this.tf.x = GraphicUtils.camX(pixelCenter.x) - 32;
         this.tf.y = GraphicUtils.camY(pixelCenter.y) - 16;
         Main.instance.particlesBMD.draw(this.tf,this.tf.transform.matrix);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
         }
         if(param2.triggerState == 1)
         {
            return;
         }
         var _loc3_:int = int(Math.random() * param2.triggerForce) + 1;
         this.tf.text = _loc3_.toString();
         if(bodyVel.Length() > 0.1 || param2.triggerDuration > 0)
         {
            return;
         }
         if(_loc3_ == param2.triggerForce)
         {
            for each(_loc4_ in param2.connected)
            {
               userData(_loc4_.GetUserData()).triggered = true;
            }
            param2.triggerDuration = 60;
         }
         param2.triggerState = 1;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         ud.triggered = true;
         return super.OnCollision(param1,param2,param3,param4,param5,param6);
      }
      
      override public function OnCollisionEnd(param1:b2Body, param2:b2ContactPoint) : void
      {
         ud.triggered = false;
         ud.triggerState = 0;
         super.OnCollisionEnd(param1,param2);
      }
   }
}

