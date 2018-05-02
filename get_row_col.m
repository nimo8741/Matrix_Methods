function [row,col] = get_row_col(a,n_loc)
row = ceil(a/sqrt(n_loc));
col = mod(a,sqrt(n_loc));
if col == 0
    col = sqrt(n_loc);
end

end