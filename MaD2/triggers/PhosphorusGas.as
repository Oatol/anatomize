package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PhosphorusGas extends Trigger
   {
      
      internal var effectMultiplier:Number = 1;
      
      public function PhosphorusGas(param1:Number = 1)
      {
         super();
         this.effectMultiplier = param1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         var _loc6_:Number = NaN;
         var _loc7_:BitmapData = null;
         var _loc8_:int = 0;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            if(_loc5_.alive)
            {
               _loc6_ = triggerForce * param2.size / BoxUtils.vectorDist(bodyCenter,_loc4_.GetPosition());
               Body.Damage(_loc4_,_loc6_,new b2Vec2(Math.random() * _loc4_.GetUserData().width * 1 / Physics.scale + _loc4_.GetPosition().x,Math.random() * _loc4_.GetUserData().height * 1 / Physics.scale + _loc4_.GetPosition().y),new b2Vec2(),new b2Vec2(1,1));
               _loc6_ *= this.effectMultiplier;
               _loc7_ = BoxUtils.getEffectBMD(_loc4_);
               if(_loc7_)
               {
                  _loc7_.lock();
                  _loc8_ = 0;
                  while(_loc8_ < (_loc6_ < 20 ? _loc6_ : 20))
                  {
                     _loc7_.copyPixels(R.getSprite("p_smoothblood"),new Rectangle(0,0,8,8),new Point(Math.random() * (_loc4_.GetUserData().width + 10) - 5,Math.random() * (_loc4_.GetUserData().height + 10) - 5),null,null,true);
                     _loc8_++;
                  }
                  _loc7_.unlock();
               }
            }
         }
         Body.Destroy(param1,"triggered");
         sounds.play("acidburn",param1,pixelCenter);
      }
   }
}

