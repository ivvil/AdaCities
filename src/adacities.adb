with Ada.Text_IO;
with Util.Http.Clients;
with Util.Http.Clients.Curl;
with Util.Beans.Objects;
with Util.Serialize.IO.JSON;
with Ada.Command_Line;

procedure Adacities is
   Count : constant Natural := Ada.Command_Line.Argument_Count;
   function Get_Token (User : String; Passwd : String) return String is
      Http        : Util.Http.Clients.Client;
      Uri         : constant String :=
        "https://" & User & ":" & Passwd & "@neocities.org/api/key";
      Response    : Util.Http.Clients.Response;
      Json_Object : Util.Beans.Objects.Object;
   begin
      Http.Add_Header ("X-Requested-By", "wget");
      Http.Get (Uri, Response);

      -- Parse JSON response
      Json_Object := Util.Serialize.IO.JSON.Read (Response.Get_Body);

      -- Check JSON structure and extract api_key
      if Util.Beans.Objects.To_Bean (Json_Object) /= null and
        Json_Object.Has_Field ("result") and
        Util.Beans.Objects.To_String (Json_Object.Get_Field ("result")) =
          "success" and
        Json_Object.Has_Field ("api_key")
      then
         return
           Util.Beans.Objects.To_String (Json_Object.Get_Field ("api_key"));
      else
         return "";
      end if;
   end Get_Token;
begin
   if Count = 0 then
      Ada.Text_IO.Put_Line ("Usage: user passwd site ...");
      return;
   end if;
   Util.Http.Clients.Curl.Register;
   for I in 2 .. Count loop
      declare
         Http     : Util.Http.Clients.Client;
         User     : constant String := Ada.Command_Line.Argument (1);
         Passwd   : constant String := Ada.Command_Line.Argument (2);
         URI      : constant String :=
           "https://" & User & ":" & Passwd & "@neocities.org/api/key";
         Response : Util.Http.Clients.Response;
      begin
         Http.Add_Header ("X-Requested-By", "wget");
         Ada.Text_IO.Put_Line ("URL: " & URI);
         -- Http.Get (URI, Response);
         -- Ada.Text_IO.Put_Line ("Code: " & Natural'Image (Response.Get_Status));
         -- Ada.Text_IO.Put_Line (Response.Get_Body);       
         Ada.Text_Io.Put_Line (Get_Token (User, Passwd));
      end;
   end loop;
end Adacities;
