package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   
   public class Island extends Environment
   {
      
      private var islandColour:uint;
      
      private var randomColour:uint;
      
      public function Island()
      {
         _loadContent = Base64.compress("mutilate=2;environmentContent=1|NM=water,PX=-50,PY=380,AN=180,SZ=4,DN=0,TM=37,LR=2,ghost=1,stainless=1;NM=vine,PX=367,PY=426,SZ=3.3526,DN=0,TM=37,LR=1,ghost=1,unbreakable=1,flipped=1;NM=banana,PX=640,PY=500,AN=203,SZ=6,DN=0,TM=37,LR=1,ghost=1,flipped=1;NM=banana,PX=530,PY=487,AN=83,SZ=6,DN=0,TM=37,LR=1,ghost=1,flipped=1;NM=banana,PX=469,PY=502,AN=156,SZ=6,DN=0,TM=37,LR=1,ghost=1;NM=treetrunk,PX=680,PY=660,AN=90,SZ=8,DN=0,TM=37,LR=1;NM=potato,PX=223,PY=523,AN=92,SZ=6,DN=0,TM=37,LR=1,unbreakable=1;NM=potato,PX=301,PY=539,AN=90,SZ=3.7194,DN=0,TM=37,LR=1;NM=anchor,PX=669,PY=488,AN=-18,SZ=1.2989000000000002,DN=0,TM=37,LR=1,ghost=1,flipped=1;NM=vine,PX=708,PY=366,SZ=5.2436,DN=0,TM=37,LR=1,ghost=1,unbreakable=1,flipped=1;NM=bushy,PX=577,PY=546,DN=0,TM=37,LR=1,ghost=1;NM=vine,PX=931,PY=437,SZ=3.3526,DN=0,TM=37,LR=1,ghost=1,unbreakable=1,flipped=1;NM=simpletrapezoid,PX=-324,PY=442,AN=180,SZ=4.35496574078398,DN=0,TM=37,LR=0,ghost=1,unbreakable=1;NM=treetrunk,PX=-450,PY=660,AN=90,SZ=8,DN=0,TM=37,LR=1;NM=stalagmite,PX=-51,PY=560,AN=-63,SZ=4,DN=0,TM=37,LR=1,unbreakable=1;NM=bushy,PX=93,PY=539,SZ=0.9999999999999996,DN=0,TM=37,LR=1,ghost=1;NM=snowpile2,PX=-286,PY=73,SZ=3.4374736842105262,DN=0,TM=37,LR=1,flipped=1;NM=palmtree,PX=-233,PY=-438,AN=9,SZ=1.5257999999999998,DN=0,TM=37,LR=1,ghost=1;NM=snowpile2,PX=-255,PY=-70,SZ=1.8283999999999996,DN=0,TM=37,LR=1|||ID=0,SKIN=7777771065C7;ID=2,SKIN=30320C01495C.252609044366.CECB31034B6E;ID=3,SKIN=30320C01495C.252609044366.CECB31034B6E;ID=4,SKIN=30320C01495C.252609044366.CECB31034B6E;ID=5,SKIN=77777702384E.33261E122C4C.372B23122c4c.5B3D2B122c4c;ID=6,SKIN=6C2C0E064472;ID=7,SKIN=6C2C0E04496F;ID=10,SKIN=3E5B251C4E4B.4E5E17044C6D.3F6018005558;ID=12,SKIN=77777702384E;ID=13,SKIN=77777702384E.33261E122C4C.372B23122c4c.5B3D2B122c4c;ID=14,SKIN=77777702384E.33261E122C4C.372B23122c4c;ID=15,SKIN=3E5B251C4E4B.4E5E17044C6D.3F6018005558;ID=16,SKIN=DFEFF504466B.EAF0F1014253.D8EDF401465D;ID=18,SKIN=D8EDF4614A01.EAF0F13A5903.DFEFF56C665F|||");
         super(GameState.width,GameState.height);
         spawnHeight = 900;
         spawnX = -184;
         _name = "island";
         enableClutter = false;
         enableFiller = false;
         enableParticles = false;
         enableSeed = false;
         enableWalls = false;
         enableBackground = false;
         gravity = 20;
         wind = 0;
         temperature = 35;
         _borderLeft = -2800;
         _borderRight = 2800;
         _backgroundColour = 5228527;
         this.islandColour = 12299089;
         _wallColour = 41983;
         _background = new BitmapData(_width,_height,false);
         _scrollBG = false;
         _walls = false;
         _wallL = false;
         _wallR = false;
         _roof = false;
         _floor = false;
         filler = false;
         autoPan = true;
         autoPanOffset = new b2Vec2(50,-950);
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         if(_background)
         {
            _background.fillRect(_background.rect,_backgroundColour);
         }
         Main.instance.stage.color = _backgroundColour;
         Main.instance.CameraHome();
      }
      
      override public function update() : void
      {
         super.update();
         var _loc1_:b2Body = Physics.world.GetBodyList();
         while(_loc1_)
         {
            if(_loc1_ != Physics.world.GetGroundBody())
            {
               if(defaultBodies.indexOf(_loc1_) == -1)
               {
                  if(_loc1_.GetPosition().y * Physics.scale > -1)
                  {
                     _loc1_.GetLinearVelocity().Multiply(1 - 0.05 * TimeLord.speed);
                     _loc1_.SetAngularVelocity(_loc1_.GetAngularVelocity() * (1 - 0.05 * TimeLord.speed));
                     _loc1_.ApplyForce(new b2Vec2(0,-gravity * 0.3 * _loc1_.GetMass()),_loc1_.GetWorldCenter());
                  }
               }
            }
            _loc1_ = _loc1_.GetNext();
         }
      }
   }
}

