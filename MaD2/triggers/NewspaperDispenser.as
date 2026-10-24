package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class NewspaperDispenser extends Trigger
   {
      
      public function NewspaperDispenser()
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
         var _loc3_:Item = O.getItem("newspaper");
         var _loc4_:String = GraphicUtils.scalehex(3355443,1 + Math.random() * 0.5 - 0.25).toString(16);
         var _loc5_:Array = [Properties.shapeDecor(_loc4_),Properties.shapeDecor(_loc4_),Properties.shapeDecor(_loc4_),Properties.shapeDecor(_loc4_),Properties.shapeDecor((Math.random() * 6710886).toString(16)),Properties.shapeDecor(_loc4_),GraphicUtils.scalehex(12961221,1 + Math.random() * 0.2 - 0.1).toString(16)];
         var _loc6_:b2Vec2 = param2.triggerPos.Copy();
         var _loc7_:b2Vec2 = BoxUtils.rotateVec(_loc6_,bodyAngle);
         _loc7_.x = Math.random() * 50 - 25;
         var _loc8_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc7_.x,pixelCenter.y + _loc7_.y);
         var _loc9_:b2Body = GameState.objects.spawnItem(_loc3_.vertices,[0.1],_loc3_.scale * param2.size,"newspaper",_loc8_.x,_loc8_.y,bodyAngle,_loc5_);
         var _loc10_:b2Vec2 = new b2Vec2(_loc8_.x - pixelCenter.x,_loc8_.y - pixelCenter.y);
         _loc10_.Multiply(param2.triggerForce);
         _loc9_.ApplyForce(_loc10_,_loc9_.GetWorldCenter());
      }
   }
}

