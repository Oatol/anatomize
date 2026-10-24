package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Mailbox extends Trigger
   {
      
      internal var value:int = 0;
      
      internal var shiny:Array = ["mail"];
      
      public function Mailbox()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(this.value > 0)
         {
            --this.value;
            this.spawn();
         }
         ud.triggered = false;
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
         return true;
      }
      
      override public function OnCut() : Boolean
      {
         super.trigger(body,ud);
         if(this.value == 0)
         {
            return false;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.value)
         {
            this.spawn();
            _loc1_++;
         }
         this.value = 0;
         ud.triggerCustom = this.value.toString();
         sounds.play("swish");
         return true;
      }
      
      private function spawn() : void
      {
         var _loc1_:b2Vec2 = ud.triggerPos.Copy();
         if(ud.flipped)
         {
            _loc1_.x *= -1;
         }
         var _loc2_:b2Vec2 = BoxUtils.rotateVec(_loc1_,bodyAngle);
         var _loc3_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc2_.x,pixelCenter.y + _loc2_.y);
         var _loc4_:b2Body = GameState.objects.spawnObject(this.shiny[Math.random() * this.shiny.length >> 0],_loc3_.x,_loc3_.y,0,false,true);
      }
   }
}

