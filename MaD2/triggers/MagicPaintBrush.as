package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class MagicPaintBrush extends Trigger
   {
      
      public function MagicPaintBrush()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:userData = null;
         var _loc8_:Sprite = null;
         var _loc9_:String = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return true;
         }
         if(param3.name != "b7a756")
         {
            return true;
         }
         _loc7_ = userData(param1.GetUserData());
         if(_loc7_.hasBeenCut)
         {
            return true;
         }
         if(ud.connected.length == 0)
         {
            _loc9_ = O.names[int(Math.random() * O.names.length)];
         }
         else
         {
            _loc9_ = userData(ud.connected[int(Math.random() * ud.connected.length)].GetUserData()).itemName;
         }
         _loc8_ = O.getItem(_loc9_).updateGraphic();
         if(Sprite(_loc7_.graphic.getChildByName("decals")).getChildByName("magic"))
         {
            return true;
         }
         _loc8_.name = "magic";
         _loc8_.x = 0;
         _loc8_.y = 0;
         Sprite(_loc7_.graphic.getChildByName("decals")).addChild(_loc8_);
         _loc7_.graphic.getChildByName("item").alpha = 0;
         GraphicUtils.addGraphicToLayer(_loc7_);
         return true;
      }
   }
}

