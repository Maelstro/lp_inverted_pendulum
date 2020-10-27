function result = p_lib(strType, strTitle, strMessage)

% p_lib.m file makes user interface and allows to display dialogs
% information
% question
% warning
% (c) InTeCo

result = 0;

switch (lower(strType))
   case 'inf'
      h = msgbox(strMessage,strTitle,'help'); 
      uiwait(h);
      result = 1;
   case 'err'
      h = msgbox(strMessage,strTitle,'error');
      uiwait(h);
      result = 1;
   case 'quest'
      button = questdlg(strMessage,strTitle,'Yes','No','Yes');
      if strcmp(lower(button), 'yes')
         result = 1;
      else
         result = 0;
      end
   otherwise
         result = 0;    
end




   