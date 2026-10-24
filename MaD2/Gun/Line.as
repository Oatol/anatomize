package Gun
{
   import Box2D.Common.Math.b2Vec2;
   
   public class Line
   {
      
      private var _start:b2Vec2;
      
      private var _end:b2Vec2;
      
      public function Line(param1:b2Vec2, param2:b2Vec2)
      {
         super();
         this._start = new b2Vec2(param1.x,param1.y);
         this._end = new b2Vec2(param2.x,param2.y);
      }
      
      public function get start() : b2Vec2
      {
         return this._start;
      }
      
      public function set start(param1:b2Vec2) : void
      {
         this._start = param1;
      }
      
      public function get end() : b2Vec2
      {
         return this._end;
      }
      
      public function set end(param1:b2Vec2) : void
      {
         this._end = param1;
      }
      
      public function get p1() : b2Vec2
      {
         return this._start;
      }
      
      public function get p2() : b2Vec2
      {
         return this._end;
      }
   }
}

