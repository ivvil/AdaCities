with Ada.Text_IO;

procedure Adacities is
   function Site_Info (Site : String) return String is
      Url : String := "https://neocities.org/api/info?sitename=" & Site;
   begin
      --  return Util.Http.Get(Url).Get_Body;
      return Url;
   end Site_Info;
begin
   Ada.Text_IO.Put_Line (Site_Info ("hii"));
end Adacities;
