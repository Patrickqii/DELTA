function[ result ] = trans2cell(doublearray)
%将double数组转为str格式的cell元组
%{
  input params:
      doublearray：double格式的数组
  output params:
      result：输出的cell格式数据

author:冯昌奇
create_date:2021-12-08
last_modify_date:2021-12-08
%}

result = cell(size(doublearray,1),1);
for i = 1:size(doublearray,1)
    result{i} = num2str(doublearray(i));
end
end