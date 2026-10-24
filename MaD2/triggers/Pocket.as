package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Pocket extends Pokeball
   {
      
      public function Pocket()
      {
         super();
      }
      
      override public function OnLoadCustom() : void
      {
         if(ud.triggerCustom)
         {
            pokemon = ud.triggerCustom;
         }
         if(ud.graphic)
         {
            ud.graphic.getChildByName("decals").alpha = pokemon == "empty" ? 0 : 1;
         }
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         if(!param2.triggerCustom)
         {
            pokemon = "moneypack";
            param2.triggerCustom = pokemon;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(ud.graphic)
         {
            ud.graphic.getChildByName("decals").alpha = 0;
         }
         radius = 100;
         ud.triggered = false;
         ud.triggerLock = true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(ud.graphic)
         {
            ud.graphic.getChildByName("decals").alpha = 1;
         }
         ud.triggerLock = false;
         return true;
      }
   }
}

