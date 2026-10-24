package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   
   public class Bubble extends GenericBullet
   {
      
      public function Bubble()
      {
         super("bubbles");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:Number = 100;
         var _loc4_:b2Vec2 = new b2Vec2(Math.random() * _loc3_ - _loc3_ * 0.5,Math.random() * _loc3_ - _loc3_ * 0.5 - 2);
         _loc4_.Multiply(param1.GetMass());
         param1.ApplyForce(_loc4_,bodyCenter);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         param1.WakeUp();
         var _loc7_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc7_)
         {
            _loc7_.colorTransform(_loc7_.rect,new ColorTransform(1,1,1,0.7));
         }
         return true;
      }
   }
}

