package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXHorizontalPingPong extends ParticleEffect
   {
      
      internal var left:Number;
      
      internal var right:Number;
      
      internal var pos:Vector.<b2Vec2>;
      
      internal var looper:Number = 0;
      
      internal var loopdir:Number = 4;
      
      public function PFXHorizontalPingPong(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         this.init();
      }
      
      override protected function init() : void
      {
         this.pos = new Vector.<b2Vec2>();
         this.left = -ud.width * 0.5;
         this.right = ud.width;
      }
      
      override public function update() : void
      {
         super.update();
         this.looper += this.loopdir * speed;
         if(this.looper > 100 || this.looper < 0)
         {
            this.loopdir *= -1;
         }
         var _loc1_:Number = body.GetPosition().x * Physics.scale;
         var _loc2_:Number = body.GetPosition().y * Physics.scale;
         var _loc3_:Number = body.GetAngle();
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(this.left * size,0),_loc3_);
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(this.right * size,0),_loc3_);
         addParticles(_loc1_ + _loc4_.x + this.looper * 0.01 * _loc5_.x,_loc2_ + _loc4_.y + this.looper * 0.01 * _loc5_.y,1,"sparkle",0,0,1,1);
      }
   }
}

