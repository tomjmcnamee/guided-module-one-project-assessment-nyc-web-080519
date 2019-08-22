module DeleteUtilities

  # class InstanceMethods

  # end  # Ends InstanceMethods class

  def delete_objects_associated_with_deleted_event_object(deleted_event_obj)

    arr_to_del = []
    self.where(event_id: deleted_event_obj.id).each { |epobj| arr_to_del << epobj}
    arr_to_del.each { |obj| obj.delete }

  end  #delete_objects_associated_with_deleted_event_object

end  # ends List Utilities module
