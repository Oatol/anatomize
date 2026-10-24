package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Scroll extends Trigger
   {
      
      public function Scroll()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:Array = ["ass","aut","bck","bea","bee","bla","bss","bubble","can","car","cry","dea","dec","dev","dra","fla","fli","flm","flr","gas","glue","las","lig","med","min","noi","pis","pnt","poi","pot","pulse","rif","smg","sna","sni","spi","tas","tox","tra","twi","voi","wat","win"];
         var _loc4_:String = _loc3_[Math.random() * _loc3_.length >> 0];
         var _loc5_:int = triggerForce;
         var _loc6_:int = int(12 + Math.random() * 36);
         var _loc7_:b2Vec2 = new b2Vec2(0,0);
         var _loc8_:Number = Math.random() * triggerRadius;
         if(_loc5_ > 24)
         {
            _loc5_ = 24;
         }
         var _loc11_:b2Body = Physics.world.GetGroundBody();
         var _loc12_:int = 0;
         while(_loc12_ < _loc5_)
         {
            _loc9_ = Math.random() * _loc8_ * 2 - _loc8_;
            _loc10_ = Math.random() * _loc8_ * 2 - _loc8_;
            _loc9_ /= Physics.scale;
            _loc10_ /= Physics.scale;
            GameState.objects.addbullet(_loc4_,bodyCenter.x + _loc9_,bodyCenter.y + _loc10_,0,1,1,_loc7_,_loc6_,_loc11_);
            _loc12_++;
         }
         param2.dead = true;
         Body.Disintegrate(param1,"poof");
      }
   }
}

