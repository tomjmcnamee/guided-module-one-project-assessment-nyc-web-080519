module ListUtilities

  # class InstanceMethods

  # end  # Ends InstanceMethods class

  def print_valid_options_and_return_hash_with_tempid_and_obj_combos(arr_of_objects_to_list_names_of)
      counter = 0
      hash_of_tempids_and_names = {}
      arr_of_objects_to_list_names_of.each { |object| counter += 1; hash_of_tempids_and_names[counter] = object.name }
      hash_of_tempids_and_names.each { |tempnumber, objname| puts "#{tempnumber}:  #{objname}"}
      puts "\n"
      hash_of_tempids_and_names
  end  # ends print_valid_options_and_return_hash_with_tempid_and_obj_combos


  def verifies_valid_selection_else_retry(selection,hash) 
    while selection.to_i <= 0 || selection.to_i > hash.length do
      puts "'#{selection}' is not a valid selection, try again."
      selection = gets.chomp
    end 
    selection
  end  # ends verifies_valid_selection_else_retry method

end  # ends List Utilities module
