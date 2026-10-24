package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerRandom extends Power
   {
      
      internal var bullets:Array = ["ass","aut","bck","bea","bee","bla","bss","bubble","can","car","cry","dea","dec","dev","dra","fla","fli","flm","flr","gas","glue","las","lig","med","min","noi","pis","pnt","poi","pot","pulse","rif","smg","sna","sni","spi","tas","tox","tra","twi","voi","wat","win"];
      
      public function PowerRandom()
      {
         super(Tool.RANDOM);
         throwBullet = this.bullets[Math.random() * this.bullets.length >> 0];
         noPressRadius = true;
      }
      
      override protected function OnProjectileThrow(param1:b2Vec2, param2:b2Vec2) : void
      {
         throwBullet = this.bullets[Math.random() * this.bullets.length >> 0];
         super.OnProjectileThrow(param1,param2);
      }
   }
}

