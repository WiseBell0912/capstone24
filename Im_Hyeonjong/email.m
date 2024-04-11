
% 메일주소와 비밀번호 입력
mail = 'ihj170cm@naver.com';
password = 'Kissme1427!';

% 환경변수 설정, 웬만해선 수정할 필요 없음
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.naver.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% 발신
sendmail('22100627@handong.ac.kr','Matlab Code Finished','Finished!');