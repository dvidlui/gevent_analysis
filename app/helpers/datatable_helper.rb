module DatatableHelper

  # Public: Sorts array of elements with nil values
  def sort_array_with_data(data, sort_column, sort_direction)
    s_col_sym = sort_column.to_sym
    if sort_direction=="asc"
      data = data.sort{|r, u| 
        if r[s_col_sym].present? && u[s_col_sym].present?
          r[s_col_sym] <=> u[s_col_sym]
        elsif r[s_col_sym].present?
          1
        elsif u[s_col_sym].present?
          -1
        else
          0
        end
      }
    else
      data = data.sort{|r, u| 
        if r[s_col_sym].present? && u[s_col_sym].present?
          u[s_col_sym] <=> r[s_col_sym]
        elsif r[s_col_sym].present?
          -1
        elsif u[s_col_sym].present?
          1
        else
          0
        end
      }
    end
  end
end