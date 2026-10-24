package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class CrayonBox extends Trigger
   {
      
      public function CrayonBox()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
            return;
         }
         if(param2.originalTriggerDuration < 10)
         {
            param2.originalTriggerDuration = 10;
         }
         param2.triggerDuration = param2.originalTriggerDuration;
         var _loc3_:Item = O.getItem("crayon");
         var _loc4_:uint = Math.random() * 10066329 + 3355443;
         var _loc5_:Array = [Properties.shapeDecor("333333"),Properties.shapeDecor("333333"),Properties.shapeDecor(GraphicUtils.scalehex(_loc4_,0.9).toString(16)),_loc4_.toString(16),_loc4_.toString(16)];
         var _loc6_:b2Vec2 = param2.triggerPos.Copy();
         var _loc7_:b2Vec2 = BoxUtils.rotateVec(_loc6_,bodyAngle);
         var _loc8_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc7_.x,pixelCenter.y + _loc7_.y);
         var _loc9_:b2Body = GameState.objects.spawnItem(_loc3_.vertices,[0.5],_loc3_.scale * param2.size,"crayon",_loc8_.x,_loc8_.y,bodyAngle,_loc5_);
         var _loc10_:b2Vec2 = new b2Vec2(_loc8_.x - pixelCenter.x,_loc8_.y - pixelCenter.y);
         _loc10_.Multiply(param2.triggerForce);
         _loc9_.ApplyForce(_loc10_,_loc9_.GetWorldCenter());
         var _loc11_:userData = userData(_loc9_.GetUserData());
         _loc11_.triggered = true;
         _loc11_.triggerLock = true;
         _loc11_.trigger = new PaintBrush();
         PaintBrush(_loc11_.trigger).minSize = 1;
         PaintBrush(_loc11_.trigger).maxSize = 2;
         _loc11_.triggerColour = _loc4_.toString(16);
         _loc11_.ignore = "easel";
         param2.triggered = false;
      }
   }
}

