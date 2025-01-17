with Ada.Text_IO;
with Util.Http.Clients;
with Util.Http.Clients.Curl;
with Ada.Command_Line;

procedure Adacities is
   Count : constant Natural := Ada.Command_Line.Argument_Count;
begin
   if Count = 0 then
      Ada.Text_IO.Put_Line ("Usage: user passwd site ...");
      Ada.Text_IO.Put_Line ("Example: wget http://www.adacore.com");
      return;
   end if;
   Util.Http.Clients.Curl.Register;
   for I in 2 .. Count loop
      declare
         Http     : Util.Http.Clients.Client;	
		 User	  : constant String := Ada.Command_Line.Argument (1);	
		 Passwd	  : constant String := Ada.Command_Line.Argument (2);
         URI      : constant String := "https://" & User & ":" & Passwd & "@neocities.org/api/key";
         Response : Util.Http.Clients.Response;
      begin
         Http.Add_Header ("X-Requested-By", "wget");	
		 Ada.Text_Io.Put_Line ("URL: " & URI);
         Http.Get (URI, Response);
         Ada.Text_IO.Put_Line ("Code: " & Natural'Image (Response.Get_Status));
         Ada.Text_IO.Put_Line (Response.Get_Body);
      end;
   end loop;
end Adacities;
