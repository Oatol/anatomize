package triggers
{
   import Box2D.Collision.b2ContactPoint;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class SayRandomLine extends Trigger
   {
      
      internal var lines:Array = [];
      
      private var tf:TextField;
      
      public function SayRandomLine()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.tf = new TextField();
         this.tf.width = 300;
         this.tf.height = 64;
         var _loc3_:TextFormat = new TextFormat(Tweak.FONT);
         _loc3_.align = TextFormatAlign.CENTER;
         _loc3_.size = 16;
         _loc3_.color = 16777215;
         this.tf.defaultTextFormat = _loc3_;
         this.tf.setTextFormat(_loc3_);
         this.tf.filters = [new GlowFilter(0,1,4,4,10)];
         this.lines = ud.triggerCustom.split(";");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         this.tf.x = GraphicUtils.camX(pixelCenter.x) - this.tf.width * 0.5;
         Main.instance.particlesBMD.draw(this.tf,this.tf.transform.matrix);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
         }
         else
         {
            this.tf.y = GraphicUtils.camY(pixelCenter.y) - 50;
         }
         var _loc3_:Number = 100;
         if(param2.triggerForce)
         {
            _loc3_ = param2.triggerForce;
         }
         if(bodyVel.Length() > _loc3_)
         {
            param2.triggerState = 0;
         }
         if(param2.triggerState == 1)
         {
            return;
         }
         if(bodyVel.Length() > 1 || param2.triggerDuration > 0)
         {
            this.tf.text = "";
            return;
         }
         var _loc4_:int = int(Math.random() * this.lines.length);
         var _loc5_:String = this.lines[_loc4_];
         if(Math.random() > 0.9)
         {
            _loc5_ = _loc5_.replace(".","...!");
         }
         else if(Math.random() > 0.9)
         {
            _loc5_ = _loc5_.replace(".","...?");
         }
         else if(Math.random() > 0.9)
         {
            _loc5_ = _loc5_.replace(".","?");
         }
         else if(Math.random() > 0.9)
         {
            _loc5_ = _loc5_.replace(".","...");
         }
         else if(Math.random() > 0.9)
         {
            _loc5_ = _loc5_.replace(".","!");
         }
         this.tf.text = _loc5_;
         this.tf.y = GraphicUtils.camY(pixelCenter.y);
         this.tf.scaleX = this.tf.scaleY = 0.01;
         Tweener.addTween(this.tf,{
            "y":GraphicUtils.camY(pixelCenter.y) - 50,
            "scaleX":1,
            "scaleY":1,
            "time":0.5 / TimeLord.timerSpeed,
            "transition":"easeInBack"
         });
         param2.triggerDuration = 30;
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

