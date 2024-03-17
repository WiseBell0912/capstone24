function [ data_out ] = movingA( data, span )

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

