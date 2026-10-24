package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Coinbox extends Trigger
   {
      
      internal var value:int = 0;
      
      internal var shiny:Array = ["moneypack","diamond","moneysack","goldbar","crystal"];
      
      public function Coinbox()
      {
         super();
      }
      
      override public function OnLoadCustom() : void
      {
         if(ud.triggerCustom)
         {
            this.value = int(ud.triggerCustom);
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_ || _loc7_.dead)
         {
            return false;
         }
         if(this.shiny.indexOf(_loc7_.name) == -1)
         {
            return false;
         }
         if(this.value > 8)
         {
            return false;
         }
         _loc7_.dead = true;
         ++this.value;
         ud.triggerCustom = this.value.toString();
         sounds.play("ching");
         return true;
      }
      
      override public function OnCut() : Boolean
      {
         var _loc2_:b2Body = null;
         super.trigger(body,ud);
         if(this.value == 0)
         {
            return false;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.value)
         {
            _loc2_ = GameState.objects.spawnObject(this.shiny[Math.random() * this.shiny.length >> 0],pixelCenter.x + Math.random() * 20 - 10,pixelCenter.y + Math.random() * 20 - 10,0,false,true);
            if(_loc2_)
            {
               userData(_loc2_.GetUserData()).ignore = "coinbox";
            }
            _loc1_++;
         }
         this.value = 0;
         ud.triggerCustom = this.value.toString();
         sounds.play("ching");
         ud.trigger = null;
         ud.dead = true;
         return true;
      }
   }
}

