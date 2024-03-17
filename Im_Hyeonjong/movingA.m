function [ data_out ] = movingA( data, span )
%UNTITLED2 이 함수의 요약 설명 위치
%   자세한 설명 위치
temp = zeros(size(data));
for ii = 1:length(data)
   if ii < span
      temp(ii) = data(ii); 
   else
    temp(ii) = mean( data(ii-span+1:ii) ,'omitnan' );
   end
 
end

data_out = temp;
end

