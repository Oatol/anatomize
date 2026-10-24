package
{
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class Links
   {
      
      public function Links()
      {
         super();
      }
      
      public static function Kong(param1:Event) : void
      {
         navigateToURL(new URLRequest("http://www.kongregate.com/forums/9794"),"_blank");
      }
      
      public static function Steam(param1:Event) : void
      {
         navigateToURL(new URLRequest("https://steamcommunity.com/app/665370/discussions/"));
      }
      
      public static function SteamStore(param1:Event) : void
      {
         navigateToURL(new URLRequest("https://store.steampowered.com/app/665370/MutilateaDoll_2/"),"_blank");
      }
      
      public static function FAQ(param1:Event) : void
      {
         navigateToURL(new URLRequest("http://www.kongregate.com/forums/9794/topics/513429-faq"),"_blank");
      }
      
      public static function Workshop(param1:Event) : void
      {
         navigateToURL(new URLRequest("steam://url/SteamWorkshopPage/665370"),"_blank");
      }
      
      public static function Patch(param1:Event) : void
      {
         navigateToURL(new URLRequest("https://www.kongregate.com/forums/9794-mutilate-a-doll-2/topics/1816747"),"_blank");
      }
      
      public static function Patch2(param1:Event) : void
      {
         navigateToURL(new URLRequest("https://store.steampowered.com/news/app/665370/view/3691311568724624143"),"_blank");
      }
      
      public static function MaDLab(param1:Event) : void
      {
         navigateToURL(new URLRequest("https://rava.games/madlab"),"_blank");
      }
      
      public static function Kart(param1:Event) : void
      {
         navigateToURL(new URLRequest("https://www.kartridge.com/games/0rava/mutilate-a-doll-2"),"_blank");
      }
      
      public static function Itch(param1:Event) : void
      {
         navigateToURL(new URLRequest("https://dashrava.itch.io/mutilate"),"_blank");
      }
      
      public static function Dashrava(param1:Event) : void
      {
         navigateToURL(new URLRequest("https://www.rava.games"),"_blank");
      }
      
      public static function Gameplays(param1:Event) : void
      {
         navigateToURL(new URLRequest("http://www.silvergames.com/mutilate-a-doll-2/walkthrough"),"_blank");
      }
      
      public static function Silvergames(param1:Event) : void
      {
         navigateToURL(new URLRequest("http://www.silvergames.com/"),"_blank");
      }
      
      public static function Youtube(param1:Event) : void
      {
         navigateToURL(new URLRequest("http://www.youtube.com/user/MutilateaDoll"),"_blank");
      }
      
      public static function Twitter(param1:Event) : void
      {
         navigateToURL(new URLRequest("https://twitter.com/dashrava"),"_blank");
      }
      
      public static function Facebook(param1:Event) : void
      {
         navigateToURL(new URLRequest("https://www.facebook.com/MutilateaDoll"),"_blank");
      }
      
      public static function Discord(param1:Event) : void
      {
         navigateToURL(new URLRequest("http://www.discord.gg/MaD2"),"_blank");
      }
   }
}

