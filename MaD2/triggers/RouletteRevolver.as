package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   import com.anegmetex.Soundmanager.sounds;
   
   public class RouletteRevolver extends Firearm
   {
      
      internal var current:int = 0;
      
      internal var currentBullet:int = -1;
      
      internal var shots:int = 0;
      
      public function RouletteRevolver(param1:b2Body)
      {
         super("rouletterevolver",param1,60,300,20,10,"pis",0.8,1);
         this.currentBullet = Math.random() * 6 >> 0;
         userData(body.GetUserData()).triggerCustom = this.currentBullet.toString() + ":" + this.current;
         gun.customFunc = this.onCustom;
      }
      
      override public function shoot() : Boolean
      {
         var _loc1_:b2Vec2 = null;
         if(!readyToFire)
         {
            return false;
         }
         if(this.currentBullet == -1)
         {
            this.currentBullet = Math.random() * 6 >> 0;
         }
         userData(body.GetUserData()).triggered = false;
         if(this.currentBullet == this.current)
         {
            _reloadTime = 80;
            reloadDone = 0;
            if(super.shoot())
            {
               this.current = 0;
               this.currentBullet = -1;
               _loc1_ = body.GetWorldCenter().Copy();
               _loc1_.Multiply(Physics.scale);
               GameState.particles.addParticles(_loc1_.x,_loc1_.y,1,"currentBullet",0,0,Math.random() * 4,Math.random() * 4);
               return true;
            }
         }
         else
         {
            _readyToFire = false;
            _reloadTime = 30;
            reloadDone = 0;
            ++this.current;
            sounds.play("launch",body,_loc1_,0.5);
         }
         userData(body.GetUserData()).triggerCustom = this.currentBullet.toString() + ":" + this.current;
         return false;
      }
      
      internal function onCustom() : void
      {
         var _loc1_:Array = String(userData(body.GetUserData()).triggerCustom).split(":");
         this.currentBullet = int(_loc1_[0]);
         this.current = int(_loc1_[1]);
      }
   }
}

