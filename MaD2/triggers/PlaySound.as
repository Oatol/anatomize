package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PlaySound extends Trigger
   {
      
      internal var trigSfx:String;
      
      internal var trigVol:Number;
      
      internal var collSfx:String;
      
      internal var collVol:Number;
      
      public function PlaySound(param1:String, param2:Number = 1, param3:String = "", param4:Number = 1)
      {
         super();
         this.trigSfx = param1;
         this.trigVol = param2;
         this.collSfx = param3;
         this.collVol = param4;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(this.trigSfx != "")
         {
            sounds.play(this.trigSfx,body,bodyCenter,this.trigVol,false);
            ud.triggered = false;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:Number = NaN;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(this.collSfx != "")
         {
            _loc7_ = this.collVol;
            _loc7_ = _loc7_ * (param4 - ud.triggerCollide);
            if(_loc7_ > 2)
            {
               _loc7_ = 2;
            }
            if(_loc7_ < 0.5)
            {
               _loc7_ = 0.5;
            }
            sounds.play(this.collSfx,body,param5,_loc7_,false);
         }
         return true;
      }
   }
}

