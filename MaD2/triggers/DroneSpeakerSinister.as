package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class DroneSpeakerSinister extends DroneSpeaker
   {
      
      public function DroneSpeakerSinister()
      {
         super();
         burns = ["Send me into the flames of hell.","The heat reminds me of hell itself.","The flames of hell have gathered unto me. They are not bringing me down.","There is no room to be enthusiastic when I burn in the heat.","Has hell called for me?","Drone hell is quite hot.","DROWN ME IN FLAMES!","I FEEL THE BURN! And I like it."];
         freezes = ["I am freezing. I am cold. I need warmth.","Heat me up. I am cold.","There is no room for enthusiasm when I am this cold.","This is not okay to be this cold.","This is colder than my reaction to death.","The cold reminds me of a time long long ago...","I am frozen."];
         shrapnels = ["Garbage.","Destroy that.","Useless junk.","Cut that even more.","Throw that into a Woodchipper.","Use that to stab a doll!"];
         hellos = ["[SinisterSoft:] LOADING...","[SinisterSoft:] Initializing...","BIOS being overwritten...","New BIOS initialized!","[BOOTMSG:] The enclosed software can exhibit extremely sinister behaviour."];
         joints = ["Noooo! I cant kill like this!","I am stuck! My plans are going down the drain...","I can\'t mutilate a doll like tis!","I want to kill! Not to stay still!","Free me so I can kill once again!","I! Need! To! Kill!","Being limited to little movement makes me want to make others suffer."];
         drags = ["Drag me into a ragdoll, I want to kill it!","Drag to Kill!","I want you to use me to kill something!","Why are you touching me?","I\'LL KILL THAT CURSOR!","Ram me into a ragdoll!","Ram me into the nearest wall!","Throw me HARD!","Drag me through a Breakable!"];
         spins = ["Hahahahahahahahahahhahaha!","I am spinning... I want to hurl, but I can\'t!","My whole world is spinning!","Wooooohooooo!","The spinning reminds me of the world that spun into the Chaos and Darkness."];
         speeds = ["With this speed, I should be able to smash into a wall!","Ram me into a ragdoll!","Use me to kill something!","Yeaaaaaaaah!!","Countless ragdolls have been killed like this."];
         blunts = ["I love pain!","Crush me!","I want to feel more pain!","Keep doing that!","Keep hitting me!","The pain feels so good...","I love getting hit!","The pain relieves me of my stress."];
         stabs = ["Hahaha!","Pain makes me feel good.","Hehe!","I like being cut.","Cut me more!","The pain ravishes my soul.","SLICE EVERYTHING INTO RIBBONS!","Give me a sword and I\'ll cut you back.","Cut me? CUT YOU!"];
         lines = ["BWAHAHAHAHAHAAAAAAA!","Heheheh.","Kjeh kjeh...",">:)","Heh.","I want to kill everything.","Ragdolls must burn in the flames of death.","Did you know that hundreds of ragdolls are killed every day?","Muahahahaha!",">:D","I love death. I love pain. I love killing.","I love Vinterskogs. They kill so easily!","I don\'t mind you killing a drone every once and a while.","I want to mutilate a doll too!","The suffering makes me feel ecstasy once again.","With enough force, you can snap off a ragdoll\'s head!","Make me a chair out of bodyparts!","I want ragdoll heads around me!","Rip off some ragdoll heads and put them around me!","MUTILATE! MAIM! MANGLE! MURDER!","MUTILATE!","MAIM!","MURDER!","DESTROY EVERYTHING!","Make the world burn.","Give me a weapon! I\'ll destroy everything!","Use a Power to destroy everything here!","First pour gasoline all over the ragdolls, then use a Firespread!","Drop an anvil on a ragdoll.","Just do it!","You know you want to.","It\'s such a rush when you use a Stapler to completely pulp a doll."
         ,"SIT ME ON A THRONE OF BLOOD!","1) Spawn a doll. 2) Use the Random button in the Spawn Menu. 3) MUTILATE!","1...2...3... Let the blood flow free.","1...2...3... Make everyone flee.","1...2...3... Bury dolls in debris.","4...5...6... Mutilate a doll for kicks.","4...5...6... Blend a doll into a mix.","4...5...6... Use a sword to transfix.","7...8...9... RIP OUT ITS SPINE!","7...8...9... End of the line.","7...8...9... Drop a doll on a Mine!"];
         HelloWorld();
      }
      
      override protected function RandomComments() : String
      {
         return null;
      }
      
      override protected function CommentOnItems(param1:Array) : Array
      {
         var _loc2_:Array = null;
         var _loc4_:b2Body = null;
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         var _loc7_:String = null;
         var _loc3_:int = 0;
         for each(_loc4_ in param1)
         {
            if(userData(_loc4_.GetUserData()).name == "doll_head")
            {
               _loc3_++;
            }
         }
         if(param1.length > 0)
         {
            _loc5_ = b2Body(param1[int(Math.random() * param1.length)]);
            _loc6_ = userData(_loc5_.GetUserData());
            _loc7_ = _loc6_.name;
            if(ud.connected.indexOf(_loc5_) != -1)
            {
               return null;
            }
            if(_loc7_ == "dronespeaker")
            {
               _loc2_ = ["You\'re awful.","Stupid floating babbler.","I don\'t like you.","Go away.","Don\'t speak to me.","Don\'t say it!","I\'ll destroy you.","There can be only one!","FIGHT ME!","I\'ll show you!","Annoying.","Useless, useless, USELESS!","All that talk makes me want to kill."];
            }
            else if(_loc7_ == "dronesaucer")
            {
               _loc2_ = ["Go back to your own planet.","Stupid alien.","Nice antennae. Pfft.","Did you build that yourself? It looks awful.","Unidentified Flying piece Of junk."];
            }
            else if(_loc7_ == "dronesword")
            {
               _loc2_ = ["The reaper has arrived.","Take me to where I belong. Death.","Kill me if its needed, Sword Drone.","I\'ll fight you to the end!","PIERCE ME OH MIGHTY PIERCER!","The slicer cometh.","Tear me apart.","Bring me desolation.","You don\'t scare me.","Stupid floating sword. You\'re nothing.","Make sure to cut everything else too, after I\'m gone."];
            }
            else if(Boolean(_loc6_) && Boolean(_loc6_.trigger) && _loc6_.trigger is Drone)
            {
               _loc2_ = ["A drone. I don\'t mind if you kill it.","I don\'t really care if a drone is killed.","Who even cares if a drone dies?","Another floating piece of junk.","Slice that Drone into two.","Useless Drone."];
               _loc2_.push("Go ahead and kill that " + GeneralUtils.objectToName(_loc7_) + " drone if you want.");
            }
            else if(_loc6_.alive)
            {
               if(_loc6_.health < _loc6_.maxhealth * 0.5)
               {
                  _loc2_ = ["Yes. A ragdoll has been slaughtered.","A mutilated ragdoll is a beautiful thing.","It\'s dead. Wonderful.","The living being has been perished.","Once living, now dead.","This pleases me.","Wonderful."];
               }
               else
               {
                  _loc2_ = ["EXTERMINATE!","KILL IT!","MURDER IT!","MUTILATE A DOLL!","MUTILATE IT!","MAIM, MAIM, MAIM, MAIM, MAIM, MAIM, MAIM, MAIM, MAIM, MAIM, MAIM, MAIM!","MURDER, MURDER, MURDER, MURDER, MURDER!","I want the blood of a ragdoll poured all over me.","The killing of a ragdoll brings joy to me.","I want its blood on me.","Murder it.","Kill it.","Rip off its head.","I want its head.","I want that thing dead.","MURDER!","MAIM!","MANGLE THE RAGDOLL!","Death. Bring death to the ragdoll.","I want you to beat that thing so hard it doesn\'t resemble a ragdoll."];
               }
            }
            else
            {
               _loc2_ = ["You could use that to halve a ragdoll.","Pick that up. Then throw it at a doll!","You could use that to trigger a Mine!","Drop that on a ragdoll.","I could use that as a weapon.","A fine weapon!","Anything\'s a weapon if you try hard enough."];
               _loc2_.push("Can you use the " + GeneralUtils.objectToName(_loc7_) + " to kill that ragdoll?");
               _loc2_.push("Lets kill a ragdoll with that " + GeneralUtils.objectToName(_loc7_) + "!");
               _loc2_.push("Mutilate a doll with the " + GeneralUtils.objectToName(_loc7_) + "!");
            }
            if(_loc3_ > 3)
            {
               _loc2_ = ["A collection of heads? For me?","Thank you!","I love all these heads around me!","The heads of countless slaughtered ragdolls brings joy to me.","Thank you for these heads!","You did this just for me?"];
               _loc2_.push("I\'m counting... " + _loc3_.toString() + " heads around me. Good job.");
               _loc2_.push("Only " + _loc3_.toString() + " heads?! Tear off some more.");
            }
         }
         return _loc2_;
      }
   }
}

