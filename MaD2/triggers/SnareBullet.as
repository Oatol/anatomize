package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class SnareBullet extends GenericBullet
   {
      
      public function SnareBullet()
      {
         super("snare");
      }
      
      override protected function safeExplode() : void
      {
         super.safeExplode();
         ud.trigger = new Snare();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,"snare",bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.01,bodyVel.y * 0.01);
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.lineStyle(2,3758913);
         _loc3_.graphics.moveTo(GraphicUtils.camX(pixelCenter.x) + camPos.x,GraphicUtils.camY(pixelCenter.y) + camPos.y);
         _loc3_.graphics.lineTo(GraphicUtils.camX(pixelCenter.x + bodyVel.x) + camPos.x,GraphicUtils.camY(pixelCenter.y + bodyVel.y) + camPos.y);
         Main.instance.particlesBMD.draw(_loc3_);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.dead = true;
         var _loc7_:userData = userData(param1.GetUserData());
         if(_loc7_.resistSnare)
         {
            return true;
         }
         _loc7_.trigger = new Snare();
         _loc7_.triggerForce = 12;
         _loc7_.triggered = true;
         return true;
      }
   }
}

