package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class VirtualTrigger extends Trigger
   {
      
      internal var stickSprite:Sprite = new Sprite();
      
      internal var col:uint;
      
      public function VirtualTrigger()
      {
         super();
      }
      
      override public function onTrigger() : void
      {
         super.onTrigger();
         bodyCenter = body.GetWorldCenter().Copy();
         pixelCenter = new b2Vec2(bodyCenter.x * Physics.scale,bodyCenter.y * Physics.scale);
         ud.triggerPos = pixelCenter;
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.col = BoxUtils.getSkinColour(param2.skin,"62646a");
         if(this.col == 16711935)
         {
            this.col = 6448234;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         if(triggerPos == null || triggerPos.x == 0 && triggerPos.y == 0)
         {
            param2.triggerPos = pixelCenter.Copy();
            updateTriggerHelpers();
         }
         var _loc3_:b2Vec2 = triggerPos.Copy();
         _loc3_.Subtract(pixelCenter);
         this.stickSprite.graphics.clear();
         this.stickSprite.graphics.lineStyle(2 * GraphicUtils.cam.scaleX,this.col);
         this.stickSprite.graphics.drawCircle(GraphicUtils.camX(triggerPos.x),GraphicUtils.camY(triggerPos.y),triggerRadius * GraphicUtils.cam.scaleX);
         this.stickSprite.graphics.lineStyle(4 * GraphicUtils.cam.scaleX,this.col,0.5);
         this.stickSprite.graphics.moveTo(GraphicUtils.camX(triggerPos.x),GraphicUtils.camY(triggerPos.y));
         this.stickSprite.graphics.lineTo(GraphicUtils.camX(pixelCenter.x),GraphicUtils.camY(pixelCenter.y));
         Main.instance.particlesBMD.draw(this.stickSprite);
         param1.SetAngularVelocity(param1.GetAngularVelocity() * 0.5);
         param1.ApplyTorque(-bodyAngle * 10);
         param1.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.8,bodyVel.y * 0.8));
         param1.ApplyForce(_loc3_,bodyCenter);
         param1.ApplyForce(new b2Vec2(0,-Vars.gravity * param1.GetMass()),param1.GetWorldCenter());
         if(_loc3_.Length() < triggerRadius)
         {
            return;
         }
         for each(_loc4_ in param2.connected)
         {
            userData(_loc4_.GetUserData()).triggered = true;
         }
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         ud.triggerPos = null;
      }
   }
}

