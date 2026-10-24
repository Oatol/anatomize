package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class SportsBall extends Transmute
   {
      
      public function SportsBall()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         var _loc3_:Array = ["football","baseball","basketball","beachball","bowlingball","actualfootball","frisbee","netball","pingpongball","shuttlecock"];
         item = _loc3_[_loc3_.length * Math.random() >> 0];
      }
   }
}

